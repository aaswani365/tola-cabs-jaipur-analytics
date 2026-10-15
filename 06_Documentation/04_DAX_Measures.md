# TOLA Cabs — DAX Measures and Calculation Logic

## 04 | Power BI Measure Reference

**Project:** TOLA Cabs — Jaipur City Operations Analytics  
**Report:** `04_TOLA_Cabs.pbix`  
**Validated reporting period:** 1 January–2 March 2026  
**Fact table:** `'tola bookings'` | **Date table:** `'Calendar'`

> **Evidence and scope.** Formulas in **Section 2** are based on DAX shared in the project conversation. The final dynamic growth formula in **Section 3** follows the version the user confirmed was working, including the All-selection completion-rate behavior. Other measures in **Section 4** are **illustrative definitions**, not verified copies of the PBIX measure expressions. Numerical outputs are from Power BI DAX query results supplied during validation. The PBIX embedded semantic model was not fully extracted or executed in this documentation step.

## 1. Measure organization

The model uses a dedicated `_Measures` table. The project groups measures conceptually into:

| Folder | Focus |
|---|---|
| `01_Bookings` | Total bookings, completed and incomplete rides, completion rate |
| `02_Revenue` | Booking value, success revenue, average values, realization rate |
| `03_Cancellations` | Customer and driver cancellations, rates |
| `04_Customers` | Unique and repeat customers, customer ratings, frequency |
| `05_Performance` | Ride distance, pickup/turnaround times, driver rating |
| `06_Time_Intelligence` | Prior-month metrics and booking growth |

Some dynamic measures reside under the disconnected `Booking Month Selector` table. Folder names describe the project organization and do not independently establish every measure's exact home table.

## 2. Core DAX formulas supplied during development

### Booking metrics

```dax
Total Bookings =
COUNTROWS('tola bookings')

Completed Rides =
CALCULATE(
    COUNT('tola bookings'[Booking_ID]),
    'tola bookings'[Booking_Status] = "Success"
)

Completion Rate =
DIVIDE([Completed Rides], [Total Bookings], 0)
```

**Validated:** 150,000 bookings; 74,553 completed; 49.702% completion rate.

> **Counting consideration:** `COUNT(Booking_ID)` counts nonblank numeric IDs; `COUNTROWS` counts rows. Check Booking_ID data type, blanks, and uniqueness if changing source data. The supplied results reconcile for the current model.

### Cancellation metrics

```dax
Customer Cancelled =
CALCULATE(
    COUNT('tola bookings'[Booking_ID]),
    'tola bookings'[Booking_Status] = "Cancelled by Customer"
)

Driver Cancelled =
CALCULATE(
    COUNT('tola bookings'[Booking_ID]),
    'tola bookings'[Booking_Status] = "Cancelled by Driver"
)

Total Cancelled =
[Customer Cancelled] + [Driver Cancelled]

Cancellation Rate =
DIVIDE([Total Cancelled], [Total Bookings], 0)
```

**Validated:** Customer cancellations 34,455; driver cancellations 27,105; total 61,560; cancellation rate 41.04%. Remaining 13,887 bookings are incomplete after subtracting completed and cancelled from the overall total.

### Revenue metrics

```dax
Total Booking Value =
SUM('tola bookings'[Booking_Value])

Success Revenue =
CALCULATE(
    SUM('tola bookings'[Booking_Value]),
    'tola bookings'[Booking_Status] = "Success"
)

Revenue Realization Rate =
DIVIDE([Success Revenue], [Total Booking Value], 0)
```

**Validated:** Total booking value ₹90,110,162 (₹9.01 Cr); success revenue ₹38,574,286 (₹3.86 Cr); realization rate 42.8079% (42.81%). **Total Booking Value is not realized revenue**; it includes unsuccessful bookings.

### Customer metrics

```dax
Total Customers =
DISTINCTCOUNT('tola bookings'[Customer_ID])
```

**Validated:** 73,036 distinct customers. The existing `[Repeat Customer]` measure returned 44,627 and `[Repeat Customer Rate]` returned 61.1027%. Their exact saved formulas have not been verified, but an independent grouping query reconciled the figures (see Section 5).

## 3. Dynamic Booking Growth: selected-month behavior

The disconnected `'Booking Month Selector'[Month No]` drives this measure. The following is the **final calculation logic supplied in the conversation** for the revised behavior:

```dax
Dynamic Booking Growth =
VAR SelectedMonth =
    SELECTEDVALUE('Booking Month Selector'[Month No], 0)
VAR CurrentMonthBookings =
    CALCULATE(
        [Total Bookings],
        REMOVEFILTERS('Calendar'),
        'Calendar'[Year] = 2026,
        'Calendar'[Month No] = SelectedMonth
    )
VAR PreviousMonthBookings =
    CALCULATE(
        [Total Bookings],
        REMOVEFILTERS('Calendar'),
        'Calendar'[Year] = 2026,
        'Calendar'[Month No] = SelectedMonth - 1
    )
VAR OverallCompletionRate =
    CALCULATE(
        [Completion Rate],
        REMOVEFILTERS('Calendar'),
        'Calendar'[Date] >= DATE(2026, 1, 1),
        'Calendar'[Date] <= DATE(2026, 3, 2)
    )
RETURN
    SWITCH(
        TRUE(),
        SelectedMonth = 0, OverallCompletionRate,
        SelectedMonth = 1, BLANK(),
        SelectedMonth IN { 2, 3 },
            DIVIDE(
                CurrentMonthBookings - PreviousMonthBookings,
                PreviousMonthBookings
            ),
        BLANK()
    )
```

