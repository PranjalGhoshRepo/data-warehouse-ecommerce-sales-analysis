-- Staging Tables (mirroring raw CSVs)

CREATE TABLE stg_customers (
    customer_id VARCHAR(255),
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(255),
    customer_state VARCHAR(255)
);

CREATE TABLE stg_order_items (
    order_id VARCHAR(255),
    order_item_id INT,
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
    shipping_limit_date DATETIME,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2)
);

CREATE TABLE stg_orders (
    order_id VARCHAR(255),
    customer_id VARCHAR(255),
    order_status VARCHAR(255),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

CREATE TABLE stg_products (
    product_id VARCHAR(255),
    product_category_name VARCHAR(255),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE stg_product_category_translation (
    product_category_name VARCHAR(255),
    product_category_name_english VARCHAR(255)
);

-- Dimension Tables

CREATE TABLE DimCustomer (
    customer_pk INT IDENTITY(1,1) PRIMARY KEY,
    customer_id VARCHAR(255) UNIQUE,
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(255),
    customer_state VARCHAR(255)
);

CREATE TABLE DimProduct (
    product_pk INT IDENTITY(1,1) PRIMARY KEY,
    product_id VARCHAR(255) UNIQUE,
    product_category_name VARCHAR(255),
    product_category_name_english VARCHAR(255),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

CREATE TABLE DimOrder (
    order_pk INT IDENTITY(1,1) PRIMARY KEY,
    order_id VARCHAR(255) UNIQUE,
    order_status VARCHAR(255),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

CREATE TABLE DimSeller (
    seller_pk INT IDENTITY(1,1) PRIMARY KEY,
    seller_id VARCHAR(255) UNIQUE
);

CREATE TABLE FactSales (
    sales_pk INT IDENTITY(1,1) PRIMARY KEY,
    order_item_id INT,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    customer_id VARCHAR(255),
    product_id VARCHAR(255),
    order_id VARCHAR(255),
    seller_id VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES DimCustomer(customer_id),
    FOREIGN KEY (product_id) REFERENCES DimProduct(product_id),
    FOREIGN KEY (order_id) REFERENCES DimOrder(order_id),
    FOREIGN KEY (seller_id) REFERENCES DimSeller(seller_id)
);
