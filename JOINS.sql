/* What are joins? Why do we use them? */
DROP TABLE EMPLOYEE;
DROP TABLE EMPLOYEE_HISTORY;
DROP TABLE DEPARTMENT;
DROP TABLE DEPARTMENT_HISTORY;

CREATE TABLE DEPARTMENT
(
	  DEPARTMENT_ID         VARCHAR(20)   PRIMARY KEY
	, DEPARTMENT_NAME       VARCHAR(50)
	
);

CREATE TABLE MANAGER
(
	  MANAGER_ID            VARCHAR(20)   PRIMARY KEY
	, MANAGER_NAME          VARCHAR(50)   NOT NULL
	, DEPARTMENT_ID         VARCHAR(20)	
	, CONSTRAINT FK_MGR_DEPT FOREIGN KEY(DEPARTMENT_ID) REFERENCES DEPARTMENT(DEPARTMENT_ID)
);


CREATE TABLE EMPLOYEE
(
	  EMPLOYEE_ID         VARCHAR(20)    PRIMARY KEY
	, EMPLOYEE_NAME       VARCHAR(50)    NOT NULL
	, SALARY              INT
	, DEPARTMENT_ID       VARCHAR(20)
	, MANAGER_ID          VARCHAR(20)
	, CONSTRAINT FK_EMP_DEPT FOREIGN KEY(DEPARTMENT_ID) REFERENCES DEPARTMENT(DEPARTMENT_ID)
	, CONSTRAINT FK_EMP_MGR FOREIGN KEY(MANAGER_ID) REFERENCES MANAGER(MANAGER_ID)
);


CREATE TABLE PROJECTS
(
      PROJECT_ID            VARCHAR(20)    PRIMARY KEY
    , PROJECT_NAME          VARCHAR(50)
    , TEAM_MEMBER_ID        VARCHAR(20)
);

INSERT INTO DEPARTMENT (DEPARTMENT_ID, DEPARTMENT_NAME) VALUES
('D001', 'Human Resources'),
('D002', 'Finance'),
('D003', 'Engineering'),
('D004', 'Sales');
INSERT INTO MANAGER (MANAGER_ID, MANAGER_NAME, DEPARTMENT_ID) VALUES
('M001', 'Alice Johnson', 'D001'),
('M002', 'Bob Smith', 'D002'),
('M003', 'Carol White', 'D003'),
('M004', 'David Black', 'D004');
INSERT INTO EMPLOYEE (EMPLOYEE_ID, EMPLOYEE_NAME, SALARY, DEPARTMENT_ID, MANAGER_ID) VALUES
('E001', 'John Doe', 60000, 'D001', 'M001'),
('E002', 'Jane Smith', 75000, 'D002', 'M002'),
('E003', 'Jim Brown', 80000, 'D003', 'M003'),
('E004', 'Jill White', 70000, 'D004', 'M004'),
('E005', 'Jack Black', 65000, 'D001', 'M001'),
('E006', 'Jenny Green', 62000, 'D002', 'M002');
INSERT INTO PROJECTS (PROJECT_ID, PROJECT_NAME, TEAM_MEMBER_ID) VALUES
('P001', 'Project Alpha', 'E001'),
('P002', 'Project Beta', 'E002'),
('P003', 'Project Gamma', 'E003'),
('P004', 'Project Delta', 'E004'),
('P005', 'Project Epsilon', 'E005');

----------------------------------------------------------------------
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM MANAGER;
SELECT * FROM PROJECTS;



-- Q) Fetch the employee name and department name they belong to.
-- Inner Join/ Join: The records which are present in both the table will be fectched from the inner join
-- Fetches matching records
SELECT E.EMPLOYEE_NAME , D.DEPARTMENT_NAME FROM EMPLOYEE E 
JOIN 
DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- Q) Fetch all the employee name and their department name they belong to.
-- Left Join:
-- LEFT JOIN = INNER JOIN + ANY ADDITIONAL RECORDS IN THE LEFT TABLE
	
