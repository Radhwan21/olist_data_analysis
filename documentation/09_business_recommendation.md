# 09 — Business Recommendations

The purpose of the analysis was not only to find interesting numbers, but to understand what could actually be done with them.

The recommendations below are based on the patterns identified in the SQL analysis and Power BI dashboard. I focused on actions that can be connected to measurable business KPIs rather than generic advice.

---

## 9.1 Improve Delivery Performance Where Delays Are Most Severe

The overall delivery rate looks strong, with around **91% of orders delivered on time**. However, the state-level analysis shows that delivery problems are not distributed evenly.

Some seller states have much higher average late-delivery days than others.

This suggests that looking only at the marketplace-wide average can hide specific operational problems.

### Recommendation

Investigate the seller states with the highest delay severity separately.

The investigation could include:

- seller concentration in those states
- carrier performance
- average distance to customers
- product categories commonly shipped from those states
- freight cost
- order volume

The goal would be to find out whether the delays come mainly from sellers, logistics, geography, or a combination of these factors.

### KPI to monitor

- Late delivery rate
- Average late-delivery days
- On-time delivery rate

---

## 9.2 Treat Severe Delays Differently From Small Delays

The delivery analysis showed a clear relationship between delay severity and review scores.

Orders delivered on time had an average review score of around **4.3**, while orders with longer delays had substantially lower scores.

This means that simply reducing the number of late orders may not tell the whole story.

A small delay and a 15+ day delay represent very different customer experiences.

### Recommendation

Track delivery problems by severity instead of using only one "late vs on-time" metric.

For example:

~~~text
On time
1–3 days late
4–7 days late
8–14 days late
15+ days late
Not delivered
~~~

This makes it easier to identify where the most serious customer-experience problems are happening.

### KPI to monitor

- % of orders in each delay group
- Average review score by delay group
- % of orders delayed 8+ days
- % of orders not delivered

---

## 9.3 Investigate Customer Retention

One of the strongest patterns in the customer analysis is the concentration of customers around a single purchase.

Around **97% of customers appear only once** in the observed dataset.

I would not automatically interpret this as a customer satisfaction problem. The dataset covers a limited historical period, and customers may simply have had no reason to purchase again during that period.

Still, this is important enough to investigate.

### Recommendation

Analyze the customer journey after the first order.

A useful next step would be to compare customers based on their first-order experience:

- on-time + high review
- on-time + low review
- late + high review
- late + low review

Then measure whether they placed another order.

This could reveal whether delivery and customer experience are connected to repeat purchasing.

### KPI to monitor

- Repeat purchase rate
- Time to second order
- Repeat purchase rate by first-order review score
- Repeat purchase rate by first-order delivery status

---

## 9.4 Separate Demand From Revenue When Evaluating Categories

The category analysis showed that the category generating the most revenue is not necessarily the category with the highest order-item demand.

That distinction matters.

A category can generate high revenue because of higher-value products, while another category can have much greater transaction volume.

### Recommendation

Use at least three dimensions when evaluating a category:

~~~text
Demand
  +
Revenue
  +
Customer experience
~~~

This avoids decisions based only on sales value.

For example, a high-demand category with relatively low revenue per item could represent a different business opportunity from a lower-volume category with expensive products.

### KPI to monitor

- Items sold
- Revenue
- Average selling value
- Average review score
- Freight / revenue ratio

---

## 9.5 Use Geography to Find Operational Gaps

The customer and seller analyses show that geography matters on both sides of the marketplace.

Customer demand is concentrated in certain cities, while seller performance and delivery delays vary across seller states.

This creates an interesting question:

> Are the places with the highest customer demand also well supported by the seller network?

### Recommendation

Compare customer demand with seller coverage.

Areas with strong customer demand but limited nearby seller coverage could deserve further investigation because distance, freight cost, or delivery time may become operational constraints.

This should not automatically be treated as a problem, but it is a useful way to identify where the next analysis should focus.

### KPI to monitor

- Revenue by customer city
- Customer count by city
- Seller count by state
- Freight / revenue ratio
- Delivery performance by seller location

---

## 9.6 Use the Performance Score as a Starting Point

The scoring layer is useful for quickly identifying groups that deserve attention, but I would not use the score alone to make a business decision.

For example, a lower seller-state score could come from:

- poor delivery performance
- lower review scores
- high freight costs
- lower revenue

Those situations would require completely different actions.

### Recommendation

Use the scoring system as a **prioritization tool**:

~~~text
Score
  ↓
Find an interesting group
  ↓
Check the underlying KPIs
  ↓
Identify the actual problem
  ↓
Choose the appropriate action
  ↓
Monitor the KPI
~~~

This keeps the score useful without hiding the reasons behind it.

---

## 9.7 From Dashboard to Action

The main idea behind the recommendations is to move from reporting to investigation.

For example:

| Finding | What I would investigate | KPI |
|---|---|---|
| High delivery delays in some seller states | Carrier, geography, seller concentration | Late delivery rate |
| Severe delays have lower reviews | Delivery process and customer communication | Review score by delay group |
| Most customers purchase once | First-order experience and retention | Repeat purchase rate |
| Demand and revenue differ by category | Product value and sales volume | Revenue + items sold |
| Customer demand is geographically concentrated | Seller coverage and logistics | Freight / revenue ratio |
| Scores differ between groups | Underlying KPI drivers | Component metrics |

The dashboard answers **what is happening**.

The next analysis should answer **why it is happening**.

That is the part I would focus on before recommending a major business change.

---

## 9.8 Final Recommendation

If I were continuing this project with access to more operational data, my next step would be to investigate the relationship between **first-order experience and repeat purchasing**.

The current analysis already shows two interesting patterns:

- most customers appear to purchase only once
- delivery delays are strongly associated with lower review scores

The next question is whether these two patterns are connected.

That would take the project from:

~~~text
Descriptive analysis
        ↓
Performance analysis
        ↓
Business recommendations
        ↓
Customer retention investigation
~~~

For me, that is where the analysis becomes more useful: not just showing what happened in the dataset, but identifying the next business question worth answering.
