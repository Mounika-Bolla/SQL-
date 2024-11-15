CREATE TABLE RANDOM_TABLE(

	ID               INT,
	VALUE            DECIMAL
);

INSERT INTO RANDOM_TABLE
SELECT 1, RANDOM() FROM GENERATE_SERIES(1, 10000000);

INSERT INTO RANDOM_TABLE
SELECT 2, RANDOM() FROM GENERATE_SERIES(1, 10000000);

SELECT * FROM RANDOM_TABLE;


CREATE MATERIALIZED VIEW MV_RANDOM_TABLE
AS
SELECT ID, AVG(VALUE), COUNT(*) 
FROM RANDOM_TABLE
GROUP BY ID;

SELECT * FROM MV_RANDOM_TABLE;


DELETE FROM RANDOM_TABLE WHERE ID = 1;

REFRESH MATERIALIZED VIEW MV_RANDOM_TABLE;

CREATE VIEW V_RANDOM_TABLE
AS
SELECT ID, AVG(VALUE), COUNT(*) 
FROM RANDOM_TABLE
GROUP BY ID;

SELECT * FROM V_RANDOM_TABLE;
