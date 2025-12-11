-- Load DimCustomer
INSERT INTO DimCustomer (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
SELECT
    sc.customer_id,
    sc.customer_unique_id,
    sc.customer_zip_code_prefix,
    sc.customer_city,
    sc.customer_state
FROM stg_customers sc
ON CONFLICT (customer_id) DO NOTHING; -- Handle potential duplicates if re-running

-- Load DimProduct
INSERT INTO DimProduct (product_id, product_category_name, product_category_name_english, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm)
SELECT
    sp.product_id,
    sp.product_category_name,
    spt.product_category_name_english,
    sp.product_name_lenght,
    sp.product_description_lenght,
    sp.product_photos_qty,
    sp.product_weight_g,
    sp.product_length_cm,
    sp.product_height_cm,
    sp.product_width_cm
FROM stg_products sp
LEFT JOIN stg_product_category_translation spt ON sp.product_category_name = spt.product_category_name
ON CONFLICT (product_id) DO NOTHING;

-- Load DimOrder
INSERT INTO DimOrder (order_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date)
SELECT
    so.order_id,
    so.order_status,
    so.order_purchase_timestamp,
    so.order_approved_at,
    so.order_delivered_carrier_date,
    so.order_delivered_customer_date,
    so.order_estimated_delivery_date
FROM stg_orders so
ON CONFLICT (order_id) DO NOTHING;

-- Load DimSeller
INSERT INTO DimSeller (seller_id)
SELECT DISTINCT
    soi.seller_id
FROM stg_order_items soi
ON CONFLICT (seller_id) DO NOTHING;

-- Load FactSales
INSERT INTO FactSales (order_item_id, price, freight_value, customer_id, product_id, order_id, seller_id)
SELECT
    soi.order_item_id,
    soi.price,
    soi.freight_value,
    so.customer_id, -- customer_id from stg_orders
    soi.product_id,
    soi.order_id,
    soi.seller_id
FROM stg_order_items soi
JOIN stg_orders so ON soi.order_id = so.order_id; -- Join to get customer_id associated with the order
