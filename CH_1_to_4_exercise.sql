/*
第一部分：建表與型態 (CH1, CH3)
1. 建立一張名為 product_catalog 的表，包含：
  sku_id: 固定 8 位的字串。
  product_name: 長度變動的文字（上限 100 字）。
  price: 能夠存到小數點後 2 位的精確數值。
  release_date: 存日期。

2. 撰寫一段語法，建立一張與 product_catalog 結構完全一樣的臨時表 product_temp。
*/

-- 1*
CREATE TABLE product_catalog(
	sku_id char(8),
	product_name varchar(100),
	price numeric(18, 2),
	release_date date
);

--2*
CREATE TEMPORARY TABLE product_temp (LIKE product_catalog);

/*
第二部分：條件篩選與排序 (CH2)
3. 從 us_counties_2010 中，找出 geo_name 裡包含 "New"（不分大小寫），且 population_count_100_percent 大於 100 萬的資料。

4. 承上題，請將結果依照人口數從多到少排序，且只取前 3 筆。
*/

-- 3
SELECT * FROM us_counties_2010
WHERE 
  geo_name ILIKE '%New%' AND
  population_count_100_percent > 1000000;

-- 4
SELECT * FROM us_counties_2010
WHERE 
  geo_name ILIKE '%New%' AND
  population_count_100_percent > 1000000
ORDER BY population_count_100_percent DESC
LIMIT 3;

/*
第三部分：COPY 匯出實務 (CH4)
5. 將 us_counties_2010 表中的 geo_name 和 internal_point_lat 兩個欄位，匯出到 C:\data\coords.csv。
要求：包含表頭，且使用 Tab 鍵 (提示: \t) 作為分隔符號。

6. 撰寫一段語法，將「土地面積大於水域面積」的所有郡縣資料，匯出到 C:\data\land_heavy.txt。
要求：CSV 格式，包含表頭。
*/

-- 5
COPY(
  SELECT geo_name, internal_point_lat FROM us_counties_2010
) TO 'C:\data\coords.csv'
WITH(FORMAT CSV, HEADER, DELIMITER E'\t');  -- ***跳脫字元 (Escape Character)，在 /t 前加一個 E***

--6
COPY (
  SELECT * FROM us_counties_2010
  WHERE area_land > area_water
) TO 'C:\data\land_heavy.txt'
WITH(FORMAT CSV, HEADER);


第四部分：COPY 匯入與 Staging ETL (CH4)
7. 假設妳有一個 C:\temp\new_prices.csv，內容只有 sku_id 和 price（有表頭），請寫出將此檔案匯入 product_catalog 對應欄位的 COPY 語法。

8. 承上題，如果 new_prices.csv 是用 冒號 : 當分隔符號，且商品名稱被 波浪號 ~ 包起來，妳的 WITH 參數要怎麼改寫？

第五部分：資料清洗與轉置 (CH4)
9. 在拋轉資料前，請寫一段語法把 product_catalog 裡面所有的舊資料清空，但不能刪除這張表。

10. 魔王題：請將臨時表 product_temp 的資料轉入正式表 product_catalog：
  sku_id, product_name, price 正常轉入。
  release_date 欄位請統一帶入 今天 的日期。
  過濾條件：只轉入 price 大於 0 的商品。
