-- What is a procedure?
-- It is a named block of code and it is stored in th database.

/* Procedures can include:
- SQL Queries
- DDL, DML, DCL and TCL Commands
- Collection Types
- Cursors
- Loop and IF else stataments
- Variables
- Exception Handling etc. */

-- Pupose of using a Procedure:
-- Procedure gives power to the SQL language. 
-- Procedured can do things which SQL queries cannot


-- Syntax to create a procedure

CREATE OR REPLACE PROCEDURE PRO_NAME (P_NAME VARCHAR, P_AGE INT)
LANGUAGE PLPGSQL
AS $$
DECLARE 
  VARIABLE
BEGIN 
    PROCEDURE BODY - ALL LOGICS
END;
$$

SELECT 'I''m Monica' as NAME
SELECT E'I\'m Monica' as NAME1;
SELECT $$I'm Monica$$ as NAME2;
DROP TABLE PRODUCTS;
CREATE TABLE products (
    product_code VARCHAR(50) PRIMARY KEY, 
    product_name VARCHAR(100), 
    price DOUBLE PRECISION, 
    quantity_remaining INT, 
    quantity_sold INT
	CONSTRAINT FOREIGN KEY 
);

INSERT INTO products (product_code, product_name, price, quantity_remaining, quantity_sold) 
VALUES ('P001', 'Iphone 13 Pro Max', 1099.99, 100, 50);

CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    order_date DATE,
    product_code VARCHAR(50),
    quantity_ordered INT,
    sale_price DOUBLE PRECISION
);
DROP TABLE SALES;

CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    order_date DATE,
    product_code VARCHAR(50),
    quantity_ordered INT,
    sale_price DOUBLE PRECISION,
    FOREIGN KEY (product_code) REFERENCES products(product_code)
);

INSERT INTO sales (order_id, order_date, product_code, quantity_ordered, sale_price) 
VALUES 
(1, '2024-01-15', 'P001', 2, 12000.00),
(2, '2024-01-16', 'P001', 1, 29000.00),
(3, '2024-01-17', 'P001', 3, 18900.97);

SELECT * FROM PRODUCTS;
SELECT * FROM SALES;

-- For every Iphone 13 max pro sale, modify the database tables accordingly.


CREATE OR REPLACE PROCEDURE PRO_BUY_PRODUCTS()
LANGUAGE PLPGSQL
AS $$
DECLARE
	V_PRODUCT_CODE VARCHAR(40);
	V_PRICE        DOUBLE PRECISION;

BEGIN 
     SELECT PRODUCT_CODE, PRICE 
     INTO V_PRODUCT_CODE, V_PRICE
     FROM PRODUCTS
     WHERE PRODUCT_NAME = 'Iphone 13 Pro Max';

     INSERT INTO SALES(ORDER_ID, ORDER_DATE, PRODUCT_CODE, QUANTITY_ORDERED, SALE_PRICE)
		 VALUES((SELECT COALESCE(MAX(ORDER_ID), 0) + 1 FROM SALES), CURRENT_DATE, V_PRODUCT_CODE, 1, (V_PRICE * 1));

     UPDATE PRODUCTS
     SET QUANTITY_REMAINING = (QUANTITY_REMAINING - 1)
		 , QUANTITY_SOLD = (QUANTITY_SOLD + 1)
	 WHERE PRODUCT_CODE = V_PRODUCT_CODE;

	 RAISE NOTICE 'Product Sold!';
END;
$$

CALL PRO_BUY_PRODUCTS();

SELECT * FROM PRODUCTS;
SELECT * FROM SALES;
-- Assuming the PRODUCTS table is already created as shown previously

-- Insert 3 more records into the PRODUCTS table
INSERT INTO PRODUCTS (PRODUCT_CODE, PRODUCT_NAME, PRICE, QUANTITY_REMAINING, QUANTITY_SOLD)
VALUES 
    ('P002', 'Samsung Galaxy S21', 799.99, 50, 0),
    ('P003', 'OnePlus 9 Pro', 969.00, 30, 0),
    ('P004', 'Google Pixel 6', 599.00, 25, 0);

DELETE FROM SALES
WHERE ORDER_ID <= 5;


INSERT INTO SALES (ORDER_ID, ORDER_DATE, PRODUCT_CODE, QUANTITY_ORDERED, SALE_PRICE)
VALUES 
    (1, '2024-06-01', 'P001', 2, 1099.98),
    (2, '2024-06-02', 'P002', 1, 1799.99),
    (3, '2024-06-03', 'P003', 3, 2907.00),
    (4, '2024-06-04', 'P004', 1, 1599.00),
    (5, '2024-06-05', 'P001', 1, 1549.99),
    (6, '2024-06-06', 'P002', 2, 1599.98),
    (7, '2024-06-07', 'P003', 1, 1969.00),
    (8, '2024-06-08', 'P004', 2, 1198.00),
    (9, '2024-06-09', 'P001', 1, 1549.99),
    (10, '2024-06-10', 'P002', 3, 2399.97);

-- Procedure with parameters

SELECT * FROM PRODUCTS;
SELECT * FROM SALES;

/* For every given product and the quantity,
   1) Check if product is available based on the required quantity.
   2) If available then modify the database tables accordingly. */




CREATE OR REPLACE PROCEDURE PRO_BUY_PRODUCTS(IN P_PRODUCT_NAME VARCHAR, IN P_QUANTITY INT)
LANGUAGE PLPGSQL
AS $$
DECLARE
	V_PRODUCT_CODE VARCHAR(40);
	V_PRICE        DOUBLE PRECISION;
    V_COUNT        INT;
BEGIN 

	 SELECT COUNT(1)
		INTO V_COUNT
	 FROM PRODUCTS
	 WHERE PRODUCT_NAME = P_PRODUCT_NAME
	 AND QUANTITY_REMAINING >= P_QUANTITY;

     IF V_COUNT > 0 THEN
		 
	     SELECT PRODUCT_CODE, PRICE 
	     INTO V_PRODUCT_CODE, V_PRICE
	     FROM PRODUCTS
	     WHERE PRODUCT_NAME = P_PRODUCT_NAME;
	
	     INSERT INTO SALES(ORDER_ID, ORDER_DATE, PRODUCT_CODE, QUANTITY_ORDERED, SALE_PRICE)
			 VALUES((SELECT COALESCE(MAX(ORDER_ID), 0) + 1 FROM SALES), CURRENT_DATE, V_PRODUCT_CODE, P_QUANTITY, (V_PRICE * P_QUANTITY));
	
	     UPDATE PRODUCTS
	     SET QUANTITY_REMAINING = (QUANTITY_REMAINING - P_QUANTITY)
			 , QUANTITY_SOLD = (QUANTITY_SOLD + P_QUANTITY)
		 WHERE PRODUCT_CODE = V_PRODUCT_CODE;
	
		 RAISE NOTICE 'Product Sold!';

    ELSE
		
		RAISE NOTICE 'Insufficient Quantity!';
		
	END IF;
END;
$$

SELECT * FROM PRODUCTS;
SELECT * FROM SALES;

CALL PRO_BUY_PRODUCTS('Google Pixel 6', 24);
