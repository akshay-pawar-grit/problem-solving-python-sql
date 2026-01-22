-- Q.1 https://datalemur.com/questions/sql-top-three-salaries
"""
    EXPLANATION:
        - Just be mindful about the WINDOWS_FUNCTION, FILTERING CONDITION and ORDER BY!
"""
WITH top_three_salaries AS (
  SELECT
    name,
    salary,
    department_id,
    DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rnk
  FROM employee
)
SELECT
  dpt.department_name,
  tts.name,
  tts.salary
FROM top_three_salaries tts
INNER JOIN department dpt
ON tts.department_id = dpt.department_id
WHERE tts.rnk <=3
ORDER BY 1, 3 DESC, 2;


-- Q.2 https://datalemur.com/questions/time-spent-snaps
"""
    EXPLANATION:
        - This is interesting question, First, I filtered only the required activity_type then combined both activities and age_breakdown tables then it's all about CONDITIONAL GROUP BY SUM CASE type where you have to aggregate the results based on certain conditions!
"""
SELECT
  ab.age_bucket,
  ROUND((SUM(CASE WHEN activity_type = 'send' THEN a.time_spent END) / SUM(a.time_spent)) * 100.0, 2) AS send_perc,
  ROUND((SUM(CASE WHEN activity_type = 'open' THEN a.time_spent END) / SUM(a.time_spent)) * 100.0, 2) AS open_perc
FROM activities a
INNER JOIN age_breakdown ab
ON a.user_id = ab.user_id
WHERE a.activity_type IN ('open', 'send')
GROUP BY ab.age_bucket;


-- Q.3 https://datalemur.com/questions/sql-third-transaction
"""
    EXPLANATION:
        - Since, we don't care about DUPLICATES here
        - ROW_NUMBER() is used, we assign a RANK FOR EACH USER means PARTITION BY user
        - THIRD Transaction means ORDER BY transaction_date and FILTER THE RESULTS
"""
WITH third_transaction AS (
  SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rnk
  FROM transactions
)
SELECT
  user_id,
  spend,
  transaction_date
FROM third_transaction
WHERE rnk = 3;

-- Q.4 https://datalemur.com/questions/sql-second-highest-salary
"""
    EXPLANATION:
        - THE HOTTEST QUESTION OF THE INTERVIEWS, n-highest salary!
        - In this question, we are concerned about Duplicates so DENSE_RANK() comes into the picture, Since it's not department wise, we should not be using Partitioning
        - Just ORDER BY salary DESC as we SECOND HIGHEST and Filter the results!
"""
WITH second_highest AS (
  SELECT
    *,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS rnk
  FROM employee
)
SELECT
  salary AS second_highest_salary
FROM second_highest
WHERE rnk = 2
LIMIT 1;

-- Q.5 https://datalemur.com/questions/rolling-average-tweets
"""
    EXPLANATION:
        - It's very simple question, if you understand two fundamentals very clearly,
            a. You are clear about the ROLLING function, SUM(), AVG() OVER()
            b. You understand the WINDOW'S BOUNDING, N PRECEDING, CURRENT ROW AND N FOLLOWING
"""
SELECT
  user_id,
  tweet_date,
  ROUND(AVG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets;

-- Q.6 https://datalemur.com/questions/sql-highest-grossing
"""
    EXPLANATION:
        - This question is a variant of RANKING ANALYTICAL Questions but we have to make one aggregation before that makes it little lengthy!
"""
WITH highest_spend_products AS (
 SELECT
  category,
  product,
  SUM(spend) AS total_spend
 FROM product_spend
 WHERE EXTRACT(YEAR FROM transaction_date) = 2022
 GROUP BY category, product
),
top_two_products AS (
  SELECT
    *,
    ROW_NUMBER() OVER(PARTITION BY category ORDER BY total_spend DESC) AS rnk
  FROM highest_spend_products
)
SELECT
  category,
  product,
  total_spend
FROM top_two_products
WHERE rnk <= 2;