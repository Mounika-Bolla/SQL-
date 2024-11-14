CREATE TABLE Employee (
    Employee_ID          INT            PRIMARY KEY,
    Employee_Name        VARCHAR(100),
    Department_Name      VARCHAR(100),
    Salary               INT
);
INSERT INTO Employee (Employee_ID, Employee_Name, Department_Name, Salary) VALUES
(1, 'Alice Johnson', 'HR', 50000),
(2, 'Bob Smith', 'IT', 60000),
(3, 'Charlie Brown', 'Finance', 55000),
(4, 'David Wilson', 'IT', 62000),
(5, 'Eve Davis', 'HR', 52000),
(6, 'Frank Moore', 'Marketing', 48000),
(7, 'Grace Taylor', 'Sales', 51000),
(8, 'Hank Anderson', 'Finance', 58000),
(9, 'Ivy Thomas', 'IT', 64000),
(10, 'Jack White', 'Marketing', 47000),
(11, 'Kate Harris', 'Sales', 53000),
(12, 'Leo Martin', 'Finance', 59000),
(13, 'Mia Clark', 'HR', 56000),
(14, 'Nina Lewis', 'IT', 63000),
(15, 'Oscar Walker', 'Marketing', 49000),
(16, 'Paul Hall', 'Sales', 52000),
(17, 'Quinn Allen', 'Finance', 60000),
(18, 'Rita Young', 'HR', 57000),
(19, 'Sam King', 'IT', 65000),
(20, 'Tina Scott', 'Marketing', 46000),
(21, 'Uma Green', 'Sales', 54000),
(22, 'Vince Adams', 'Finance', 61000),
(23, 'Wendy Nelson', 'HR', 58000),
(24, 'Xander Baker', 'IT', 66000);
---------------------------------------------------------------
SELECT * FROM EMPLOYEE;

SELECT DEPARTMENT_NAME, MAX(SALARY) AS MAX_SALARY
FROM EMPLOYEE 
GROUP BY DEPARTMENT_NAME;


-- Uisng Window functions

SELECT E.*,
	MAX(SALARY) OVER(PARTITION BY DEPARTMENT_NAME) AS MAX_SALARY
FROM EMPLOYEE E;

-- Row_Number, rank, dense_rank, lead and leg

SELECT E.*,
ROW_NUMBER() OVER(PARTITION BY DEPARTMENT_NAME) AS RN
FROM EMPLOYEE E;

-- Fetch the first 2 employees from each department to join the company.

SELECT *
FROM (SELECT E.*,
      ROW_NUMBER() OVER(PARTITION BY DEPARTMENT_NAME ORDER BY EMPLOYEE_ID) AS RN
      FROM EMPLOYEE E) X
WHERE X.RN < 3;

-- Rank

-- Fetch the top 3 employees in each department earning the max salary.

SELECT * 
FROM (SELECT E.*,
      RANK() OVER(PARTITION BY DEPARTMENT_NAME ORDER BY SALARY DESC) AS RNK
      FROM EMPLOYEE E) X
WHERE X.RNK < 4;

-- Dense rank

--

SELECT E.*,
      RANK() OVER(PARTITION BY DEPARTMENT_NAME ORDER BY SALARY DESC) AS RNK,
	  DENSE_RANK() OVER(PARTITION BY DEPARTMENT_NAME ORDER BY SALARY DESC) AS DENSE_RNK,
	  ROW_NUMBER() OVER(PARTITION BY DEPARTMENT_NAME ORDER BY SALARY DESC) AS RN
FROM EMPLOYEE E;

-- Lead and lag

-- Fetch a query to display if the salary of an employee id higher, lower or equal to the previous employee.

SELECT E.*,
LAG(SALARY) OVER(PARTITION BY DEPARTMENT_NAME ORDER BY EMPLOYEE_ID) AS PREV_EMP_SAL,
LEAD(SALARY) OVER(PARTITION BY DEPARTMENT_NAME ORDER BY EMPLOYEE_ID) AS NEXT_EMP_SAL
FROM EMPLOYEE E;

