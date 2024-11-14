-- View is a database object which is created over an SQL query.
-- View does not store any data.
-- View is like a virtual table

SELECT * FROM TB_CUSTOMER_DATA;
SELECT * FROM TB_PRODUCT_INFO;
SELECT * FROM TB_ORDER_INFO;

CREATE VIEW order_summary
 AS
 SELECT o.order_id,
    o.date,
    p.product_name,
    c.customer_name,
    (p.price * o.quantity)::double precision - (p.price * o.quantity)::double precision * o.discount_percentage::double precision / 100::double precision AS cost
   FROM tb_customer_data c
     JOIN tb_order_info o ON c.customer_id = o.customer_id
     JOIN tb_product_info p ON p.product_id = o.product_id;

SELECT * FROM ORDER_SUMMARY;

-- What is the main purpose of using a view/ advantages of views.
-- 1) SECURITY
-- 2) To simplify complex SQL queries

CREATE ROLE JAMES
LOGIN
PASSWORD 'James';

GRANT SELECT ON ORDER_SUMMARY TO JAMES;