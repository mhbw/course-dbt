{{
  config(
    materialized='table'
    , post_hook = 'grant select on {{ this }} to role REPORTING'
  )
}}

SELECT
  order_date , 
  per_day.product_id , 
  sold_by_day , 
  name  
FROM {{ ref('base_item_orders_per_day') }} per_day
left join
{{ source('snowflake', 'products') }} order_items
on per_day.product_id = order_items.product_id