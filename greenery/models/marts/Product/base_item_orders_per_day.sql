{{
  config(
    materialized='table'
  )
}}


SELECT 
DATE_TRUNC('day', created_at) as order_date, 
product_id, 
count(*) as sold_by_day 
FROM {{ source('snowflake', 'orders') }} orders
left join
{{ source('snowflake', 'order_items') }} order_items
on orders.order_id = order_items.order_id
group by 1, 2
order by 1
