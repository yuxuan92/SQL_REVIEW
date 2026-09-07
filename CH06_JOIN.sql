/*
SELECT *
FROM table_a JOIN table_b
ON table_a_key_column = table_b_foreign_key_column

-- table_a 是主要的表格，把 table_b 的資料串到 table_a
-- ON的那一列也可以用 布林值

ON table_a_key_column >= table_b_foreign_key_column
*/

-- 先建個等等要用的表格

CREATE TABLE departments (
  dept_id BIGSERIAL,
  dept VARCHAR(100),
  city VARCHAR(100),
  CONSTRAINT dept_key PRIMARY KEY (dept_id),        -- dept_key規則：dept_id 是這張表的主鍵
  CONSTRAINT dept_city_unique UNIQUE (dept, city)   -- dept_city_unique規則：(dept, city) 這個「組合」必須唯一
);

CREATE TABLE employees (
  emp_id BIGSERIAL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  salary INTEGER,
  dept_id INTEGER REFERENCES departments(dept_id),  -- employees的dept_id輸入的值必須要存在departments的dept_id
  CONSTRAINT emp_key PRIMARY KEY (emp_id),
  CONSTRAINT emp_dept_unique UNIQUE (emp_id, dept_id)
);

-- 輸入一些資料

INSERT INTO departments(dept, city)
VALUES
    ('Tax', 'Atlanta'),
    ('IT', 'Boston');

INSERT INTO employees(first_name, last_name, salary, dept_id)
VALUES
  ('Nancy', 'Jones', 62500, 1),
  ('Lee', 'Smith', 59300, 1),
  ('Soo', 'Nguyen', 83000, 2),
  ('Janet', 'King', 95000, 2);

-- JOIN----------

SELECT *
FROM employees JOIN departments
ON employees.dept_id = departments.dept_id;

/*
"emp_id"	"first_name"	"last_name"	"salary"	"dept_id"	"dept_id-2"	"dept"	"city"
1	"Nancy"	"Jones"	62500	1	1	"Tax"	"Atlanta"
2	"Lee"	"Smith"	59300	1	1	"Tax"	"Atlanta"
3	"Soo"	"Nguyen"	83000	2	2	"IT"	"Boston"
4	"Janet"	"King"	95000	2	2	"IT"	"Boston"

前面5欄是employees的表， 後面3欄是departments的表 => 兩張表串起來
*/

-- 再建兩張表討論LEFT JOIN, RIGHT JOIN, FULL OUTER JOIN ,CROSS JOIN

CREATE TABLE schools_left (
  id INTEGER CONSTRAINT left_id_key PRIMARY KEY,    -- 也可以寫  id INTEGER PRIMARY KEY, 只是沒有幫這個規則取名字而已
  left_school VARCHAR(30)
);

-- 補充 1.資料表層級寫法 v.s. 2.欄位層級寫法 v.s. 3.欄位層級但不命名
--1. CONSTRAINT left_id_key PRIMARY KEY (id)
--2. id INTEGER CONSTRAINT left_id_key PRIMARY KEY
--3. id INTEGER PRIMARY KEY

CREATE TABLE schools_right (
  id INTEGER CONSTRAINT right_id_key PRIMARY KEY,
  right_school VARCHAR(30)
);

INSERT INTO schools_left (id, left_school) VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (5, 'Washington Middle School'),
    (6, 'Jefferson High School');

INSERT INTO schools_right (id, right_school) VALUES
    (1, 'Oak Street School'),
    (2, 'Roosevelt High School'),
    (3, 'Morrison Elementary'),
    (4, 'Chase Magnet Academy'),
    (6, 'Jefferson High School');

-- LEFT JOIN----------
SELECT *
FROM schools_left LEFT JOIN schools_right
ON schools_left.id = schools_right.id;

/*
"id"	   "left_school"	            "id-2"	"right_school"
1	      "Oak Street School"	        1	      "Oak Street School"
2	      "Roosevelt High School"	    2	      "Roosevelt High School"
5	      "Washington Middle School"		
6	      "Jefferson High School"	    6	      "Jefferson High School"
*/

-- 以 left(FROM 旁那個表格) 為主， 把另一個串近來 => 所以 schools_left 的資料是完整的

-- RIGHT JOIN----------
SELECT *
FROM schools_left RIGHT JOIN schools_right
ON schools_left.id = schools_right.id;

/*
"id"	"left_school"	          "id-2"	"right_school"
1	    "Oak Street School"	    1	      "Oak Street School"
2	    "Roosevelt High School"	2	      "Roosevelt High School"
		                          3	      "Morrison Elementary"
		                          4	      "Chase Magnet Academy"
6	"Jefferson High School"	    6	      "Jefferson High School"
*/

-- -- 以 right(FROM 後面那個表格) 為主， 把另一個串近來 => 所以 schools_right 的資料是完整的

-- FULL OUTER JOIN----------
SELECT *
FROM schools_left FULL JOIN schools_right
ON schools_left.id = schools_right.id;

/*
"id"	"left_school"				"id-2"	"right_school"
1		"Oak Street School"			1		"Oak Street School"
2		"Roosevelt High School"		2		"Roosevelt High School"
5		"Washington Middle School"		
6		"Jefferson High School"		6		"Jefferson High School"
									4		"Chase Magnet Academy"
									3		"Morrison Elementary"
*/

-- 少用， 但可以檢查重疊的資料有多少

-- CROSS JOIN----------
-- Cartesian product, left_schools 有 4 筆資料, right_schools 有 5 筆資料 => 一共會有 4 * 5 的組合
-- 資料量很多會跑很久
SELECT *
FROM schools_left CROSS JOIN schools_right;

