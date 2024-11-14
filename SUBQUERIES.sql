CREATE TABLE DEPARTMENT
(
      Department_code  INT              PRIMARY KEY
    , Department_name  VARCHAR(30)    
    , Location         VARCHAR(33)
);

CREATE TABLE EMPLOYEE
(
      Employee_ID        VARCHAR(30)    PRIMARY KEY
    , Employee_name      VARCHAR(30)    NOT NULL
    , Department_code    INT
    , Salary             FLOAT
    , CONSTRAINT FK_EMP_DEPT FOREIGN KEY(Department_code) REFERENCES DEPARTMENT(Department_code)
);

INSERT INTO DEPARTMENT (Department_code, Department_name, Location) VALUES
(1, 'Human Resources', 'New York'),
(2, 'Finance', 'Los Angeles'),
(3, 'Engineering', 'San Francisco'),
(4, 'Sales', 'Chicago'),
(5, 'Marketing', 'Miami'),
(6, 'IT', 'Seattle'),
(7, 'Customer Support', 'Houston'),
(8, 'Research and Development', 'Boston'),
(9, 'Legal', 'Washington D.C.'),
(10, 'Operations', 'Atlanta');

INSERT INTO EMPLOYEE (Employee_ID, Employee_name, Department_code, Salary) VALUES
('E001', 'John Doe', 1, 60000),
('E002', 'Jane Smith', 2, 75000),
('E003', 'Jim Brown', 3, 80000),
('E004', 'Jill White', 4, 70000),
('E005', 'Jack Black', 5, 65000),
('E006', 'Jenny Green', 6, 62000),
('E007', 'Jerry Red', 7, 55000),
('E008', 'Joe Blue', 8, 85000),
('E009', 'Jasmine Purple', 9, 90000),
('E010', 'Jordan Grey', 10, 72000),
('E011', 'Joan Pink', 1, 63000),
('E012', 'James Gold', 2, 77000),
('E013', 'Jade Silver', 3, 82000),
('E014', 'Jared Copper', 4, 71000),
('E015', 'Julie Bronze', 5, 67000),
('E016', 'Jackson Iron', 6, 64000),
('E017', 'Jocelyn Steel', 7, 57000),
('E018', 'Jonathan Zinc', 8, 86000),
('E019', 'Jessica Lead', 9, 91000),
('E020', 'Jeff Brass', 10, 73000),
('E021', 'Jennifer Platinum', 1, 64000),
('E022', 'Jacob Diamond', 2, 78000),
('E023', 'Janet Jade', 3, 83000),
('E024', 'Jeremy Ruby', 4, 72000);
--------------------------------------------------------------------
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;

-- Find the employee's who's salary is more than the average salary earned by all the employess?

1) find the avg salary
2) filter the employees salary based on the above result

SELECT AVG(SALARY) FROM EMPLOYEE AS AVG_SALARY; --75000.33

SELECT * FROM EMPLOYEE --Outer query or Main query
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE AS AVG_SALARY);  -- Sub Query/Inner Query

-- Scalar Subquery
-- It always returns 1 row and 1 column
-- We can use the subquery not only in WHERE clause but also in FROM and SELECT clause 

-- From clause

SELECT * FROM EMPLOYEE AS E
JOIN (SELECT AVG(SALARY) SAL FROM EMPLOYEE) AS AVG_SALARY
ON E.SALARY > AVG_SALARY.SAL;

-- Multiple row subquery --> 2 kinds
-- 1) Subquery which returns multiple row and multiple column
-- 2) Subquery which returns only one column and multiple rows

-- Q) Find the employees who earn the highest salary in each department.

SELECT DEPARTMENT_NAME, MAX(SALARY) SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT DEP ON E.DEPARTMENT_CODE = DEP.DEPARTMENT_CODE
GROUP BY DEPARTMENT_NAME;

SELECT * FROM EMPLOYEE E
JOIN DEPARTMENT DEP ON E.DEPARTMENT_CODE = DEP.DEPARTMENT_CODE
WHERE (DEPARTMENT_NAME,SALARY) IN (SELECT DEPARTMENT_NAME, MAX(SALARY) SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT DEP ON E.DEPARTMENT_CODE = DEP.DEPARTMENT_CODE
GROUP BY DEPARTMENT_NAME);

