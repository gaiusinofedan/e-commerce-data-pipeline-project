{{ config(
    materialized = 'table',
    tags = ['mart', 'customers']
) }}

WITH transactions AS (
  SELECT 
    customer_id,
    transaction_date,
    quantity,
    p.retail_price,
    p.cost,
    quantity * p.retail_price AS revenue,
    quantity * (p.retail_price - p.cost) AS profit
  FROM {{ ref('stg_transactions') }} t
  JOIN {{ ref('stg_products') }} p ON t.product_id = p.product_id
),

returns AS (
  SELECT 
    customer_id,
    return_quantity
  FROM {{ ref('stg_returns') }} r
  JOIN {{ ref('stg_transactions') }} t
    ON r.product_id = t.product_id 
    AND r.store_id = t.store_id
    AND r.return_date = t.transaction_date
),

agg AS (
  SELECT 
    customer_id,
    COUNT(DISTINCT transaction_date) AS total_orders,
    SUM(quantity) AS total_quantity,
    SUM(revenue) AS total_revenue,
    SUM(profit) AS total_profit,
    MIN(transaction_date) AS first_order_date,
    MAX(transaction_date) AS last_order_date
  FROM transactions
  GROUP BY customer_id
),

returns_agg AS (
  SELECT
    customer_id,
    SUM(return_quantity) AS total_returns
  FROM returns
  GROUP BY customer_id
)

SELECT
  c.customer_id,
  c.customer_acct_num,
  c.first_name,
  c.last_name,
  c.address,
  c.city,
  c.state,
  c.postal_code,
  c.country,
  c.birthdate,
  c.marital_status,
  c.yearly_income,
  c.gender,
  c.total_children,
  c.num_children_at_home,
  c.education_level,
  c.acct_open_date,
  c.member_card_type,
  c.occupation,
  c.is_homeowner,
  agg.total_orders,
  agg.total_quantity,
  agg.total_revenue,
  agg.total_profit,
  agg.first_order_date,
  agg.last_order_date,
  COALESCE(r.total_returns, 0) AS total_returns,
  SAFE_DIVIDE(COALESCE(r.total_returns, 0), agg.total_quantity) AS return_rate
FROM agg
LEFT JOIN {{ ref('stg_customer') }} c ON agg.customer_id = c.customer_id
LEFT JOIN returns_agg r ON agg.customer_id = r.customer_id
