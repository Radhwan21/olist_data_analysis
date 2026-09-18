# 07 — Business Insights

The dashboard gives me the numbers, but the more interesting part was looking for patterns between them.

I did not want to stop at statements like *“health_beauty generates the most revenue.”* I wanted to understand what changes when revenue, demand, customers, delivery and reviews are looked at together.

---

## 7.1 High Revenue Does Not Always Mean Highest Demand

One of the first things I noticed is that the ranking changes depending on whether I look at **revenue** or **number of items sold**.

In the revenue view, `health_beauty` is the largest category, followed by `watches_gifts` and `bed_bath_table`.

However, in the demand view, `bed_bath_table` is the largest category, followed by `health_beauty` and `sports_leisure`.

This is important because these are two different business situations.

A category can sell many items without generating the highest revenue, while another category can generate more revenue with fewer items.

So I would not use item volume alone to decide which categories deserve more attention. I would look at:

**Demand → Revenue → Average selling value → Customer satisfaction**

This gives a better picture of whether a category is mainly a **high-volume business** or a **higher-value business**.

---

## 7.2 The Customer Base Is Heavily Concentrated Around One-Time Purchases

The customer purchase-frequency chart is one of the more interesting visuals on the dashboard.

Around **96.95% of customers have only one order**, while about **2.8% have two orders**. The remaining customers are spread across much smaller repeat-purchase groups.

So the customer base in this dataset is dominated by one-time purchasers.

I would not immediately conclude that customers are dissatisfied. There can be many other reasons for this, including the types of products being purchased and the relatively short period covered by the dataset.

But from a business perspective, this raises an important question:

> **Is the marketplace generating sales mainly by acquiring new customers rather than bringing existing customers back?**

If this were a real e-commerce business, I would investigate this further using:

- Repeat-purchase rate
- Time between first and second order
- First-order category
- First-order value
- Delivery experience of the first order
- Review score of the first order

That would turn the current frequency chart into a proper **customer retention analysis**.

---

## 7.3 Delivery Performance Has a Strong Relationship with Customer Reviews

The delivery page shows a clear pattern between delay and review score.

Orders delivered on time have an average review score of roughly **4.3**, while the score drops to around **3.3** for orders that are 1–3 days late.

The score then falls further:

- **4–7 days late:** around 2.1
- **8–14 days late:** around 1.7
- **15+ days late:** around 1.7
- **Not delivered:** around 1.8

So the difference is not simply between *on time* and *late*.

There appears to be a progressive deterioration in customer satisfaction as the delay becomes longer.

The first few days already matter: moving from on-time delivery to only 1–3 days late is associated with a substantial drop in the average review score.

I would describe this as an **association rather than proof of causation**, because other factors can influence a customer's review.

Still, from a business perspective, this suggests that delivery reliability is not just an operational metric. It is closely connected to the customer's experience.

---

## 7.4 The Interesting Problem Is Not Simply "Reduce Late Deliveries"

The delay distribution makes the previous finding more interesting.

About **91.16% of orders are delivered on time**, representing roughly **88.31K orders**.

So the marketplace already has a large majority of orders delivered on time.

The more useful question is:

> **What is happening with the smaller group of late orders, and where are they concentrated?**

This is where the seller-state analysis becomes useful.

Instead of looking only at the overall late-delivery rate, I would investigate the states where late deliveries take much longer.

For example, the seller-state chart shows a large difference in average late-delivery days:

- **Amazonas:** around 38 days
- **Ceará:** around 27 days
- Several other states: around 10–15 days
- **Paraíba:** around 2 days

That is a major operational difference.

This suggests that a single marketplace-wide delivery KPI can hide **regional operational problems**.

A useful next analysis would therefore be:

**Seller state → Late-delivery rate → Average late days → Number of affected orders → Review impact**

This would tell the business whether a state has a problem because it has **many late orders**, because its late orders are **extremely late**, or both.

---

## 7.5 A Composite Score Can Hide the Reason Behind Performance

The scoring page adds another layer to the analysis, but I would not treat the score as the final answer.

For example, São Paulo has a seller-state score of **8.3/10**, while Amazonas is much lower.

But the score itself does not immediately tell me *why* the difference exists.

A state can have:

- Strong revenue but poor delivery performance
- Good reviews but high freight costs
- Lower revenue but relatively strong operational performance

The composite score compresses several dimensions into one number.

That is useful for quickly identifying areas that deserve attention, but the underlying KPIs are still needed to explain the result.

This is why I use the score as a **screening tool**, rather than treating it as a replacement for the original metrics.

---

## 7.6 Category Performance Changes When Customer Experience Is Included

The category score gives another perspective on product performance.

`health_beauty` scores **8.5/10**, while `sports_leisure` and `watches_gifts` are around **8.2/10**.

What I find more useful is that the category score is not based only on revenue.

A category can generate a lot of sales, but if its customer satisfaction or operational efficiency is weaker, that should change how I interpret its performance.

This is more useful than simply saying:

> "Category X has the highest revenue."

For example, I can think about categories in different ways:

### High commercial performance + strong customer experience

The category is performing well across several dimensions, so the next question is how to maintain that performance.

### High demand + weaker customer experience

The category generates activity, but the customer experience may need investigation before simply pushing for more sales.

### Lower commercial performance + strong customer experience

The problem may be related more to visibility, assortment or demand than to customer experience.

The dashboard gives the first layer of this analysis. The next step would be to investigate the individual causes.

---

## 7.7 Revenue Is Geographically Concentrated

The customer and seller maps show that marketplace activity is not distributed evenly across geography.

Customer revenue is concentrated mainly around major Brazilian population and economic centers.

The seller map also shows strong seller activity in the southeastern part of Brazil.

This creates a more interesting supply-versus-demand question:

> **Are the places with the most customers also the places with the strongest seller presence?**

If there is a mismatch, it could have operational consequences.

For example, a large customer market with relatively weak local seller coverage could potentially experience:

- Longer delivery distances
- Higher freight costs
- Greater exposure to delivery delays

So the geographic visuals are not only useful for showing *where* customers and sellers are located. They can also be used as a starting point for investigating the relationship between **market demand and operational coverage**.

---

## 7.8 The Pattern I Would Investigate Further

After putting the pages together, one pattern stands out to me:

**Customer experience sits between several parts of the business.**

Product demand creates orders.

Orders create delivery requirements.

Delivery performance is strongly associated with review scores.

Geography affects both the seller side and the customer side.

This gives me a chain that connects several parts of the analysis:

```text
Product / Category
        ↓
      Demand
        ↓
     Sellers
        ↓
    Geography
        ↓
    Delivery
        ↓
Customer Satisfaction
        ↓
  Repeat Purchase

---

## 7.9 What I Take Away From the Analysis

The main thing I learned from this project is that the biggest number is not always the most useful number.

Revenue tells me where the money is.

Item volume tells me where the demand is.

Delivery data tells me where operational problems may exist.

Reviews tell me how customers experienced the transaction.

Purchase frequency gives me a first indication of whether customers come back.

Looking at them together gives a much better picture than analysing any one KPI on its own.

That is also why I built the scoring page: not to create a "magic ranking", but to make it easier to identify areas that deserve a closer look and then return to the underlying KPIs to understand why.