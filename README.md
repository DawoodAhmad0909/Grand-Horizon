# Grand Horizon Hotel
## Overview 
This hotel management database is designed to comprehensively manage and analyze operations in a hospitality setting. It includes the following core entities:
#### •Guests: Tracks personal and loyalty information of all hotel customers.
#### •Rooms: Stores details like room type, rate, floor, occupancy limits, and amenities.
#### •Reservations: Manages room bookings, guest stay dates, and reservation status.
#### •Services: Catalogs additional hotel services such as spa, breakfast, or conference facilities.
#### •Billings: Records financial transactions tied to both reservations and extra services.
The schema supports a wide range of operational and analytical queries, including:
##### •Tracking guest loyalty and spending,
##### •Identifying room utilization patterns,
##### •Comparing revenue from room bookings vs. ancillary services,
##### •Analyzing service usage trends and popular combinations,
##### •Monitoring conference room utilization over time,
##### •Providing insights into underutilized rooms by month.
## Objectives 
To optimize a robust Hotel Reservation System database for streamlined guest bookings, room management, service tracking, and revenue optimization.
## Database Creation
``` sql
CREATE DATABASE GHH_db;
USE GHH_db;
```
## Table Creation 
### Table:guests
``` sql
CREATE TABLE guests(
    guest_id        VARCHAR(25) PRIMARY KEY,
    first_name      VARCHAR(25) NOT NULL,
    last_name       VARCHAR(25) NOT NULL,
    email           TEXT,
    phone           VARCHAR(15) UNIQUE,
    address         TEXT,
    id_proof        TEXT,
    loyalty_points  INT
);

SELECT * FROM guests;
```
### Table:rooms
``` sql
CREATE TABLE rooms(
    room_id        VARCHAR(25) PRIMARY KEY,
    room_type      VARCHAR(25),
    floor          INT,
    rate_per_night DECIMAL(10,2) NOT NULL,
    max_occupancy  INT NOT NULL,
    amenities      TEXT 
);

SELECT * FROM rooms;
```
### Table:reservations
``` sql
CREATE TABLE reservations(
    reservation_id VARCHAR(25) PRIMARY KEY,
    guest_id       VARCHAR(25),
    room_id        VARCHAR(25),
    check_in       DATE,
    check_out      DATE,
    adults         INT,
    children       INT,
    status         VARCHAR(50),
    total_amount   DECIMAL(10,2),
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

SELECT * FROM reservations;
```
### Table:services
``` sql
CREATE TABLE services(
    service_id   VARCHAR(25) PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL,
    rate         DECIMAL(10,2) NOT NULL,
    category     VARCHAR(50)
);

SELECT * FROM services;
```
### Table:billings
``` sql
CREATE TABLE billings(
    bill_id         VARCHAR(25) PRIMARY KEY,
    reservation_id  VARCHAR(25),
    service_id      VARCHAR(25),
    date            DATE,
    amount          DECIMAL(10,2),
    payment_method  VARCHAR(50),
    payment_status  VARCHAR(50),
    FOREIGN KEY (reservation_id) REFERENCES reservations (reservation_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

SELECT * FROM billings;
```
## KEY Queries 

