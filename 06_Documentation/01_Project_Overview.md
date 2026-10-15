# TOLA Cabs — Jaipur City Operations Analytics

## 01 | Project Overview

**Project type:** Transportation and ride-booking analytics  
**Primary tools:** SQL, Microsoft Power BI, Power Query, DAX  
**Reporting period:** 1 January 2026 – 2 March 2026  
**Dataset size:** 150,000 booking records in the validated reporting period  
**Power BI report:** `04_TOLA_Cabs.pbix`  
**Project status:** Completed; core KPI reconciliation performed

## 1. Business Context

TOLA Cabs is a Jaipur-focused ride-booking analytics case study. The project explores how booking records can be transformed into decision-support reporting for ride demand, booking outcomes, revenue, customer engagement, vehicle categories, service quality, and location patterns.

The dashboard is designed as an **analytical portfolio project**. Findings describe patterns in the supplied dataset; they should not be represented as verified operating results of a real company.

## 2. Business Problem

Booking-level records are difficult to interpret without a consolidated view of performance. A stakeholder needs to understand:

- How many rides were booked, completed, cancelled, or left incomplete?
- What proportion of potential booking value became revenue from successful rides?
- How do customer and driver cancellations contribute to unsuccessful bookings?
- How do booking volume and completion rates change across the reporting period?
- Which vehicle categories, payment methods, and Jaipur locations feature prominently?
- What can customer repeat-booking behavior and rating metrics tell us?

## 3. Project Objectives

1. Consolidate booking and revenue metrics into a clear executive overview.
2. Track daily and monthly booking patterns and completion outcomes.
3. Separate customer-initiated and driver-initiated cancellations.
4. Measure customer engagement, including repeat booking behavior.
5. Compare vehicle-level completion, cancellation, distance, and turnaround measures.
6. Analyze revenue contribution and realization by payment method.
7. Identify leading pickup locations, drop locations, and pickup–drop routes.
8. Validate important dashboard KPIs against independent DAX query outputs.

## 4. Dataset and Reporting Scope

The validated report covers **150,000 bookings** dated **1 January–2 March 2026**:

| Period | Total bookings | Completed rides | Completion rate |
|---|---:|---:|---:|
| January 2026 | 100,000 | 62,087 | 62.09% |
| February 2026 | 46,758 | 11,648 | 24.91% |
| March 1–2, 2026 | 3,242 | 818 | 25.23% |
| **Total** | **150,000** | **74,553** | **49.70%** |

**Scope limitation:** March covers only two days. A full-month February-versus-March booking comparison is therefore not like-for-like. The marked decline in February booking volume and completion rate is a pattern in the dataset; its operational cause has not been independently established.

## 5. Technology Stack

| Technology | Role in the project |
|---|---|
| SQL | Source data preparation and analytical querying |
| CSV | Booking data source |
| Power Query | Data transformation for reporting |
| Power BI Desktop | Data modeling, report pages, interactive visuals, and slicers |
| DAX | Business measures, KPIs, and dynamic month-selection calculations |
| GitHub | Version control and portfolio presentation |

## 6. Report Architecture

The report contains **eight pages**:

| Page | Report section | Analytical focus |
|---|---|---|
| 01 | Executive Overview | Booking volume, completion, cancellations, revenue, and booking status |
| 02 | Booking Trends & Growth Analysis | Daily booking patterns, monthly volume, and selected-month comparison |
| 03 | Cancellation Trends & Root Cause Analysis | Customer/driver cancellations and cancellation reasons |
| 04 | Customer Behaviour & Engagement Analysis | Customer count, repeat behavior, booking frequency, and ratings |
| 05 | Driver Performance & Service Quality | Driver ratings, driver cancellations, and pickup time |
| 06 | Operational Efficiency & Performance Analysis | Completion, distance, turnaround time, and vehicle performance |
| 07 | Revenue & Payment Analytics | Booking value, successful revenue, payment methods, and realization |
| 08 | Location Demand & Route Analysis | Pickup/drop location activity and popular routes |

