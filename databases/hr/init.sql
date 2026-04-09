-- HR Database Schema and Data

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS emp_audit;
GO
DROP TABLE IF EXISTS job_history;
GO
DROP TABLE IF EXISTS employees;
GO
DROP TABLE IF EXISTS jobs;
GO
DROP TABLE IF EXISTS departments;
GO
DROP TABLE IF EXISTS locations;
GO
DROP TABLE IF EXISTS countries;
GO
DROP TABLE IF EXISTS regions;
GO

-- REGIONS
CREATE TABLE regions (
region_id INT NOT NULL PRIMARY KEY,
region_name VARCHAR(25)
);
GO

-- COUNTRIES
CREATE TABLE countries (
country_id CHAR(2) NOT NULL PRIMARY KEY,
country_name VARCHAR(60),
region_id INT,
CONSTRAINT fk_countries_regions
FOREIGN KEY (region_id) REFERENCES regions(region_id)
);
GO

-- LOCATIONS
CREATE TABLE locations (
location_id INT PRIMARY KEY,
street_address VARCHAR(40),
postal_code VARCHAR(12),
city VARCHAR(30) NOT NULL,
state_province VARCHAR(25),
country_id CHAR(2),
CONSTRAINT fk_locations_countries
FOREIGN KEY (country_id) REFERENCES countries(country_id)
);
GO

-- DEPARTMENTS
CREATE TABLE departments (
department_id INT PRIMARY KEY,
department_name VARCHAR(30) NOT NULL,
manager_id INT NULL,
location_id INT,
total_salary DECIMAL(12,2) DEFAULT 0,
CONSTRAINT fk_departments_locations
FOREIGN KEY (location_id) REFERENCES locations(location_id)
);
GO

-- JOBS
CREATE TABLE jobs (
job_id VARCHAR(10) PRIMARY KEY,
job_title VARCHAR(50),
min_salary INT,
max_salary INT
);
GO

-- EMPLOYEES
CREATE TABLE employees (
employee_id INT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100),
hire_date DATE,
job_id VARCHAR(10),
salary DECIMAL(10,2),
commission_pct DECIMAL(5,2),
manager_id INT NULL,
department_id INT NULL,
CONSTRAINT fk_emp_jobs FOREIGN KEY (job_id) REFERENCES jobs(job_id),
CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
GO

-- JOB HISTORY
CREATE TABLE job_history (
employee_id INT,
start_date DATE,
end_date DATE,
job_id VARCHAR(10),
department_id INT
);
GO

-- AUDIT
CREATE TABLE emp_audit (
audit_id INT IDENTITY PRIMARY KEY,
employee_id INT,
action_type VARCHAR(10),
action_date DATETIME DEFAULT GETDATE(),
user_name VARCHAR(100) DEFAULT SUSER_NAME()
);
GO

-- =========================
-- REGIONS
-- =========================
INSERT INTO regions VALUES
(10,'Europe'),
(20,'Americas'),
(30,'Asia'),
(40,'Oceania'),
(50,'Africa');
GO

-- =========================
-- COUNTRIES
-- =========================
INSERT INTO countries VALUES
('IT','Italy',10),
('JP','Japan',30),
('US','United States of America',20),
('CA','Canada',20),
('CN','China',30),
('IN','India',30),
('AU','Australia',40),
('ZW','Zimbabwe',50),
('SG','Singapore',30),
('GB','United Kingdom',10),
('FR','France',10),
('DE','Germany',10),
('ZM','Zambia',50),
('EG','Egypt',50),
('BR','Brazil',20),
('CH','Switzerland',10),
('NL','Netherlands',10),
('MX','Mexico',20),
('KW','Kuwait',30),
('IL','Israel',30),
('DK','Denmark',10),
('ML','Malaysia',30),
('NG','Nigeria',50),
('AR','Argentina',20),
('BE','Belgium',10);
GO