#### 1. List guests with more than 1000 loyalty points and their total spending.
``` sql
SELECT g.guest_id,CONCAT(g.first_name,' ', g.last_name) AS Guest_name,g.loyalty_points,SUM(re.total_amount) Total_spendings
FROM guests g 
JOIN reservations re 
ON g.guest_id=re.guest_id
WHERE g.loyalty_points>1000
GROUP BY g.guest_id;
```
#### 2. Find guests who have stayed in both Deluxe and Suite room types.
``` sql
SELECT g.guest_id,CONCAT(g.first_name,' ', g.last_name) AS Guest_name,COUNT(DISTINCT r.room_type) AS Room_types_booked
FROM guests g 
JOIN reservations re 
ON g.guest_id=re.guest_id
JOIN rooms r 
ON r.room_id=re.room_id
WHERE LOWER(r.room_type) IN ('deluxe','suite')
GROUP BY g.guest_id
HAVING Room_types_booked=2;
```
#### 3. Calculate the average length of stay for business vs leisure travelers (identify by room type).
``` sql
SELECT 
        CASE 
                WHEN LOWER(r.room_type) IN ('executive','presidential') THEN 'Business'
        WHEN  LOWER(r.room_type) IN ('suite','deluxe') THEN 'leisure'
        ELSE 'Other'
        END AS Traveler_type,
    ROUND(AVG(TIMESTAMPDIFF(DAY,re.check_in,re.check_out)),2) AS Average_stay_days
FROM rooms r 
JOIN reservations re 
ON r.room_id=re.room_id
GROUP BY Traveler_type
HAVING Traveler_type IN ('Business','leisure');
```
#### 4. Show all confirmed reservations for July 2023 with prepayment status. 
``` sql
SELECT re.* , b. payment_status
FROM reservations re 
JOIN billings b 
ON re.reservation_id=b.reservation_id
WHERE 
        re.check_in BETWEEN '2023-07-01' AND '2023-07-31'
    AND LOWER(b.payment_status) ='prepaid'
    AND LOWER (re.status) ='confirmed';
```
#### 5. Identify rooms that have never been booked.
``` sql
SELECT r.* , COUNT(re.reservation_id) AS Total_reservations
FROM rooms r 
LEFT JOIN reservations re 
ON r.room_id=re.room_id
GROUP BY r.room_id
HAVING Total_reservations=0;
```
#### 6. Find reservations where the actual check-out date differed from the planned check-out date.
``` sql
SELECT 
        re.reservation_id,
    re.check_out AS Planned_check_out_date, 
    b.date AS Actual_check_out_date, 
    TIMESTAMPDIFF(DAY, re.check_out, b.date) AS Days_Difference
FROM reservations re 
JOIN billings b 
ON re.reservation_id=b.reservation_id
WHERE TIMESTAMPDIFF(DAY, re.check_out, b.date) >0;
```
#### 7. Calculate daily occupancy rates for June 2023.
``` sql
WITH RECURSIVE calendar AS (
        SELECT DATE('2023-06-01') AS day
    UNION ALL 
    SELECT day + INTERVAL 1 DAY 
    FROM calendar 
    WHERE day<'2023-06-30'
    ),
daily_occupation AS (
        SELECT 
                c.day,
        COUNT(DISTINCT re.room_id) AS occupied_rooms
        FROM calendar c
        JOIN reservations re 
        ON c.day>=re.check_in AND c.day<re.check_out
        GROUP BY c.day
        ),
total_rooms AS (
        SELECT COUNT(*) AS Total_room
    FROM rooms
    )
SELECT do.day,do.occupied_rooms,ROUND((do.occupied_rooms/tr.Total_room)*100.0,2) as occupancy_rate
FROM daily_occupation do 
JOIN total_rooms tr 
ORDER BY do.day;
```
#### 8. List the most frequently booked room type by season (summer vs winter). 
``` sql
WITH reservation_seasons AS (
    SELECT 
        re.reservation_id,
        r.room_type,
        MONTH(re.check_in) AS month,
        CASE 
            WHEN MONTH(re.check_in) IN (6, 7, 8) THEN 'Summer'
            WHEN MONTH(re.check_in) IN (12, 1, 2) THEN 'Winter'
            ELSE 'Other'
        END AS season
    FROM reservations re
    JOIN rooms r ON r.room_id = re.room_id
),
room_type_counts AS (
    SELECT 
        season,
        room_type,
        COUNT(*) AS booking_count
    FROM reservation_seasons
    WHERE season IN ('Summer', 'Winter')
    GROUP BY season, room_type
),
ranked_room_types AS (
    SELECT 
        *,
        RANK() OVER (PARTITION BY season ORDER BY booking_count DESC) AS ranking
    FROM room_type_counts
)
SELECT season, room_type, booking_count
FROM ranked_room_types
WHERE ranking = 1;
```
#### 9. Find rooms that were occupied for less than 50% of the month.
``` sql
WITH RECURSIVE calendar AS (
    SELECT DATE('2023-06-01') AS day
    UNION ALL
    SELECT day + INTERVAL 1 DAY
    FROM calendar
    WHERE day < '2023-06-30'
),
room_occupancy_days AS (
    SELECT 
        r.room_id,
        c.day
    FROM reservations r
    JOIN calendar c
      ON c.day >= r.check_in AND c.day < r.check_out
),
room_day_counts AS (
    SELECT 
        room_id,
        COUNT(DISTINCT day) AS occupied_days
    FROM room_occupancy_days
    GROUP BY room_id
)
SELECT 
    rm.room_id,
    rm.room_type,
    COALESCE(rdc.occupied_days, 0) AS occupied_days,
    30 AS total_days,
    ROUND(COALESCE(rdc.occupied_days, 0) / 30 * 100, 2) AS occupancy_percentage
FROM rooms rm
LEFT JOIN room_day_counts rdc ON rm.room_id = rdc.room_id
WHERE COALESCE(rdc.occupied_days, 0) < 15;
```
#### 10. Compare revenue from room bookings vs ancillary services (spa, F&B, etc.).
``` sql
WITH revenue_split AS (
        SELECT 
                CASE 
                        WHEN service_id IS NULL THEN 'Room Booking'
                        WHEN service_id IS NOT NULL THEN 'Ancilary Services'
                END AS Revenue_type,
                ROUND(SUM(amount),2) AS Total_revenue
        FROM billings
        GROUP BY Revenue_type
    )
SELECT 
        Revenue_type,
    Total_revenue,
    ROUND((Total_revenue/SUM(Total_revenue) OVER())*100,2) AS Revenue_percentage
FROM revenue_split;
```
#### 11. Identify the top 5 highest-spending guests with their preferred room types.
``` sql
WITH guest_spending AS (
    SELECT 
        r.guest_id,
        SUM(b.amount) AS total_spent
    FROM reservations r
    JOIN billings b ON r.reservation_id = b.reservation_id
    GROUP BY r.guest_id
),
room_preference AS (
    SELECT 
        re.guest_id,
        r.room_type,
        COUNT(*) AS booking_count,
        RANK() OVER (PARTITION BY re.guest_id ORDER BY COUNT(*) DESC) AS ranking
    FROM reservations re
    JOIN rooms r ON r.room_id = re.room_id
    GROUP BY re.guest_id, r.room_type
),
preferred_rooms AS (
    SELECT guest_id, room_type
    FROM room_preference
    WHERE ranking = 1
),
top_guests AS (
    SELECT gs.guest_id, gs.total_spent, pr.room_type
    FROM guest_spending gs
    JOIN preferred_rooms pr ON gs.guest_id = pr.guest_id
)
SELECT 
    g.guest_id,
    CONCAT(g.first_name, ' ', g.last_name) AS full_name,
    tg.total_spent,
    tg.room_type AS preferred_room_type
FROM top_guests tg
JOIN guests g ON g.guest_id = tg.guest_id
ORDER BY tg.total_spent DESC
LIMIT 5;
```
#### 12. Calculate the average spend per guest per room type.
``` sql
WITH guest_room_spending AS (
        SELECT 
                re.guest_id,
        r.room_type,
        SUM(b.amount) AS Total_spending
        FROM reservations re 
    JOIN rooms r 
    ON r.room_id=re.room_id
    JOIN billings b 
    ON re.reservation_id=b.reservation_id
    GROUP BY re.guest_id,r.room_id
    )
SELECT 
    room_type,
    ROUND(AVG(Total_spending),2) AS Average_spend_guest
FROM guest_room_spending
GROUP BY room_type;
```
#### 13. List services ordered more than twice by the same guest during a stay.
``` sql
SELECT re.guest_id,re.reservation_id,s.service_id,s.service_name,COUNT(s.service_id) AS Total_orders
FROM billings b 
JOIN reservations re 
ON b.reservation_id=re.reservation_id
JOIN services s
ON s.service_id=b.service_id
GROUP BY re.guest_id,re.reservation_id,s.service_id,s.service_name
HAVING Total_orders>2;
```
#### 14. Find the most popular service combination (e.g., Spa + Breakfast).
``` sql
WITH service_pairs AS (
    SELECT 
        b1.reservation_id,
        LEAST(b1.service_id, b2.service_id) AS service_1,
        GREATEST(b1.service_id, b2.service_id) AS service_2
    FROM billings b1
    JOIN billings b2 
      ON b1.reservation_id = b2.reservation_id
     AND b1.service_id < b2.service_id
    WHERE b1.service_id IS NOT NULL AND b2.service_id IS NOT NULL
)
SELECT 
    s1.service_name AS service_1,
    s2.service_name AS service_2,
    COUNT(*) AS combination_count
FROM service_pairs sp
JOIN services s1 ON sp.service_1 = s1.service_id
JOIN services s2 ON sp.service_2 = s2.service_id
GROUP BY service_1, service_2
ORDER BY combination_count DESC
LIMIT 1;
```
#### 15. Calculate the utilization rate of conference rooms.
``` sql
WITH monthly_service_usage AS (
    SELECT 
        DATE_FORMAT(date, '%Y-%m') AS month_year,
        COUNT(DISTINCT reservation_id) AS conference_usage
    FROM billings b 
    JOIN services s 
    ON s.service_id=b.service_id
    WHERE LOWER( s.service_name) ='conference room'
    GROUP BY month_year
),
monthly_reservations AS (
    SELECT 
        DATE_FORMAT(date, '%Y-%m') AS month_year,
        COUNT(DISTINCT reservation_id) AS total_reservations
    FROM billings
    GROUP BY month_year
)
SELECT 
    mr.month_year,
    COALESCE(msu.conference_usage, 0) AS conference_usage,
    mr.total_reservations,
    ROUND(COALESCE(msu.conference_usage, 0) / mr.total_reservations * 100, 2) AS utilization_rate_percent
FROM monthly_reservations mr
LEFT JOIN monthly_service_usage msu ON mr.month_year = msu.month_year
ORDER BY mr.month_year;
```
## Conclusion

This database effectively integrates guest, room, and service management with billing and analytics capabilities. It provides a strong foundation for:
##### •Operational decision-making (e.g., optimizing room usage, pricing),
##### •Customer insights (e.g., high-value guests, service preferences),
##### •Revenue analysis (e.g., earnings breakdown by type),
##### •Strategic planning (e.g., loyalty programs, seasonal promotions).


