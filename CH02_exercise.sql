/* 1.請列出 sales_records 表中所有的資料。*/
SELECT * FROM sales_records;

/* 2.只想看產品跟價格，請只選取 product_name 和 sale_amount。*/
SELECT product_name, sale_amount FROM sales_records;

/* 3.找出所有在「一號本店」發生的銷售紀錄。*/
SELECT * FROM sales_records
	WHERE store_name = '一號本店';

/* 4.找出所有「非二號分店」的銷售紀錄。*/
SELECT * FROM sales_records
	WHERE store_name != '二號分店';

/* 5.找出所有 sale_amount 大於等於 500 元的交易。*/
SELECT * FROM sales_records
	WHERE sale_amount >= 500;

/* 6.找出所有 sale_amount 介於 100 到 1000 之間的產品名稱與金額（請使用 BETWEEN）。*/
SELECT product_name, sale_amount
	FROM sales_records
	where sale_amount BETWEEN 100 AND 1000;

/* 7.找出 product_name 是以「面」字開頭的產品（例如：面紙）。*/
SELECT product_name
	FROM sales_records
	WHERE product_name LIKE '面%'
	-WHERE product_name LIKE '面_'; <= 底線代表一個字元，所以只會抓到一個字元的資料

/* 8.找出 store_name 中包含「分店」兩個字的所有紀錄。*/
SELECT *
	FROM sales_records
	WHERE store_name LIKE '%分店%';

/* 9.請列出所有紀錄，並先依照 sale_date 由新到舊（最新日期在上）排序，如果日期相同，再依照 sale_amount 由高到低排序。*/
SELECT *
	FROM sales_records
	ORDER BY sale_date DESC,
		sale_amount DESC;

/* 10.找出在「一號本店」販售，且 sale_amount 超過 1000 元，或者是產品名稱中包含「盔甲」的所有紀錄。*/
SELECT *
	FROM sales_records
	WHERE store_name = '一號本店' AND
		(sale_amount >1000 OR product_name LIKE '%盔甲%'); 
