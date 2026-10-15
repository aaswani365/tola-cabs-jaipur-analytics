# TOLA Cabs — Data Dictionary

## 02 | Dataset Schema and Field Definitions

**Project:** TOLA Cabs — Jaipur City Operations Analytics  
**Primary source inspected:** `01_bookings.csv`  
**SQL field mapping inspected:** `02_bookings.sql`  
**Power BI report:** `04_TOLA_Cabs.pbix`

## 1. Important dataset-version distinction

The checked-in source file `01_bookings.csv` contains **100,000 rows**, dated **2026-01-01 to 2026-01-30**, with **21 columns**. The validated Power BI report, by contrast, contains **150,000 bookings** across **2026-01-01 to 2026-03-02**. Therefore, the CSV in the repository is **not by itself a complete export of the final report's data**. Additional data or processing is required to reproduce the final dashboard. The provenance of the additional 50,000 report rows should be documented before describing the repository as fully reproducible.

The source CSV has **99,999 distinct Booking ID values across 100,000 rows**; investigate the repeated ID if booking identifiers are expected to be unique. The field types below describe the *CSV's observed values* and reasonable analytical types; they are **not independently verified SQL DDL or Power BI model data types**.

## 2. Field-by-field dictionary

| # | Source CSV column | SQL-renamed column (where applicable) | Suggested analytical type | Business meaning / usage |
|---:|---|---|---|---|
| 1 | `Date` | `Date` | Date | Calendar date of booking; links to Calendar dimension in Power BI. |
| 2 | `Time` | `Time` | Time or text (HH:MM) | Booking time; can support time-of-day analysis. |
| 3 | `Booking ID` | `Booking_ID` | Text | Booking transaction identifier; check duplicates before using as unique key. |
| 4 | `Booking Status` | `Booking_Status` | Text / category | Booking outcome: Success, Cancelled by Customer, Cancelled by Driver, or Incomplete. |
| 5 | `Customer ID` | `Customer_ID` | Whole number / identifier | Customer identifier for distinct-customer and repeat-booking analysis. |
| 6 | `Vehicle Type` | `Vehicle_Type` | Text / category | Vehicle service category, e.g. Auto, Bike, Mini, eBike, Prime Sedan, Prime SUV, Prime Plus. |
| 7 | `Pickup Location` | `Pickup_Location` | Text / category | Pickup locality; used in location and route visuals. |
| 8 | `Drop Location` | `Drop_Location` | Text / category | Drop-off locality; used in destination and route visuals. |
| 9 | `Avg VTAT` | `V_TAT` | Decimal number | Source-provided vehicle turnaround/arrival metric; verify exact operational definition and unit with source owner. Dashboard presents V_TAT in minutes. |
| 10 | `Avg CTAT` | `C_TAT` | Decimal number | Source-provided customer turnaround/arrival metric; dashboard presents C_TAT as pickup time in minutes; confirm definition with source owner. |
| 11 | `Cancelled Rides by Customer` | `cancelled_Rides_by_Customer` | Numeric flag | Customer-cancellation indicator, populated for applicable bookings. |
| 12 | `Reason for cancelling by Customer` | `reason_for_cancelling_by_Customer` | Text / category | Stated customer cancellation reason; null for most other booking statuses. |
| 13 | `Cancelled Rides by Driver` | `cancelled_Rides_by_Driver` | Numeric flag | Driver-cancellation indicator, populated for applicable bookings. |
| 14 | `Driver Cancel Reason` | `reason_for_cancelling_by_Driver` | Text / category | Driver cancellation reason; SQL mapping changes its name. |
| 15 | `Incomplete Rides` | `Incomplete_Rides` | Numeric flag | Indicator for an incomplete booking. |
| 16 | `Incomplete Rides Reason` | `Incomplete_Rides_Reason` | Text / category | Reason for incomplete ride; populated where applicable. |
| 17 | `Booking Value` | `Booking_Value` | Whole number / currency | Recorded value of booking, in INR for dashboard reporting. Not necessarily realized revenue. |
| 18 | `Payment Method` | `Payment_Method` | Text / category | Payment channel; final report includes UPI, Wallet, Cash, and In App. |
| 19 | `Ride Distance` | `Ride_Distance` | Decimal number | Ride distance, shown in kilometers on dashboard. |
| 20 | `Driver Ratings` | `Driver_Ratings` | Decimal number | Driver rating where recorded; null for many non-success outcomes. |
| 21 | `Customer Rating` | `Customer_Rating` | Decimal number | Customer rating where recorded; null for many non-success outcomes. |

## 3. Source CSV profile

| Property | Observed in `01_bookings.csv` |
|---|---:|
| Rows | 100,000 |
| Columns | 21 |
| Earliest date | 2026-01-01 |
| Latest date | 2026-01-30 |
| Distinct booking IDs | 99,999 |
| Distinct customer IDs | 60,344 |
| Vehicle types | 7 |
| Pickup locations | 50 |
| Drop locations | 50 |
| Booking statuses | 4 |
| Payment methods | 3 |

