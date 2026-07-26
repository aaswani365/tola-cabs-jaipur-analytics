SELECT 
    *
FROM
    tola.bookings;

ALTER TABLE bookings
RENAME COLUMN `Booking ID` TO `Booking_ID`,
RENAME COLUMN `Booking Status` TO `Booking_Status`,
RENAME COLUMN `Customer ID` TO `Customer_ID`,
RENAME COLUMN `Vehicle Type` TO `Vehicle_Type`,
RENAME COLUMN `Pickup Location` TO `Pickup_Location`,
RENAME COLUMN `Drop Location` TO `Drop_Location`,
RENAME COLUMN `Avg VTAT` TO `V_TAT`,
RENAME COLUMN `Avg CTAT` TO `C_TAT`,
RENAME COLUMN `Cancelled Rides by Customer` TO `cancelled_Rides_by_Customer`,
RENAME COLUMN `Reason for cancelling by Customer` to `reason_for_cancelling_by_Customer`,
RENAME COLUMN `Cancelled Rides by Driver` TO `cancelled_Rides_by_Driver`,
RENAME COLUMN `Driver Cancel Reason` to `reason_for_cancelling_by_Driver`,
RENAME COLUMN `Incomplete Rides` TO `Incomplete_Rides`,
RENAME COLUMN `Incomplete Rides Reason` TO `Incomplete_Rides_Reason`,
RENAME COLUMN `Booking Value` TO `Booking_Value`,
RENAME COLUMN `Payment Method` TO `Payment_Method`,
RENAME COLUMN `Ride Distance` TO `Ride_Distance`,
RENAME COLUMN `Driver Ratings` TO `Driver_Ratings`,
RENAME COLUMN `Customer Rating` TO `Customer_Rating`;


SELECT 
    MIN(Date), MAX(Date)
FROM
    bookings;
SELECT DISTINCT
    Date
FROM
    bookings;