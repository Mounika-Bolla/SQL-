CREATE TABLE INPUT (
    sales_date DATE,
    customer_id VARCHAR(30),
    amount INT
);

INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-01-01', 'Cust-1', 505.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-01-02', 'Cust-1', 50.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-01-03', 'Cust-1', 50.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-01-01', 'Cust-2', 100.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-01-02', 'Cust-2', 100.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-01-03', 'Cust-2', 100.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-02-01', 'Cust-2', -100.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-02-02', 'Cust-2', -100.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-02-03', 'Cust-2', -100.50);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-03-01', 'Cust-3', 15.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-04-01', 'Cust-3', 15.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-05-01', 'Cust-3', 15.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-06-01', 'Cust-3', 15.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-07-01', 'Cust-3', -15.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-08-01', 'Cust-3', -15.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-09-01', 'Cust-3', -15.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-10-01', 'Cust-3', -15.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-11-01', 'Cust-3', -15.00);
INSERT INTO input (sales_date, customer_id, amount) VALUES ('2021-12-01', 'Cust-3', -15.00);

ALTER TABLE INPUT RENAME TO SALES_DATA;
------------------------------------------------------------------------------------------------------
SELECT * FROM SALES_DATA;

SELECT CUSTOMER_ID AS CUSTOMER,
TO_CHAR(SALES_DATE, 'Mon-YY') AS SALES_DATE,
AMOUNT
FROM SALES_DATA;

SELECT CUSTOMER_ID AS CUSTOMER,
TO_CHAR(SALES_DATE, 'Mon-YY') AS SALES_DATE,
SUM(AMOUNT)
FROM SALES_DATA
GROUP BY CUSTOMER_ID, TO_CHAR(SALES_DATE, 'Mon-YY')
ORDER BY 1;

-------------------------------------------------------------------------------------------------------------------
WITH PIVOT_DATA AS (
    SELECT * FROM CROSSTAB(
        'SELECT customer_id AS customer,
                TO_CHAR(sales_date, ''Mon-YY'') AS sales_date,
                SUM(amount) AS amount
         FROM SALES_DATA
         GROUP BY customer_id, TO_CHAR(sales_date, ''Mon-YY'')
         ORDER BY customer_id, sales_date',
        'VALUES (''Jan-21''), (''Feb-21''), (''Mar-21''), (''Apr-21''), (''May-21''), (''Jun-21''), (''Jul-21''), 
                 (''Aug-21''), (''Sep-21''), (''Oct-21''), (''Nov-21''), (''Dec-21'')'
    ) AS ct (
        customer VARCHAR, 
        Jan_21 BIGINT, 
        Feb_21 BIGINT, 
        Mar_21 BIGINT, 
        Apr_21 BIGINT, 
        May_21 BIGINT, 
        Jun_21 BIGINT, 
        Jul_21 BIGINT, 
        Aug_21 BIGINT, 
        Sep_21 BIGINT, 
        Oct_21 BIGINT, 
        Nov_21 BIGINT, 
        Dec_21 BIGINT
    )
    UNION
    SELECT * FROM CROSSTAB(
        'SELECT ''TOTAL'' AS customer,
                TO_CHAR(sales_date, ''Mon-YY'') AS sales_date,
                SUM(amount) AS amount
         FROM SALES_DATA
         GROUP BY TO_CHAR(sales_date, ''Mon-YY'')
         ORDER BY sales_date',
        'VALUES (''Jan-21''), (''Feb-21''), (''Mar-21''), (''Apr-21''), (''May-21''), (''Jun-21''), (''Jul-21''), 
                 (''Aug-21''), (''Sep-21''), (''Oct-21''), (''Nov-21''), (''Dec-21'')'
    ) AS ct (
        customer VARCHAR, 
        Jan_21 BIGINT, 
        Feb_21 BIGINT, 
        Mar_21 BIGINT, 
        Apr_21 BIGINT, 
        May_21 BIGINT, 
        Jun_21 BIGINT, 
        Jul_21 BIGINT, 
        Aug_21 BIGINT, 
        Sep_21 BIGINT, 
        Oct_21 BIGINT, 
        Nov_21 BIGINT, 
        Dec_21 BIGINT
    )
    ORDER BY 1
),
FINAL_DATA AS (
    SELECT customer,
           COALESCE(Jan_21, 0) AS Jan_21,
           COALESCE(Feb_21, 0) AS Feb_21,
           COALESCE(Mar_21, 0) AS Mar_21,
           COALESCE(Apr_21, 0) AS Apr_21,
           COALESCE(May_21, 0) AS May_21,
           COALESCE(Jun_21, 0) AS Jun_21,
           COALESCE(Jul_21, 0) AS Jul_21,
           COALESCE(Aug_21, 0) AS Aug_21,
           COALESCE(Sep_21, 0) AS Sep_21,
           COALESCE(Oct_21, 0) AS Oct_21,
           COALESCE(Nov_21, 0) AS Nov_21,
           COALESCE(Dec_21, 0) AS Dec_21
    FROM PIVOT_DATA
)

SELECT * FROM FINAL_DATA;