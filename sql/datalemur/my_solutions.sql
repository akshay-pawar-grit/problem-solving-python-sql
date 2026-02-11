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

-- Q.6 https://datalemur.com/questions/signup-confirmation-rate
"""
  EXPLANATION:
    - We have two tables here, emails and texts, since we have to find the activation rate, we must have to use the LEFT join on emails table to get the overall idea about the total records but for texts, we can apply the early filtering to get only the confirmed signup_records
    -  Next step, is to join the tables, I am using LEFT join to get all the records and not the matching ones
    - Then, I used SUM CASE to count the confirmed records and got the ratio
"""
WITH confirmed AS (
  SELECT
    email_id,
    signup_action
  FROM texts
  WHERE signup_action = 'Confirmed'
)
SELECT
  ROUND(SUM(CASE WHEN c.signup_action = 'Confirmed' THEN 1 ELSE 0 END)::NUMERIC / COUNT(e.email_id), 2) AS activation_rate
FROM emails e 
LEFT JOIN confirmed c 
ON e.email_id = c.email_id;

-- Q.7 https://datalemur.com/questions/spotify-streaming-history
"""
  EXPLANATION:
    - The thought process is simple, we have songs_history table which has historical data and songs_weekly which has current week records, let's first filter the records upto 4th August 2022 and aggregate the count based on user and song
    - Union the current week records with the historical data to get the combined user_id and song_id combo and then aggregate based on user_id and song_id to get the required answer
"""
WITH songs_weekly_agg AS (
  SELECT
    user_id,
    song_id,
    COUNT(song_id) AS song_plays
  FROM songs_weekly
  WHERE listen_time <= '08/04/2022 23:59:59'
  GROUP BY user_id, song_id
), combined AS (
  SELECT
    user_id,
    song_id,
    song_plays
  FROM songs_weekly_agg
  UNION ALL
  SELECT
    user_id,
    song_id,
    song_plays
  FROM songs_history
)
SELECT
  user_id,
  song_id,
  SUM(song_plays) AS song_count
FROM combined
GROUP BY user_id, song_id
ORDER BY 3 DESC;

-- Q.8 https://datalemur.com/questions/supercloud-customer
"""
  EXPLANATION:
    - Join customer_contracts table with products to get the complete data
    - Filter the records on product_category to have only the required categories
    - Aggregate the records and apply HAVING CLAUSE on DISTINCT product_category of each customer should be equal to the DISTINCT count of each product_category
"""
SELECT
  cc.customer_id
FROM customer_contracts cc
INNER JOIN products prd
ON cc.product_id = prd.product_id
WHERE prd.product_category IN ('Analytics', 'Containers', 'Compute')
GROUP BY cc.customer_id
HAVING(COUNT( DISTINCT prd.product_category)) = (SELECT COUNT(DISTINCT product_category) FROM products);

-- Q.9 https://datalemur.com/questions/odd-even-measurements
"""
  EXPLANATION:
    - First thing to focus on is to get the DATE from TIMESTAMP measurement_time column
    - We need ODD and Even Numbers so we must assign the rank to each record
    - Used ROW_NUMBER() to assign that PARTITION BY Date to match the quetstion's requirements
    - For Ranking Questions, we filter the ranks but in this case we need to use that rnk column to determine which category the record belongs to
    - Used conditional summing using CASE SUM and got the results!
"""
WITH ranked AS ( 
  SELECT
  CAST(measurement_time AS DATE) AS measurement_day,
  measurement_value,
  ROW_NUMBER() OVER(PARTITION BY CAST(measurement_time AS DATE) ORDER BY measurement_time) AS rnk
FROM measurements
)

SELECT
  measurement_day,
  SUM(CASE WHEN rnk % 2 = 1 THEN measurement_value END) AS odd_sum,
  SUM(CASE WHEN rnk % 2 = 0 THEN measurement_value END) AS even_sum
FROM ranked
GROUP BY 1
ORDER BY 1;

-- Q.10 https://datalemur.com/questions/sql-swapped-food-delivery
"""
  EXPLANATION:
    - Very Tasty Question hehe
    - Simple Question, We just need to swap the order_id of odd to even and even to odd with the only condition of the last record if odd, don't do anything
    - How to achieve it, Use CASE WHEN, if odd make it even by adding +1 and -1 for vice versa
"""
WITH corrected AS (
  SELECT 
    *,
    CASE WHEN order_id % 2 = 1 AND order_id = (SELECT MAX(order_id) FROM orders) THEN order_id
      WHEN order_id % 2 = 1 THEN order_id + 1
      WHEN order_id % 2 = 0 THEN order_id - 1
    END AS corrected_order_id
  FROM orders 
)
SELECT
  corrected_order_id,
  item
FROM corrected
ORDER BY corrected_order_id;

