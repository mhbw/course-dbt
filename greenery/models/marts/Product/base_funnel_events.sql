{{ config(materialized='view') }}

SELECT
    user_id,
    session_id,
    event_type,
    created_at
FROM
    {{ source('snowflake', 'events') }}
WHERE
    event_type IN ('page_view', 'add_to_cart', 'checkout')