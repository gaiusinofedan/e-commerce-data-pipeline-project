{{
  config(
    materialized='view',
    tags=['staging', 'inventory']
  )
}}

SELECT
  CAST(product_id AS INT64) AS product_id,
  TRIM(product_brand) AS brand,
  TRIM(product_name) AS name,
  CAST(product_sku AS INT64) AS sku,
  CAST(product_retail_price AS FLOAT64) AS retail_price,
  CAST(product_cost AS FLOAT64) AS cost,
  SAFE_DIVIDE(
    (product_retail_price - product_cost),
    product_retail_price
  ) AS gross_margin_pct,
  CAST(product_weight AS FLOAT64) AS weight_kg,
  CAST(recyclable AS BOOL) AS is_recyclable,
  CAST(low_fat AS BOOL) AS is_low_fat,
  -- Data quality
  CASE
    WHEN product_cost > product_retail_price THEN 'NEGATIVE_MARGIN'
    WHEN product_weight <= 0 THEN 'INVALID_WEIGHT'
    ELSE 'VALID'
  END AS dq_flag
FROM `ecommerce-data-pipeline-465100`.`mavenmarket_raw`.`products`