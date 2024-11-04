pt 1

what is our conversion rate overall? What is our conversion rate by product?

added three models, sessions, converted_sessions,  and int_session_timing to run this. then combined.

pt 2

I added a number of macros, star (mentioned in the tutorial, replicated here), event_type, and static_copy.

pt 3

I added

post_hook = 'grant select on {{ this }} to role REPORTING'

to a number of the original models, to add reporting to things like fact_average_sold since reporting might need those.

pt 4

I installed the package dbt_project_evaluator to help check my work.

pt 5/pt 6

dags/snapshots, not shown here. 