**Source CSV status counts:** Success 62,087; Cancelled by Driver 18,050; Cancelled by Customer 7,018; Incomplete 12,845. These are **source-file counts**, not the 150,000-row final report counts.

### Missing values and conditional applicability

The source CSV has nulls in `Avg VTAT`, `Avg CTAT`, `Driver Ratings`, and `Customer Rating` (37,913 rows each). Cancellation and incomplete-ride flags/reasons are populated conditionally: customer cancellation fields have 92,982 nulls; driver cancellation fields have 81,950 nulls; incomplete-ride fields have 87,155 nulls. **These nulls should not automatically be classified as data errors**: most correspond to booking outcomes for which a field is not applicable. Validate exceptions using status-specific rules.

## 4. Power BI model and derived fields

The report's model view shows:

- **`tola bookings`**: transactional fact table, with SQL-style field names such as `Booking_ID`, `Booking_Status`, `Customer_ID`, `Booking_Value`, `C_TAT`, `Driver_Ratings`, `Pickup_Location`, `Drop_Location`, and `Ride_Distance`.
- **`Calendar`**: `Date`, `Month`, `Month No`, `Quarter`, `Year`; one-to-many relationship to the fact table, with single-direction filtering from Calendar to bookings shown in Model View.
- **`_Measures`**: centralized DAX measure table, not a data dimension.
- **`Booking Month Selector`**: disconnected month selector supporting dynamic booking comparisons.
- **`Customer Booking Frequency`**, **`Booking Frequency Groups`**, and **`Customer Type`**: helper tables used in customer-frequency and segmentation visuals. Their complete generation formulas have not been independently reviewed.

Additional calculated columns visible in the fact table include `Day_Name`, `Distance Bucket`, `Hour`, `Hour Basket`, and `Pickup Drop Route`. Their precise expressions and data types should be exported from the Power BI model if a fully exhaustive model dictionary is needed.

## 5. Validated final-report measures and business rules

These figures come from DAX query results for the final report, **not** from the 100,000-row CSV alone:

| Metric | Definition / interpretation | Validated report result |
|---|---|---:|
| Total Bookings | Count of booking fact rows | 150,000 |
| Completed Rides | Bookings with `Booking_Status = "Success"` | 74,553 |
| Completion Rate | Completed Rides / Total Bookings | 49.70% |
| Customer Cancelled | Bookings cancelled by customer | 34,455 |
| Driver Cancelled | Bookings cancelled by driver | 27,105 |
| Total Cancelled | Customer Cancelled + Driver Cancelled | 61,560 |
| Cancellation Rate | Total Cancelled / Total Bookings | 41.04% |
| Incomplete Rides | Total Bookings − Completed Rides − Total Cancelled | 13,887 |
| Total Booking Value | Sum of booking values | ₹90,110,162 |
| Success Revenue | Booking value restricted to successful bookings | ₹38,574,286 |
| Revenue Realization Rate | Success Revenue / Total Booking Value | 42.81% |
| Total Customers | Distinct customer IDs | 73,036 |
| Repeat Customers | Customers with at least two bookings | 44,627 |
| Repeat Customer Rate | Repeat Customers / Total Customers | 61.10% |
| Avg Driver Rating | Mean of recorded driver ratings | 4.25 |
| Avg Customer Rating | Mean of recorded customer ratings | 4.25 |
| Avg C_TAT | Mean of recorded C_TAT | 14.95 min |
| Avg Distance | Mean ride distance | 13.82 km |
| Pickup Locations | Distinct pickup location values | 50 |
| Drop Locations | Distinct drop location values | 50 |

## 6. Data quality and interpretation notes

1. **Dataset completeness:** the checked-in CSV contains 100,000 rows, but the Power BI report contains 150,000. Include the missing source/update procedure or clearly label the CSV as a partial source extract.
2. **Booking identifier uniqueness:** one booking ID is repeated in the checked-in CSV. Investigate before applying unique constraints or using `DISTINCTCOUNT(Booking_ID)` as a substitute for row count.
3. **March is partial:** March 2026 covers March 1–2 only; raw February-to-March totals are not a like-for-like monthly growth comparison.
4. **Conditional nulls:** ratings, turnaround values, and cancellation-reason fields may be blank when not applicable. Use booking-status-aware quality rules.
5. **Status versus revenue:** total booking value includes bookings regardless of status, whereas success revenue is restricted to successful bookings.
6. **Model data types:** confirm actual types using Power BI Model View / Power Query and SQL `DESCRIBE` or information schema; suggested types in this dictionary are not a database schema audit.

## 7. Source references

- Repository source file: `01_bookings.csv`
- SQL rename script: `02_bookings.sql`
- Report file: `04_TOLA_Cabs.pbix`
- Power BI model screenshot and independently run DAX query outputs reviewed during final validation.
