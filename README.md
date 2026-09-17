# E-Commerce Business Performance & Customer Analytics

## Project Overview

This project analyzes the performance of an e-commerce marketplace using the **Olist Brazilian E-Commerce Public Dataset**.

The objective is not simply to build a dashboard or practice SQL. The project follows an end-to-end analytics workflow that transforms raw transactional data into a structured analytical model and then uses that model to answer practical business questions.

The analysis focuses on:

* Revenue and sales performance
* Product category performance
* Seller performance
* Customer geography
* Delivery performance
* Customer satisfaction
* Relationships between operational performance and customer experience
* Multi-factor performance scoring for sellers, customer cities, and product categories

The project follows this workflow:

**Raw CSV data → PostgreSQL → Data Quality → Analytical Data Model → SQL Analysis → Power BI → Business Insights**

A major focus of the project is making analytical decisions based on the actual structure and limitations of the data, rather than simply applying generic transformations.

The final result combines **SQL-based data engineering and analysis, relational data modeling, Power BI visualization, DAX calculations, and business interpretation**.

---

## Business Objective

An e-commerce marketplace needs to understand not only how much it sells, but also **where performance comes from, what operational factors affect customers, and where improvements could have the greatest business impact**.

This project therefore goes beyond basic revenue reporting.

The analysis connects commercial performance with operational and customer-experience metrics, allowing questions such as:

* Which product categories generate the most revenue?
* Which seller states contribute strongly to marketplace performance?
* Which customer cities generate significant commercial value?
* How does delivery performance vary across the marketplace?
* How are delivery delays related to customer satisfaction?
* Which categories combine strong revenue with high customer satisfaction and broad market reach?
* Which geographical markets show strong commercial potential?
* How can multiple performance indicators be combined into a single transparent score?

The purpose is to demonstrate how a data analyst can move from:

**"What happened?"**

to:

**"Why might it be happening?"**

and finally to:

**"What could the business do about it?"**

---

# Dataset

The project uses the **Olist Brazilian E-Commerce Public Dataset**, a real-world anonymized dataset containing approximately 100,000 orders from a Brazilian e-commerce marketplace.

The dataset contains information about:

* Orders and order status
* Customers
* Products and product categories
* Sellers
* Order items
* Payments
* Reviews
* Delivery dates
* Customer and seller geographic information

The data is distributed across multiple related CSV files.

This makes the dataset particularly useful for practicing relational data modeling because the business information is distributed across multiple entities and different levels of granularity.

---

# Tech Stack

* **PostgreSQL** — data storage, relational modeling and SQL analysis
* **SQL** — data validation, transformation and business analysis
* **Power BI** — interactive reporting and visualization
* **DAX** — KPIs, calculated measures and performance scoring
* **Git / GitHub** — version control and project documentation

---

# Project Structure

```text
olist-ecommerce-analytics/
│
├── data/
│   └── raw/
│
├── sql/
│   ├── 1_create_raw_tables.sql
│   ├── 2_load_data.sql
│   ├── 3_data_quality.sql
│   ├── 4_data_modeling.sql
│   ├── 5_last_quality_check.sql
│   └── 6_analysis.sql
│
├── powerbi/
│   └── olist_dashboard.pbix
│
├── screenshots/
│
├── documentation/
│
└── README.md
```

---

# Data Architecture

Instead of joining all raw tables together into one large dataset, the project uses a **star-schema-oriented analytical model**.

## Dimensions

* `dim_customer`
* `dim_product`
* `dim_seller`
* `dim_date`

## Facts

* `fact_order_item`
* `fact_payment`
* `fact_review`

The most important modeling principle was defining the **grain of each table before joining data**.

For example:

* `fact_order_item` → one row per product item in an order
* `fact_payment` → one row per payment sequence within an order
* `fact_review` → one row per review/order combination

Keeping these grains separate prevents problems such as duplicated revenue, payment amounts or review scores when combining tables with different levels of detail.

