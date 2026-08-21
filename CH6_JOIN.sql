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
