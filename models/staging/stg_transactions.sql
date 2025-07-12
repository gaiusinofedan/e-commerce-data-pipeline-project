{{ config(
  materialized='view',
  tags=['staging', 'sales']
) }}

WITH combined AS (
  SELECT
    CAST(transaction_date AS DATE) AS transaction_date,
    CAST(product_id AS INT64) AS product_id,
    CAST(customer_id AS INT64) AS customer_id,
    CAST(store_id AS INT64) AS store_id,
    CAST(quantity AS INT64) AS quantity,
    1997 AS year
  FROM `ecommerce-data-pipeline-465100`.`mavenmarket_raw`.`transactions_1997`

  UNION ALL

  SELECT
    CAST(transaction_date AS DATE),
    CAST(product_id AS INT64),
    CAST(customer_id AS INT64),
    CAST(store_id AS INT64),
    CAST(quantity AS INT64),
    1998 AS year
  FROM `ecommerce-data-pipeline-465100`.`mavenmarket_raw`.`transactions_1998`
)

SELECT
  -- Synthetic unique transaction ID using ROW_NUMBER over all key fields
  CONCAT(
    CAST(year AS STRING), '_',
    CAST(ROW_NUMBER() OVER (
      PARTITION BY transaction_date, product_id, customer_id, store_id, quantity, year
      ORDER BY transaction_date
    ) AS STRING)
  ) AS transaction_id,

  transaction_date,
  product_id,
  customer_id,
  store_id,
  quantity,
  year

FROM combined
WHERE quantity > 0
