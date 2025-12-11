-- Monthly Sales
SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS sales_month,
    SUM(fs.price + fs.freight_value) AS total_sales
FROM FactSales fs
JOIN DimOrder do ON fs.order_id = do.order_id
GROUP BY 1
ORDER BY 1;

-- Top 10 Products by Sales Revenue
SELECT
    dp.product_category_name_english,
    SUM(fs.price + fs.freight_value) AS total_revenue
FROM FactSales fs
JOIN DimProduct dp ON fs.product_id = dp.product_id
GROUP BY 1
ORDER BY total_revenue DESC
LIMIT 10;

-- Top 10 Customers by Total Spend
SELECT
    dc.customer_unique_id,
    SUM(fs.price + fs.freight_value) AS total_spend
FROM FactSales fs
JOIN DimCustomer dc ON fs.customer_id = dc.customer_id
GROUP BY 1
ORDER BY total_spend DESC
LIMIT 10;

-- Sales by State
SELECT
    dc.customer_state,
    SUM(fs.price + fs.freight_value) AS total_sales
FROM FactSales fs
JOIN DimCustomer dc ON fs.customer_id = dc.customer_id
GROUP BY 1
ORDER BY total_sales DESC;
