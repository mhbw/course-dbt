This week for the project I thought it would be interesting to create a stream that showed average sales per item by day. I choose that because knowing what the best average sales are is always interesting, and I thought it worked well with the idea of having to make a base, int, and fact table.

for the base I had to first compile the items order by day, int I had to then bring in the proper names, then finally create an average and publish a fact. as you can see in the DAG it follows the best practice of being very linear, minimal joins, and steps per stage. 

In my tests I went for a simple check to make sure that there were no nulls and everything was unique.

thanks for reviewing!
