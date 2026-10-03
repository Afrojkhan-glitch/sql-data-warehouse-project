USE Datawarehouse;

-- 1. Dimension Exploration
-- Explore all Countries Our Customers come from
SELECT DISTINCT country FROM gold.dim_customers;

-- Explore All Categories & Subcategories
SELECT DISTINCT category, subcategory, product_name
FROM gold.dim_products
ORDER BY 1, 2, 3;

-- 2. Date Ranges & Demographics
-- Find the date of the first and last order & duration in months
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_month
FROM gold.fact_sales;

-- Find the youngest and oldest customer age
SELECT
    MIN(birthdate) AS oldest_birthdate,
    TIMESTAMPDIFF(YEAR, MIN(birthdate), CURDATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    TIMESTAMPDIFF(YEAR, MAX(birthdate), CURDATE()) AS youngest_age
FROM gold.dim_customers;

-- 3. Core KPI Metrics
SELECT SUM(sales_amount) AS Total_Sales FROM gold.fact_sales;
SELECT SUM(quantity) AS item_sold FROM gold.fact_sales;
SELECT AVG(price) AS avg_price FROM gold.fact_sales;
SELECT COUNT(DISTINCT order_number) AS Total_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT product_name) AS Total_products FROM gold.dim_products;
SELECT COUNT(DISTINCT customer_key) AS Total_customers FROM gold.dim_customers;
SELECT COUNT(DISTINCT customer_key) AS Total_customer_order FROM gold.fact_sales;

-- Executive Summary KPI Report
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total no. Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total no. Products', COUNT(DISTINCT product_key) FROM gold.dim_products
UNION ALL
SELECT 'Total no. Customers', COUNT(DISTINCT customer_key) FROM gold.dim_customers
UNION ALL
SELECT 'Total Customers Placed Order', COUNT(DISTINCT customer_key) FROM gold.fact_sales;

-- 4. Demographic & Categorical Distributions
-- Total customers by country
SELECT country, COUNT(customer_key) AS total_customer
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customer DESC;

-- Total customers by gender
SELECT gender, COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Total products by category
SELECT category, COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Average cost in each category
SELECT category, ROUND(AVG(cost), 2) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- Total revenue by category
SELECT dp.category, SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs 
LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
GROUP BY dp.category
ORDER BY total_revenue DESC;

-- Total revenue by customer
SELECT c.customer_key, c.first_name, c.last_name, SUM(f.sales_amount) AS total_amount
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_amount DESC;

-- Distribution of sold items across countries
SELECT c.country, SUM(fs.quantity) AS total_quantity
FROM gold.dim_customers c 
JOIN gold.fact_sales fs ON c.customer_key = fs.customer_key
GROUP BY c.country
ORDER BY total_quantity DESC;

-- 5. Ranking Analysis (Top / Bottom Performers)
-- Top 5 products by revenue
SELECT dp.product_name, SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs 
LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
GROUP BY dp.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 5 worst-performing products by revenue
SELECT dp.product_name, SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs 
LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
GROUP BY dp.product_name
ORDER BY total_revenue ASC
LIMIT 5;

-- Top 5 subcategories by revenue
SELECT dp.subcategory, SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs 
LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
GROUP BY dp.subcategory
ORDER BY total_revenue DESC
LIMIT 5;

-- 5 worst subcategories by revenue
SELECT dp.subcategory, SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs 
LEFT JOIN gold.dim_products dp ON dp.product_key = fs.product_key
GROUP BY dp.subcategory
ORDER BY total_revenue ASC
LIMIT 5;

-- Top 3 customers by number of orders placed
SELECT c.customer_key, c.first_name, c.last_name, COUNT(DISTINCT f.order_number) AS total_orders
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_orders DESC
LIMIT 3;

-- Bottom 3 customers by number of orders placed
SELECT c.customer_key, c.first_name, c.last_name, COUNT(DISTINCT f.order_number) AS total_orders
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_orders ASC
LIMIT 3;
