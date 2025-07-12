{{
  config(
    materialized='view',
    tags=['staging', 'locations']
  )
}}

SELECT
  CAST(store_id AS INT64) AS store_id,
  CAST(region_id AS INT64) AS region_id,
  TRIM(store_type) AS store_type,
  TRIM(store_name) AS name,
  REGEXP_REPLACE(TRIM(store_street_address), r'\s{2,}', ' ') AS street_address,
  TRIM(store_city) AS city,
  TRIM(store_state) AS state,
  TRIM(store_country) AS country,
  TRIM(store_phone) AS phone,
  CAST(first_opened_date AS DATE) AS opened_date,
  CAST(last_remodel_date AS DATE) AS last_remodel_date,
  CAST(total_sqft AS INT64) AS total_sqft,
  CAST(grocery_sqft AS INT64) AS grocery_sqft,
  -- Data quality
  CASE
    WHEN first_opened_date > last_remodel_date THEN 'INVALID_REMODEL_DATE'
    ELSE 'VALID'
  END AS dq_flag
FROM `ecommerce-data-pipeline-465100`.`mavenmarket_raw`.`stores`