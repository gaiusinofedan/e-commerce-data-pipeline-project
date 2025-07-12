{{ config(
  materialized='table',
  tags=['staging', 'utility']
) }}

SELECT
  date,
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(QUARTER FROM date) AS quarter,
  FORMAT_DATE('%B', date) AS month_name,
  EXTRACT(DAY FROM date) AS day_of_month,
  FORMAT_DATE('%A', date) AS day_of_week,
  CASE WHEN EXTRACT(DAYOFWEEK FROM date) IN (1,7) THEN TRUE ELSE FALSE END AS is_weekend
FROM UNNEST(
  GENERATE_DATE_ARRAY(
    LEAST(
      (SELECT MIN(transaction_date) FROM {{ ref('stg_transactions') }}),
      (SELECT MIN(return_date) FROM {{ ref('stg_returns') }}),
      (SELECT MIN(opened_date) FROM {{ ref('stg_stores') }}),
      (SELECT MIN(last_remodel_date) FROM {{ ref('stg_stores') }})
    ),
    GREATEST(
      (SELECT MAX(transaction_date) FROM {{ ref('stg_transactions') }}),
      (SELECT MAX(return_date) FROM {{ ref('stg_returns') }}),
      (SELECT MAX(opened_date) FROM {{ ref('stg_stores') }}),
      (SELECT MAX(last_remodel_date) FROM {{ ref('stg_stores') }})
    )
  )
) AS date
