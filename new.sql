CREATE DATABASE GHH_db;
USE GHH_db;

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

INSERT INTO guests VALUES
('GST1001', 'Rahul', 'Sharma', 'rahul.s@example.com', '+919876543210', '24 Green Park, Delhi', 'AADHAAR3782', 250),
('GST1002', 'Priya', 'Patel', 'priya.p@example.com', '+919876543211', '45 MG Road, Bangalore', 'PANPT4532D', 1200),
('GST1003', 'Amit', 'Kumar', 'amit.k@example.com', '+919876543212', '78 Hill View, Mumbai', 'DL143567890', 500),
('GST1004', 'Neha', 'Reddy', 'neha.r@example.com', '+919876543213', '32 Jubilee Hills, Hyderabad', 'AADHAAR9821', 1800),
('GST1005', 'Vikram', 'Singh', 'vikram.s@example.com', '+919876543214', '15 Park Street, Kolkata', 'PASS8765432', 350);

CREATE TABLE rooms(
    room_id        VARCHAR(25) PRIMARY KEY,
    room_type      VARCHAR(25),
    floor          INT,
    rate_per_night DECIMAL(10,2) NOT NULL,
    max_occupancy  INT NOT NULL,
    amenities      TEXT 
);

SELECT * FROM rooms;

INSERT INTO rooms VALUES
('RM101', 'Deluxe', 1, 4500.00, 2, 'AC, TV, Mini-Fridge'),
('RM102', 'Deluxe', 1, 4500.00, 2, 'AC, TV, Mini-Fridge'),
('RM201', 'Executive', 2, 7500.00, 3, 'AC, TV, Mini-Bar, Work Desk'),
('RM202', 'Executive', 2, 7500.00, 3, 'AC, TV, Mini-Bar, Work Desk'),
('RM301', 'Suite', 3, 12000.00, 4, 'AC, TV, Living Area, Mini-Bar'),
('RM302', 'Presidential', 3, 25000.00, 2, 'AC, TV, Jacuzzi, Butler Service');

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

INSERT INTO reservations VALUES
('RES2306001', 'GST1001', 'RM101', '2023-06-15', '2023-06-18', 2, 0, 'Checked-Out', 13500.00),
('RES2306002', 'GST1002', 'RM201', '2023-06-16', '2023-06-20', 2, 1, 'Checked-Out', 30000.00),
('RES2306003', 'GST1003', 'RM102', '2023-06-18', '2023-06-19', 1, 0, 'Checked-Out', 4500.00),
('RES2306004', 'GST1004', 'RM301', '2023-06-20', '2023-06-25', 2, 2, 'Checked-Out', 60000.00),
('RES2306005', 'GST1005', 'RM202', '2023-06-22', '2023-06-24', 2, 0, 'Checked-Out', 15000.00),
('RES2307001', 'GST1001', 'RM101', '2023-07-05', '2023-07-07', 2, 0, 'Confirmed', 9000.00),
('RES2307002', 'GST1002', 'RM302', '2023-07-10', '2023-07-15', 2, 0, 'Confirmed', 125000.00),
('RES2307003', 'GST1003', 'RM201', '2023-07-12', '2023-07-14', 3, 0, 'Confirmed', 15000.00),
('RES2307004', 'GST1004', 'RM301', '2023-07-18', '2023-07-22', 4, 0, 'Confirmed', 48000.00),
('RES2307005', 'GST1005', 'RM102', '2023-07-20', '2023-07-21', 1, 0, 'Confirmed', 4500.00);

CREATE TABLE services(
    service_id   VARCHAR(25) PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL,
    rate         DECIMAL(10,2) NOT NULL,
    category     VARCHAR(50)
);

SELECT * FROM services;

INSERT INTO services VALUES
('SRV1001', 'Airport Transfer', 2000.00, 'Transport'),
('SRV1002', 'Spa Package', 3500.00, 'Wellness'),
('SRV1003', 'Laundry Service', 500.00, 'Housekeeping'),
('SRV1004', 'Breakfast Buffet', 800.00, 'F&B'),
('SRV1005', 'Conference Room', 10000.00, 'Business');

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

