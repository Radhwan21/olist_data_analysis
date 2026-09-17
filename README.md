# E-Commerce Business Performance & Customer Analytics

## Project Overview

This project analyzes the performance of an e-commerce marketplace using the **Olist Brazilian E-Commerce Public Dataset**.

The goal is not just to build a dashboard, but to go from raw transactional data to a reliable analytical model and use it to answer practical business questions around:

* Revenue and sales performance
* Product and seller performance
* Customer geography
* Delivery performance
* Customer satisfaction

The project follows an end-to-end analytics workflow:

**Raw CSV data → PostgreSQL → Data Quality → Analytical Data Model → SQL Analysis → Power BI**

A major focus of the project is making analytical decisions based on the actual structure and limitations of the data, rather than simply applying generic transformations.

---

## Business Questions

The analysis is designed to answer questions such as:

* How does revenue change over time?
* Which product categories generate the most revenue?
* Which sellers contribute the most to marketplace sales?
* Which customer regions generate the most revenue?
* How well is the marketplace performing in terms of delivery?
* Is there a relationship between delivery delays and customer satisfaction?
* Among orders delivered on time, which product categories combine strong revenue with high customer satisfaction?

These questions were selected to connect the technical analysis to decisions that an e-commerce business could realistically make.

---

## Dataset

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
* Geographic information

The data is distributed across multiple related CSV files, which makes it suitable for practicing relational data modeling rather than treating the dataset as one large flat table.

---

## Tech Stack

* **PostgreSQL** — data storage, modeling and SQL analysis
* **SQL** — data validation, transformation and business analysis
* **Power BI** — interactive reporting and visualization
* **DAX** — analytical measures and KPIs
* **Git / GitHub** — version control and project documentation

---

## Project Structure

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

## Data Architecture

Instead of joining all raw tables together into one large dataset, the project uses a **star-schema-oriented analytical model**.

### Dimensions

* `dim_customer`
* `dim_product`
* `dim_seller`
* `dim_date`

### Facts

* `fact_order_item`
* `fact_payment`
* `fact_review`

The most important design principle was defining the **grain of each table before joining data**.

For example:

* `fact_order_item` → one row per product item in an order
* `fact_payment` → one row per payment sequence within an order
* `fact_review` → one row per review/order combination

Keeping these grains separate prevents problems such as duplicated revenue, payment amounts or review scores when tables with different levels of detail are combined.

### A few important data decisions

#### Customer identity

The raw customer table contains both `customer_id` and `customer_unique_id`.

`customer_id` is not treated as the permanent customer identity because the same `customer_unique_id` can appear across multiple customer records.

The analytical customer dimension therefore uses:

```text
customer_unique_id
```

as its key.

There were also 252 customers associated with more than one location. Rather than arbitrarily duplicating customers or ignoring the issue, the model keeps the **latest known customer location based on purchase activity**.

This is documented as a latest-known location, not assumed to be a customer's permanent residence.

#### Review key

The review data also required investigation.

`review_id` initially appeared to be a natural primary key, but the raw data contains repeated `review_id` values associated with different orders.

After checking the duplicated records, the analytical key was defined as:

```text
(review_id, order_id)
```

This matches the actual uniqueness of the dataset instead of forcing an incorrect primary key.

#### NULL values

Missing values were not automatically treated as errors.

For example, a missing delivery date for a `canceled`, `processing`, or `shipped` order can be a legitimate representation of the order's lifecycle.

The data-quality process therefore distinguishes between:

**missing because of a data problem**

and

**missing because the business event has not happened or does not apply.**

This prevents "cleaning" the data by removing information that is actually meaningful.

#### No unnecessary transformations

The project deliberately avoids adding columns simply because they are common in tutorials.

For example, existing date information is not duplicated into unnecessary fields unless the transformation serves a specific analytical purpose.

The principle is simple:

> **Every transformation should have a reason.**

---

## SQL Workflow

### 01 — Database Creation

Creates the PostgreSQL database and prepares the environment for the project.

### 02 — Raw Tables

Creates the `raw` schema and defines tables matching the original CSV structures.

The raw layer is kept separate from the analytical model so that the original data remains traceable.

### 03 — Data Loading

Loads the original CSV files into the PostgreSQL raw tables.

### 04 — Data Quality

Checks the raw data before building the analytical model.

The checks cover areas such as:

* Duplicate and uniqueness problems
* Missing values
* Referential integrity
* Invalid date sequences
* Invalid numerical values
* Relationships between order status and timestamps

The purpose is not simply to find NULLs, but to determine whether a value is actually problematic in a business context.

### 05 — Analytical Transformations

Builds the analytical schema from the validated raw data.

This includes the dimension and fact tables used by the analysis.

The transformations focus on meaningful modeling decisions rather than creating unnecessary derived columns.

### 06 — Business Analysis

Uses SQL to answer the project's business questions.

The analysis covers:

* Executive sales KPIs
* Revenue trends
* Product category performance
* Seller performance
* Customer geography
* Delivery performance
* Delivery delays
* Delivery performance vs. customer reviews
* Product category revenue vs. customer satisfaction

Special attention is given to **aggregation level** when combining facts. For example, order-item data is aggregated to the appropriate order or order-category level before being combined with review information.

This avoids misleading results caused by joining tables with different grains.

---

## Current Status

The PostgreSQL data model and SQL analysis are complete.

The next stage is to build the Power BI layer on top of the analytical model and turn the SQL findings into an interactive business report.

The final version of this README will be updated with the dashboard, key findings and business recommendations after the Power BI analysis is complete.