-- Q.11 https://datalemur.com/questions/sql-bloomberg-stock-min-max-1
"""
  EXPLANATION:
  - ranked the results based on the highest and lowest value, how to get both? Simple, Use this trick of using ROW_NUMBER() OVER(ORDER BY col_name) to get the lowest value and ROW_NUMBER() OVER(ORDER BY same_col_name DESC) to get the highest value
  - Filtered the records which are having value 1
  - Performed Self Join to get what is being asked in the question, key thing, see the join condition, ON f1.ticker = f2.ticker AND f1.open < f2.open
"""
WITH ranked AS (
SELECT
  to_char(date, 'Mon-YYYY') AS mth,
  ticker,
  open,
  ROW_NUMBER() OVER(PARTITION BY ticker ORDER BY open) AS l_rn,
  ROW_NUMBER() OVER(PARTITION BY ticker ORDER BY open DESC) AS h_rn
FROM stock_prices
),
filtered AS (
SELECT
  mth,
  ticker,
  open
FROM ranked
WHERE l_rn = 1 OR h_rn = 1
)
SELECT
  f1.ticker,
  f2.mth AS highest_mth,
  f2.open AS highest_open,
  f1.mth AS lowest_mth,
  f1.open AS lowest_open
FROM filtered f1
INNER JOIN filtered f2
ON f1.ticker = f2.ticker AND f1.open < f2.open
ORDER BY ticker;

-- Q.12 https://datalemur.com/questions/amazon-shopping-spree
"""
  EXPLANATION:
    - Ranked the customers to find how many transactions are made by each one
    - Filtered the user_id with rank greater than equal to 3
"""
WITH ranked AS (
  SELECT 
    user_id,
    ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rnk
  FROM transactions
)
SELECT
  DISTINCT user_id
FROM ranked
WHERE rnk >=3;

-- Q.13 https://datalemur.com/questions/histogram-users-purchases
"""
  EXPLANATION:
  - Found the recent transaction_date but used DENSE_RANK as we need multiple records for the same user
  - Next was just a simple aggregation with date and user_id!
"""

WITH latest_transaction AS (
  SELECT
    transaction_date,
    user_id,
    DENSE_RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS rnk
  FROM user_transactions
)
SELECT
  transaction_date,
  user_id,
  COUNT(user_id) AS purchase_count
FROM latest_transaction 
WHERE rnk = 1
GROUP BY transaction_date, user_id;

-- Q.14 https://datalemur.com/questions/uncategorized-calls-percentage
"""
  EXPLANATION:
    - Basic CONDITIONAL SUM question, Used CASE WHEN SUM to find the NA or NULLs
"""
SELECT
  ROUND((SUM(CASE WHEN call_category = 'n/a' OR call_category IS NULL THEN 1 ELSE 0 END)::NUMERIC /
   COUNT(*)) * 100,1) AS uncategorised_call_pct
FROM 
  callers;

-- Q.15 https://datalemur.com/questions/international-call-percentage
"""
  EXPLANATION:
     - This is interesting one, My thought process was if we have to know the international call, first we need to bring them to one column
     - So I joined phone_calls table with phone_info on caller_id
     - Next, I joined this combined table again with phone_info on receiver_id
     - Then, it was a simple SUM CASE WHEN to filter the countries which are not same
"""
WITH caller_combined AS (
  SELECT
    pc.caller_id,
    pc.receiver_id,
    pi.country_id
  FROM phone_calls pc
  LEFT JOIN phone_info pi
  ON pc.caller_id = pi.caller_id
)
SELECT
  ROUND(SUM(CASE WHEN cc.country_id <> pi.country_id THEN 1 ELSE 0 END)::NUMERIC /
          (SELECT COUNT(caller_id) FROM phone_calls) * 100.0,1) AS international_calls_pct
FROM caller_combined cc
LEFT JOIN phone_info pi
ON cc.receiver_id = pi.caller_id;

-- Q.16 https://datalemur.com/questions/card-launch-success
"""
  EXPLANATION:
    - The question is very simple if you understand how windows function works
    - Used ROW_NUMBER() PARTITION BY card_name and ORDER BY year, month as we need the latest card
"""
WITH ordered AS (
  SELECT
    card_name,
    issued_amount,
    ROW_NUMBER() OVER(PARTITION BY card_name ORDER BY issue_year,issue_month) AS rnk
  FROM monthly_cards_issued
)

SELECT
  card_name,
  issued_amount
FROM ordered
WHERE rnk=1
ORDER BY issued_amount DESC;

-- Q.17 https://datalemur.com/questions/alibaba-compressed-mode
"""
  EXPLANATION:
    - Probably the easiest medium question
    - As like AI hallucinate, I hallucinate with simple questions which are categorised as medium, Overthinked and realised its just a simple filtering question LOL
"""
SELECT 
  item_count AS mode
FROM items_per_order
WHERE order_occurrences = (SELECT MAX(order_occurrences) FROM items_per_order);