---

# Important Data Modeling Decisions

## Customer Identity

The raw customer data contains both:

```text
customer_id
customer_unique_id
```

`customer_id` is not treated as the permanent customer identity because the same `customer_unique_id` can appear across multiple customer records.

The analytical customer dimension therefore uses:

```text
customer_unique_id
```

as the customer key.

The data also contained **252 customers associated with more than one location**.

Instead of arbitrarily duplicating customers or ignoring the issue, the analytical model keeps the **latest known customer location based on purchase activity**.

This is explicitly treated as a **latest-known location**, rather than an assumption that the location represents the customer's permanent residence.

---

## Review Key

The review data required additional investigation.

`review_id` initially appeared to be a natural primary key, but the raw data contains repeated `review_id` values associated with different orders.

After investigating the duplicated records, the analytical key was defined as:

```text
(review_id, order_id)
```

This reflects the actual uniqueness of the available data instead of forcing an incorrect primary key.

---

## NULL Values

Missing values were not automatically treated as data-quality errors.

For example, a missing delivery date for a `canceled`, `processing`, or `shipped` order can be a legitimate representation of the order lifecycle.

The data-quality process therefore distinguishes between:

**missing because of a data problem**

and

**missing because the business event has not happened or does not apply.**

This prevents valid business information from being incorrectly removed during cleaning.

---

## Avoiding Unnecessary Transformations

The project deliberately avoids adding columns simply because they are common in tutorials.

For example, existing date information is not duplicated into unnecessary fields unless the transformation serves a specific analytical purpose.

The principle is:

> **Every transformation should have a business or analytical reason.**

---

# SQL Workflow

## 1. Database and Raw Tables

The first stage establishes the PostgreSQL environment and creates the raw schema.

The raw tables follow the structure of the original Olist CSV files.

The raw layer is kept separate from the analytical model so that the original data remains traceable.

---

## 2. Data Loading

The original CSV files are loaded into PostgreSQL raw tables.

This creates a reproducible starting point for all subsequent validation, transformation and analysis.

---

## 3. Data Quality

Before building the analytical model, the raw data is systematically investigated.

The quality checks cover areas such as:

* Duplicate and uniqueness problems
* Missing values
* Referential integrity
* Invalid date sequences
* Invalid numerical values
* Order-status/timestamp consistency
* Relationships between different entities

The purpose is not simply to find NULL values.

The goal is to determine whether a value is actually **wrong in the context of the business process**.

---

## 4. Analytical Data Modeling

After validation, the raw data is transformed into the analytical schema.

The resulting model contains:

```text
dim_customer
dim_product
dim_seller
dim_date

fact_order_item
fact_payment
fact_review
```

The model is designed around clear table grains and controlled relationships.

This provides a reliable foundation for both SQL analysis and Power BI.

---

## 5. Final Quality Check

A final validation stage checks the analytical tables after transformation.

This ensures that the modeling process did not introduce problems such as:

* Duplicate keys
* Broken relationships
* Unexpected row multiplication
* Invalid values
* Incorrect aggregations

This additional step is important because a dataset can be correct at the raw level while still becoming incorrect during transformation.

---

## 6. Business Analysis

The final SQL analysis answers business questions around:

* Executive sales KPIs
* Revenue trends
* Product category performance
* Seller performance
* Customer geography
* Delivery performance
* Delivery delays
* Delivery performance versus customer reviews
* Product category revenue versus customer satisfaction

Special attention is given to **aggregation level** when combining facts.

For example, order-item information is aggregated to the appropriate order or order-category level before being combined with review information.

This avoids misleading results caused by joining tables with different grains.

---

# Power BI Dashboard

The Power BI report contains four analytical pages.

## Page 1 — Executive Overview

The first page provides a high-level view of marketplace performance.

It focuses on the main commercial KPIs and trends required to understand the overall business situation.

This page is designed for an executive or management audience who needs to understand the marketplace quickly before exploring individual areas.

