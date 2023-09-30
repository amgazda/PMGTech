--Question 1
SELECT mp.date, SUM(mp.impressions)
FROM marketing_performance mp
GROUP BY mp.date;

--Question 2 top three
SELECT wr.state, SUM(wr.revenue)
FROM website_revenue wr
GROUP BY wr.state
ORDER BY SUM(wr.revenue) DESC
LIMIT 3;

--Question 2 third only
SELECT wr.state, SUM(wr.revenue)
FROM website_revenue wr
GROUP BY wr.state
ORDER BY SUM(wr.revenue) DESC
LIMIT 1 offset 2;

--Question 3
SELECT ci.name, mpc, mpi, mpcl, wrr
FROM campaign_info ci, (
SELECT mp.campaign_id as mpid, SUM(mp.cost) as mpc, SUM(mp.impressions) as mpi, SUM(mp.clicks) as mpcl
FROM marketing_performance mp
GROUP BY mpid
)
JOIN (
SELECT wr.campaign_id as wrid, SUM(wr.revenue) as wrr
FROM website_revenue wr
GROUP BY wrid
)
ON mpid=wrid
WHERE ci.id=mpid;

--Question 4 full rankings
SELECT TRIM(mp.geo, 'United States-') as st, SUM(mp.conversions) as ms
FROM marketing_performance mp, campaign_info ci
WHERE ci.id=mp.campaign_id and ci.name='Campaign5'
GROUP BY st
ORDER BY ms DESC;

--Question 4 top only
SELECT TRIM(mp.geo, 'United States-') as st, SUM(mp.conversions) as ms
FROM marketing_performance mp, campaign_info ci
WHERE ci.id=mp.campaign_id and ci.name='Campaign5'
GROUP BY st
ORDER BY ms DESC
LIMIT 1;

--Question 5
/*
I created a modified version of Query 3 where I added conversions and divided all of the metrics by the cost of the marketing, and I decided Campaign 4 was the most efficient. It had the highest impressions per cost, the second highest clicks per cost, the highest conversions per cost, and the second highest revenue per cost. I think the fact that Campaign 4 was in the top 2 in every metric when factoring in cost makes it the most efficient.
*/

--Bonus Question
SELECT case cast(day as integer)
when 1 then 'Monday'
when 2 then 'Tuesday'
when 3 then 'Wednesday'
when 4 then 'Thursday'
when 5 then 'Friday'
when 6 then 'Saturday'
else 'Sunday' end as dow
FROM (
SELECT STRFTIME('%w', TRIM(mp.date,'00:00:00')) as day, SUM(mp.conversions) as s
FROM marketing_performance mp
GROUP BY day
ORDER BY s DESC
LIMIT 1);