Display measure as last shared:

```dax
Dynamic Booking Growth Display =
VAR SelectedMonth =
    SELECTEDVALUE('Booking Month Selector'[Month No], 0)
VAR Growth = [Dynamic Booking Growth]
RETURN
    SWITCH(
        TRUE(),
        ISBLANK(Growth), "N/A",
        SelectedMonth = 0, "▲ " & FORMAT(Growth, "0.00%"),
        Growth < 0, "▼ " & FORMAT(ABS(Growth), "0.00%"),
        "▲ " & FORMAT(Growth, "0.00%")
    )
```

**User confirmation:** The revised visual was reported as working. The actual final PBIX formula text was not separately exported for comparison.

| Selector | Displayed result | Interpretation |
|---|---:|---|
| All / none | 49.70% | **Overall completion rate** for Jan 1–Mar 2, **not booking growth** |
| January | N/A | No prior-month comparison in the defined reporting window |
| February | ▼ 53.24% | February 46,758 bookings vs January 100,000 |
| March | ▼ 93.07% | March 1–2 3,242 bookings vs all of February 46,758 |

**Presentation warning:** An upward arrow on All / none is a visual convention only. It **does not establish an increase** in completion rate. The most analytically accurate label is `Overall Completion Rate` with a neutral indicator. March is a partial month and must not be presented as a like-for-like monthly decline.

**Filter-context warning:** `REMOVEFILTERS('Calendar')` ignores Calendar slicers for these fixed comparisons, while filters on other columns (e.g., vehicle type) may remain in effect. If multiple months are selected, `SELECTEDVALUE(..., 0)` falls back to the All behavior.

## 4. Additional measures — illustrative formulas, not extracted originals

These examples express the business definitions used in the report. **Do not overwrite existing measures without checking their original definitions and intended filter context.**

```dax
-- Illustration: incomplete bookings
Incomplete Rides (example) =
[Total Bookings] - [Completed Rides] - [Total Cancelled]

-- Illustration: average value of all bookings
Avg Booking Value (example) =
DIVIDE([Total Booking Value], [Total Bookings], 0)

-- Illustration: revenue per completed ride
Revenue / Completed Ride (example) =
DIVIDE([Success Revenue], [Completed Rides], 0)

-- Illustration: average bookings per unique customer
Bookings / Customer (example) =
DIVIDE([Total Bookings], [Total Customers], 0)

-- Illustration: repeat customer rate if the existing
-- [Repeat Customer] measure counts distinct customers with 2+ bookings
Repeat Customer Rate (example) =
DIVIDE([Repeat Customer], [Total Customers], 0)
```

**Validated derived values:** 13,887 incomplete; average booking value approximately ₹600.73; revenue per completed ride approximately ₹517.41; bookings per customer approximately 2.05.

**Other existing measures** include `[Avg Distance]`, `[Avg C_TAT]`, `[Avg V_TAT]`, `[Avg Driver Rating]`, and `[Avg Customer Rating]`. Their outputs were tested, but their exact DAX expressions and blank-handling rules were not exported.

## 5. Independent customer frequency validation query

This DAX query was executed in Power BI and reconciled to the customer dashboard:

```dax
EVALUATE
VAR CustomerBookings =
    ADDCOLUMNS(
        VALUES('tola bookings'[Customer_ID]),
        "BookingCount", CALCULATE([Total Bookings])
    )
RETURN
    ROW(
        "Total Customers", COUNTROWS(CustomerBookings),
        "One Booking", COUNTROWS(FILTER(CustomerBookings, [BookingCount] = 1)),
        "Two Bookings", COUNTROWS(FILTER(CustomerBookings, [BookingCount] = 2)),
        "Three Bookings", COUNTROWS(FILTER(CustomerBookings, [BookingCount] = 3)),
        "Four Plus Bookings", COUNTROWS(FILTER(CustomerBookings, [BookingCount] >= 4)),
        "Repeat Customers", COUNTROWS(FILTER(CustomerBookings, [BookingCount] >= 2))
    )
```

| Booking frequency | Distinct customers |
|---|---:|
| 1 booking | 28,409 |
| 2 bookings | 23,535 |
| 3 bookings | 13,134 |
| 4+ bookings | 7,958 |
| **Total** | **73,036** |
| **Repeat (2+)** | **44,627** |

## 6. Monthly reconciliation

| Month | Total bookings | Completed rides | Completion rate |
|---|---:|---:|---:|
| January 2026 | 100,000 | 62,087 | 62.09% |
| February 2026 | 46,758 | 11,648 | 24.91% |
| March 1–2, 2026 | 3,242 | 818 | 25.23% |
| **Total** | **150,000** | **74,553** | **49.70%** |

## 7. Validation and maintenance notes

- The KPI totals above were checked using DAX Query View and vehicle/payment group reconciliations.
- Query results establish **arithmetic consistency**, not correctness under every slicer combination.
- Check `Booking_ID` uniqueness and nulls when refreshing source data.
- Confirm Calendar relationship, active status and date table configuration in Power BI Desktop.
- Check the customer-frequency helper tables under date/vehicle slicers; refresh-time calculated tables may not recalculate grouping dynamically.
- The checked-in 100,000-row CSV does not alone reproduce the 150,000-row Power BI model. Document the additional 50,000 rows and ingestion steps.
- For audit results, see [`05_Data_Validation.md`](05_Data_Validation.md) once created; for model architecture, see [`03_Data_Model.md`](03_Data_Model.md).
