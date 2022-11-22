
--The total quantity sold for all products:
SELECT 
	details.product_name,
	SUM(sales.qty) AS sale_counts
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY sale_counts DESC;


--The total generated revenue for all products before discounts:
SELECT 
	SUM(price * qty) AS nodis_revenue
FROM sales AS sales;


--The total discount amount for all products:
SELECT 
	SUM(price * qty * discount)/100 AS total_discount
FROM sales;


--The total number of unique transactions:
SELECT 
	COUNT(DISTINCT txn_id) AS unique_txn
FROM sales;


--The average unique products purchased in each transaction:
WITH cte_transaction_products AS (
	SELECT
		txn_id,
		COUNT(DISTINCT prod_id) AS product_count
	FROM sales
	GROUP BY txn_id
)
SELECT
	ROUND(AVG(product_count)) AS avg_unique_products
FROM cte_transaction_products;


--The average discount value per transaction:
WITH cte_transaction_discounts AS (
	SELECT
		txn_id,
		SUM(price * qty * discount)/100 AS total_discount
	FROM sales
	GROUP BY txn_id
)
SELECT
	ROUND(AVG(total_discount)) AS avg_unique_products
FROM cte_transaction_discounts;


--The average revenue for member transactions and non-member transactions:
WITH cte_member_revenue AS (
  SELECT
    member,
    txn_id,
    SUM(price * qty) AS revenue
  FROM sales
  GROUP BY 
	member, 
	txn_id
)
SELECT
  member,
  ROUND(AVG(revenue), 2) AS avg_revenue
FROM cte_member_revenue
GROUP BY member;


--The top 3 products by total revenue before discount:
SELECT 
	details.product_name,
	SUM(sales.qty * sales.price) AS nodis_revenue
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY nodis_revenue DESC
LIMIT 3;


--The total quantity, revenue and discount for each segment:
SELECT 
	details.segment_id,
	details.segment_name,
	SUM(sales.qty) AS total_quantity,
	SUM(sales.qty * sales.price) AS total_revenue,
	SUM(sales.qty * sales.price * sales.discount)/100 AS total_discount
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY 
	details.segment_id,
	details.segment_name
ORDER BY total_revenue DESC;


--The top selling product for each segment:
SELECT 
	details.segment_id,
	details.segment_name,
	details.product_id,
	details.product_name,
	SUM(sales.qty) AS product_quantity
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY
	details.segment_id,
	details.segment_name,
	details.product_id,
	details.product_name
ORDER BY product_quantity DESC
LIMIT 5;


--The total quantity, revenue and discount for each category:
SELECT 
	details.category_id,
	details.category_name,
	SUM(sales.qty) AS total_quantity,
	SUM(sales.qty * sales.price) AS total_revenue,
	SUM(sales.qty * sales.price * sales.discount)/100 AS total_discount
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY 
	details.category_id,
	details.category_name
ORDER BY total_revenue DESC;


--The top selling product for each category:
SELECT 
	details.category_id,
	details.category_name,
	details.product_id,
	details.product_name,
	SUM(sales.qty) AS product_quantity
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY
	details.category_id
ORDER BY product_quantity DESC
LIMIT 5;

