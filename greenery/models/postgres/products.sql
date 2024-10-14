{{
  config(
    materialized='table'
  )
}}

SELECT 
  product_id ,
  -- Name of the product
  name ,
  -- Price of the product
  price,
  -- Amount of the inventory we have for this product
  inventory 
FROM {{ source('snowflake', 'products') }}