SELECT E.*,
LAG(SALARY, 2, 0) OVER(PARTITION BY DEPARTMENT_NAME ORDER BY EMPLOYEE_ID) AS PREV_EMP_SAL
FROM EMPLOYEE E;

SELECT E.*,
LAG(SALARY) OVER(PARTITION BY DEPARTMENT_NAME ORDER BY EMPLOYEE_ID) AS PREV_EMP_SAL,
CASE WHEN E.SALARY >  LAG(SALARY) OVER(PARTITION BY DEPARTMENT_NAME ORDER BY EMPLOYEE_ID) THEN 'Higher than the previos employee'
     WHEN E.SALARY <  LAG(SALARY) OVER(PARTITION BY DEPARTMENT_NAME ORDER BY EMPLOYEE_ID) THEN 'Lower than the previos employee'
     WHEN E.SALARY =  LAG(SALARY) OVER(PARTITION BY DEPARTMENT_NAME ORDER BY EMPLOYEE_ID) THEN 'Same as the previos employee'
     END SAL_RANGE
FROM EMPLOYEE E;

----------------------------------------------------------------------------------------------

CREATE TABLE Product (
    Product_Category    VARCHAR(100),
    Brand               VARCHAR(100),
    Product_Name        VARCHAR(100),
    Price               INT
);

INSERT INTO Product (Product_Category, Brand, Product_Name, Price) VALUES
('Phone', 'Apple', 'iPhone 13', 800),
('Phone', 'Samsung', 'Galaxy S21', 700),
('Phone', 'Google', 'Pixel 6', 600),
('Phone', 'OnePlus', 'OnePlus 9', 730),
('Smart Watch', 'Apple', 'Apple Watch Series 7', 400),
('Smart Watch', 'Samsung', 'Galaxy Watch 4', 250),
('Smart Watch', 'Fitbit', 'Fitbit Versa 3', 230),
('Smart Watch', 'Garmin', 'Garmin Venu', 350),
('Headphone', 'Sony', 'WH-1000XM4', 350),
('Headphone', 'Bose', 'QuietComfort 35 II', 300),
('Headphone', 'Apple', 'AirPods Max', 550),
('Headphone', 'Sennheiser', 'HD 450BT', 200),
('Phone', 'Xiaomi', 'Mi 11', 750),
('Phone', 'Huawei', 'P40 Pro', 900),
('Smart Watch', 'Huawei', 'Watch GT 2', 180),
('Smart Watch', 'Amazfit', 'Amazfit GTS 2', 180),
('Headphone', 'Jabra', 'Elite 85h', 250),
('Headphone', 'Beats', 'Studio3', 350),
('Phone', 'Oppo', 'Find X3 Pro', 1150),
('Smart Watch', 'Fossil', 'Gen 5', 295),
('Headphone', 'Audio-Technica', 'ATH-M50x', 149),
('Phone', 'LG', 'Wing', 1000);

SELECT * FROM PRODUCT;


-- FIRST VALUE WINDOW FUNCTION

-- Write a quert to display the most expensive product under each category (corresponding to each record).


SELECT *,
FIRST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC) AS MOST_EXP_PROD
FROM PRODUCT;

-- LAST_VALUE

-- Write a quert to display the least expensive product under each category (corresponding to each record).

-- FRAME Clause
-- Frames is a subset of partition.

SELECT *,
FIRST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC) AS MOST_EXP_PROD,
LAST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC
	RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS LEAST_EXP_PROD
FROM PRODUCT;
SELECT *,
FIRST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC) AS MOST_EXP_PROD,
LAST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC
	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING ) AS LEAST_EXP_PROD
FROM PRODUCT;

SELECT *,
FIRST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC) AS MOST_EXP_PROD,
LAST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS LEAST_EXP_PROD
FROM PRODUCT
WHERE PRODUCT_CATEGORY = 'Phone';

SELECT *,
FIRST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC) AS MOST_EXP_PROD,
LAST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC
	RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS LEAST_EXP_PROD
FROM PRODUCT
WHERE PRODUCT_CATEGORY = 'Phone';

SELECT *,
FIRST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC) AS MOST_EXP_PROD,
LAST_VALUE(PRODUCT_NAME) OVER (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC
	RANGE BETWEEN 2 PRECEDING AND 2 FOLLOWING ) AS LEAST_EXP_PROD
