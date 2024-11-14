SELECT * FROM EMPLOYEE;

/* With clause also to be referred as CTE (Common Table Expression) Or Sub Query Factoring*/

-- Fetch employee_id who earn salary more than the avg salary of all the employees

/*
SELECT EMPLOYEE_ID
FROM EMPLOYEE
WHERE SALARY > SELECT AVG(SALARY) FROM EMPLOYEE 
 */
-- With clause should be before select statement

WITH AVERAGE_SALARY (AVG_SAL) AS
	(SELECT CAST(AVG(SALARY) AS INT) FROM EMPLOYEE)
SELECT * 
FROM EMPLOYEE E, AVERAGE_SALARY AV
WHERE E.SALARY > AV.AVG_SAL;
------------------------------------
SELECT * FROM SALES;

-- Find stores who's sales where better than the average sales across all the stores.

1) Total sales per each store
	
SELECT S.STORE_ID, SUM(PRICE) AS TOTAL_SALES_PER_STORE
FROM SALES S
GROUP BY S.STORE_ID;

2) Find the total sales w.r.t all the stores.

SELECT CAST(AVG(TOTAL_SALES_PER_STORE) AS INT) AS AVG_SALES_FOR_ALL_STORES
FROM (SELECT S.STORE_ID, SUM(PRICE) AS TOTAL_SALES_PER_STORE
      FROM SALES S
      GROUP BY S.STORE_ID) X;

3) Find the stores where total_sales >  avg_sales of all stores

-- WITH Clause
	
WITH TOTAL_SALES (STORE_ID, TOTAL_SALES_PER_STORE) AS
      (SELECT S.STORE_ID, SUM(PRICE) AS TOTAL_SALES_PER_STORE
       FROM SALES S
       GROUP BY S.STORE_ID),
     AVG_SALES(AVG_SALES_FOR_ALL_STORES) AS
       (SELECT CAST(AVG(TOTAL_SALES_PER_STORE) AS INT) AS AVG_SALES_FOR_ALL_STORES
        FROM TOTAL_SALES) 
SELECT * 
FROM TOTAL_SALES TS
JOIN AVG_SALES AS AV
ON TS.TOTAL_SALES_PER_STORE > AV.AVG_SALES_FOR_ALL_STORES;

-- Sub query

SELECT *
FROM (SELECT S.STORE_ID, SUM(PRICE) AS TOTAL_SALES_PER_STORE
      FROM SALES S
      GROUP BY S.STORE_ID) TOTAL_SALES
JOIN (SELECT CAST(AVG(TOTAL_SALES_PER_STORE) AS INT) AS AVG_SALES_FOR_ALL_STORES
      FROM (SELECT S.STORE_ID, SUM(PRICE) AS TOTAL_SALES_PER_STORE
            FROM SALES S
            GROUP BY S.STORE_ID) X) AVG_SALES
ON TOTAL_SALES.TOTAL_SALES_PER_STORE > AVG_SALES.AVG_SALES_FOR_ALL_STORES;

-- Advantage od using WITH clause

-- Easily readible and easy to debug.
-- Improve performance.

-- When to use WITH clause
	