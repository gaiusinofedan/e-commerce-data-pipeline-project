{{ config(
  materialized='view',
  tags=['staging', 'locations']
) }}

SELECT
  CAST(region_id AS INT64) AS region_id,
  TRIM(sales_district) AS sales_district,
  TRIM(sales_region) AS sales_region,
  -- Data quality checks
  CASE
    WHEN region_id IS NULL THEN 'MISSING_REGION_ID'
    WHEN sales_region IS NULL THEN 'MISSING_SALES_REGION'
    ELSE 'VALID'
  END AS dq_flag
FROM `ecommerce-data-pipeline-465100`.`mavenmarket_raw`.`regions`