-- Single column and multiple row subquery

-- Q) Find the department who do not have any employees.

SELECT * FROM DEPARTMENT 
WHERE DEPARTMENT_NAME NOT IN (SELECT DISTINCT(DEPARTMENT_NAME) FROM EMPLOYEE E
JOIN DEPARTMENT DEP ON E.DEPARTMENT_CODE = DEP.DEPARTMENT_CODE);

-- Correlated Subquery
-- A subquery which is related to the outer query

-- Q) Find the employees in each department who earn more than the average salary in that department.

SELECT AVG(SALARY) FROM EMPLOYEE E
JOIN DEPARTMENT DEP ON E.DEPARTMENT_CODE = DEP.DEPARTMENT_CODE
WHERE DEPARTMENT_NAME = "Specifi_dept";

SELECT * E1 FROM EMPLOYEE E1
JOIN DEPARTMENT DEP ON E1.DEPARTMENT_CODE = DEP.DEPARTMENT_CODE
WHERE SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE E2
JOIN DEPARTMENT DEP ON E2.DEPARTMENT_CODE = DEP.DEPARTMENT_CODE
WHERE E2.DEPARTMENT_NAME = E1.DEPARTMENT_NAME);

-- Q) Find the department who do not have any employees

SELECT * FROM DEPARTMENT D
WHERE NOT EXISTS (SELECT * FROM EMPLOYEE E JOIN DEPARTMENT ON E.DEPARTMENT_CODE = D.DEPARTMENT_CODE
	WHERE E.DEPARTMENT_NAME = D.DEPARTMENT_NAME);

SELECT * FROM EMPLOYEE 
	WHERE E.DEPARTMENT_NAME = 'Human Resources';

-- Nested Subquery
-- Subquery inside a sub query
CREATE TABLE SALES
(
	  Store_ID     INT
    , Store_name   VARCHAR(50)
	, Product_name VARCHAR(50)
	, Quantity     INT
	, Price        INT
	
);
INSERT INTO SALES (Store_ID, Store_name, Product_name, Quantity, Price) VALUES
(1, 'Store A', 'Product 1', 10, 100),
(1, 'Store A', 'Product 2', 20, 200),
(1, 'Store A', 'Product 3', 15, 150),
(2, 'Store B', 'Product 1', 5, 110),
(2, 'Store B', 'Product 2', 25, 210),
(2, 'Store B', 'Product 4', 10, 310),
(3, 'Store C', 'Product 1', 8, 120),
(3, 'Store C', 'Product 3', 22, 220),
(3, 'Store C', 'Product 5', 12, 320),
(4, 'Store D', 'Product 2', 30, 230),
(4, 'Store D', 'Product 4', 6, 330),
(4, 'Store D', 'Product 6', 14, 430),
(5, 'Store E', 'Product 1', 16, 140),
(5, 'Store E', 'Product 3', 18, 240),
(5, 'Store E', 'Product 5', 9, 340),
(6, 'Store F', 'Product 2', 12, 250),
(6, 'Store F', 'Product 4', 7, 350),
(6, 'Store F', 'Product 6', 13, 450),
(7, 'Store G', 'Product 1', 11, 160),
(7, 'Store G', 'Product 3', 24, 260),
(7, 'Store G', 'Product 5', 14, 360),
(8, 'Store H', 'Product 2', 9, 270),
(8, 'Store H', 'Product 4', 15, 370),
(8, 'Store H', 'Product 6', 10, 470),
(9, 'Store I', 'Product 1', 14, 180),
(9, 'Store I', 'Product 3', 21, 280),
(9, 'Store I', 'Product 5', 11, 380),
(10, 'Store J', 'Product 2', 13, 290),
(10, 'Store J', 'Product 4', 16, 390),
(10, 'Store J', 'Product 6', 12, 490);

SELECT * FROM SALES;

-- Q) Find stores who's sales where better than the average sales across all the stores

1) FIND THE TOTAL SALES FOR EACH STORE
2) find the avg sales for all the stores
3) compare 1 and 2


