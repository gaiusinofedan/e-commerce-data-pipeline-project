{{
  config(
    materialized='view',
    tags=['staging', 'pii']
  )
}}

SELECT
  CAST(customer_id AS INT64) AS customer_id,
  CAST(customer_acct_num AS INT64) AS customer_acct_num,
  TRIM(first_name) AS first_name,
  TRIM(last_name) AS last_name,
  TRIM(customer_address) AS address,
  TRIM(customer_city) AS city,
  TRIM(customer_state_province) AS state,
  CAST(customer_postal_code AS STRING) AS postal_code,
  TRIM(customer_country) AS country,
  birthdate,
  TRIM(marital_status) AS marital_status,
  -- Income cleaning (handles $50K format)
  CASE
    WHEN yearly_income LIKE '%K%' THEN CAST(REGEXP_REPLACE(yearly_income, r'[^0-9.]', '') AS FLOAT64) * 1000
    ELSE CAST(yearly_income AS FLOAT64)
  END AS yearly_income,
  TRIM(gender) AS gender,
  CAST(total_children AS INT64) AS total_children,
  CAST(num_children_at_home AS INT64) AS num_children_at_home,
  TRIM(education) AS education_level,
  acct_open_date,
  TRIM(member_card) AS member_card_type,
  TRIM(occupation) AS occupation,
  CAST(homeowner AS BOOL) AS is_homeowner,
  -- Data quality
  CASE
    WHEN customer_id IS NULL THEN 'MISSING_ID'
    WHEN birthdate > CURRENT_DATE() THEN 'INVALID_BIRTHDATE'
    ELSE 'VALID'
  END AS dq_flag
FROM `ecommerce-data-pipeline-465100`.`mavenmarket_raw`.`customers`