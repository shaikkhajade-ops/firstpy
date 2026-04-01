-- ===============================
-- JOINS
-- ===============================

-- 1. INNER JOIN: Employee name with department name
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id;

-- 2. LEFT JOIN: All employees with department (if exists)
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d
ON e.dept_id = d.dept_id;

-- 3. RIGHT JOIN: All departments with employees (if exists)
SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d
ON e.dept_id = d.dept_id;

-- 4. Employees without department
SELECT *
FROM employees
WHERE dept_id IS NULL;

-- 5. Departments without employees
SELECT d.dept_name
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;


-- ===============================
-- AGGREGATIONS
-- ===============================

-- 1. Total employees in each department
SELECT dept_id, COUNT(*) AS total_employees
FROM employees
GROUP BY dept_id;

-- 2. Departments having more than 1 employee
SELECT dept_id, COUNT(*) AS total_employees
FROM employees
GROUP BY dept_id
HAVING COUNT(*) > 1;

-- 3. Department with highest employees
SELECT dept_id, COUNT(*) AS total_employees
FROM employees
GROUP BY dept_id
ORDER BY total_employees DESC
LIMIT 1;

-- 4. Count including departments with zero employees
SELECT d.dept_name, COUNT(e.emp_id) AS total_employees
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
GROUP BY d.dept_name;


-- ===============================
-- SUBQUERIES
-- ===============================

-- 1. Employees earning more than average salary
SELECT *
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 2. Employees in same department as employee 'A'
SELECT *
FROM employees
WHERE dept_id = (
    SELECT dept_id
    FROM employees
    WHERE name = 'A'
);

-- 3. Second highest salary
SELECT MAX(salary)
FROM employees
WHERE salary < (SELECT MAX(salary) FROM employees);


-- ===============================
-- WINDOW FUNCTIONS
-- ===============================

-- 1. Second highest salary using DENSE_RANK
SELECT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 2;

-- 2. Rank employees by salary
SELECT name, salary,
       RANK() OVER (ORDER BY salary DESC) AS rank
FROM employees;

-- 3. Top 2 highest salaries
SELECT *
FROM (
    SELECT name, salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk <= 2;


-- ===============================
-- REAL INTERVIEW QUESTIONS
-- ===============================

-- 1. Employees earning more than department average
SELECT e.*
FROM employees e
JOIN (
    SELECT dept_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept_id
) d
ON e.dept_id = d.dept_id
WHERE e.salary > d.avg_salary;

-- 2. Find duplicate records
SELECT name, COUNT(*)
FROM employees
GROUP BY name
HAVING COUNT(*) > 1;

-- 3. Highest salary in each department
SELECT dept_id, MAX(salary) AS max_salary
FROM employees
GROUP BY dept_id;
