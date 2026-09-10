-------- creating dim_customer ----------
-- verifications
SELECT
    customer_unique_id,
    COUNT(*) AS customer_records,
    COUNT(DISTINCT customer_zip_code_prefix) AS zip_codes,
    COUNT(DISTINCT customer_city) AS cities,
    COUNT(DISTINCT customer_state) AS states
FROM raw.customers

GROUP BY customer_unique_id
HAVING COUNT(*) > 1
AND (
    COUNT(DISTINCT customer_zip_code_prefix) > 1 OR 
    COUNT(DISTINCT customer_city) > 1 OR
    COUNT(DISTINCT customer_state) > 1
)
ORDER BY customer_records DESC;

-- there are 252 customers that have multiple location
-- that's why we will use the last location recorded (probably current location)
-- FINDING THE LAST LOCATION
SELECT
    customer_unique_id,
    customer_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    order_purchase_timestamp
FROM (
    SELECT
        c.customer_unique_id,
        c.customer_id,
        c.customer_zip_code_prefix,
        c.customer_city,
        c.customer_state,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp DESC
        ) AS rn
    FROM raw.customers c
    JOIN raw.orders o
        ON c.customer_id = o.customer_id
) t
WHERE rn = 1;
-- there are 96096 row which are exactly the number of the real customers assigned to their last location

--------- CREATING analytics.dim_customer ------------
CREATE SCHEMA IF NOT EXISTS analytics;
CREATE TABLE analytics.dim_customer (
    customer_unique_id VARCHAR(50) PRIMARY KEY,
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(100),
    customer_state VARCHAR(10)
);
INSERT INTO analytics.dim_customer(
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
)
SELECT
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM (
    SELECT 
        c.customer_unique_id,
        c.customer_zip_code_prefix,
        c.customer_city,
        c.customer_state,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp DESC
        ) AS rn
        FROM raw.customers c
        JOIN raw.orders o 
            ON c.customer_id = o.customer_id
        ) t 
WHERE rn = 1;

--verification
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM analytics.dim_customer


------------- Creating dim_product-------------------
CREATE TABLE analytics.dim_product (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100),
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g NUMERIC,
    product_length_cm NUMERIC,
    product_height_cm NUMERIC,
    product_width_cm NUMERIC
);

INSERT INTO analytics.dim_product (
    product_id,
    product_category_name,
    product_category_name_english,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    p.product_id,
    p.product_category_name,
    t.product_category_name_english,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM raw.products p
LEFT JOIN raw.product_category_translation t
    ON p.product_category_name = t.product_category_name;

-- verifications
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products
FROM analytics.dim_product;

SELECT *
FROM analytics.dim_product
LIMIT 10;

------ CREATING dim_seller --------
CREATE TABLE analytics.dim_seller (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INTEGER,
    seller_city VARCHAR(100),
    seller_state VARCHAR(10)
);

INSERT INTO analytics.dim_seller (
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM raw.sellers;

---verifications
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_sellers
FROM analytics.dim_seller;

SELECT *
FROM analytics.dim_seller
LIMIT 10;

----------- Creating dim_date ------------
CREATE TABLE analytics.dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL,
    year INTEGER NOT NULL,
    quarter INTEGER NOT NULL,
    month_number INTEGER NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    week INTEGER NOT NULL,
    day INTEGER NOT NULL,
    day_name VARCHAR(20) NOT NULL
);

--- generating dates based only on the oldes and newest date in the olist dataset
INSERT INTO analytics.dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month_number,
    month_name,
    week,
    day,
    day_name
)
SELECT
    TO_CHAR(d, 'YYYYMMDD')::INTEGER AS date_key,
    d::DATE AS full_date,
    EXTRACT(YEAR FROM d)::INTEGER AS year,
    EXTRACT(QUARTER FROM d)::INTEGER AS quarter,
    EXTRACT(MONTH FROM d)::INTEGER AS month_number,
    TO_CHAR(d, 'FMMonth') AS month_name,
    EXTRACT(WEEK FROM d)::INTEGER AS week,
    EXTRACT(DAY FROM d)::INTEGER AS day,
    TO_CHAR(d, 'FMDay') AS day_name
FROM generate_series(
    (SELECT MIN(order_purchase_timestamp::DATE) FROM raw.orders),
    (SELECT MAX(order_purchase_timestamp::DATE) FROM raw.orders),
    INTERVAL '1 day'
) AS d;

---- verifications
SELECT COUNT(*) AS total_dates
FROM analytics.dim_date;

SELECT *
FROM analytics.dim_date
ORDER BY full_date DESC
LIMIT 10;



