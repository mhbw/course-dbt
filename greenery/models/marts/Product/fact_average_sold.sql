{{
  config(
    materialized='table'
    , post_hook = 'grant select on {{ this }} to role REPORTING'
  )
}}



SELECT
    name, 
   sum(sold_by_day) / count(order_date) as average_sold_per_day
FROM {{ ref('int_order_names') }} 
group by 1