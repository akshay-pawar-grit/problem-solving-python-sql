# Problem Solving - Python & SQL

A personal repository documenting my daily problem-solving journey for technical interview preparation. This repo contains solutions with detailed explanations for popular coding and SQL challenges.

## Repository Structure

```
problem-solving-python-sql/
├── python/
│   └── leetcode-top-interview-150/
│       └── my_solutions.py          # Python solutions with explanations
├── sql/
│   └── datalemur/
│       ├── my_solutions.sql         # SQL solutions with explanations
│       └── sample_data.py           # Test data setup for local testing
└── README.md
```

## Contents

### Python - LeetCode Top Interview 150

Solutions to problems from [LeetCode's Top Interview 150](https://leetcode.com/studyplan/top-interview-150/) collection. Each solution includes:
- Problem explanation
- Thought process and approach
- Edge cases considered

**Current Problems:**
| # | Problem | Difficulty |
|---|---------|------------|
| 1 | H-Index | Medium |
| 2 | Product of Array Except Self | Medium |

### SQL - DataLemur

Solutions to SQL problems from [DataLemur](https://datalemur.com/). Each query includes explanations covering:
- Query breakdown
- Key SQL concepts used (window functions, CTEs, aggregations)
- Edge cases

**Current Problems:**
| # | Problem | Key Concepts |
|---|---------|--------------|
| 1 | [Top Three Salaries](https://datalemur.com/questions/sql-top-three-salaries) | DENSE_RANK, Window Functions, CTEs |
| 2 | [Time Spent on Snaps](https://datalemur.com/questions/time-spent-snaps) | Conditional Aggregation, CASE, JOINs |
| 3 | [Third Transaction](https://datalemur.com/questions/sql-third-transaction) | ROW_NUMBER, Window Functions, CTEs |
| 4 | [Second Highest Salary](https://datalemur.com/questions/sql-second-highest-salary) | DENSE_RANK, Window Functions, CTEs |
| 5 | [Rolling Average Tweets](https://datalemur.com/questions/rolling-average-tweets) | Window Functions, ROWS BETWEEN, Rolling Aggregates |
| 6 | [Highest Grossing](https://datalemur.com/questions/sql-highest-grossing) | ROW_NUMBER, Window Functions, CTEs, Aggregation |
| 7 | [Signup Confirmation Rate](https://datalemur.com/questions/signup-confirmation-rate) | LEFT JOIN, Conditional Aggregation, CTEs |
| 8 | [Spotify Streaming History](https://datalemur.com/questions/spotify-streaming-history) | UNION ALL, CTEs, Aggregation, Date Filtering |
| 9 | [Supercloud Customer](https://datalemur.com/questions/supercloud-customer) | JOIN, GROUP BY, HAVING, Subqueries |
| 10 | [Odd Even Measurements](https://datalemur.com/questions/odd-even-measurements) | ROW_NUMBER, Window Functions, Conditional Aggregation, CTEs |
| 11 | [Swapped Food Delivery](https://datalemur.com/questions/sql-swapped-food-delivery) | CASE WHEN, Conditional Logic, Subqueries |
| 12 | [Bloomberg Stock Min Max](https://datalemur.com/questions/sql-bloomberg-stock-min-max-1) | ROW_NUMBER, Window Functions, Self Join, to_char |
| 13 | [Amazon Shopping Spree](https://datalemur.com/questions/amazon-shopping-spree) | ROW_NUMBER, Window Functions, DISTINCT |
| 14 | [Histogram Users Purchases](https://datalemur.com/questions/histogram-users-purchases) | DENSE_RANK, Window Functions, Aggregation |
| 15 | [Uncategorized Calls Percentage](https://datalemur.com/questions/uncategorized-calls-percentage) | Conditional Aggregation, CASE WHEN |
| 16 | [International Call Percentage](https://datalemur.com/questions/international-call-percentage) | JOINs, CASE WHEN, Conditional Aggregation |
| 17 | [Card Launch Success](https://datalemur.com/questions/card-launch-success) | ROW_NUMBER, Window Functions |
| 18 | [Alibaba Compressed Mode](https://datalemur.com/questions/alibaba-compressed-mode) | Subqueries, Filtering |

## Local SQL Testing

The `sql/datalemur/sample_data.py` file provides SQLite-compatible test data for practicing queries locally:

```python
import sqlite3
from sample_data import QUESTION_SETUP

# Create in-memory database
conn = sqlite3.connect(':memory:')

# Setup data for question 1
QUESTION_SETUP[1](conn)

# Run your query
cursor = conn.cursor()
cursor.execute("YOUR SQL QUERY HERE")
print(cursor.fetchall())
```

## Purpose

This repository serves as:
- A personal reference for interview preparation
- Documentation of problem-solving approaches and learnings
- A way to track progress through popular interview question sets

## Resources

- [LeetCode Top Interview 150](https://leetcode.com/studyplan/top-interview-150/)
- [DataLemur SQL Questions](https://datalemur.com/questions)
