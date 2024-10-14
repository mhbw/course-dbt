{{
  config(
    materialized='table'
  )
}}

SELECT 
  -- OrderId of this order
  order_id ,
  -- ProductId of a single item in this order
  product_id,
  -- Number of units of the product in this order
  quantity 
FROM {{ source('snowflake', 'order_items') }}