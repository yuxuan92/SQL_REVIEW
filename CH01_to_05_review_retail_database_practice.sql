CREATE TABLE products(
    product_id BIGSERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC(8,2) CHECK (price >= 0),
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    status VARCHAR(10) DEFAULT '販售中'
);

CREATE TABLE members( 
  member_id BIGSERIAL PRIMARY KEY, 
  member_name VARCHAR(50) NOT NULL, 
  phone VARCHAR(10) UNIQUE, 
  gender VARCHAR(4) CHECK (gender IN ('男', '女', '其他')), 
  register_date DEFAULT CURRENT_DATE
);

INSERT INTO products
    (product_name, price, stock)
VALUES
    ('可樂', 35, 100),
    ('洋芋片', 45, 50),
    ('巧克力', 60, 20

--WAY1
INSERT INTO orders (customer_name)
VALUES ('王小明');

--WAY2
INSERT INTO orders
    (customer_name, amount, order_date)
VALUES
    ('王小明', DEFAULT, DEFAULT);

CREATE TABLE employees(
    employee_id BIGSERIAL PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    department VARCHAR(20)
        CHECK (department IN ('IT', 'HR', 'Sales', 'Finance')),
    salary NUMERIC(10,2)
        CHECK (salary >= 25000),
    hire_date DATE DEFAULT CURRENT_DATE
);

/*
Practical SQL - Chapters 1–5 Review

Topics:
- CREATE TABLE
- Data types
- PRIMARY KEY
- NOT NULL / UNIQUE
- CHECK constraints
- DEFAULT values
- INSERT
- Basic SELECT / WHERE / ORDER BY
*/
