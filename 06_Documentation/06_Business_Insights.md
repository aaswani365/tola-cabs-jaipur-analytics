# TOLA Cabs — Business Insights and Recommendations

## 06 | Jaipur City Operations Analytics

**Report:** `04_TOLA_Cabs.pbix`  
**Period:** 1 January–2 March 2026 (March contains only two days)  
**Coverage:** 150,000 bookings, seven vehicle categories, 50 pickup locations and 50 drop locations  
**Basis:** Power BI DAX Query View results and dashboard figures reviewed during project validation. These are **descriptive findings**, not proof of operational causes or intervention outcomes.

---

## 1. Executive summary

The TOLA Cabs dataset records **150,000 bookings**, of which **74,553 (49.70%)** were completed successfully, **61,560 (41.04%)** were cancelled by a customer or driver, and **13,887 (9.26%)** were incomplete. Total booking value was **₹90,110,162 (₹9.01 Cr)**, while successful-booking revenue was **₹38,574,286 (₹3.86 Cr)**, giving a **42.81% revenue realization rate**.

The principal operational opportunity is to understand and reduce booking non-completion, particularly cancellations. January and February also exhibit markedly different completion rates; the source and business context should be checked before attributing that change to operational performance.

### KPI snapshot

| Metric | Validated result |
|---|---:|
| Total bookings | 150,000 |
| Completed rides | 74,553 |
| Completion rate | 49.70% |
| Customer cancellations | 34,455 (22.97% of bookings) |
| Driver cancellations | 27,105 (18.07% of bookings) |
| All cancellations | 61,560 (41.04% of bookings) |
| Incomplete bookings | 13,887 (9.26% of bookings) |
| Total booking value | ₹9.01 Cr |
| Successful-booking revenue | ₹3.86 Cr |
| Revenue realization | 42.81% |
| Distinct customers | 73,036 |
| Repeat customers | 44,627 (61.10%) |

**Definitions:** *Total booking value* represents the value attached to all bookings; *success revenue* is the booking value of rides marked `Success`. The latter should not automatically be described as settled cash receipts or accounting revenue without payment-settlement evidence.

---

## 2. Booking demand and completion trends

| Period | Bookings | Successful rides | Completion rate |
|---|---:|---:|---:|
| January 2026 | 100,000 | 62,087 | 62.09% |
| February 2026 | 46,758 | 11,648 | 24.91% |
| March 1–2, 2026 | 3,242 | 818 | 25.23% |

**Findings**

- Recorded February bookings were **53.24% below January**. The periods are both complete calendar months, but the dataset's generation/collection methodology has not been independently verified.
- February's completion rate was about **37.18 percentage points below January's**.
- March contains only **two days**. Its 3,242 bookings must **not** be treated as a full-month demand figure or compared directly with full February to claim a 93.07% decline in comparable monthly demand.

**Recommended actions**

1. Check source-data generation, completeness, and booking-status definitions for each month before concluding that demand or service quality deteriorated.
2. Track daily bookings, completion rate, and cancellation mix together, segmented by vehicle type and pickup zone.
3. For future month-over-month reporting, use completed months or like-for-like day counts, and flag partial periods visibly.

---

## 3. Cancellation and service reliability

**Finding:** Customer cancellations (**34,455**) exceed driver cancellations (**27,105**) by **7,350 bookings**. Together they represent **41.04%** of all bookings. A further **9.26%** are incomplete.

**Recommended actions**

- Analyze customer cancellation reasons separately from driver cancellation reasons; prioritize the largest reason groups after checking their labels and counts in the report.
- Examine cancellations by pickup zone, vehicle category, time of day, and turnaround time to locate actionable patterns.
- Define clear operational ownership and targets for customer cancellation rate, driver cancellation rate, and incomplete-booking rate.
- Evaluate interventions using before/after cohorts or controlled tests, rather than assuming the dashboard establishes causation.