The visible Power BI model uses a `Calendar` date table related **one-to-many** to the `tola bookings` fact table with single-direction filtering. A `_Measures` table centralizes measures. Additional helper tables support month selection, customer type, and booking-frequency visualizations.

## 7. Validated Executive KPIs

The following values were reconciled using Power BI DAX query results:

| Metric | Validated value |
|---|---:|
| Total Bookings | 150,000 |
| Completed Rides | 74,553 |
| Completion Rate | 49.70% |
| Customer Cancellations | 34,455 |
| Driver Cancellations | 27,105 |
| Total Cancellations | 61,560 |
| Cancellation Rate | 41.04% |
| Incomplete Rides | 13,887 |
| Total Booking Value | ₹90,110,162 (₹9.01 Cr) |
| Success Revenue | ₹38,574,286 (₹3.86 Cr) |
| Revenue Realization Rate | 42.81% |
| Distinct Customers | 73,036 |
| Repeat Customers | 44,627 |
| Repeat Customer Rate | 61.10% |
| Average Bookings per Customer | 2.05 |
| Average Driver Rating | 4.25 |
| Average Customer Rating | 4.25 |
| Average Pickup Time (C_TAT) | 14.95 min |
| Average Trip Distance | 13.82 km |
| Unique Pickup Locations | 50 |
| Unique Drop Locations | 50 |

### Metric Definitions

- **Completion Rate:** Completed Rides ÷ Total Bookings.
- **Cancellation Rate:** (Customer Cancellations + Driver Cancellations) ÷ Total Bookings.
- **Success Revenue:** Sum of booking value for successful bookings.
- **Revenue Realization Rate:** Success Revenue ÷ Total Booking Value.
- **Repeat Customer Rate:** Customers with two or more bookings ÷ Distinct Customers, within the validated reporting period.

**Important:** Total Booking Value represents the value associated with bookings, not necessarily revenue earned. Success Revenue is the more appropriate metric for realized successful-ride value in this dataset.

## 8. Selected Data Insights

- **UPI** accounts for approximately **56.56% of successful booking revenue** and has the highest payment-method revenue realization rate in the validated breakdown.
- **eBike** has the highest vehicle-level completion rate in the validated results (**50.16%**), although rates across vehicle types are close.
- **Prime SUV** has the highest vehicle-level cancellation rate (**41.85%**) in the validated results.
- **44,627 customers (61.10%)** made at least two bookings within the reporting period.
- February's completion rate (**24.91%**) is substantially lower than January's (**62.09%**); this is a descriptive finding, not proof of an operational cause.

## 9. Validation and Limitations

**Checks performed:** Reconciliation of overall KPIs; monthly booking and completed-ride totals; customer frequency groups; payment-method totals and revenue; vehicle-category booking and cancellation counts; and driver/location KPI values.

**Checks not fully completed:** Exhaustive slicer-interaction testing, every DAX definition under every filter context, and independent verification of the underlying source-generation process.

The `Booking Month Selector` is a disconnected helper table. The dynamic growth measure supports selected-month comparisons. For **All / No selection**, the dashboard presents **49.70% overall completion performance**, which is **not a growth rate**. March comparisons should always be marked as partial-period comparisons.

## 10. Project Deliverables

- Power BI report: [`../04_TOLA_Cabs.pbix`](../04_TOLA_Cabs.pbix)
- Main project README: [`../README.md`](../README.md)
- Source dataset: [`../01_bookings.csv`](../01_bookings.csv)
- SQL data preparation: [`../02_bookings.sql`](../02_bookings.sql)
- SQL analysis (30 queries): [`../03_tola_bookings.sql`](../03_tola_bookings.sql)
- Report screenshots: [`../screenshots/`](../screenshots/)

## 11. Next Documentation Files

- `02_Data_Dictionary.md` — fields and business definitions
- `03_Data_Model.md` — relationships and helper tables
- `04_DAX_Measures.md` — measures and calculation logic
- `05_Data_Validation.md` — reconciliation methodology and evidence
- `06_Business_Insights.md` — findings, caveats, and recommendations

---

**Project:** TOLA Cabs — Jaipur City Operations Analytics  
**Repository:** https://github.com/aaswani365/tola-cabs-jaipur-analytics
