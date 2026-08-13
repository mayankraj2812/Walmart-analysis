
-- Walmart Sales Data Analysis

SHOW databases;
create database walmart_db; 
SHOW databases;
use walmart_db;
show tables;
Select count(*) from walmart;
Select * from walmart limit 5;
select * from walmart where profit_margin>0.4 limit 10;

SELECT 
	count(branch) from walmart WHERE branch IS NOT NULL;

-- BUSINESS PROBLEMS AND SOLUTIONS

--

select
	payment_method,
    count(*)
from walmart
group by payment_method;

SELECT COUNT(DISTINCT branch)
from walmart;


-- 1. Analyze Payment Methods and Sales

SELECT 
    payment_method,
    COUNT(*) AS no_payments,
    SUM(quantity) AS no_of_qnty
FROM
    walmart
GROUP BY payment_method;

-- 2. Identify the Highest-Rated Category in Each Branch


SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rankk
    FROM walmart
    GROUP BY branch, category
) AS ranked
WHERE rankk = 1;


-- Q3: Identify the busiest day for each branch based on the number of transactions

SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
        COUNT(*) AS num_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rankk
    FROM walmart
    GROUP BY branch, day_name
) AS ranked
WHERE rankk = 1;


-- Q4: Calculate the total quantity of items sold per payment method
SELECT 
    payment_method,
    SUM(quantity) AS no_qty_sold
FROM walmart
GROUP BY payment_method;


SELECT 
    *
FROM
    walmart
LIMIT 5;


-- Q5: Determine the average, minimum, and maximum rating of categories for each city

SELECT city,
		MAX(rating) AS max_rat,
        MIN(rating) AS min_rat,
        AVG(rating) AS avg_rat
FROM walmart
GROUP BY city,category;


-- Q6: Calculate the total profit for each category

SELECT category,
	 SUM( (unit_price)*(quantity)*(profit_margin)) AS total_profits
FROM walmart
GROUP BY category
ORDER BY total_profits DESC;



-- Q7: Determine the most common payment method for each branch
WITH cte AS(

SELECT branch,
		payment_method,
        RANK()OVER( PARTITION BY branch ORDER BY COUNT(*) DESC) AS rankk
FROM walmart
GROUP BY branch, payment_method
)
SELECT branch as place,payment_method
FROM cte
WHERE rankk=1;

-- Q8: Categorize sales into Morning, Afternoon, and Evening shifts

SELECT branch,
		CASE
        WHEN HOUR(TIME(time)) < 12 THEN "MORNIG"
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN "AFTERNOON"
        WHEN HOUR(TIME(TIME))>17 THEN "EVENING"
        END AS shift,
        COUNT(*) AS num_invoices        
FROM walmart
GROUP BY branch,shift
ORDER BY branch,num_invoices DESC;

-- 9: Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)

WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM( unit_price*quantity) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM( unit_price*quantity) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;





      


        








