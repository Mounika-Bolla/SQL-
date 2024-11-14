-- View is a database object which is created over an SQL query.
-- View does not store any data.
-- View is like a virtual table

SELECT * FROM TB_CUSTOMER_DATA;
SELECT * FROM TB_PRODUCT_INFO;
SELECT * FROM TB_ORDER_INFO;

CREATE OR REPLACE VIEW order_summary
 AS
 SELECT o.order_id,
    o.date,
    p.product_name,
    c.customer_name,
    (p.price * o.quantity)::double precision - (p.price * o.quantity)::double precision * o.discount_percentage::double precision / 100::double precision AS cost
   , c.customer_id
	FROM tb_customer_data c
     JOIN tb_order_info o ON c.customer_id = o.customer_id
     JOIN tb_product_info p ON p.product_id = o.product_id;

ALTER VIEW ORDER_SUMMARY RENAME COLUMN DATE TO ORDER_DATE;
ALTER VIEW ORDER_SUMMARY RENAME TO ORDER_SUMMAER_2;
SELECT * FROM ORDER_SUMMARY;
SELECT * FROM ORDER_SUMMAER_2;
DROP VIEW ORDER_SUMMAER_2;

-- What is the main purpose of using a view/ advantages of views.
-- 1) SECURITY by hiding the query used to generate the view.
-- 2) To simplify complex SQL queries
      --> Sharing a view is better than sharing complex query
      --> Avoid re-writing same complex query multiple times

CREATE ROLE JAMES
LOGIN
PASSWORD 'James';

GRANT SELECT ON ORDER_SUMMARY TO JAMES;

-- Using CREATE or REPLACE and Modifying a View

-- Rules when using CREATE or REPLACE 
 -- 1) Cannot change the column name of existing view
 -- 2) Cannot change column data type of view
 -- 3) Cnnot change the order of coulmn


----------------------------------------------------------------------------------
CREATE OR REPLACE VIEW EXPENSIVE_PRODUCTS
	AS
SELECT * FROM TB_PRODUCT_INFO
	WHERE PRICE > 500;

SELECT * FROM EXPENSIVE_PRODUCTS;
SELECT * FROM TB_PRODUCT_INFO;
ALTER TABLE TB_PRODUCT_INFO ADD COLUMN PRODUCT_CONFIGURATION VARCHAR(100);

INSERT INTO tb_product_info (product_id, product_name, brand, price, product_configuration) VALUES
(11, 'MacBook Pro', 'Apple', 1299, null);


-- UPDATABLE VIEWS
-- 1) Views should be created using 1 table/view only
-- 2) View cannot have DISTINCT clause
-- 3) If query contains GROUP_BY then cannot update such views
-- 4) If query contains WITH clause then cannot update such views
-- 5) If query contains WINDOE FUNCTIONS then cannot update such views

CREATE OR REPLACE VIEW EXPENSIVE_PRODUCTS
	AS
SELECT * FROM TB_PRODUCT_INFO
	WHERE PRICE > 500;

SELECT * FROM EXPENSIVE_PRODUCTS;
SELECT * FROM TB_PRODUCT_INFO;

UPDATE EXPENSIVE_PRODUCTS
SET PRODUCT_NAME = 'Airpods Pro 2', BRAND = 'Apple'
WHERE PRODUCT_ID = 11;

SELECT * FROM ORDER_SUMMARY;

UPDATE ORDER_SUMMARY
SET COST = 300
WHERE ORDER_ID = 7;


CREATE OR REPLACE VIEW EXPENSIVE_PRODUCTS
	AS
SELECT DISTINCT * FROM TB_PRODUCT_INFO
	WHERE PRICE > 500;

UPDATE EXPENSIVE_PRODUCTS
SET PRODUCT_NAME = 'Airpods Pro 2', BRAND = 'Apple'
WHERE PRODUCT_ID = 11;

CREATE VIEW ORDER_COUNT
	AS
SELECT DATE, COUNT(1) AS NO_OF_ORDERS
FROM TB_ORDER_INFO
GROUP BY DATE;

SELECT * FROM ORDER_COUNT;

UPDATE ORDER_COUNT
SET NO_OF_ORDERS = 0
WHERE DATE = '2024-06-14';


----------------------------------------------------------------------------------------------------------------
-- WITH CHECK OPTION

CREATE OR REPLACE VIEW APPLE_PRODUCTS
	AS
SELECT * FROM TB_PRODUCT_INFO
WHERE BRAND = 'Apple'
WITH CHECK OPTION;

INSERT INTO APPLE_PRODUCTS
VALUES (13, 'Note 22', 'Samsung', 699, null);

INSERT INTO APPLE_PRODUCTS
VALUES (13, 'MacBook 3', 'Apple', 699, null);
SELECT * FROM TB_PRODUCT_INFO;
SELECT * FROM APPLE_PRODUCTS;