SELECT 
    *
FROM
    tola.bookings;

-- 1.  Find total number of bookings.
SELECT 
    COUNT(*)
    AS
    Total_Bookings
FROM
    bookings;

-- 2.  Find total successful rides.
SELECT 
    COUNT(*) AS Total_success_rides
FROM
    bookings
WHERE
    Booking_Status = 'Success';

-- 3.  Count bookings by vehicle type.
SELECT 
    Vehicle_Type, COUNT(*) Counts
FROM
    bookings
GROUP BY Vehicle_Type;

-- 4.  Find total cancelled rides by customer.

SELECT 
    COUNT(*) AS Total_cancelled_rides_by_cust
FROM
    bookings
WHERE
    Booking_Status = 'Cancelled by Customer';

-- 5.  Find total cancelled rides by driver.

SELECT 
    COUNT(*) AS Total_cancelled_rides_by_driver
FROM
    bookings
WHERE
    Booking_Status = 'Cancelled by Driver';

-- 6.  Find average booking value.
SELECT 
    ROUND(AVG(Booking_Value), 2) AS avg_booking_value
FROM
    bookings;

-- 7.  Find highest booking value.
SELECT 
    MAX(Booking_Value) AS max_booking_value
FROM
    bookings;

-- 8.  Find lowest booking value.
SELECT 
    MIN(Booking_Value) AS min_booking_value
FROM
    bookings;

-- 9.  Show top 10 highest fare bookings.
SELECT 
    Booking_ID, Pickup_Location, Drop_Location, Booking_Value
FROM
    bookings
ORDER BY Booking_Value DESC
LIMIT 10;

-- 10. Find bookings for a specific vehicle type.
SELECT 
    *
FROM
    bookings
WHERE
    Vehicle_Type = 'Prime SUV';

-- 11. Find booking success rate.
SELECT 
    ROUND((SUM(CASE
                WHEN Booking_Status = 'Success' THEN 1
                ELSE 0
            END) * 100) / COUNT(*),
            2) AS success_rate
FROM
    bookings;

-- 12. Find cancellation percentage by customer.
SELECT 
    ROUND((SUM(CASE
                WHEN Booking_Status = 'Cancelled by Customer' THEN 1
                ELSE 0
            END) * 100) / COUNT(*),
            2) AS cancellation_by_cust_rate
FROM
    bookings;

-- 13. Find cancellation percentage by driver.
SELECT 
    ROUND((SUM(CASE
                WHEN Booking_Status = 'Cancelled by Driver' THEN 1
                ELSE 0
            END) * 100) / COUNT(*),
            2) AS cancellation_by_driver_rate
FROM
    bookings;

-- 14. Find average ride distance by vehicle type.
SELECT 
    Vehicle_Type,
    ROUND(AVG(Ride_Distance), 2) AS avg_ride_distance
FROM
    bookings
GROUP BY Vehicle_Type;

-- 15. Find average driver rating by vehicle type.
SELECT 
    Vehicle_Type,
    ROUND(AVG(Driver_Ratings), 2) AS avg_driver_ratings
FROM
    bookings
GROUP BY Vehicle_Type;

-- 16. Find top pickup locations.
SELECT 
    Pickup_Location, COUNT(*)
FROM
    bookings
GROUP BY Pickup_Location
LIMIT 10;

-- 17. Find top drop locations.
SELECT 
    Drop_Location, COUNT(*)
FROM
    bookings
GROUP BY Drop_Location
LIMIT 10;

-- 18. Find weekend bookings.
SELECT 
    COUNT(*) AS weekend_bookings
FROM
    bookings
WHERE
    DAYNAME(Date) IN ('Saturday' , 'Sunday');

-- 19. Find weekday vs weekend booking count.
SELECT 
    CASE
        WHEN DAYNAME(Date) IN ('Saturday' , 'Sunday') THEN 'weekend'
        ELSE 'weekdays'
    END AS day_type,
    COUNT(*)
FROM
    bookings
GROUP BY day_type;

-- 20. Find daily booking trend.
SELECT 
    Date, COUNT(*)
FROM
    bookings
GROUP BY Date
ORDER BY Date;

-- 21. Revenue by vehicle type.
SELECT 
    Vehicle_Type, SUM(Booking_Value) AS Revenue
FROM
    bookings
GROUP BY Vehicle_Type
ORDER BY Revenue DESC;

-- 22. Find top 5 revenue-generating pickup locations.
SELECT 
    Pickup_Location, SUM(Booking_Value) AS Revenue
FROM
    bookings
GROUP BY Pickup_Location
ORDER BY Revenue DESC
LIMIT 5;

-- 23. Find peak booking hours.
SELECT 
    HOUR(Time) AS booking_hours, COUNT(*) AS Total_Booking
FROM
    bookings
GROUP BY booking_hours
ORDER BY Total_Booking DESC;

-- 24. Find average VTAT and CTAT.
SELECT 
    ROUND(AVG(V_TAT), 2) AS avg_VTAT,
    ROUND(AVG(C_TAT), 2) AS avg_CTAT
FROM
    bookings;

-- 25. Find vehicle type with highest ratings.
SELECT 
    Vehicle_Type, ROUND(AVG(Customer_Rating), 2) AS Cust_Ratings
FROM
    bookings
GROUP BY Vehicle_Type
ORDER BY Cust_Ratings DESC;

-- 26. Rank vehicle types by revenue.
select Vehicle_Type, 
sum(Booking_Value) as Revenue , 
Rank() Over (Order BY SUM(Booking_Value) desc) as ranking 
from bookings
group by Vehicle_Type;

-- 27. Find top 10 customers by bookings.
SELECT 
    Customer_ID, COUNT(*) AS total_rides
FROM
    bookings
GROUP BY Customer_ID
ORDER BY total_rides DESC
LIMIT 10;

-- 28. Find ride category by booking amount.
SELECT 
    Booking_ID,
    Booking_Value,
    CASE
        WHEN Booking_Value < 500 THEN 'Low Fare'
        WHEN Booking_Value BETWEEN 500 AND 1000 THEN 'Medium Fare'
        ELSE 'High Fare'
    END AS Fare_Category
FROM
    bookings;

-- 29. Find cancellation trend by day.
SELECT 
    Date, COUNT(*) AS cancellation
FROM
    bookings
WHERE
    Booking_Status IN ('Cancelled by Customer' , 'Cancelled by Driver')
GROUP BY Date;

-- 30. Find the busiest day.
SELECT 
    Date, COUNT(*) AS Total_Bookings
FROM
    bookings
GROUP BY Date
ORDER BY Total_Bookings DESC;