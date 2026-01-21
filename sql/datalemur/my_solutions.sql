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