-- Lab3

-- 1
CREATE DATABASE advanced_lab;

CREATE TABLE employees (
    emp_id       SERIAL PRIMARY KEY,
    first_name   VARCHAR(100),
    last_name    VARCHAR(100),
    department   VARCHAR(100),
    salary       INTEGER,
    hire_date    DATE,
    status       VARCHAR(50) DEFAULT 'Active'
);

CREATE TABLE departments (
    dept_id      SERIAL PRIMARY KEY,
    dept_name    VARCHAR(100),
    budget       INTEGER,
    manager_id   INTEGER
);

CREATE TABLE projects (
    project_id   SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id      INTEGER,
    start_date   DATE,
    end_date     DATE,
    budget       INTEGER
);

-- 2
INSERT INTO employees (
    emp_id,
    first_name,
    last_name,
    department
)
VALUES
    (DEFAULT, 'Igor', 'Smirnov', 'Sales'),
    (DEFAULT, 'Tatyana', 'Volkova', 'HR');

-- 3
INSERT INTO employees (
    first_name,
    last_name,
    department,
    salary,
    status,
    hire_date
)
VALUES
    (
        'Dmitry',
        'Popov',
        'Operations',
        DEFAULT,
        DEFAULT,
        '2024-09-30'
    );

-- 4
INSERT INTO departments (
    dept_name,
    budget,
    manager_id
)
VALUES
    ('IT', 500000, 1),
    ('Marketing', 350000, 2),
    ('HR', 120000, 3);

-- 5
INSERT INTO employees (
    first_name,
    last_name,
    department,
    salary,
    hire_date
)
VALUES
    (
        'Viktoria',
        'Morozova',
        'Research',
        50000 * 1.1,
        CURRENT_DATE
    );

-- 6
CREATE TEMP TABLE temp_employees AS
SELECT
    emp_id,
    first_name,
    last_name,
    department,
    salary,
    hire_date,
    status
FROM employees
LIMIT 0;

INSERT INTO temp_employees (
    emp_id,
    first_name,
    last_name,
    department,
    salary,
    hire_date,
    status
)
SELECT
    emp_id,
    first_name,
    last_name,
    department,
    salary,
    hire_date,
    status
FROM employees
WHERE department = 'IT';

-- 7
UPDATE employees
SET salary = salary * 1.10
WHERE salary IS NOT NULL;

-- 8
UPDATE employees
SET status = 'Senior'
WHERE salary > 60000 AND hire_date < '2020-01-01';

-- 9
UPDATE employees
SET department =
    CASE
        WHEN salary > 80000 THEN 'Management'
        WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
        ELSE 'Junior'
    END
WHERE salary IS NOT NULL;

-- 10
UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

-- 11
UPDATE departments d
SET budget = (e.avg_salary * 1.20)
FROM (
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM employees
    WHERE salary IS NOT NULL
    GROUP BY department
) AS e
WHERE d.dept_name = e.department;

-- 12
UPDATE employees
SET
    salary = salary * 1.15,
    status = 'Promoted'
WHERE department = 'Sales';

-- 13
DELETE FROM employees
WHERE status = 'Terminated';

-- 14
DELETE FROM employees
WHERE salary < 40000
  AND hire_date > '2023-01-01'
  AND department IS NULL;

-- 15
DELETE FROM departments
WHERE dept_name NOT IN (
    SELECT DISTINCT department
    FROM employees
    WHERE department IS NOT NULL
);

-- 16
DELETE FROM projects
WHERE end_date < '2023-01-01'
RETURNING *;

-- 17
INSERT INTO employees (
    first_name,
    last_name,
    department,
    salary
)
VALUES
    (
        'Petr',
        'Volkov',
        NULL,
        NULL
    );

-- 18
UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

-- 19
DELETE FROM employees
WHERE salary IS NULL OR department IS NULL;

-- 20
INSERT INTO employees (
    first_name,
    last_name,
    department
)
VALUES
    (
        'Ivan',
        'Sokolov',
        'Management'
    )
RETURNING emp_id, first_name || ' ' || last_name AS full_name;

-- 21
UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT' AND salary IS NOT NULL
RETURNING emp_id, salary - 5000 AS old_salary, salary AS new_salary;

-- 22
DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;

-- 23
INSERT INTO employees (
    first_name,
    last_name,
    department
)
SELECT
    'Andrey',
    'Ivanov',
    'New Department'
WHERE NOT EXISTS (
    SELECT 1
    FROM employees
    WHERE first_name = 'Andrey' AND last_name = 'Ivanov'
);

-- 24
UPDATE employees e
SET salary = e.salary * CASE
        WHEN d.budget > 100000 THEN 1.10
        ELSE 1.05
    END
FROM departments d

WHERE e.department = d.dept_name
  AND e.salary IS NOT NULL;

-- 25
INSERT INTO employees (
    first_name,
    last_name,
    department,
    salary
)
VALUES
    ('Artem', 'Belov', 'Bulk Insert', 50000),
    ('Maria', 'Klimova', 'Bulk Insert', 50000),
    ('Nikita', 'Gerasimov', 'Bulk Insert', 50000),
    ('Olga', 'Fedorova', 'Bulk Insert', 50000),
    ('Dmitry', 'Smirnov', 'Bulk Insert', 50000);

-- updating salaries
UPDATE employees
SET salary = salary * 1.10
WHERE department = 'Bulk Insert';

-- 26
CREATE TABLE employee_archive AS
SELECT *
FROM employees
LIMIT 0;

INSERT INTO employee_archive
SELECT *
FROM employees
WHERE status = 'Inactive';

DELETE FROM employees
WHERE status = 'Inactive';

-- 27
UPDATE projects p
SET end_date = p.end_date + INTERVAL '30 days'
FROM departments d
WHERE p.budget > 50000
  AND p.dept_id = d.dept_id
  AND d.dept_name IN (
    SELECT department
    FROM employees
    GROUP BY department
    HAVING COUNT(*) > 3
  );