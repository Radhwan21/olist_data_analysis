# E-Commerce Business Performance & Customer Analytics

## 1. Project Introduction

### 1.1 Overview

This project is an end-to-end **e-commerce data analytics project** built using the Brazilian E-Commerce Public Dataset by **Olist**.

The objective is to analyze an e-commerce marketplace from both a **commercial** and **operational** perspective, starting from raw transactional data and progressing through data quality validation, relational data modeling, SQL-based analysis, interactive Power BI reporting, and business-oriented performance evaluation.

Rather than treating the project as a simple dashboard-building exercise, the analysis focuses on the complete analytical process:

> **Raw data → Data quality → Data modeling → Business analysis → Visualization → Insights → Business recommendations**

The project demonstrates how technical data-analysis skills can be applied to realistic business questions involving revenue, products, sellers, customers, logistics and customer satisfaction.

---

## 1.2 Business Context

E-commerce performance cannot be evaluated using revenue alone.

A marketplace can generate significant sales while simultaneously experiencing:

* delivery delays,
* high logistics costs,
* weak customer satisfaction,
* geographical concentration,
* differences in seller performance, or
* significant variation between product categories.

Therefore, this project examines the marketplace from multiple perspectives.

The analysis investigates:

* **Sales performance** — How revenue develops over time and across product categories.
* **Product performance** — Which categories contribute most to marketplace revenue and how they perform from a customer perspective.
* **Seller performance** — How seller-related performance differs geographically.
* **Customer geography** — Which cities and regions represent important customer markets.
* **Delivery performance** — How effectively orders are delivered and where delays occur.
* **Customer satisfaction** — How customers evaluate their purchasing experience.
* **Performance trade-offs** — Whether strong commercial performance is accompanied by strong operational and customer-experience performance.

The final analysis therefore aims to connect **what the business sells** with **where it sells, how efficiently it operates, and how customers experience the service**.

---

## 1.3 Project Objectives

The main objectives of the project are:

### Technical objectives

1. Build a reliable PostgreSQL environment for the raw e-commerce data.
2. Investigate and validate the quality of the source data.
3. Identify data-quality issues that could affect analytical results.
4. Design a structured analytical data model based on clearly defined table grains.
5. Perform business analysis using SQL.
6. Build an interactive Power BI dashboard using the analytical model.
7. Develop DAX measures for KPIs and multi-factor performance evaluation.
8. Maintain the project in a reproducible Git/GitHub structure.

### Business objectives

1. Understand the marketplace's overall sales performance.
2. Identify important product categories and geographical markets.
3. Evaluate delivery performance and customer satisfaction.
4. Investigate the relationship between operational performance and customer experience.
5. Compare seller states, customer cities and product categories using multiple performance dimensions.
6. Identify areas that may require further business investigation or operational improvement.
7. Translate analytical results into practical business recommendations.

---

## 1.4 Analytical Approach

The project follows a structured analytical workflow.

```text
┌──────────────────────┐
│   Raw CSV Dataset    │
│      Olist Data      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│      PostgreSQL      │
│     Raw Data Layer   │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│    Data Quality      │
│ Validation & Checks  │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│   Analytical Model   │
│ Dimensions + Facts   │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│     SQL Analysis     │
│   Business Questions │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│      Power BI        │
│ Interactive Dashboard │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Business Insights &  │
│ Performance Scoring  │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Recommendations &    │
│ Decision Support     │
└──────────────────────┘
```

This workflow was intentionally designed so that visualization is built on top of a validated analytical model rather than directly on top of unverified raw data.

---

## 1.5 Key Business Questions

The project was designed around practical questions that an e-commerce marketplace could realistically ask.

### Sales

* How does revenue change over time?
* Which product categories contribute the most revenue?
* How is marketplace performance distributed geographically?

### Products

* Which categories generate strong commercial performance?
* Which categories combine revenue with strong customer satisfaction?
* Does product-category performance change when geographical reach and freight efficiency are considered?

### Sellers

* How does seller performance vary between states?
* Which seller states combine commercial contribution with strong delivery and customer-experience performance?
* Are there geographical areas where operational performance deserves further investigation?

### Customers

