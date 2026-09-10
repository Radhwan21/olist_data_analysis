
--CHECKING DUPLICATES FROM ORDERS
SELECT 
    COUNT (*) AS total_rows,
    COUNT (DISTINCT order_id) AS unique_orders
FROM raw.orders

--understanding customers table
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT customer_unique_id) AS unique_people
FROM raw.customers;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT product_id) AS products
FROM raw.order_items;

--INVESTIGATING NULL VALUES
SELECT
    COUNT(*) AS total_rows,
    COUNT(order_id) AS order_id,
    COUNT(customer_id) AS customer_id,
    COUNT(order_status) AS order_status,
    COUNT(order_purchase_timestamp) AS purchase_date,
    COUNT(order_approved) AS approved_date,
    COUNT(order_delivered_carrier_date) AS carrier_date,
    COUNT(order_delivered_customer_date) AS delivered_date,
    COUNT(order_estimated_delivery_date) AS estimated_date
FROM raw.orders;
--MISSING: approved_date: 160 -- carrier_date: 1783 -- delivery_date: 2965 
-- WHY ?
SELECT 
    order_status,
    COUNT (*) AS orders
FROM raw.orders
WHERE order_delivered_carrier_date IS NULL
GROUP BY order_status
ORDER BY orders DESC

SELECT 
    order_status,
    COUNT (*) AS orders
FROM raw.orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status
ORDER BY orders DESC


SELECT 
    order_status,
    COUNT (*) AS orders
FROM raw.orders
WHERE order_approved IS NULL
GROUP BY order_status
ORDER BY orders DESC

--Checking chronological order
SELECT * 
FROM raw.orders
WHERE
    order_approved < order_purchase_timestamp AND
    order_delivered_carrier_date < order_approved AND
    order_delivered_customer_date < order_delivered_carrier_date