**Caution:** The reviewed aggregate query confirms cancellation totals but does not establish the leading *individual cancellation reasons*. Do not rank reasons without checking the reason-level visuals or query outputs.

---

## 4. Customer engagement and repeat use

| Booking frequency | Distinct customers | Share of customers |
|---|---:|---:|
| Exactly one booking | 28,409 | 38.90% |
| Exactly two | 23,535 | 32.22% |
| Exactly three | 13,134 | 17.98% |
| Four or more | 7,958 | 10.90% |
| **Total** | **73,036** | **100%** |

**Finding:** **44,627 customers (61.10%)** made two or more bookings within the observed dataset, with an average of **2.05 bookings per customer**. The average customer rating reported by the dashboard is **4.25/5**.

**Recommended actions**

- Segment one-time and repeat customers to study completion and cancellation patterns.
- Investigate whether customers with multiple bookings show different ride success rates or payment preferences.
- Track repeat-booking behavior over consistent cohorts and observation windows.

**Interpretation:** The **61.10%** figure is the share of customers with multiple bookings in this dataset; it is **not** a longitudinal customer-retention rate.

---

## 5. Revenue and payment performance

| Payment method | Bookings | Completed rides | Successful-booking revenue |
|---|---:|---:|---:|
| UPI | 81,472 | 50,070 | Approx. ₹2.18 Cr |
| Wallet | 29,869 | 7,497 | Approx. ₹70.18 L |
| Cash | 27,693 | 12,450 | Approx. ₹69.92 L |
| In App | 10,966 | 4,536 | Approx. ₹27.47 L |
| **Total** | **150,000** | **74,553** | **₹3.86 Cr** |

**Findings**

- **UPI** accounts for the largest share of successful-booking revenue, approximately **56.56%**.
- The dataset-wide revenue realization rate is **42.81%**, consistent with the low overall ride completion rate.
- Payment-method differences in successful-booking revenue and completion mix warrant investigation, but do not by themselves demonstrate that payment choice causes a successful ride.

**Recommended actions**

- Track completed bookings and realized booking value by payment method and vehicle type.
- Investigate the booking-status composition of each payment method before designing payment-related interventions.
- Reconcile booking-value metrics with actual payments, refunds, discounts, and settlements if financial data becomes available.

---

## 6. Vehicle-category performance

| Vehicle category | Bookings | Completion rate | Cancellation rate |
|---|---:|---:|---:|
| Auto | 21,672 | 49.19% | 41.28% |
| Prime Sedan | 21,515 | 49.86% | 41.05% |
| Bike | 21,424 | 49.62% | 40.93% |
| Prime SUV | 21,409 | 49.28% | 41.85% |
| Mini | 21,346 | 50.07% | 40.66% |
| eBike | 21,339 | **50.16%** | **40.65%** |
| Prime Plus | 21,295 | 49.73% | 40.86% |

**Findings**

- **eBike** has the highest observed completion rate (**50.16%**) and lowest cancellation rate (**40.65%**).
- **Prime SUV** has the highest observed cancellation rate (**41.85%**).
- Differences are relatively small across the seven categories, so the dataset does not justify large category-specific claims without further segmentation or statistical testing.

**Recommended actions**

- Review cancellation reasons and demand/supply balance for Prime SUV and other categories.
- Compare vehicle performance within the same periods and pickup zones to reduce confounding.
- Avoid interpreting small percentage differences as proven service-quality differences.

---

## 7. Driver and turnaround performance

**Validated averages**

- Driver rating: **4.25/5**
- Customer rating: **4.25/5**
- Average C_TAT (pickup time as labeled in the report): **14.95 minutes**
- Average V_TAT: **8.49 minutes**
- Average trip distance: **13.82 km**

**Recommended actions**

