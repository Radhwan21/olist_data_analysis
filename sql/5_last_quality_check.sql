---- Checking fact tables rows that all of them are there
SELECT
    (SELECT COUNT(*) FROM raw.order_items) AS raw_order_items,
    (SELECT COUNT(*) FROM analytics.fact_order_item) AS fact_order_items,

    (SELECT COUNT(*) FROM raw.order_payments) AS raw_payments,
    (SELECT COUNT(*) FROM analytics.fact_payment) AS fact_payments,

    (SELECT COUNT(*) FROM raw.order_reviews) AS raw_reviews,
    (SELECT COUNT(*) FROM analytics.fact_review) AS fact_reviews;

--- Checking for orphan products, sellers, customers and dates
SELECT COUNT(*) AS orphan_products
FROM analytics.fact_order_item f
LEFT JOIN analytics.dim_product p
    ON f.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS orphan_sellers
FROM analytics.fact_order_item f
LEFT JOIN analytics.dim_seller s
    ON f.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT COUNT(*) AS orphan_customers
FROM analytics.fact_order_item f
LEFT JOIN analytics.dim_customer c
    ON f.customer_unique_id = c.customer_unique_id
WHERE c.customer_unique_id IS NULL;

SELECT COUNT(*) AS orphan_dates
FROM analytics.fact_order_item f
LEFT JOIN analytics.dim_date d
    ON f.purchase_date_key = d.date_key
WHERE d.date_key IS NULL;

----checking that every payment should belong to an order
SELECT COUNT(*) AS orphan_payment_orders
FROM analytics.fact_payment p
LEFT JOIN raw.orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;


--- checking the revenue if it didn't changed
--- comparing it with the old raw table
SELECT
    SUM(price) AS raw_revenue,
    SUM(freight_value) AS raw_freight
FROM raw.order_items;

SELECT
    SUM(price) AS fact_revenue,
    SUM(freight_value) AS fact_freight
FROM analytics.fact_order_item;