-- =========================
-- LOCATIONS
-- =========================
INSERT INTO locations VALUES
(1000,'1297 Via Cola di Rie','00989','Roma',NULL,'IT'),
(1100,'93091 Calle della Testa','10934','Venice',NULL,'IT'),
(1200,'2017 Shinjuku-ku','1689','Tokyo','Tokyo','JP'),
(1300,'9450 Kamiya-cho','6823','Hiroshima',NULL,'JP'),
(1400,'2014 Jabberwocky Rd','26192','Southlake','Texas','US'),
(1500,'2011 Interiors Blvd','99236','South San Francisco','California','US'),
(1600,'2007 Zagora St','50090','South Brunswick','New Jersey','US'),
(1700,'2004 Charade Rd','98199','Seattle','Washington','US'),
(1800,'147 Spadina Ave','M5V 2L7','Toronto','Ontario','CA'),
(1900,'6092 Boxwood St','YSW 9T2','Whitehorse','Yukon','CA');
GO

-- =========================
-- DEPARTMENTS
-- =========================
INSERT INTO departments VALUES
(10,'Administration',NULL,1700,0),
(20,'Marketing',NULL,1800,0),
(30,'Purchasing',NULL,1700,0),
(40,'Human Resources',NULL,1400,0),
(50,'Shipping',NULL,1500,0),
(60,'IT',NULL,1400,0),
(70,'Public Relations',NULL,1700,0),
(80,'Sales',NULL,1500,0),
(90,'Executive',NULL,1700,0),
(100,'Finance',NULL,1700,0),
(110,'Accounting',NULL,1700,0);
GO

-- =========================
-- JOBS
-- =========================
INSERT INTO jobs VALUES
('AD_PRES','President',20000,40000),
('AD_VP','Administration Vice President',15000,30000),
('AD_ASST','Administration Assistant',3000,6000),
('FI_MGR','Finance Manager',8200,16000),
('FI_ACCOUNT','Accountant',4200,9000),
('AC_MGR','Accounting Manager',8200,16000),
('AC_ACCOUNT','Public Accountant',4200,9000),
('SA_MAN','Sales Manager',10000,20000),
('SA_REP','Sales Representative',6000,12000),
('IT_PROG','Programmer',4000,10000),
('MK_MAN','Marketing Manager',9000,15000),
('MK_REP','Marketing Representative',4000,9000);
GO

-- =========================
-- EMPLOYEES
-- =========================
INSERT INTO employees VALUES
(100,'Steven','King','SKING','2003-06-17','AD_PRES',24000,NULL,NULL,90),
(101,'Neena','Kochhar','NKOCHHAR','2005-09-21','AD_VP',17000,NULL,100,90),
(102,'Lex','De Haan','LDEHAAN','2001-01-13','AD_VP',17000,NULL,100,90),
(103,'Alexander','Hunold','AHUNOLD','2006-01-03','IT_PROG',9000,NULL,102,60),
(104,'Bruce','Ernst','BERNST','2007-05-21','IT_PROG',6000,NULL,103,60),
(105,'David','Austin','DAUSTIN','2005-06-25','IT_PROG',4800,NULL,103,60),
(106,'Valli','Pataballa','VPATABAL','2006-02-05','IT_PROG',4800,NULL,103,60),
(107,'Diana','Lorentz','DLORENTZ','2007-02-07','IT_PROG',4200,NULL,103,60),
(108,'Nancy','Greenberg','NGREENBE','2002-08-17','FI_MGR',12000,NULL,101,100),
(109,'Daniel','Faviet','DFAVIET','2002-08-16','FI_ACCOUNT',9000,NULL,108,100),
(110,'John','Chen','JCHEN','2005-09-28','FI_ACCOUNT',8200,NULL,108,100),
(111,'Ismael','Sciarra','ISCIARRA','2005-09-30','FI_ACCOUNT',7700,NULL,108,100),
(112,'Jose Manuel','Urman','JMURMAN','2006-03-07','FI_ACCOUNT',7800,NULL,108,100),
(113,'Luis','Popp','LPOPP','2007-12-07','FI_ACCOUNT',6900,NULL,108,100);
GO

-- =========================
-- JOB_HISTORY
-- =========================
INSERT INTO job_history VALUES
(102,'1993-01-13','1998-07-24','IT_PROG',60),
(101,'1989-09-21','1993-10-27','AC_ACCOUNT',110),
(101,'1993-10-28','1997-03-15','AC_MGR',110),
(201,'1996-02-17','1999-12-19','MK_REP',20),
(114,'1998-03-24','1999-12-31','ST_CLERK',50),
(122,'1999-01-01','1999-12-31','ST_CLERK',50);
GO
