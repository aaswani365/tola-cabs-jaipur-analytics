# TOLA Cabs — Data Validation and KPI Reconciliation

## 05 | Power BI Technical Validation Evidence

**Project:** TOLA Cabs — Jaipur City Operations Analytics  
**Report file:** `04_TOLA_Cabs.pbix`  
**Reporting window:** 1 January–2 March 2026  
**Evidence:** DAX Query View outputs shared during project review; results are from the loaded Power BI model, not independently re-executed against the source CSV.

## 1. Validation scope and status

| Area | Outcome | Qualification |
|---|---|---|
| Overall bookings and statuses | PASS | Category counts reconcile to 150,000 |
| Completion and cancellation rates | PASS | Numerators/denominators reconcile |
| Revenue and payment methods | PASS | Successful revenue and booking values reconcile |
| Customer frequency and retention | PASS | Frequency buckets sum to distinct customers |
| Vehicle-category performance | PASS | Seven vehicle categories reconcile to totals |
| Driver ratings, trip time and locations | PASS | Reported measures match dashboard figures |
| Date-model relationship | REVIEWED | Screenshot showed 1:* single-direction relationship; column mapping, active state and date-table marking were not independently inspected |
| Full filter/slicer interaction coverage | NOT FULLY TESTED | Test selections and cross-highlighting in Power BI Desktop |
| Reproduction from repository CSV | OPEN | Repository CSV contains 100,000 records; model reports 150,000 |

**Interpretation:** PASS means the *supplied query results* reconcile arithmetically. It does not mean every DAX expression, source row, filter combination, or refresh operation has been independently audited.

## 2. Overall KPI reconciliation

| KPI | DAX result | Check |
|---|---:|---|
| Total bookings | 150,000 | Baseline |
| Completed rides | 74,553 | 49.702% of bookings |
| Customer cancelled | 34,455 | Cancellation component |
| Driver cancelled | 27,105 | Cancellation component |
| Total cancelled | 61,560 | 34,455 + 27,105 |
| Incomplete bookings | 13,887 | 150,000 − 74,553 − 61,560 |
| Completion rate | 49.702% | 74,553 / 150,000 |
| Cancellation rate | 41.040% | 61,560 / 150,000 |
| Total booking value | ₹90,110,162 | ₹9.01 crore (rounded) |
| Success revenue | ₹38,574,286 | ₹3.86 crore (rounded) |
| Revenue realization | 42.8079% | 38,574,286 / 90,110,162 |
| Distinct customers | 73,036 | Baseline |
| Repeat customers | 44,627 | Two or more bookings |
| Repeat customer rate | 61.1027% | 44,627 / 73,036 |
| Bookings per customer | 2.0538 | 150,000 / 73,036 |

**Status identity:** 74,553 + 34,455 + 27,105 + 13,887 = **150,000**.

## 3. Monthly reconciliation

| Month | Total bookings | Completed rides | Completion rate |
|---|---:|---:|---:|
| January 2026 | 100,000 | 62,087 | 62.09% |
| February 2026 | 46,758 | 11,648 | 24.91% |
| March 1–2, 2026 | 3,242 | 818 | 25.23% |
| **Total** | **150,000** | **74,553** | **49.70%** |

January to February booking volume changes by **−53.24%**. February to March 1–2 changes by **−93.07%**, but this latter figure compares a full month with two days and must **not** be presented as a like-for-like month-over-month decline. The completion-rate decline between January and February is substantial; the data alone does not establish its cause.

### Dynamic Booking Growth selector

| Selection | Intended result | Meaning |
|---|---|---|
| All / no selection | 49.70% | **Overall completion rate**, not growth |
| January | N/A | No prior-month baseline in scope |
| February | ▼ 53.24% | February vs January booking count |
| March | ▼ 93.07% | March 1–2 vs full February; not comparable periods |

**Presentation warning:** An upward arrow alongside the All-selection 49.70% could be mistaken for positive growth. Prefer a neutral indicator and a title such as *Overall Completion Rate* for this selection. The user confirmed the selector displays the intended values; every combination of date and vehicle slicers was not separately tested.

## 4. Customer segmentation reconciliation

| Bookings per customer | Distinct customers |
|---|---:|
| Exactly 1 | 28,409 |
| Exactly 2 | 23,535 |
| Exactly 3 | 13,134 |
| 4 or more | 7,958 |
| **Total** | **73,036** |

Repeat customers = 23,535 + 13,134 + 7,958 = **44,627**. The buckets are mutually exclusive and sum to the overall distinct-customer count.

