Part 1. dbt Snapshots
Which products had their inventory change from week 3 to week 4?

Answer:

```sql
SELECT DISTINCT name
FROM dev_db.dbt_michaelhbwoodgmailcom.product_inventory_snapshot
WHERE DATE(dbt_updated_at) = '2024-10-29'
   OR DATE(dbt_valid_to) = '2024-10-29';
```
| Name             |
|------------------|
| Philodendron     |
| Bamboo           |
| String of pearls |
| Pothos           |
| Monstera         |
| ZZ Plant         |


Now that we have 3 weeks of snapshot data, can you use the inventory changes to determine which products had the most fluctuations in inventory? Did we have any items go out of stock in the last 3 weeks? 

```sql
-- Find products with inventory changes in the past weeks

WITH inventory_not_valid AS (
    SELECT product_id, name, price, inventory, dbt_updated_at, dbt_valid_from, dbt_valid_to
    FROM dev_db.dbt_michaelhbwoodgmailcom.product_inventory_snapshot
    WHERE dbt_valid_to IS NOT NULL
    ORDER BY product_id
),

current_inventory AS (
    SELECT ic.product_id, s.name, s.price, s.inventory, s.dbt_updated_at, s.dbt_valid_from, s.dbt_valid_to
    FROM inventory_not_valid ic
    JOIN dev_db.dbt_michaelhbwoodgmailcom.product_inventory_snapshot s ON s.product_id = ic.product_id
    WHERE s.dbt_valid_to IS NULL
),

all_inventory_changes AS (
    SELECT * FROM inventory_not_valid
    UNION DISTINCT
    SELECT * FROM current_inventory
    ORDER BY product_id, dbt_valid_from DESC
),

inventory_changes_per_week AS (
    SELECT product_id, name, price,
        CASE WHEN DATE(dbt_valid_from) = '2024-10-10' AND (DATE(dbt_valid_to) <= '2024-10-29' OR dbt_valid_to IS NULL) THEN inventory END AS inventory_week1,
        CASE WHEN DATE(dbt_valid_from) = '2024-10-16' AND (DATE(dbt_valid_to) <= '2024-10-29' OR dbt_valid_to IS NULL)
                 OR DATE(dbt_valid_from) = '2024-10-10' AND (DATE(dbt_valid_to) > '2024-10-16' AND (DATE(dbt_valid_to) <= '2024-10-29' OR dbt_valid_to IS NULL)) 
             THEN inventory END AS inventory_week2,
        CASE WHEN DATE(dbt_valid_from) = '2024-10-22' AND (DATE(dbt_valid_to) <= '2024-10-29' OR dbt_valid_to IS NULL)
                 OR DATE(dbt_valid_from) IN ('2024-10-10', '2024-10-16') AND (DATE(dbt_valid_to) > '2024-10-22' AND (DATE(dbt_valid_to) <= '2024-10-29' OR dbt_valid_to IS NULL)) 
             THEN inventory END AS inventory_week3,
        CASE WHEN DATE(dbt_valid_from) = '2024-10-29' AND dbt_valid_to IS NULL
                 OR DATE(dbt_valid_from) IN ('2024-10-10', '2024-10-16', '2024-10-22') AND (DATE(dbt_valid_to) > '2024-10-29' OR dbt_valid_to IS NULL) 
             THEN inventory END AS inventory_week4
    FROM all_inventory_changes
)

SELECT product_id, name, price,
       SUM(inventory_week1) AS inventory_week1,
       SUM(inventory_week2) AS inventory_week2,
       SUM(inventory_week3) AS inventory_week3,
       SUM(inventory_week4) AS inventory_week4
FROM inventory_changes_per_week
GROUP BY product_id, name, price
ORDER BY product_id;
```

Pothos and String of Pearls went out of stock, large fluctuations : Philodendron, String of Pearls

| PRODUCT_ID                             | NAME             | PRICE | INVENTORY_WEEK1 | INVENTORY_WEEK2 | INVENTORY_WEEK3 | INVENTORY_WEEK4 |
|----------------------------------------|------------------|-------|-----------------|-----------------|-----------------|-----------------|
| 4cda01b9-62e2-46c5-830f-b7f262a58fb1   | Pothos           | 30.5  | 40              | 20              | 0               | 20              |
| 55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3   | Philodendron     | 45    | 51              | 25              | 15              | 30              |
| 689fb64e-a4a2-45c5-b9f2-480c2155624d   | Bamboo           | 15.25 | 56              | 56              | 44              | 23              |
| b66a7143-c18a-43bb-b5dc-06bb5d1d3160   | ZZ Plant         | 25    | 89              | 89              | 53              | 41              |
| be49171b-9f72-4fc9-bf7a-9a52e259836b   | Monstera         | 50.75 | 77              | 64              | 50              | 31              |
| fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80   | String of Pearls | 80.5  | 58              | 10              | 0               | 10              |


Part 2. Modeling challenge

I made the models ```base_funnel_events.sql, product_funnel.sql and funnel_analysis.sql```  from querying that I got: 

| Metric                   | Count    |
|--------------------------|----------|
| Total Sessions           | 578      |
| Page View Sessions       | 578      |
| Add to Cart Sessions     | 467      |
| Checkout Sessions        | 361      |
| Drop-Off Rate (Add to Cart) | 19.2%  |
| Drop-Off Rate (Checkout) | 22.7%    |

Part 3: Reflection questions -- please answer 3A or 3B, or both!

3A. dbt next steps for you 
Reflecting on your learning in this class...

one of my 'fun' work projects is to build a new dbt instance around our bq data, to show other parts of the team how it could work. I think I am framing it around the ease of cleaning transforming raw data from say, a sheet that's been turned into a data source, into an usable dashboard. 

I think the thing I've most picked up is how much more refined each step is in analytics engineering: I want to hammer together 30569 things in one block but this thinking around the dag as each step being separate is interesting. and probably easier to isolate when things fail and find the issue. 


3B. Setting up for production / scheduled dbt run of your project And finally, before you fly free into the dbt night, we will take a step back and reflect: after learning about the various options for dbt deployment and seeing your final dbt project, how would you go about setting up a production/scheduled dbt run of your project in an ideal state? You don’t have to actually set anything up - just jot down what you would do and why and post in a README file.

Hints: what steps would you have? Which orchestration tool(s) would you be interested in using? What schedule would you run your project on? Which metadata would you be interested in using? How/why would you use the specific metadata? , etc.

one of my goals is to start using Prefect, so I'd use that. I'm really not sure about the metadata leg. 
