How many users do we have?

`select count(distinct user_id) from dev_db.dbt_michaelhbwoodgmailcom.users ;`

130 

On average, how many orders do we receive per hour?
`
select ROUND(AVG(number_hour))
from (
SELECT DATE_TRUNC('hour', created_at), count(*) as number_hour
from dev_db.dbt_michaelhbwoodgmailcom.orders
group by 1) sub
;
`

8 

On average, how long does an order take from being placed to being delivered?
`
select ROUND(AVG(DATEDIFF(day, created_at, delivered_at)))
from dev_db.dbt_michaelhbwoodgmailcom.orders;
`

4

How many users have only made one purchase? Two purchases? Three+ purchases?
`
WITH user_orders AS (
  SELECT
    u.user_id AS user,
    COUNT(orders.order_id) AS num_orders
  FROM
    dev_db.dbt_michaelhbwoodgmailcom.users AS u
    LEFT JOIN dev_db.dbt_michaelhbwoodgmailcom.orders AS orders ON u.user_id = orders.user
  GROUP BY
    1
)
SELECT
  COUNT(*) AS num_users,
  CASE
    WHEN num_orders = 1 THEN 'One purchase'
    WHEN num_orders = 2 THEN 'Two purchases'
    ELSE 'Three or more purchases'
  END AS purchase_category
FROM
  user_orders
GROUP BY
  purchase_category;
`

77	Three or more purchases
25	One purchase
28	Two purchases
  
On average, how many unique sessions do we have per hour? **/
`select round(AVG(num_sessions))
FROM (
SELECT
  DATE_PART (HOUR, created_at) AS hour,
  COUNT(DISTINCT session_id) AS num_sessions
FROM
  dev_db.dbt_michaelhbwoodgmailcom.events
GROUP BY
  hour) sub;
`
  39