### Reproducible DAX check

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

## 5. Revenue and payment method checks

| Payment method | Bookings | Completed rides |
|---|---:|---:|
| UPI | 81,472 | 50,070 |
| Wallet | 29,869 | 7,497 |
| Cash | 27,693 | 12,450 |
| In App | 10,966 | 4,536 |
| **Total** | **150,000** | **74,553** |

The four payment categories reconcile to the overall booking and completed-ride counts. The query-level successful revenue reconciled to **₹38,574,286**, and total booking value to **₹90,110,162**. Approximate successful-revenue shares displayed in the report are UPI 56.56%, Wallet 18.19%, Cash 18.13%, and In App 7.12%. The payment-method result screenshot is the source for the individual revenue breakdown; use unrounded values when checking totals.

## 6. Vehicle-type reconciliation

| Vehicle type | Bookings | Completed | Customer cancelled | Driver cancelled | Completion rate | Cancellation rate |
|---|---:|---:|---:|---:|---:|---:|
| Auto | 21,672 | 10,660 | 4,981 | 3,966 | 49.19% | 41.28% |
| Prime Sedan | 21,515 | 10,728 | 4,965 | 3,866 | 49.86% | 41.05% |
| Bike | 21,424 | 10,631 | 4,921 | 3,847 | 49.62% | 40.93% |
| Prime SUV | 21,409 | 10,551 | 4,936 | 4,023 | 49.28% | 41.85% |
| Mini | 21,346 | 10,688 | 4,867 | 3,812 | 50.07% | 40.66% |
| eBike | 21,339 | 10,704 | 4,861 | 3,813 | 50.16% | 40.65% |
| Prime Plus | 21,295 | 10,591 | 4,924 | 3,778 | 49.73% | 40.86% |
| **Total** | **150,000** | **74,553** | **34,455** | **27,105** | **49.70%** | **41.04%** |

The supplied per-vehicle turnaround and distance averages are consistent with the dashboard's approximate overall **13.82 km** trip distance, **14.95 min** C_TAT and **8.49 min** V_TAT. Weighted averages are indicative; exact global means can differ if underlying measures exclude blanks or use different row populations.

## 7. Driver and location KPI checks

| KPI | Validated displayed value |
|---|---:|
| Average driver rating | 4.25 / 5 |
| Average customer rating | 4.25 / 5 |
| Average C_TAT | 14.95 min |
| Average trip distance | 13.82 km |
| Unique pickup locations | 50 |
| Unique drop locations | 50 |

These match the reported Drivers, Customers, Performance, and Location cards. The top-location and route ranking visuals were not separately independently recalculated in this audit.

## 8. Open data-quality and reproducibility items

1. **Source coverage:** The inspected repository file `01_bookings.csv` contains 100,000 rows dated 1–30 January 2026, while the Power BI model reports 150,000 rows through 2 March 2026. Document or publish the additional 50,000 rows or their generation method before claiming end-to-end reproduction from the CSV alone.
2. **Booking ID uniqueness:** The 100,000-row CSV was observed to contain 99,999 distinct booking IDs. Determine whether the repeated identifier is a source error or legitimate reuse.
3. **Partial March:** Explicitly label March as *March 1–2* in charts, tooltips, and business conclusions.
4. **Refresh path:** Confirm Power Query source paths work after cloning on another computer.
5. **Relationship settings:** Confirm Calendar-to-fact relationship is active, correctly typed, and that Calendar is marked as the date table.
6. **Filter testing:** Test date, vehicle, payment, and month-selector selections individually and in combination, including empty and multi-select states.
7. **Operational interpretation:** The cause of January–February changes is not established; avoid causal claims without supporting operational evidence.

## 9. Final verification checklist

- [x] Overall booking status totals reconcile
- [x] Core ratios recalculate from their component counts
- [x] Monthly totals reconcile
- [x] Customer-frequency groups reconcile
- [x] Payment method booking and completion counts reconcile
- [x] Vehicle category totals reconcile
- [x] Driver/location summary cards match query output
- [ ] Confirm full report reproducibility from checked-in sources
- [ ] Resolve duplicate booking identifier in source CSV
- [ ] Test all critical slicer interactions and refresh paths
- [ ] Confirm Calendar date-table configuration and active relationship

**Audit conclusion:** Core report metrics passed arithmetic reconciliation against user-supplied Power BI query results. The remaining items concern source completeness, data quality, configuration, and end-to-end reproducibility; they should remain visible rather than be described as already validated.
