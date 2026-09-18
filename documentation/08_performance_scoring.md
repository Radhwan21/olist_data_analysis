# 08 — Performance Scoring

The scoring layer was added after the main analysis.

I did not want to create one overall score for the whole marketplace because a seller state, a product category and a customer city represent completely different business entities.

So I created three separate scores:

- Seller State Score
- Product Category Score
- Customer City Score

All scores are normalized to a **0–10 scale**.

The goal is not to create a "magic ranking". The score is mainly a way to combine several KPIs and quickly identify areas that deserve a closer look.

---

## 8.1 Why I Used a Score

The individual KPIs have very different units.

For example:

- Revenue is measured in money.
- Customers are counts.
- Review score ranges from 1 to 5.
- Late delivery is measured in days or percentages.
- Freight cost is another monetary measure.

Putting these values directly into one formula would make variables with larger numerical scales dominate the result.

I therefore normalized the metrics before combining them.

The result is easier to interpret:

```text
0  = weak relative performance
5  = middle of the observed range
10 = strong relative performance
```

---

## 8.2 Seller State Score

For seller states, I wanted the score to represent a combination of commercial performance, customer experience and delivery efficiency.

The weighting is:

| Metric                     | Weight | Direction        |
| -------------------------- | -----: | ---------------- |
| Average Review Score       |    35% | Higher is better |
| Late Delivery Rate         |    25% | Lower is better  |
| Revenue                    |    20% | Higher is better |
| Average Late Delivery Days |    15% | Lower is better  |
| Freight / Revenue Ratio    |     5% | Lower is better  |

I gave review score the largest weight because strong sales alone do not tell the whole story about seller-side performance.

I also separated **late-delivery rate** from **average late-delivery days**.

This was intentional.

A state with many slightly late orders is a different operational problem from a state with fewer late orders but extremely long delays.

The score therefore considers both the **frequency** and the **severity** of delivery problems.

---

## 8.3 Product Category Score

For product categories, I used a different combination:

| Metric                  | Weight | Direction        |
| ----------------------- | -----: | ---------------- |
| Revenue                 |    35% | Higher is better |
| Average Review Score    |    30% | Higher is better |
| City Reach              |    25% | Higher is better |
| Freight / Revenue Ratio |    10% | Lower is better  |

Here I wanted the score to capture more than just sales.

A category that generates strong revenue but reaches only a limited number of cities is different from one that performs well across a much wider market.

I therefore included **city reach** as a measure of geographic coverage.

Freight efficiency has a smaller weight because it matters, but I did not want it to overpower the commercial and customer-experience metrics.

---

## 8.4 Customer City Score

For customer cities, the metrics are:

| Metric       | Weight | Direction        |
| ------------ | -----: | ---------------- |
| Revenue      |    40% | Higher is better |
| Customers    |    35% | Higher is better |
| Freight Cost |    25% | Lower is better  |

I intentionally did **not** include review score here.

At city level, the review values did not provide enough useful variation to differentiate cities meaningfully.

Instead of forcing every available KPI into the formula, I left it out.

That was a deliberate decision:

> **A metric should only be included if it adds useful information.**

---

## 8.5 Not Every Metric Should Be Normalized in the Same Way

One problem with normalization is that different variables can have very different distributions.

Revenue is a good example.

A few groups can generate much more revenue than most of the others. A simple linear normalization could therefore give extreme values too much influence.

For revenue, I used a **logarithmic transformation before normalization**.

This reduces the influence of very large values while still preserving the general relationship between high- and low-revenue groups.

The result is a score that is less dominated by one extreme observation.

---

## 8.6 Higher Is Not Always Better

Another important part of the scoring logic is the direction of each metric.

For some variables:

```text
Higher value → better performance
```

Examples:

* Revenue
* Customers
* Review score
* City reach

For others:

```text
Lower value → better performance
```

Examples:

* Late delivery rate
* Average late-delivery days
* Freight / revenue ratio
* Freight cost

For the second group, I inverted the normalized result.

Otherwise, a group with more delivery delays or higher freight costs could accidentally receive a higher score.

---

## 8.7 Review Score Needed Special Treatment

Review score is originally measured on a **1–5 scale**.

Numerically, this is much smaller than something like revenue, but the difference between review scores can be meaningful.

For example, a change from 4.0 to 4.5 is not something I wanted the scoring system to treat as insignificant simply because the original scale is small.

I therefore normalized the review metric separately before applying its weight.

This is especially important for the seller-state and category scores, where customer satisfaction is one of the main components.

---

## 8.8 What the Scores Show

The final dashboard gives a quick way to identify groups that perform relatively strongly across several dimensions.

Some examples visible in the dashboard are:

* **Seller State:** São Paulo — **8.3/10**
* **Category:** health_beauty — **8.5/10**
* **Customer City:** São Paulo — **7.5/10**

But the score itself is not the conclusion.

For me, the useful workflow is:

```text
Score
  ↓
Identify an interesting group
  ↓
Check the underlying KPIs
  ↓
Understand what drives the score
  ↓
Decide what should be investigated
```

For example, if a seller state receives a lower score, I would not immediately conclude that the sellers there are performing poorly.

I would first check whether the score is being pulled down by:

* delivery delays,
* review scores,
* freight efficiency,
* or lower revenue.

That makes the scoring layer a starting point for analysis rather than a final judgment.

---

## 8.9 Why I Did Not Create One Overall Ranking

I deliberately avoided combining seller states, product categories and customer cities into one master ranking.

They represent different business entities and answer different questions.

A customer city should not be directly compared with a product category.

Instead, the scoring system answers three separate questions:

### Seller states

Where is seller-side performance relatively strong or weak?

### Product categories

Which categories combine commercial performance with customer and geographic performance?

### Customer cities

Which markets combine customer scale, revenue and freight efficiency?

This keeps the score connected to an actual business question instead of creating a number just because it looks impressive on a dashboard.

---

## 8.10 Limitations

The scores are useful for comparison within this dataset, but they have some limitations.

### Relative rather than absolute

A score of 8/10 does not mean that the underlying performance is objectively "80% good."

It means the group scores relatively strongly according to the selected metrics and weights.

### Weight selection

The weights are analytical design choices.

Different business priorities could justify different weights.

For example, a company focused heavily on logistics could give delivery metrics more weight.

### Data period

The Olist dataset covers a historical period, so these scores should not be interpreted as current marketplace performance.

### The score hides detail

Two groups can receive similar scores for completely different reasons.

That is why I kept the underlying KPIs visible instead of relying only on the composite score.

---

## 8.11 What I Wanted the Scoring Layer to Achieve

The main idea was simple:

**Use the score to find where to look, not to replace the analysis.**

The individual KPIs explain the business.

The score helps me scan the data faster.

That distinction was important to me because a composite score can look very precise even when it is based on subjective weighting decisions.

I would rather have a transparent score that can be explained and challenged than a complicated formula that produces a number nobody understands.