* Which customer cities represent important markets?
* How do revenue, customer volume and freight costs differ geographically?
* Which markets combine commercial value with efficient logistics?

### Delivery

* How well does the marketplace perform against expected delivery dates?
* Where are delivery delays concentrated?
* How does delivery performance relate to customer satisfaction?

### Overall performance

* Can several business metrics be combined into a transparent performance score?
* How can entities be compared fairly when their underlying metrics have different units and scales?

These questions provide the bridge between the technical analysis and the business interpretation presented later in the documentation.

---

## 1.6 Analytical Philosophy

A central principle throughout the project was:

> **The goal is not to make the data look clean. The goal is to make the analysis reliable.**

This affected several decisions throughout the project.

Missing values were investigated according to their business meaning rather than automatically removed.

Duplicate identifiers were investigated rather than blindly deleted.

Different fact-table grains were kept separate rather than forcing everything into a single large table.

Derived fields were only introduced when they served a clear analytical purpose.

Composite performance scores were normalized before combining metrics so that variables with different units and scales would not unfairly dominate the results.

This approach places emphasis on **analytical reasoning and data reliability**, not simply on applying predefined transformation recipes.

---

## 1.7 Final Deliverables

The completed project consists of:

### Data layer

* Raw Olist CSV data
* PostgreSQL raw schema
* Validated analytical data model

### SQL layer

* Raw table creation
* Data loading
* Data-quality checks
* Analytical transformations
* Final quality validation
* Business analysis queries

### BI layer

* Four-page Power BI dashboard
* DAX-based KPIs
* Multi-factor performance scoring

### Analytical output

* Revenue and sales analysis
* Product-category analysis
* Seller-state analysis
* Customer-geography analysis
* Delivery-performance analysis
* Customer-satisfaction analysis
* Composite performance scores
* Business insights
* Potential business recommendations

---

## 1.8 Technology Stack

| Technology       | Purpose                                               |
| ---------------- | ----------------------------------------------------- |
| **PostgreSQL**   | Data storage, relational modeling and SQL analysis    |
| **SQL**          | Data validation, transformation and business analysis |
| **Power BI**     | Interactive reporting and data visualization          |
| **DAX**          | KPIs and composite performance scoring                |
| **Git / GitHub** | Version control and project organization              |

---

## 1.9 Dataset Attribution & License

This project uses the **Brazilian E-Commerce Public Dataset by Olist**, originally provided by **Olist** and published through Kaggle.

The dataset contains approximately 100,000 orders from Olist Store between 2016 and 2018 and includes information covering orders, products, customers, sellers, payments, freight, delivery performance and customer reviews. The original dataset is anonymized.

### Dataset source

**Dataset:** Brazilian E-Commerce Public Dataset by Olist
**Provider:** Olist
**Public distribution:** Kaggle
**License:** CC BY-NC-SA 4.0

The dataset is used in this portfolio project for **educational and analytical purposes**, with attribution to the original data provider.

The original dataset should be considered the property of its respective provider and is not claimed as original data created by the author of this project.

**Original dataset:**
[Olist — Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Attribution:**

> Brazilian E-Commerce Public Dataset by Olist. Dataset provided by Olist and distributed through Kaggle under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International license (CC BY-NC-SA 4.0).

The dataset's published description states that the commercial data was anonymized and that identifying references in review text were replaced.

---

## 1.10 Documentation Roadmap

The remaining documentation will explain the project in detail through the following stages:

1. **Data Understanding**
   Structure, tables, entities and data relationships.

2. **Data Quality**
   Validation process, identified issues and analytical decisions.

3. **Data Modeling**
   Fact and dimension tables, table grain, relationships and modeling decisions.

4. **SQL Analysis**
   Business questions, analytical queries and methodology.

5. **Power BI Dashboard**
   Structure and purpose of each of the four dashboard pages.

6. **Business Insights**
   Key findings extracted from the analysis and their business meaning.

7. **Performance Scoring**
   Methodology behind the seller-state, customer-city and product-category scores.

8. **Business Recommendations**
   Potential actions derived from the evidence and areas for further investigation.

The objective of the documentation is to make the complete analytical process reproducible and understandable, while demonstrating the connection between **technical data analysis and real-world business decision support**.
