---- KPI measures
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_unique_id) AS total_customers,
    COUNT(*) AS total_items,
    ROUND(SUM(price), 2) AS total_revenue,
    ROUND(SUM(freight_value), 2) AS total_freight,
    ROUND(
        SUM(price) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM analytics.fact_order_item;

--- Revenue trend
SELECT
    d.year,
    d.month_number,
    d.month_name,

    COUNT(DISTINCT f.order_id) AS total_orders,

    ROUND(SUM(f.price), 2) AS revenue,

    ROUND(
        SUM(f.price) / COUNT(DISTINCT f.order_id),
        2
    ) AS average_order_value

FROM analytics.fact_order_item f

JOIN analytics.dim_date d
    ON f.purchase_date_key = d.date_key

GROUP BY
    d.year,
    d.month_number,
    d.month_name

ORDER BY
    d.year,
    d.month_number;

--- Product category performance
SELECT
    p.product_category_name_english AS category,

    COUNT(DISTINCT f.order_id) AS orders,

    COUNT(*) AS items_sold,

    ROUND(SUM(f.price), 2) AS revenue,

    ROUND(SUM(f.freight_value), 2) AS freight_cost

FROM analytics.fact_order_item f

JOIN analytics.dim_product p
    ON f.product_id = p.product_id

GROUP BY
    p.product_category_name_english

ORDER BY
    revenue DESC;


---- Sellers Performance
SELECT
    s.seller_state,
    COUNT(DISTINCT f.seller_id) AS sellers,
    COUNT(DISTINCT f.order_id) AS orders,
    ROUND(SUM(f.price), 2) AS revenue,
    ROUND(SUM(f.freight_value), 2) AS freight_cost

FROM analytics.fact_order_item f

JOIN analytics.dim_seller s
    ON f.seller_id = s.seller_id

GROUP BY
    s.seller_state

ORDER BY
    revenue DESC;

---- Calculate delivery performance
--- ps: using MAX to group items in orders
WITH order_level AS (
    SELECT
        order_id,
        MAX(order_status) AS order_status,
        MAX(order_delivered_customer_date) AS delivered_date,
        MAX(order_estimated_delivery_date) AS estimated_delivery_date
    FROM analytics.fact_order_item
    GROUP BY order_id
)

SELECT
    CASE
        WHEN delivered_date IS NULL THEN 'Not Delivered'
        WHEN delivered_date <= estimated_delivery_date THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,

    COUNT(*) AS orders

FROM order_level

GROUP BY
    CASE
        WHEN delivered_date IS NULL THEN 'Not Delivered'
        WHEN delivered_date <= estimated_delivery_date THEN 'On Time'
        ELSE 'Late'
    END

ORDER BY orders DESC;

--- Connecting delivery statis to reviews
WITH order_level AS (
    SELECT
        order_id,
        MAX(order_delivered_customer_date) AS delivered_date,
        MAX(order_estimated_delivery_date) AS estimated_delivery_date
    FROM analytics.fact_order_item
    GROUP BY order_id
),

order_delivery AS (
    SELECT
        order_id,

        CASE
            WHEN delivered_date IS NULL THEN 'Not Delivered'
            WHEN delivered_date <= estimated_delivery_date THEN 'On Time'
            ELSE 'Late'
        END AS delivery_status

    FROM order_level
)

SELECT
    od.delivery_status,

    COUNT(*) AS reviews,

    ROUND(AVG(r.review_score), 2) AS average_review_score

FROM order_delivery od

JOIN analytics.fact_review r
    ON od.order_id = r.order_id

GROUP BY
    od.delivery_status

ORDER BY
    average_review_score DESC;

--- since the late deliveries has low scores, let's investigate whether the number of days late matter
WITH order_level AS (
    SELECT
        order_id,
        MAX(order_delivered_customer_date) AS delivered_date,
        MAX(order_estimated_delivery_date) AS estimated_delivery_date
    FROM analytics.fact_order_item
    GROUP BY order_id
),

late_orders AS (
    SELECT
        order_id,

        EXTRACT(
            DAY FROM (
                delivered_date - estimated_delivery_date
            )
        ) AS days_late

    FROM order_level

    WHERE delivered_date > estimated_delivery_date
)

SELECT
    CASE
        WHEN lo.days_late BETWEEN 1 AND 3 THEN '1–3 days late'
        WHEN lo.days_late BETWEEN 4 AND 7 THEN '4–7 days late'
        WHEN lo.days_late BETWEEN 8 AND 14 THEN '8–14 days late'
        ELSE '15+ days late'
    END AS delay_group,

    COUNT(DISTINCT lo.order_id) AS late_orders,

    COUNT(r.review_id) AS reviews,

    ROUND(AVG(r.review_score), 2) AS average_review_score

FROM late_orders lo

JOIN analytics.fact_review r
    ON lo.order_id = r.order_id

GROUP BY
    CASE
        WHEN lo.days_late BETWEEN 1 AND 3 THEN '1–3 days late'
        WHEN lo.days_late BETWEEN 4 AND 7 THEN '4–7 days late'
        WHEN lo.days_late BETWEEN 8 AND 14 THEN '8–14 days late'
        ELSE '15+ days late'
    END

ORDER BY
    MIN(lo.days_late);
--- actually days late doesn't matter

--- Relation between reviews and categories revenue (excluding bad reviews on latency)
WITH order_category AS (
    SELECT
        f.order_id,
        p.product_category_name_english AS category,
        SUM(f.price) AS order_revenue,
        MAX(f.order_delivered_customer_date) AS delivered_date,
        MAX(f.order_estimated_delivery_date) AS estimated_delivery_date
    FROM analytics.fact_order_item f
    JOIN analytics.dim_product p
        ON f.product_id = p.product_id
    GROUP BY
        f.order_id,
        p.product_category_name_english
),

on_time_orders AS (
    SELECT *
    FROM order_category
    WHERE delivered_date IS NOT NULL
      AND delivered_date <= estimated_delivery_date
)

SELECT
    oc.category,
    COUNT(DISTINCT oc.order_id) AS orders,
    ROUND(SUM(oc.order_revenue), 2) AS revenue,
    COUNT(DISTINCT (r.review_id, r.order_id)) AS reviews,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM on_time_orders oc
JOIN analytics.fact_review r
    ON oc.order_id = r.order_id
GROUP BY oc.category
ORDER BY revenue DESC;
