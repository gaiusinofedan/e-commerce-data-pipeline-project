{{ config(
    materialized='table',
    tags=['mart', 'executive']
) }}

WITH base AS (
  SELECT
    t.transaction_date,
    p.brand AS product_category,
    t.quantity AS quantity_sold,
    r.return_quantity,
    pr.retail_price,
    pr.cost,
    (t.quantity * pr.retail_price) AS revenue,
    (t.quantity * (pr.retail_price - pr.cost)) AS profit
  FROM {{ ref('stg_transactions') }} t
  LEFT JOIN {{ ref('stg_products') }} pr ON t.product_id = pr.product_id
  LEFT JOIN {{ ref('stg_returns') }} r 
    ON t.transaction_date = r.return_date
    AND t.product_id = r.product_id
    AND t.store_id = r.store_id
  LEFT JOIN {{ ref('stg_products') }} p ON t.product_id = p.product_id
)

SELECT
  DATE_TRUNC(transaction_date, MONTH) AS month,
  product_category,
  SUM(quantity_sold) AS total_orders,
  SUM(COALESCE(return_quantity, 0)) AS total_returns,
  SUM(revenue) AS total_revenue,
  SUM(profit) AS total_profit,
  SAFE_DIVIDE(SUM(COALESCE(return_quantity, 0)), SUM(quantity_sold)) AS return_rate
FROM base
GROUP BY 1, 2