SELECT E.EMPLOYEE_NAME , D.DEPARTMENT_NAME FROM EMPLOYEE E 
LEFT JOIN 
DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- Q) Fetch employee name and ALL THE department name they belong to.
-- Right Join:
-- RIGHT JOIN = INNER JOIN + ANY ADDITIONAL RECORDS IN THE RIGHT TABLE

SELECT E.EMPLOYEE_NAME , D.DEPARTMENT_NAME FROM EMPLOYEE E 
RIGHT JOIN 
DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- Q) Fetch all the employees, their managers, their department and the projects they work on.

SELECT E.EMPLOYEE_NAME, D.DEPARTMENT_NAME, M.MANAGER_NAME, P.PROJECT_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN MANAGER M ON E.MANAGER_ID = M.MANAGER_ID
LEFT JOIN PROJECTS P ON P.TEAM_MEMBER_ID = E.EMPLOYEE_ID;

-- Full Outer Join/ Full Join
-- Full Join = Inner Join 
--                        + all remaning records from left table  (returns null value for any columns fetches)
--                        + all remaning records from right table  (returns null value for any columns fetches)

SELECT E.EMPLOYEE_NAME, D.DEPARTMENT_NAME
FROM EMPLOYEE E
FULL JOIN
DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

-- LEFT JOIN ==> LEFT OUTER JOIN
-- RIGHT JOIN ==> RIGHT OUTER JOIN
-- INNER JOIN ==> JOIN

-- Cross Join
-- Cross join returns Cartesian product.
-- Cross join does not need join condition.

CREATE TABLE COMPANY
(
      COMPANY_ID   VARCHAR(20)   PRIMARY KEY
    , COMPANY_NAME VARCHAR(50)
    , LOCATION     VARCHAR(50)
);
INSERT INTO COMPANY (COMPANY_ID, COMPANY_NAME, LOCATION) VALUES
('C001', 'Tech Innovators Inc.', 'San Francisco');

SELECT * FROM COMPANY;

SELECT E.EMPLOYEE_NAME, D.DEPARTMENT_NAME
FROM EMPLOYEE E
CROSS JOIN
DEPARTMENT D;

-- Write a query to fetch the employee name and their corresponding department name.
-- Also make sure to display the company name and company location corresponding to each employee.

SELECT E.EMPLOYEE_NAME, D.DEPARTMENT_NAME, C.COMPANY_NAME, C.LOCATION
FROM EMPLOYEE E
JOIN
DEPARTMENT D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
CROSS JOIN COMPANY C;

-- Natural Join

SELECT E.EMPLOYEE_NAME, D.DEPARTMENT_NAME
FROM EMPLOYEE E
NATURAL JOIN
DEPARTMENT D;

ALTER TABLE DEPARTMENT RENAME DEPARTMENT_ID TO ID;

CREATE TABLE FAMILY
(
      MEMBER_ID   VARCHAR(20)   PRIMARY KEY
    , NAME        VARCHAR(50)
    , AGE         INT
    , PARENT_ID   VARCHAR(20)
    , CONSTRAINT FK_PARENT FOREIGN KEY (PARENT_ID) REFERENCES FAMILY (MEMBER_ID)
);
INSERT INTO FAMILY (MEMBER_ID, NAME, AGE, PARENT_ID) VALUES
('F001', 'John Smith', 60, NULL),
('F002', 'Jane Smith', 58, NULL),
('F003', 'Michael Smith', 35, 'F001'),
('F004', 'Emily Smith', 32, 'F001'),
('F005', 'William Smith', 10, 'F003'),
('F006', 'Samantha Smith', 8, 'F003'),
('F007', 'Andrew Smith', 6, 'F004'),
('F008', 'Olivia Smith', 4, 'F004');

SELECT * FROM FAMILY;

-- Self Join

-- Q) Write a query to fetch the child name and their age corresponding to their parent name and parent age

SELECT CHILD.NAME AS CHILD_NAME, CHILD.AGE AS CHILD_AGE
	, PARENT.NAME AS PARENT_NAME, PARENT.AGE AS PARENT_AGE
FROM FAMILY AS CHILD
LEFT JOIN 
FAMILY AS PARENT ON CHILD.PARENT_ID = PARENT.MEMBER_ID;