-------- CREATING fact_order_itme TABLE ---------------
CREATE TABLE analytics.fact_order_item (
    order_id VARCHAR(50) NOT NULL,
    order_item_id INTEGER NOT NULL,

    customer_unique_id VARCHAR(50),
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    purchase_date_key INTEGER,

    order_status VARCHAR(30),

    price NUMERIC(12,2),
    freight_value NUMERIC(12,2),

    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,

    PRIMARY KEY (order_id, order_item_id),

    FOREIGN KEY (customer_unique_id)
        REFERENCES analytics.dim_customer(customer_unique_id),

    FOREIGN KEY (product_id)
        REFERENCES analytics.dim_product(product_id),

    FOREIGN KEY (seller_id)
        REFERENCES analytics.dim_seller(seller_id),

    FOREIGN KEY (purchase_date_key)
        REFERENCES analytics.dim_date(date_key)
);

INSERT INTO analytics.fact_order_item (
    order_id,
    order_item_id,
    customer_unique_id,
    product_id,
    seller_id,
    purchase_date_key,
    order_status,
    price,
    freight_value,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT
    oi.order_id,
    oi.order_item_id,

    c.customer_unique_id,

    oi.product_id,
    oi.seller_id,

    TO_CHAR(o.order_purchase_timestamp::DATE, 'YYYYMMDD')::INTEGER
        AS purchase_date_key,

    o.order_status,

    oi.price,
    oi.freight_value,

    o.order_purchase_timestamp,
    o.order_approved,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date

FROM raw.order_items oi

JOIN raw.orders o
    ON oi.order_id = o.order_id

JOIN raw.customers c
    ON o.customer_id = c.customer_id;


-------- verifications
SELECT COUNT(*) AS fact_rows
FROM analytics.fact_order_item;

SELECT COUNT(*) AS raw_order_items
FROM raw.order_items;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT seller_id) AS unique_sellers,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM analytics.fact_order_item;

SELECT *
FROM analytics.fact_order_item
LIMIT 10;

SELECT 
    COUNT(customer_unique_id)
FROM analytics.dim_customer

---- unique customers are 96096 but in the fact table it states only 95420
---- checking if these missing customers really did not buy anything

SELECT 
    COUNT(customer_unique_id)
FROM analytics.dim_customer
WHERE customer_unique_id NOT IN(
    SELECT 
        customer_unique_id
    FROM analytics.fact_order_item
)
---- there are 676 missing customers and 96096 - 95420 = 676 exactly

-------------- CREATING fact_payment table -----------------
CREATE TABLE analytics.fact_payment (
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INTEGER NOT NULL,
    payment_type VARCHAR(30),
    payment_installments INTEGER,
    payment_value NUMERIC(12,2),

    PRIMARY KEY (order_id, payment_sequential),

    FOREIGN KEY (order_id)
        REFERENCES raw.orders(order_id)
);


INSERT INTO analytics.fact_payment (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM raw.order_payments;


------ verifications
SELECT COUNT(*) AS fact_payment_rows
FROM analytics.fact_payment;

SELECT COUNT(*) AS raw_payment_rows
FROM raw.order_payments;

------ CREATING fact_reviews table ---------------
CREATE TABLE analytics.fact_review (
    review_id VARCHAR(50) PRIMARY KEY,
    order_id VARCHAR(50) NOT NULL,

    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,

    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES raw.orders(order_id)
);

---------- the review_id cannot be PK since it is not unique
SELECT *
FROM raw.order_reviews
WHERE review_id IN (
    SELECT review_id
    FROM raw.order_reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
)
ORDER BY review_id;
--- checking the relationship with orders
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_reviews,
    COUNT(DISTINCT order_id) AS unique_orders
FROM raw.order_reviews;


SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM raw.order_reviews
WHERE review_id IN (
    SELECT review_id
    FROM raw.order_reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
)
ORDER BY review_id, order_id
LIMIT 30;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (review_id, order_id)) AS unique_review_order_pairs
FROM raw.order_reviews;

----- after running these queries, I deducted that the real 
----- PK is (review_id,order_id)

---- re-creating the fixed fact_review table
DROP TABLE analytics.fact_review;

CREATE TABLE analytics.fact_review (
    review_id VARCHAR(50) NOT NULL,
    order_id VARCHAR(50) NOT NULL,

    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,

    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,

    PRIMARY KEY (review_id, order_id),

    FOREIGN KEY (order_id)
        REFERENCES raw.orders(order_id)
);

INSERT INTO analytics.fact_review (
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM raw.order_reviews;

--- verifications
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (review_id, order_id)) AS unique_review_order_pairs
FROM analytics.fact_review;

