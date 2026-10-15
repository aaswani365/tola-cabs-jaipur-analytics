# TOLA Cabs — Data Model and Filter Architecture

## 03 | Power BI Data Model

**Project:** TOLA Cabs — Jaipur City Operations Analytics  
**Report file:** `04_TOLA_Cabs.pbix`  
**Model evidence:** Power BI Model View screenshot and DAX query results shared during project validation.  
**Scope:** Describes the model structure observed in Power BI; does not claim that every calculated-column expression or relationship property was exported and audited.

## 1. Model at a glance

The report uses a **central bookings fact table with a connected Calendar date dimension**, plus a dedicated measure table and disconnected helper tables. This is a **lightweight star-style reporting model**, not a fully normalized star schema: customer, vehicle, payment and location attributes are retained on the bookings fact table rather than modeled as separate connected dimensions.

```text
                     Calendar
                 [Date, Month, ...]
                         |
                  1 : * | single direction
                         v
                   tola bookings
        [Booking_ID, Date, Customer_ID, ...]

 _Measures                 Booking Month Selector
 (DAX measures)            (disconnected slicer)

 Customer Booking Frequency    Booking Frequency Groups
 (helper table)               (disconnected grouping helper)

 Customer Type
 (helper table)
```

## 2. Core tables

| Table | Role | Fields observed / purpose |
|---|---|---|
| `tola bookings` | Transaction fact | `Booking_ID`, `Date`, `Booking_Status`, `Customer_ID`, `Vehicle_Type`, `Booking_Value`, `Payment_Method`, `Pickup_Location`, `Drop_Location`, `Ride_Distance`, `C_TAT`, `V_TAT`, ratings and cancellation reasons |
| `Calendar` | Connected date dimension | `Date`, `Month`, `Month No`, `Quarter`, `Year` |
| `_Measures` | Measures-only organizational table | Central home for KPI, performance, revenue, cancellation and other DAX measures |
| `Booking Month Selector` | Disconnected interaction table | `Month`, `Month No`, `Dynamic Booking Growth` measure |
| `Customer Booking Frequency` | Customer analysis helper | `Customer_ID`, `BookingCount`, `Booking Group` |
| `Booking Frequency Groups` | Display / sort helper | `Booking Group`, `Sort Order` |
| `Customer Type` | Customer segmentation helper | `Type`, `Sort Order`, `Customers by Type` measure |

The helper tables were shown without relationship lines in the provided model screenshot. Their **exact calculated-table expressions and behavior under all filters have not been independently verified**.

## 3. Verified relationship shape

The Power BI Model View screenshot shows a **one-to-many (1:*)** relationship from `Calendar` to `tola bookings`, with a **single-direction filter flowing from Calendar to bookings**.

| Setting | Observed or expected |
|---|---|
| One-side table | `Calendar` |
| Many-side table | `tola bookings` |
| Date columns | Expected `Calendar[Date]` → `'tola bookings'[Date]`; verify in Edit Relationship dialog |
| Cardinality | `1:*` shown in screenshot |
| Cross-filter direction | Single, from Calendar to fact, shown in screenshot |
| Active status | Relationship line appears solid; confirm explicitly in Edit Relationship |
| Mark as date table | Recommended: mark `Calendar` using its unique, continuous `Date` column; not confirmed from screenshot |

**Important:** A screenshot of the relationship line alone does not prove the date keys have matching types or that `Calendar` has been marked as a date table. Confirm these in Power BI Desktop.

## 4. Date and time intelligence

The report's validated reporting window is **2026-01-01 through 2026-03-02**. Monthly DAX query results reconcile to:

| Month | Bookings | Completed | Completion rate |
|---|---:|---:|---:|
| January | 100,000 | 62,087 | 62.09% |
| February | 46,758 | 11,648 | 24.91% |
| March 1–2 | 3,242 | 818 | 25.23% |
| **Total** | **150,000** | **74,553** | **49.70%** |

A disconnected `Booking Month Selector` controls a measure that returns:

- **All / no selection:** overall completion rate, 49.70%, for the fixed Jan 1–Mar 2 reporting window; this is **not a growth rate**.
- **January:** N/A (no December comparison in this project window).
- **February:** booking change versus January, **−53.24%**.
- **March:** booking change versus February, **−93.07%**, comparing a **partial two-day month** to a full month.

The month selector affects only measures that explicitly read its selection; it is not a model relationship. Label the overall value **Overall Completion Rate / Overall Performance** and reserve up/down growth arrows for actual period-over-period changes. A positive completion rate does not itself indicate an increase.

## 5. Filter behavior and analytical implications

1. **Calendar slicers:** A date selection propagates to booking facts through the 1:* relationship and changes measures based on those facts.
2. **Vehicle-type filters:** Fact-level vehicle filtering affects booking, cancellation and revenue measures unless a measure deliberately removes those filters.
3. **Disconnected month selector:** `SELECTEDVALUE('Booking Month Selector'[Month No], 0)` determines the comparison month; it does not automatically filter other report visuals.
4. **`REMOVEFILTERS('Calendar')`:** The dynamic booking comparison explicitly clears date filters to calculate fixed 2026 month totals. Other filters, such as vehicle type, can remain active. Therefore the booking-growth visual may **not respect the top date slicer**, which should be made clear if both controls appear on the same page.
5. **Customer helper tables:** If calculated at refresh time, frequency groups may not automatically recompute for every report-level filter. Validate their slicer behavior before claiming fully dynamic customer segmentation.

## 6. Calculated columns visible in the model

The fact table screenshot also shows derived fields such as `Day_Name`, `Distance Bucket`, `Hour`, `Hour Basket`, and `Pickup Drop Route`. They support time-of-day, distance and route reporting. Their precise DAX/Power Query definitions have **not** been inspected, so no expressions are asserted here.

## 7. Data lineage and reproducibility caveat

The checked-in `01_bookings.csv` has **100,000 rows dated Jan 1–30, 2026**, while the validated Power BI report contains **150,000 rows through Mar 2, 2026**. The additional 50,000 records and the final transformation or append process are not fully represented by that CSV alone. Record the source and transformation steps for the additional data before claiming the repository reproduces the report end to end.

For column-by-column definitions, see [`02_Data_Dictionary.md`](02_Data_Dictionary.md). For project scope and validated totals, see [`01_Project_Overview.md`](01_Project_Overview.md).

## 8. Final model checklist

- [x] Fact and Calendar tables identified in Model View
- [x] One-to-many single-direction date relationship visible
- [x] Dedicated measure table identified
- [x] Disconnected month selector and customer helper tables identified
- [x] Overall and monthly bookings reconciled using DAX queries
- [ ] Confirm exact date join columns, active relationship, and data types in Edit Relationship
- [ ] Confirm Calendar date continuity and Mark as date table setting
- [ ] Test combined date, vehicle and customer-related slicer behavior
- [ ] Document provenance of the additional 50,000 bookings

---

*Documentation prepared from observed model structure and user-supplied validation results; unverified implementation details are explicitly identified.*
