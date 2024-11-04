{{ config(materialized='view') }}

WITH funnel_counts AS (
    SELECT
        COUNT(DISTINCT session_id) AS total_sessions,
        COUNT(DISTINCT CASE WHEN sessions_with_page_view IS NOT NULL THEN session_id END) AS page_view_sessions,
        COUNT(DISTINCT CASE WHEN sessions_with_add_to_cart IS NOT NULL THEN session_id END) AS add_to_cart_sessions,
        COUNT(DISTINCT CASE WHEN sessions_with_checkout IS NOT NULL THEN session_id END) AS checkout_sessions
    FROM
        {{ ref('product_funnel') }}
)

SELECT
    total_sessions,
    page_view_sessions,
    add_to_cart_sessions,
    checkout_sessions,
    (page_view_sessions - add_to_cart_sessions) / page_view_sessions::FLOAT AS drop_off_rate_add_to_cart,
    (add_to_cart_sessions - checkout_sessions) / add_to_cart_sessions::FLOAT AS drop_off_rate_checkout
FROM
    funnel_counts