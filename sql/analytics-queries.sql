/* ===========================================================
   BRASIMART E-COMMERCE ANALYTICS QUERIES
   Author: Ashwin Abraham Philip
   Purpose: Business analytics and KPI extraction from transactional schema
   =========================================================== */


/* ===========================================================
   1. REVENUE AND SALES METRICS
   =========================================================== */

-- Business Question: How much revenue is generated over time?
SELECT 
    DATEPART(year, o.order_purchase_timestamp) AS year,
    DATEPART(month, o.order_purchase_timestamp) AS month,
    SUM(oi.price + oi.freight_value) AS total_revenue
FROM Orders o
JOIN OrderItem oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATEPART(year, o.order_purchase_timestamp),
         DATEPART(month, o.order_purchase_timestamp)
ORDER BY year, month;


-- Business Question: What is the Average Order Value (AOV)?
SELECT 
    AVG(order_total) AS avg_order_value
FROM (
    SELECT o.order_id,
           SUM(oi.price + oi.freight_value) AS order_total
    FROM Orders o
    JOIN OrderItem oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
) t;


/* ===========================================================
   2. CUSTOMER ANALYTICS
   =========================================================== */

-- Business Question: Who are the top customers by lifetime value (CLV)?
SELECT 
    c.customer_id,
    c.customer_city,
    c.customer_state,
    SUM(oi.price + oi.freight_value) AS lifetime_value
FROM Customer c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderItem oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_city, c.customer_state
ORDER BY lifetime_value DESC;


-- Business Question: How many repeat customers exist?
SELECT 
    COUNT(DISTINCT customer_id) AS repeat_customers
FROM (
    SELECT customer_id, COUNT(order_id) AS num_orders
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) t;


/* ===========================================================
   3. PRODUCT & CATEGORY PERFORMANCE
   =========================================================== */

-- Business Question: Which products generate the most revenue?
SELECT 
    p.product_id,
    p.product_category_name,
    SUM(oi.price + oi.freight_value) AS product_revenue
FROM Product p
JOIN OrderItem oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_category_name
ORDER BY product_revenue DESC;


-- Business Question: Which categories drive the most sales?
SELECT 
    p.product_category_name,
    SUM(oi.price + oi.freight_value) AS category_revenue
FROM Product p
JOIN OrderItem oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY category_revenue DESC;


/* ===========================================================
   4. SELLER PERFORMANCE
   =========================================================== */

-- Business Question: Which sellers generate the highest revenue?
SELECT 
    s.seller_id,
    s.seller_city,
    SUM(oi.price + oi.freight_value) AS seller_revenue
FROM Seller s
JOIN OrderItem oi ON s.seller_id = oi.seller_id
GROUP BY s.seller_id, s.seller_city
ORDER BY seller_revenue DESC;


/* ===========================================================
   5. DELIVERY & LOGISTICS ANALYTICS
   =========================================================== */

-- Business Question: How often are orders delivered late?
SELECT 
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_delivered_cust_date > order_est_delivery_date THEN 1 ELSE 0 END) AS late_deliveries
FROM Orders
WHERE order_status = 'delivered';


-- Business Question: Average delivery delay (in days)
SELECT 
    AVG(DATEDIFF(day, order_est_delivery_date, order_delivered_cust_date)) AS avg_delay_days
FROM Orders
WHERE order_delivered_cust_date IS NOT NULL;


/* ===========================================================
   6. CUSTOMER SERVICE ANALYTICS
   =========================================================== */

-- Business Question: What are the most common service issues?
SELECT 
    issue_type,
    COUNT(*) AS issue_count
FROM cust_service_ticket
GROUP BY issue_type
ORDER BY issue_count DESC;


-- Business Question: Total compensation paid to customers
SELECT 
    SUM(comp_amt) AS total_compensation
FROM cust_service_ticket
WHERE comp_amt IS NOT NULL;


/* ===========================================================
   7. CUSTOMER REVIEWS ANALYTICS
   =========================================================== */

-- Business Question: Average review score by product category
SELECT 
    p.product_category_name,
    AVG(r.review_score) AS avg_review_score
FROM OrderReview r
JOIN Orders o ON r.order_id = o.order_id
JOIN OrderItem oi ON o.order_id = oi.order_id
JOIN Product p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY avg_review_score DESC;


/* ===========================================================
   8. Further Analysis
   =========================================================== */

-- Pareto Analysis: Top 20% customers driving revenue
WITH customer_revenue AS (
    SELECT c.customer_id,
           SUM(oi.price + oi.freight_value) AS revenue
    FROM Customer c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN OrderItem oi ON o.order_id = oi.order_id
    GROUP BY c.customer_id
),
ranked AS (
    SELECT *,
           NTILE(5) OVER (ORDER BY revenue DESC) AS revenue_bucket
    FROM customer_revenue
)
SELECT *
FROM ranked
WHERE revenue_bucket = 1;


-- Rolling 3-month revenue trend
SELECT 
    DATEPART(year, o.order_purchase_timestamp) AS year,
    DATEPART(month, o.order_purchase_timestamp) AS month,
    SUM(oi.price + oi.freight_value) AS revenue,
    SUM(SUM(oi.price + oi.freight_value)) OVER (
        ORDER BY DATEPART(year, o.order_purchase_timestamp),
                 DATEPART(month, o.order_purchase_timestamp)
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3_month_revenue
FROM Orders o
JOIN OrderItem oi ON o.order_id = oi.order_id
GROUP BY DATEPART(year, o.order_purchase_timestamp),
         DATEPART(month, o.order_purchase_timestamp);
