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


-- 6. MONTHLY AGGREGATION & VOLUME METRICS
-- Purpose: Breakdown revenue, order volume, unique customers, and items sold by month.

SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;



-- 7. MONTHLY RUNNING TOTAL & MOVING AVERAGE ANALYSIS
-- Purpose: Calculate cumulative sales over time and track a 3-month rolling 
-- average price using Window Functions and a Common Table Expression (CTE).

WITH monthly_metrics AS (
    SELECT
        DATE_FORMAT(order_date, '%Y_%m') AS order_month,
        MIN(order_date) AS month_start_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y_%m')
)
SELECT 
    order_month,
    total_sales,
    SUM(total_sales) OVER(ORDER BY month_start_date) AS running_total_sales,
    avg_price,
    AVG(avg_price) OVER(ORDER BY month_start_date) AS running_avg_price,
    AVG(avg_price) OVER(ORDER BY month_start_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3m_avg_price
FROM monthly_metrics
ORDER BY month_start_date;



-- 6. YEARLY RUNNING TOTAL & ANNUAL MOVING AVERAGE ANALYSIS
-- Purpose: Evaluate year-over-year growth and cumulative sales trajectory.

WITH yearly_metrics AS (
    SELECT
        YEAR(order_date) AS order_year,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY YEAR(order_date)
)
SELECT 
    order_year,
    total_sales,
    SUM(total_sales) OVER(ORDER BY order_year) AS running_total_sales,
    avg_price,
    AVG(avg_price) OVER(ORDER BY order_year) AS running_avg_price
FROM yearly_metrics
ORDER BY order_year;


--Analyze the yearly performance of products by comparing their sales to both the
--average sales performance of the product and the previous year's sales

WITH yearly_product_sales AS (
    SELECT 
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p 
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY YEAR(f.order_date), p.product_name
),
product_performance AS (
    SELECT 
        order_year,
        product_name,
        current_sales,
        AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
        LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales
    FROM yearly_product_sales
)
SELECT 
    order_year,
    product_name,
    current_sales,
    avg_sales,
    current_sales - avg_sales AS diff_avg,
    CASE 
        WHEN current_sales - avg_sales > 0 THEN 'Above_Avg'
        WHEN current_sales - avg_sales < 0 THEN 'Below_Avg'
        ELSE 'Avg'
    END AS avg_change,
    py_sales,
    current_sales - py_sales AS diff_py,
    CASE 
        WHEN current_sales - py_sales > 0 THEN 'Increase'
        WHEN current_sales - py_sales < 0 THEN 'Decrease'
        WHEN py_sales IS NULL THEN 'New Product'
        ELSE 'No Change'
    END AS py_change
FROM product_performance
ORDER BY product_name, order_year;

--Which categories contribute the most to overall sales
WITH category_sales AS(
SELECT
category,
sum(sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON
f.product_key = p.product_key
GROUP BY category)
SELECT
category,
total_sales,
sum(total_sales) over() AS overall_sales,
concat(round((total_sales/sum(total_sales) over())*100,2),'%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;


--Segment products into cost ranges and count how many products fall into eact segment
WITH product_segments AS(
SELECT
product_key,
product_name,
cost,
CASE
	WHEN cost<100 THEN 'Below 100'
    WHEN cost BETWEEN 100 AND 500 THEN '100-500'
    WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
    ELSE 'Above 1000'
END AS cost_range
FROM gold.dim_products)

SELECT
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;


/*Group customers into three segements based on their spending behaviour:
	-VIP: Customers with at least 12 months of history and spending more than 5000.
    -Regular: Customer with at least 12 months of history but spending 5000 or less.
    -New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group.*/
WITH customer_spending AS (
SELECT
c.customer_key,
sum(f.sales_amount) AS total_spending,
min(order_date) AS first_order,
max(order_date) AS last_order,
TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c ON
f.customer_key = c.customer_key
GROUP BY c.customer_key)

SELECT
customer_segment,
COUNT(customer_key) AS total_customer
FROM(
	SELECT
	customer_key,
	CASE 
		WHEN lifespan >=12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan >=12 AND total_spending <=5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
	FROM customer_spending
	ORDER BY customer_key)t
GROUP BY customer_segment;