---

## Page 2 — Customers & Products

The second page examines the customer and product sides of the marketplace.

The analysis explores areas such as:

* Customer distribution
* Customer geography
* Product categories
* Revenue contribution
* Product and customer patterns

This page connects marketplace demand with the products being sold.

---

## Page 3 — Delivery & Customer Satisfaction

The third page focuses on the operational side of the customer experience.

It analyzes:

* Delivery performance
* Delivery delays
* Late deliveries
* The relationship between operational performance and customer satisfaction

The purpose is to understand whether operational problems, particularly delivery problems, are associated with differences in customer experience.

---

# Page 4 — Performance Scores

The fourth page introduces a more advanced analytical layer.

Instead of looking at individual metrics independently, the report creates **composite performance scores** for:

* Seller states
* Customer cities
* Product categories

The purpose is not to replace the underlying metrics.

Instead, the score provides a way to summarize several dimensions of business performance into a single, transparent indicator that can be used for comparison and prioritization.

All scores are presented on a **0–10 scale**.

---

# Why the Scoring System Is Fair

The underlying metrics have very different units and ranges.

For example:

* Revenue can reach very large monetary values.
* Delivery delay is measured in days.
* Freight is measured in monetary values.
* Review scores range only from 1 to 5.
* Customer counts can vary substantially between locations.

Simply adding these raw values together would not be meaningful.

A location with high revenue would automatically dominate the score because revenue has a much larger numerical scale.

The scoring methodology therefore uses **normalization before combining the metrics**.

The general process is:

```text
Raw metric
     ↓
Normalization
     ↓
0–1 comparable score
     ↓
Apply business weight
     ↓
Combine weighted scores
     ↓
Final score × 10
     ↓
0–10 performance score
```

This means that each metric contributes according to its intended importance rather than according to the size of its original numerical units.

---

# Direction of Performance

Another important part of the scoring methodology is that not every metric has the same meaning.

Some metrics are:

**Higher = better**

Examples:

* Revenue
* Review score
* Customer reach
* Customer count

Other metrics are:

**Lower = better**

Examples:

* Late delivery rate
* Average late delivery days
* Freight/revenue ratio

The negative metrics are therefore inverted during normalization.

As a result, a lower delay rate receives a higher contribution to the final score, while a higher delay rate receives a lower contribution.

This makes the direction of every component consistent before the metrics are combined.

---

# Seller State Score

Seller states are evaluated using five dimensions:

| Factor                     | Weight | Direction        |
| -------------------------- | -----: | ---------------- |
| Average Review Score       |    35% | Higher is better |
| Late Delivery Rate         |    25% | Lower is better  |
| Revenue                    |    20% | Higher is better |
| Average Late Delivery Days |    15% | Lower is better  |
| Freight / Revenue Ratio    |     5% | Lower is better  |

The final score therefore reflects both **commercial performance and operational quality**.

A seller state cannot achieve a high score simply by generating large revenue while performing poorly in delivery and customer satisfaction.

Likewise, strong reviews alone are not enough if the state has weak commercial performance or poor delivery results.

The weighting gives the greatest importance to customer satisfaction and delivery reliability while still considering revenue generation and logistics efficiency.

Revenue is normalized logarithmically because revenue is highly skewed and large entities can otherwise dominate the comparison.

The review score is normalized according to its actual 1–5 scale so that differences in customer satisfaction are treated appropriately.

The final result is a balanced state-level performance indicator rather than a pure sales ranking.

---

# Product Category Score

Product categories are evaluated using four dimensions:

| Factor                  | Weight | Direction        |
| ----------------------- | -----: | ---------------- |
| Revenue                 |    35% | Higher is better |
| Average Review Score    |    30% | Higher is better |
| City Reach              |    25% | Higher is better |
| Freight / Revenue Ratio |    10% | Lower is better  |

This score considers more than simply how much revenue a category generates.

A category can also benefit from:

