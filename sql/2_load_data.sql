COPY raw.orders
FROM 'C:\olist_project\data\raw\olist_orders_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY raw.customers
FROM 'C:\olist_project\data\raw\olist_customers_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY raw.products
FROM 'C:\olist_project\data\raw\olist_products_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY raw.sellers
FROM 'C:\olist_project\data\raw\olist_sellers_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY raw.order_items
FROM 'C:\olist_project\data\raw\olist_order_items_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY raw.order_payments
FROM 'C:\olist_project\data\raw\olist_order_payments_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY raw.order_reviews
FROM 'C:\olist_project\data\raw\olist_order_reviews_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY raw.geolocation
FROM 'C:\olist_project\data\raw\olist_geolocation_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);

COPY raw.product_category_translation
FROM 'C:\olist_project\data\raw\olist_product_category_name_dataset.csv'
WITH (
    FORMAT CSV,
    HEADER TRUE,
    DELIMITER ',',
    ENCODING 'UTF8'
);
