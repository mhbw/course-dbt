{{ config(materialized='view') }}

WITH page_views AS (
    SELECT
        session_id,
        COUNT(DISTINCT user_id) AS sessions_with_page_view
    FROM
        {{ ref('base_funnel_events') }}
    WHERE
        event_type = 'page_view'
    GROUP BY
        session_id
),

add_to_cart AS (
    SELECT
        session_id,
        COUNT(DISTINCT user_id) AS sessions_with_add_to_cart
    FROM
        {{ ref('base_funnel_events') }}
    WHERE
        event_type = 'add_to_cart'
    GROUP BY
        session_id
),

checkout AS (
    SELECT
        session_id,
        COUNT(DISTINCT user_id) AS sessions_with_checkout
    FROM
        {{ ref('base_funnel_events') }}
    WHERE
        event_type = 'checkout'
    GROUP BY
        session_id
)

SELECT
    COALESCE(pv.session_id, ac.session_id, co.session_id) AS session_id,
    pv.sessions_with_page_view,
    ac.sessions_with_add_to_cart,
    co.sessions_with_checkout
FROM
    page_views pv
    FULL OUTER JOIN add_to_cart ac ON pv.session_id = ac.session_id
    FULL OUTER JOIN checkout co ON pv.session_id = co.session_id