- Segment pickup times by vehicle type, pickup location, and booking status.
- Test whether longer pickup times are associated with cancellations; association would not itself prove causation.
- Establish an operational definition of C_TAT and V_TAT in the data dictionary and use consistent units across visuals.
- Review ratings alongside completed-ride counts and missing-rating coverage.

---

## 8. Location demand and route analysis

The model contains **50 distinct pickup locations** and **50 distinct drop locations**. The Location report presents top pickup areas, top drop areas, pickup-area completion rates, and leading pickup–drop routes.

**Illustrative findings from reviewed dashboard figures**

- **Kanakpura** and **VKI Area** appeared among the highest-volume pickup locations, each with approximately **3,077 bookings**.
- **Sindhi Camp** appeared as a leading drop location with approximately **3,188 bookings**.
- **Vaishali Nagar** appeared among the higher-completion pickup locations at approximately **51.91%**.

These location figures were read from dashboard views and have not been independently re-run through a location-level DAX validation query.

**Recommended actions**

- Compare pickup demand with completed rides and cancellation rates by zone, not demand alone.
- Use peak-period and route analysis to identify candidate areas for driver positioning.
- Validate operational changes with location-level service metrics and comparable time periods.

---

## 9. Prioritized business recommendations

| Priority | Recommendation | Proposed monitoring KPI |
|---|---|---|
| High | Investigate causes and data quality behind low booking completion | Completion rate; incomplete rate |
| High | Break down customer and driver cancellation reasons | Cancellation rate by actor and reason |
| High | Audit January–February status and volume shifts | Daily bookings and completion rate |
| Medium | Segment performance by vehicle and pickup location | Zone/category completion and cancellation rates |
| Medium | Explore repeat-booking patterns by customer cohort | Repeat-booking share and cohort retention |
| Medium | Monitor payment-method differences without causal assumptions | Success revenue and completion rate by method |
| Medium | Assess pickup time and customer experience | C_TAT, ratings, cancellation rate |

These are **proposed actions**, not interventions shown to have been implemented or proven effective.

---

## 10. Data quality and analytical limitations

1. **Partial March:** The report ends on **2 March 2026**; March is not a complete month.
2. **Source reproducibility:** The repository's `01_bookings.csv` contains **100,000 rows**, whereas the validated Power BI model reports **150,000 bookings**. The additional data source or generation step should be documented or supplied before claiming full reproduction from the repository CSV.
3. **Data generation and provenance:** The origin and realism of observed monthly shifts have not been independently established. Treat findings as analysis of the provided dataset.
4. **Missing fields:** Cancellation reasons and ratings may be conditionally missing according to booking outcome; confirm definitions before treating missing values as errors.
5. **Revenue terminology:** Successful booking value is not independently verified settled revenue.
6. **Metric definitions:** Repeat-booking share is not cohort retention. March's month-over-month growth display is not a like-for-like comparison.
7. **Technical scope:** KPI totals were arithmetically reconciled from shared Power BI query outputs; all DAX definitions, refresh paths, cross-filter interactions, and source records were not independently audited.

---

## 11. Dashboard pages and supporting documentation

The report contains eight pages: **Executive Overview**, **Booking Trends & Growth Analysis**, **Cancellation Trends & Root Cause Analysis**, **Customer Behaviour & Engagement Analysis**, **Driver Performance & Service Quality**, **Operational Efficiency & Performance Analysis**, **Revenue & Payment Analytics**, and **Location Demand & Route Analysis**.

For implementation and evidence, see:

- [`01_Project_Overview.md`](01_Project_Overview.md)
- [`02_Data_Dictionary.md`](02_Data_Dictionary.md)
- [`03_Data_Model.md`](03_Data_Model.md)
- [`04_DAX_Measures.md`](04_DAX_Measures.md)
- [`05_Data_Validation.md`](05_Data_Validation.md)

**Project status:** Dashboard completed; core KPI reconciliation passed; full source-data reproducibility and all slicer combinations remain to be independently verified.
