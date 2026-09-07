/*實作題目：建立「門市銷售紀錄」
請依照以下需求，寫出完整的語法：
1. 建立資料庫：名稱為 store_db。
2. 建立資料表：名稱為 sales_records，包含以下欄位：
	sale_id (整數)
	store_name (字串)
	product_name (字串)
	sale_amount (數值)
	sale_date (日期)
3. 插入資料：手動輸入 3 筆 紀錄。*/

CREATE DATABASE store_db;

CREATE TABLE sales_records(
	sale_id bigserial,
	store_name varchar(50),
	product_name varchar(50),
	sale_amount numeric,
	sale_date date);

INSERT INTO sales_records(store_name, product_name, sale_amount, sale_date)
VALUES('一號本店', '面紙', 25, '2010-01-09'),
	('二號分店', '拖把', 699, '2017-10-10'),
	('一號本店', '盔甲', 9999999, '2026-01-01');

/*挑戰題：把「店號」也加進去
既然妳已經掌握了 bigserial 和基本的 INSERT，我們試著把這張表結構變得更像真實的零售業數據：
1. 刪除舊表：DROP TABLE sales_records;
2. 建立新表：保留原本的 bigserial 做流水號，但增加一個 store_id (字元型態) 來存店號。
3. 插入資料：練習如何同時處理「自動遞增欄位」與「手動輸入欄位」。*/

DROP TABLE sales_records;

CREATE TABLE sales_records(
	sale_id bigserial,
  store_id varchar(6),
	store_name varchar(50),
	product_name varchar(50),
	sale_amount numeric,
	sale_date date);

INSERT INTO sales_records(store_id, store_name, product_name, sale_amount, sale_date)
VALUES('312001', '一號本店', '面紙', 25, '2010-01-09'),
	('987067', '二號分店', '拖把', 699, '2017-10-10'),
	('342654', '一號本店', '盔甲', 9999999, '2026-01-01');