-- Q.18 https://datalemur.com/questions/user-retention
"""
  EXPLANATION:
    -  I first filtered the records only for July 2022 but I saw there are multiple records so I chose the MIN event_time which I will explain further why
    - My idea was that if I get the july_users and I combined that with the user_actions on user_id and event_date should be of the 1 month interval to get the June Records which is the actual ask of the question
    - But, one problem I faced that I am using SELF JOIN so the records of the JULY month itself were getting joined, resulting into the incorrect count so I used MIN(event_date) to filter that records 
"""
WITH july_users AS (
  SELECT 
    user_id,
    MIN(event_date) AS july_event_date
  FROM user_actions
  WHERE EXTRACT(YEAR FROM event_date) = 2022 AND EXTRACT(MONTH FROM event_date) = 7
  GROUP BY user_id
)

SELECT 
    EXTRACT(MONTH FROM ju.july_event_date) AS month,
    COUNT(DISTINCT ju.user_id) AS monthly_active_users
FROM july_users ju
JOIN user_actions ua
ON ua.user_id = ju.user_id AND 
  ua.event_date <  ju.july_event_date AND
  ua.event_date >= ju.july_event_date - INTERVAL '1 month'
GROUP BY 1;

-- Q.19
"""
  EXPLANATION:
    - The last question was Monthly Active Users, this is another Growth Accounting Question, YoY
    - Used the LAG function to compare the previous spend
    - Rest is the simple calculations
    - This is not HARD Level Question for sure!
"""
SELECT 
  EXTRACT(YEAR FROM transaction_date) AS year,
  product_id,
  spend AS curr_year_spend,
  LAG(spend, 1) OVER ( PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date)) AS prev_year_spend,
  ROUND(((spend - LAG(spend, 1) OVER ( PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date))) 
   / LAG(spend, 1) OVER ( PARTITION BY product_id ORDER BY EXTRACT(YEAR FROM transaction_date))) * 100,2) AS yoy_rate
FROM user_transactions;

-- Q.20 https://datalemur.com/questions/prime-warehouse-storage
"""
  EXPLANATION:
     - Took me a lot of time to just go through the question as it's long and confusing
     - But after staring at it for 30 mins like that's the only partner I have in this Valentine's week, I realised the ask is simple, count the total prime_area, count the total prime_area items, count the total non_prime_area and non_prime items
     - Since, the priority is to be given to the prime items, I calculated the max_area for prime items and see how many prime items can fit in
     - Once that is done, it's all about the remaining area and how many non prime items can be accommodated
"""
WITH aggregated AS (
SELECT
  SUM(CASE WHEN item_type = 'prime_eligible' THEN square_footage END) AS prime_sum,
  SUM(CASE WHEN item_type = 'not_prime' THEN square_footage END) AS not_prime_sum,
  SUM(CASE WHEN item_type = 'prime_eligible' THEN 1 ELSE 0 END) AS prime_cnt,
  SUM(CASE WHEN item_type = 'not_prime' THEN 1 ELSE 0 END) AS not_prime_cnt
FROM inventory
),

prime_area AS (
  SELECT
    FLOOR(500000/prime_sum) * prime_sum as prime_max_area
  FROM aggregated
)

SELECT
  'prime_eligible' AS item_type,
  FLOOR(500000/prime_sum) * prime_cnt AS item_count
FROM aggregated

UNION ALL

SELECT 
  'not_prime' AS item_type,
  FLOOR((500000 - (SELECT prime_max_area FROM prime_area)) / not_prime_sum) * not_prime_cnt
FROM aggregated;

-- Q.21 https://datalemur.com/questions/updated-status
"""
  EXPLANATION:
    - Well, this is categorised as HARD but I believe this is pretty easy question
    - This concept I learnt from Zach while learning the GROWTH ACCOUNTING PATTERN
    - The concept is simple, Check the previous and the current_state based on the metric, for this question, it was payment, in bootcamp, it was the number of users who are active
    - So, the main thing here is, you apply CASE WHEN rules based on the state, this was provided in the question so was very easy
    - But the main catch is you need to use FULL OUTER JOIN as there would be a data in the right table which would be a new user/new record
    - Used the COALESCE to determine whether the record is from the left or right side of the table
    - COALESCE WITH CASE WHEN was new but the idea is simple if the left table IS NULL, it indicates it's a new RECORD
"""
SELECT
    COALESCE(a.user_id,dp.user_id),
    COALESCE(CASE WHEN a.status = 'NEW' AND dp.paid IS NOT NULL THEN 'EXISTING'
      WHEN a.status = 'NEW' AND dp.paid IS NULL THEN 'CHURN'
      WHEN a.status = 'EXISTING' AND dp.paid IS NOT NULL THEN 'EXISTING'
      WHEN a.status = 'EXISTING' AND dp.paid IS NULL THEN 'CHURN'
      WHEN a.status = 'CHURN' AND dp.paid IS NOT NULL THEN 'RESURRECT'
      WHEN a.status = 'CHURN' AND dp.paid IS NULL THEN 'CHURN'
      WHEN a.status = 'RESURRECT' AND dp.paid IS NOT NULL THEN 'EXISTING'
      WHEN a.status = 'RESURRECT' AND dp.paid IS NULL THEN 'CHURN'
    END, 'NEW') AS new_status
  FROM advertiser a 
  FULL OUTER JOIN daily_pay dp 
  ON a.user_id = dp.user_id
ORDER BY 1;