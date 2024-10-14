{{
  config(
    materialized='table'
  )
}}

SELECT 
  -- Each unique promocode on platform
  promo_id ,
  -- Absolute dollar amount that is given off with the code
  discount ,
  -- Is the promo code active or disabled
  status 
FROM {{ source('snowflake', 'promos') }}