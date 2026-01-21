"""
Sample data for DataLemur SQL questions.
Each function sets up the required tables and inserts test data.
"""
import sqlite3


def setup_q1_top_three_salaries(conn: sqlite3.Connection) -> None:
    """
    Q.1 Top Three Salaries
    https://datalemur.com/questions/sql-top-three-salaries
    """
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE department (
            department_id INTEGER PRIMARY KEY,
            department_name TEXT
        )
    """)

    cursor.execute("""
        CREATE TABLE employee (
            employee_id INTEGER PRIMARY KEY,
            name TEXT,
            salary INTEGER,
            department_id INTEGER,
            FOREIGN KEY (department_id) REFERENCES department(department_id)
        )
    """)

    # Insert departments
    cursor.executemany(
        "INSERT INTO department (department_id, department_name) VALUES (?, ?)",
        [
            (1, 'Engineering'),
            (2, 'Marketing'),
            (3, 'Sales'),
        ]
    )

    # Insert employees with various salaries
    cursor.executemany(
        "INSERT INTO employee (name, salary, department_id) VALUES (?, ?, ?)",
        [
            # Engineering - should return top 3 distinct salaries
            ('Alice', 150000, 1),
            ('Bob', 150000, 1),      # Same as Alice (DENSE_RANK handles this)
            ('Charlie', 120000, 1),
            ('Diana', 110000, 1),
            ('Eve', 100000, 1),       # Should NOT appear (4th rank)
            # Marketing
            ('Frank', 90000, 2),
            ('Grace', 85000, 2),
            ('Henry', 80000, 2),
            # Sales
            ('Ivy', 70000, 3),
            ('Jack', 65000, 3),
            ('Kate', 60000, 3),
            ('Leo', 55000, 3),        # Should NOT appear (4th rank)
        ]
    )

    conn.commit()


def setup_q2_time_spent_snaps(conn: sqlite3.Connection) -> None:
    """
    Q.2 Time Spent on Snaps
    https://datalemur.com/questions/time-spent-snaps
    """
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE age_breakdown (
            user_id INTEGER PRIMARY KEY,
            age_bucket TEXT
        )
    """)

    cursor.execute("""
        CREATE TABLE activities (
            activity_id INTEGER PRIMARY KEY,
            user_id INTEGER,
            activity_type TEXT,
            time_spent REAL,
            FOREIGN KEY (user_id) REFERENCES age_breakdown(user_id)
        )
    """)

    # Insert age breakdown
    cursor.executemany(
        "INSERT INTO age_breakdown (user_id, age_bucket) VALUES (?, ?)",
        [
            (1, '21-25'),
            (2, '21-25'),
            (3, '26-30'),
            (4, '26-30'),
            (5, '31-35'),
        ]
    )

    # Insert activities (send, open, chat - but we only care about send/open)
    cursor.executemany(
        "INSERT INTO activities (user_id, activity_type, time_spent) VALUES (?, ?, ?)",
        [
            # 21-25 age bucket
            (1, 'send', 5.0),
            (1, 'open', 3.0),
            (1, 'chat', 10.0),   # Should be ignored
            (2, 'send', 4.0),
            (2, 'open', 6.0),
            # 26-30 age bucket
            (3, 'send', 2.0),
            (3, 'open', 8.0),
            (4, 'send', 3.0),
            (4, 'open', 7.0),
            # 31-35 age bucket
            (5, 'send', 1.0),
            (5, 'open', 9.0),
            (5, 'chat', 5.0),   # Should be ignored
        ]
    )

    conn.commit()


# Registry mapping question numbers to their setup functions
QUESTION_SETUP = {
    1: setup_q1_top_three_salaries,
    2: setup_q2_time_spent_snaps,
}