SELECT * FROM (SELECT STORE_NAME, SUM(PRICE) AS TOTAL_SALES FROM SALES
GROUP BY STORE_NAME) SALES 
JOIN
(SELECT AVG(TOTAL_SALES) AS SALES FROM (SELECT STORE_NAME, SUM(PRICE) AS TOTAL_SALES FROM SALES
GROUP BY STORE_NAME) X) AVG_SALES
ON SALES.TOTAL_SALES > AVG_SALES.SALES;

WITH SALES AS (SELECT STORE_NAME, SUM(PRICE) AS TOTAL_SALES FROM SALES
GROUP BY STORE_NAME)
SELECT *
FROM SALES 
JOIN
(SELECT AVG(TOTAL_SALES) AS SALES FROM SALES X) AVG_SALES
ON SALES.TOTAL_SALES > AVG_SALES.SALES;

-- Different SQL clause where sub query is allowed
-- SELECT
-- FROM
-- WHERE
-- HAVING

-- Using a sub query in SELECT Clause

-- Q) Fetch all the employee details and add remarks to those employees who earn more than the average pay.

SELECT *
	, (CASE WHEN SALARY > (SELECT AVG(SALARY) FROM EMPLOYEE)
	          THEN 'Higher than the avg salary'
	        ELSE NULL
	    END
	) AS REMARKS 
FROM EMPLOYEE;

SELECT *
	, (CASE WHEN SALARY > AVG_SAL.SAL
	          THEN 'Higher than the avg salary'
	        ELSE NULL
	    END
	) AS REMARKS 
FROM EMPLOYEE
CROSS JOIN
(SELECT AVG(SALARY) SAL FROM EMPLOYEE) AVG_SAL;


-- HAVING

-- Q) Find the stores who have sold more units than the average units sold by all the stores.

SELECT * FROM SALES;

SELECT STORE_NAME, SUM(QUANTITY)
FROM SALES
GROUP BY STORE_NAME
HAVING SUM(QUANTITY) > (SELECT AVG(QUANTITY) FROM SALES);

-- SQL Commands which allow sub query
-- INSERT
-- UPDATE
-- DELETE

-- INSERT

-- Q) Insert data to employee history table. Make sure not insert duplicate records.
CREATE TABLE EMPLOYEE_HISTORY
(
      Employee_ID        VARCHAR(30)    PRIMARY KEY
    , Employee_name      VARCHAR(30)    NOT NULL
    , Department_name    VARCHAR(30)
    , Salary             FLOAT
);
ALTER TABLE EMPLOYEE_HISTORY ADD Location VARCHAR(33);
CREATE TABLE DEPARTMENT_HISTORY
(
      Department_code  INT              
    , Department_name  VARCHAR(30)    PRIMARY KEY
    , Location         VARCHAR(33)
);

SELECT * FROM EMPLOYEE_HISTORY;

INSERT INTO EMPLOYEE_HISTORY
SELECT E.EMPLOYEE_ID, E.EMPLOYEE_NAME, D.DEPARTMENT_NAME, E.SALARY, D.LOCATION
FROM EMPLOYEE E 
JOIN DEPARTMENT D ON D.DEPARTMENT_CODE = E.DEPARTMENT_CODE
WHERE NOT EXISTS (SELECT * FROM EMPLOYEE EH
	                     WHERE EH.EMPLOYEE_ID = E.EMPLOYEE_ID);

-- UPDATE 

/* Q) Give 10% increment to all employees in bangalore location based on the maximum salary by an emp in each department. Only consider employees
employee_history table.*/

UPDATE EMPLOYEE E
SET SALARY = (SELECT MAX(SALARY) + (MAX(SALARY) * 0.1)
	FROM EMPLOYEE_HISTORY EH
	WHERE EH.DEPARTMENT_NAME = E.DEPARTMENT_NAME)
WHERE E.DEPARTMENT_NAME IN (SELECT DEPARTMENT_NAME  
	                        FROM DEPARTMENT
	                        WHERE LOCATION = 'Bangalore')
AND E.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_HISTORY);

-- DELETE

/* Q) Delete all departments who do not have any employees.*/

DELETE FROM DEPARTMENT
WHERE DEPARTMENT_NAME IN (SELECT DEPARTMENT_NAME FROM DEPARTMENT D
	                       WHERE NOT EXISTS (SELECT 1 FROM EMPLOYEE E
	                                          WHERE E.DEPARTMENT_NAME = D.DEPARTMENT_NAME)
	);
