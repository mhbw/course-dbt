{{
  config(
    materialized='table'
  )
}}

SELECT 
  -- OrderId of this order
  product_id ,
  -- total ordered
  sum(quantity) as total_ordered
FROM {{ source('snowflake', 'order_items') }}
group by 1
order by 2 desc