* Strong customer satisfaction
* Broad geographical reach
* Efficient freight relative to its revenue

This makes the score useful for identifying categories that combine **commercial value, customer acceptance and market reach**.

The score also prevents revenue alone from determining category performance.

---

# Customer City Score

Customer cities are evaluated using three dimensions:

| Factor       | Weight | Direction        |
| ------------ | -----: | ---------------- |
| Revenue      |    40% | Higher is better |
| Customers    |    35% | Higher is better |
| Freight Cost |    25% | Lower is better  |

Customer review score was deliberately excluded from this particular score.

During the city-level analysis, the relevant filtered review values did not provide meaningful variation between cities. Including a metric that does not differentiate the entities would give the appearance of additional analytical information without actually improving the comparison.

The final city score therefore focuses on:

* Commercial value
* Customer base size
* Logistics cost

Revenue receives the highest weight because it represents direct commercial contribution.

Customer count represents market size.

Freight cost is included as an efficiency consideration.

Revenue uses logarithmic normalization to reduce the dominance of extremely large markets, while customer count uses linear normalization. Freight is inverted so that lower logistics cost contributes positively to the final score.

---

# Why Normalization Matters

Consider two hypothetical metrics:

```text
Revenue:       €10,000 – €1,000,000
Review Score:  1 – 5
```

A raw-value calculation would make revenue overwhelmingly dominate the review score.

The scoring system instead transforms the metrics into comparable values.

For example:

```text
Revenue → 0–1
Reviews → 0–1
Delivery → 0–1
Freight → 0–1
```

The weighted combination can then be calculated fairly.

This is particularly important for the review metric because a change of **0.5 points on a 1–5 scale represents a meaningful change in customer satisfaction**, even though the numerical difference appears small compared with monetary metrics.

The scoring system therefore respects the original meaning and scale of each metric rather than treating all raw numbers as directly comparable.

---

# Interpreting the Scores

The composite score should not be interpreted as a replacement for the underlying KPIs.

Instead, it acts as a **decision-support indicator**.

For example, a category with a strong overall score should still be investigated through its individual:

* Revenue
* Reviews
* Reach
* Freight efficiency

Similarly, a lower-performing state or city should not automatically be interpreted as a business problem.

The score helps identify **where further investigation may be valuable**.

This is important because composite metrics simplify complex business situations. The dashboard therefore keeps the underlying measures visible so that users can understand *why* an entity receives its score.

---

# Business Insights & Decision Support

The project is designed to translate technical analysis into practical business decisions.

## Revenue and Growth

Revenue analysis helps identify:

* Major sources of marketplace revenue
* Changes in sales over time
* Categories and geographical markets contributing to sales
* Areas where commercial performance can be investigated further

This provides the foundation for decisions around category strategy, market development and resource allocation.

---

## Product Category Strategy

Combining revenue, reviews, geographical reach and freight efficiency allows categories to be viewed from several business perspectives simultaneously.

For example, a category may generate substantial revenue but have weaker customer satisfaction or higher logistics costs.

Conversely, a smaller category may demonstrate strong satisfaction and geographical reach, indicating a potentially interesting area for further commercial investigation.

The scoring framework helps surface these trade-offs.

---

## Seller Performance

Seller-state analysis connects commercial contribution with customer experience and delivery reliability.

This is useful because high sales volume does not necessarily mean strong overall marketplace performance.

The analysis allows the business to investigate areas where:

* Revenue is strong but delivery performance is weak
* Customer satisfaction is strong but commercial contribution is smaller
* Freight efficiency differs substantially
* Delivery reliability may require operational attention

This provides a more complete view of seller performance than revenue alone.

---

## Customer Geography

Customer-city analysis combines:

* Revenue
* Number of customers
* Freight cost

This helps distinguish between large markets and efficient markets.

A city with many customers but relatively weak commercial value may require a different strategy from a city with high revenue but high logistics costs.

This type of analysis can support decisions related to:

* Market expansion
* Logistics planning
* Regional marketing
* Customer acquisition
* Operational prioritization

---

## Delivery and Customer Satisfaction

Delivery performance is analyzed alongside customer reviews to investigate the connection between operational execution and customer experience.

This allows the business to move beyond simply reporting:

> "Some orders were late."

and instead investigate:

> "Where are delays occurring, how large are they, and how do they relate to customer satisfaction?"

This connection is particularly important for an e-commerce marketplace because delivery is part of the customer's overall purchasing experience.

---

# From Analysis to Action

The main value of the project is not the dashboard itself.

The dashboard provides the evidence needed to support business decisions.

The analytical workflow can therefore be summarized as:

```text
Raw Data
   ↓
Reliable Data
   ↓
Structured Analytical Model
   ↓
Business Questions
   ↓
KPIs & Analysis
   ↓
Performance Comparison
   ↓
Business Insights
   ↓
Potential Actions
```

Potential business actions can include:

* Investigating high-delay seller regions
* Reviewing logistics performance where freight costs are disproportionately high
* Identifying product categories with strong customer satisfaction and market reach
* Investigating high-revenue categories with weaker customer experience
* Identifying geographically strong customer markets
* Prioritizing further analysis of markets with strong revenue but inefficient logistics
* Using seller and category performance indicators to identify areas requiring operational investigation

The purpose is not to claim that one metric automatically determines the correct business decision.

Instead, the analysis provides a structured evidence base for deciding **where the business should investigate further and where improvement opportunities may exist**.

---

# Key Analytical Principles

Several principles guided the entire project.

### 1. Define grain before joining

Different tables represent different business events.

Understanding their grain prevents duplicated metrics and misleading analysis.

### 2. Validate before transforming

Data quality problems are investigated before the data is modeled.

### 3. Treat missing data in context

A NULL value is not automatically an error.

Its meaning depends on the business process.

### 4. Avoid unnecessary transformations

Columns and transformations are created because they serve an analytical purpose, not because they are commonly used in tutorials.

### 5. Normalize before combining metrics

Metrics with different units and scales cannot be fairly combined without normalization.

### 6. Keep the underlying KPIs visible

Composite scores are useful for summarization, but the individual components remain necessary for interpretation.

### 7. Connect technical work to business decisions

SQL, data modeling and Power BI are means to an end.

The final objective is to extract information that can support real-world e-commerce decisions.

---

# Project Outcome

The completed project demonstrates an end-to-end data analytics workflow:

**Raw Data**

→ CSV-based transactional data

**Data Engineering**

→ PostgreSQL raw layer

**Data Quality**

→ Validation of duplicates, NULLs, relationships, dates and business rules

**Data Modeling**

→ Star-schema-oriented analytical model

**SQL Analysis**

→ Business KPIs and analytical questions

**Power BI**

→ Four-page interactive analytical dashboard

**DAX**

→ KPIs and multi-factor performance scoring

**Business Analysis**

→ Performance comparisons, operational analysis and actionable areas for investigation

The project therefore demonstrates not only the ability to work with SQL and Power BI, but also the ability to **understand data structure, identify data-quality issues, make defensible analytical decisions, and translate technical results into business-oriented insights**.

---

# Dashboard Pages

The final Power BI report contains:

1. **Executive Overview**
2. **Customers & Products**
3. **Delivery & Customer Satisfaction**
4. **Performance Scores**

The fourth page represents the project's additional analytical layer by combining multiple business dimensions into transparent 0–10 performance scores for seller states, customer cities and product categories.

---

# Final Perspective

This project was built with the principle that a good data analyst should not stop at producing charts.

The complete workflow demonstrates the progression from:

**data → information → analysis → insight → business action.**

The technical implementation provides the foundation, while the business analysis provides the value.

The final objective is therefore not simply to answer **"What does the data show?"**, but to provide a structured way for an e-commerce business to understand its performance, identify important trade-offs, investigate potential problems and discover opportunities for improvement.
