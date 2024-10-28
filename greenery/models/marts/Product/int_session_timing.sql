{{
  config(
    materialized='table'
    , post_hook = 'grant select on {{ this }} to role REPORTING'
  )
}}

select session_guid
    , min(created_at_utc) as session_start_time_utc
    , max(created_at_utc) as session_end_time_utc
from {{ref('events')}}
group by 1