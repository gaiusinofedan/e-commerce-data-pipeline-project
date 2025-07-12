{{
  config(
    materialized='view',
    tags=['staging', 'sales']
  )
}}

SELECT
  CAST(return_date AS DATE) AS return_date,
  CAST(product_id AS INT64) AS product_id,
  CAST(store_id AS INT64) AS store_id,
  CAST(quantity AS INT64) AS return_quantity,
  -- Data quality
  CASE
    WHEN return_date > CURRENT_DATE() THEN 'FUTURE_RETURN'
    ELSE 'VALID'
  END AS dq_flag
FROM `ecommerce-data-pipeline-465100`.`mavenmarket_raw`.`returns`