FROM PRODUCT
WHERE PRODUCT_CATEGORY = 'Phone';

-- Alternate way to write SQL query using Windoe Functions.

SELECT *,
FIRST_VALUE(PRODUCT_NAME) OVER W AS MOST_EXP_PROD,
LAST_VALUE(PRODUCT_NAME) OVER W AS LEAST_EXP_PROD
FROM PRODUCT
WINDOW W AS (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC
	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);

-- NTH_VALUE

--Write a query to display the second most expensive product under each category.

SELECT *,
FIRST_VALUE(PRODUCT_NAME) OVER W AS MOST_EXP_PROD,
LAST_VALUE(PRODUCT_NAME) OVER W AS LEAST_EXP_PROD,
NTH_VALUE(PRODUCT_NAME, 2) OVER W AS SEC_MOST_EXP_PROD
FROM PRODUCT
WINDOW W AS (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC
	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);
SELECT *,
FIRST_VALUE(PRODUCT_NAME) OVER W AS MOST_EXP_PROD,
LAST_VALUE(PRODUCT_NAME) OVER W AS LEAST_EXP_PROD,
NTH_VALUE(PRODUCT_NAME, 8) OVER W AS SEC_MOST_EXP_PROD
FROM PRODUCT
WINDOW W AS (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC
	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);
SELECT *,
FIRST_VALUE(PRODUCT_NAME) OVER W AS MOST_EXP_PROD,
LAST_VALUE(PRODUCT_NAME) OVER W AS LEAST_EXP_PROD,
NTH_VALUE(PRODUCT_NAME, 2) OVER W AS SEC_MOST_EXP_PROD
FROM PRODUCT
WINDOW W AS (PARTITION BY PRODUCT_CATEGORY ORDER BY PRICE DESC);
	--RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);

-- NTILE

-- Write a query to segregate all the expensive phones, mid range phones and the cheaper phones.

SELECT PRODUCT_NAME,
	CASE WHEN X.BUCKETS = 1 THEN 'Expensive Phones'
         WHEN X.BUCKETS = 2 THEN 'Mid RangePhones'
	     WHEN X.BUCKETS = 3 THEN 'Cheaper Phones' END PHONE_CATEGORY
FROM (SELECT *,
      NTILE(3) OVER (ORDER BY PRICE DESC) AS BUCKETS
      FROM PRODUCT
	  WHERE PRODUCT_CATEGORY = 'Phone') X;


-- CUME_DIST stands for Cummulative Distribution
-- Value --> 1 <= CUME_DIST > 0
-- Formula = Current row no (or row no with the same num as current row)/ Total no.of rows

-- Query to fetch all products which are constituting the first 30% of the data in products table based on price.
SELECT PRODUCT_NAME, (CUMMULATIVE_DISRIBUTION_PERCENTAGE||'%') AS CUMMULATIVE_DISRIBUTION_PERCENTAGE
FROM (SELECT *,
      CUME_DIST() OVER (ORDER BY PRICE DESC) AS CUMMULATIVE_DISRIBUTION,
      ROUND(CUME_DIST() OVER (ORDER BY PRICE DESC)::NUMERIC*100, 2) AS CUMMULATIVE_DISRIBUTION_PERCENTAGE
      FROM PRODUCT) X
WHERE X.CUMMULATIVE_DISRIBUTION_PERCENTAGE <= 30
;

-- Percent_Rank (Relative rank of the current row/percentage ranking)
-- Value --> 1 <= PERCENT_RANK > 0
-- Formula = (Current row num - 1)/ (total no.of rows - 1)

-- Query to identify how much percentage more expensive id "Galaxy Z Fold 3" when compared to all products

SELECT PRODUCT_NAME, PER_RANK
FROM (SELECT *,
      PERCENT_RANK() OVER (ORDER BY PRICE) AS PERCENTAGE_RANKING,
      ROUND(PERCENT_RANK() OVER (ORDER BY PRICE)::NUMERIC*100, 2) AS PER_RANK
      FROM PRODUCT) X
WHERE X.PRODUCT_NAME = 'iPhone 13';
