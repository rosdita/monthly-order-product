-- Monthly sales order based on product category
CREATE TEMPORARY TABLE report_monthly_orders_product_agg AS
SELECT b.category AS product_category,
  DATE(DATE_TRUNC (a.created_at, MONTH)) AS month,
  COUNT(a.product_id) AS items_sold,
  SUM(a.sale_price) AS sales
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS a
  LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` AS b
  ON a.product_id = b.id
WHERE a.status = 'Complete'
GROUP BY 1, 2
ORDER BY 1, 2;

-- Monthly Top-Selling Products
SELECT *
FROM report_monthly_orders_product_agg AS a
WHERE sales = 
  (SELECT MAX(sales)
  FROM report_monthly_orders_product_agg AS b
  WHERE a.month = b.month)
ORDER BY month;

-- Monthly Top-Selling Products by Sales Quantity
SELECT *
FROM report_monthly_orders_product_agg AS a
WHERE items_sold = 
  (SELECT MAX(items_sold)
  FROM report_monthly_orders_product_agg AS b
  WHERE a.month = b.month)
ORDER BY month;
