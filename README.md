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