/*
"id"	"left_school"	"id-2"	"right_school"
1	"Oak Street School"	1	"Oak Street School"
1	"Oak Street School"	2	"Roosevelt High School"
1	"Oak Street School"	3	"Morrison Elementary"
1	"Oak Street School"	4	"Chase Magnet Academy"
1	"Oak Street School"	6	"Jefferson High School"
2	"Roosevelt High School"	1	"Oak Street School"
2	"Roosevelt High School"	2	"Roosevelt High School"
2	"Roosevelt High School"	3	"Morrison Elementary"
2	"Roosevelt High School"	4	"Chase Magnet Academy"
2	"Roosevelt High School"	6	"Jefferson High School"
5	"Washington Middle School"	1	"Oak Street School"
5	"Washington Middle School"	2	"Roosevelt High School"
5	"Washington Middle School"	3	"Morrison Elementary"
5	"Washington Middle School"	4	"Chase Magnet Academy"
5	"Washington Middle School"	6	"Jefferson High School"
6	"Jefferson High School"	1	"Oak Street School"
6	"Jefferson High School"	2	"Roosevelt High School"
6	"Jefferson High School"	3	"Morrison Elementary"
6	"Jefferson High School"	4	"Chase Magnet Academy"
6	"Jefferson High School"	6	"Jefferson High School"
*/

-- NULL ----------
SELECT *
FROM schools_left LEFT JOIN schools_right
ON schools_left.id = schools_right.id
WHERE schools_right.id IS NULL;	

/*
"id"	"left_school"				"id-2"	"right_school"
5		"Washington Middle School"		
*/

-- ie. left_schools 有，但 right_schools 沒有

-- 有 JOIN 欄位名又重複的話要說是哪個表格的哪個欄位，不過最好是養成習慣都加上表格名
SELECT schools_left.id,
	schools_left.left_school,
	schools_right.right_school
FROM schools_left JOIN schools_right
ON schools_left.id = schools_right.id;

-- 用別名簡化程式碼 ----------
SELECT lt.id,
	lt.left_school,
	rt.right_school
FROM schools_left AS lt JOIN schools_right AS rt
ON lt.id = rt.id;

-- 建個表等等用
CREATE TABLE schools_enrollment(
	id INTEGER,
	enrollment INTEGER
);

CREATE TABLE schools_grades(
	id INTEGER,
	grades VARCHAR(10)
);

INSERT INTO schools_enrollment(id, enrollment)
VALUES
	(1, 360),
	(2,1001),
	(5, 450),
	(6, 927);

INSERT INTO schools_grades(id, grades)
VALUES
	(1, 'K-3'),
	(2, '9-12'),
	(5, '6-8'),
	(6, '9-12');

-- JOIN 再結合一個表 ----------
SELECT lt.id, 
	lt.left_school, 
	en.enrollment, 
	gr.grades
FROM schools_left AS lt LEFT JOIN schools_enrollment AS en
	ON lt.id = en.id
LEFT JOIN schools_grades AS gr
	ON lt.id = gr.id;		-- 以 lt.id 為主把另外兩張表串近來

/*
"id"	"left_school"				"enrollment"	"grades"
1		"Oak Street School"			360				"K-3"
2		"Roosevelt High School"		1001			"9-12"
5		"Washington Middle School"	450				"6-8"
6		"Jefferson High School"		927				"9-12"
*/

-- 建個表等等用

CREATE TABLE us_counties_2000 (
    geo_name varchar(90),              -- County/state name,
    state_us_abbreviation varchar(2),  -- State/U.S. abbreviation
    state_fips varchar(2),             -- State FIPS code
    county_fips varchar(3),            -- County code
    p0010001 integer,                  -- Total population
    p0010002 integer,                  -- Population of one race:
    p0010003 integer,                      -- White Alone
    p0010004 integer,                      -- Black or African American alone
    p0010005 integer,                      -- American Indian and Alaska Native alone
    p0010006 integer,                      -- Asian alone
    p0010007 integer,                      -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,                      -- Some Other Race alone
    p0010009 integer,                  -- Population of two or more races
    p0010010 integer,                  -- Population of two races
    p0020002 integer,                  -- Hispanic or Latino
    p0020003 integer                   -- Not Hispanic or Latino:
);

COPY us_counties_2000
FROM 'C:\temp\us_counties_2000.csv'
WITH (FORMAT CSV, HEADER);

SELECT c2010.geo_name,
	c2010.state_us_abbreviation AS state,
	c2010.p0010001 AS pop_2010,
	c2000.p0010001 AS pop_2000,
	c2010.p0010001 - c2000.p0010001 AS raw_change,
	round( (c2010.p0010001::numeric(8,1) - c2000.p0010001) / c2000.p0010001 * 100, 1) AS pct_change
FROM us_counties_2010 c2010 JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips			-- 	州代碼
	AND c2010.county_fips = c2000.county_fips	--	郡代碼  =>  州代碼+郡代碼 : 唯一KEY值
	AND c2010.p0010001 <> c2000.p0010001		--  人口有變化的才看
ORDER BY pct_change DESC;

/*
"geo_name"			"state"	"pop_2010"	"pop_2000"	"raw_change"	"pct_change"
"Kendall County"	"IL"	114736		54544		60192			110.4
"Pinal County"		"AZ"	375770		179727		196043			109.1
"Flagler County"	"FL"	95696		49832		45864			92.0
"Lincoln County"	"SD"	44828		24131		20697			85.8
"Loudoun County"	"VA"	312311		169599		142712			84.1
*/