INSERT INTO billings VALUES
('BIL23060001', 'RES2306001', NULL, '2023-06-18', 13500.00, 'Credit Card', 'Paid'),
('BIL23060002', 'RES2306002', NULL, '2023-06-20', 30000.00, 'UPI', 'Paid'),
('BIL23060003', 'RES2306003', NULL, '2023-06-19', 4500.00, 'Debit Card', 'Paid'),
('BIL23060004', 'RES2306004', NULL, '2023-06-25', 60000.00, 'Credit Card', 'Paid'),
('BIL23060005', 'RES2306005', NULL, '2023-06-24', 15000.00, 'Cash', 'Paid'),
('BIL23060006', 'RES2306001', 'SRV1004', '2023-06-16', 1600.00, 'Credit Card', 'Paid'),
('BIL23060007', 'RES2306002', 'SRV1001', '2023-06-16', 2000.00, 'UPI', 'Paid'),
('BIL23060008', 'RES2306004', 'SRV1002', '2023-06-21', 3500.00, 'Credit Card', 'Paid'),
('BIL23060009', 'RES2306004', 'SRV1003', '2023-06-22', 1000.00, 'Credit Card', 'Paid'),
('BIL23060010', 'RES2306005', 'SRV1004', '2023-06-23', 800.00, 'Cash', 'Paid');


-- KEY Queries 
 
-- 1. List guests with more than 1000 loyalty points and their total spending.
SELECT g.guest_id,CONCAT(g.first_name,' ', g.last_name) AS Guest_name,g.loyalty_points,SUM(re.total_amount) Total_spendings
FROM guests g 
JOIN reservations re 
ON g.guest_id=re.guest_id
WHERE g.loyalty_points>1000
GROUP BY g.guest_id;

-- 2. Find guests who have stayed in both Deluxe and Suite room types.
SELECT g.guest_id,CONCAT(g.first_name,' ', g.last_name) AS Guest_name,COUNT(DISTINCT r.room_type) AS Room_types_booked
FROM guests g 
JOIN reservations re 
ON g.guest_id=re.guest_id
JOIN rooms r 
ON r.room_id=re.room_id
WHERE LOWER(r.room_type) IN ('deluxe','suite')
GROUP BY g.guest_id
HAVING Room_types_booked=2;

-- 3. Calculate the average length of stay for business vs leisure travelers (identify by room type).
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

-- 4. Show all confirmed reservations for July 2023 with prepayment status. 
SELECT re.* , b. payment_status
FROM reservations re 
JOIN billings b 
ON re.reservation_id=b.reservation_id
WHERE 
	re.check_in BETWEEN '2023-07-01' AND '2023-07-31'
    AND LOWER(b.payment_status) ='prepaid'
    AND LOWER (re.status) ='confirmed';
    
-- 5. Identify rooms that have never been booked.
SELECT r.* , COUNT(re.reservation_id) AS Total_reservations
FROM rooms r 
LEFT JOIN reservations re 
ON r.room_id=re.room_id
GROUP BY r.room_id
HAVING Total_reservations=0;
 
-- 6. Find reservations where the actual check-out date differed from the planned check-out date.
SELECT 
	re.reservation_id,
    re.check_out AS Planned_check_out_date, 
    b.date AS Actual_check_out_date, 
    TIMESTAMPDIFF(DAY, re.check_out, b.date) AS Days_Difference
FROM reservations re 
JOIN billings b 
ON re.reservation_id=b.reservation_id
WHERE TIMESTAMPDIFF(DAY, re.check_out, b.date) >0;

-- 7. Calculate daily occupancy rates for June 2023.
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

-- 8. List the most frequently booked room type by season (summer vs winter). 
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

-- 9. Find rooms that were occupied for less than 50% of the month.
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

-- 10. Compare revenue from room bookings vs ancillary services (spa, F&B, etc.).
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

-- 11. Identify the top 5 highest-spending guests with their preferred room types.
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

-- 12. Calculate the average spend per guest per room type.
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

-- 13. List services ordered more than twice by the same guest during a stay.
SELECT re.guest_id,re.reservation_id,s.service_id,s.service_name,COUNT(s.service_id) AS Total_orders
FROM billings b 
JOIN reservations re 
ON b.reservation_id=re.reservation_id
JOIN services s
ON s.service_id=b.service_id
GROUP BY re.guest_id,re.reservation_id,s.service_id,s.service_name
HAVING Total_orders>2;

-- 14. Find the most popular service combination (e.g., Spa + Breakfast).
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

-- 15. Calculate the utilization rate of conference rooms.
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