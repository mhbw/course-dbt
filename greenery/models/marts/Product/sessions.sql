{{
  config(
    materialized='table'
  )
}}

with events as 
(select *
from {{ref('events')}}) ,

order_items as 
(select *
from {{ref('order_items')}}),

products as 
(select *
from {{ref('products')}})

select a.session_id
    , a.user_id
    , coalesce(a.product_id,b.product_id) as product_id
    , c.session_start_time_utc
    , c.session_end_time_utc
    , d.product_name
    , d.product_type
    , datediff('minute',c.session_start_time_utc,c.session_end_time_utc) as session_length_minutes
from events a
left join order_items b on a.order_id = b.order_id
left join {{ref('int_session_timing')}} c on a.session_id = c.session_id    
left join products d on coalesce(a.product_id,b.product_id) = d.product_id
group by 1,2,3,4,5,6,7