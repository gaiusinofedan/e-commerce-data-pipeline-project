{{ config(
    materialized = 'table',
    tags = ['mart', 'products']
) }}

WITH base AS (
  SELECT
    p.brand AS product_brand,
    COUNT(DISTINCT t.transaction_id) AS total_orders,
    SUM(t.quantity) AS quantity_sold,
    SUM(t.quantity * p.retail_price) AS total_revenue,
    SUM(t.quantity * p.cost) AS total_cost,
    SUM(t.quantity * (p.retail_price - p.cost)) AS total_profit,
    SUM(COALESCE(r.return_quantity, 0)) AS quantity_returned,
    SAFE_DIVIDE(SUM(COALESCE(r.return_quantity, 0)), SUM(t.quantity)) AS return_rate
  FROM {{ ref('stg_transactions') }} t
  JOIN {{ ref('stg_products') }} p 
    ON t.product_id = p.product_id
  LEFT JOIN {{ ref('stg_returns') }} r 
    ON t.product_id = r.product_id
    AND t.store_id = r.store_id
    AND t.transaction_date = r.return_date
  GROUP BY p.brand
)

SELECT *
FROM base