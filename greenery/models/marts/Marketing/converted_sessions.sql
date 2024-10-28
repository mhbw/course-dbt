{{
  config(
    materialized='table'
  )
}}

select distinct session_id
from {{ref('events')}}
where event_type = 'checkout'