-- 數學運算子
  -- +, add
  -- -, deduct
  -- *, multiple
  -- /, devide
  -- %, 模數(傳回餘數)
  -- ^, 指數
  -- |/, 平方根
  -- ||/, 立方根
  -- !, 階乘

-- 1.兩個integer做運算， 會回傳integer
-- 2.運算子任一側有numeric, 會回傳numeric
-- 3.只要有處理到浮點數, 會回傳double
    -- numeric(n, m), decimal(n, m)_整位數固定，小數位固定
    -- real_6位數精度 (變動)
    -- double_15位數精度 (變動)

-- 指數(^)、根數(|/)、階層(!)，經過左述運算子處裡的任何數值，會回傳 numeric, real, double(反正就是會回傳小數)

-- Add -----
COPY(
	SELECT 2 + 2	
)TO 'C:\temp\ch5_1.txt'
WITH(FORMAT CSV, HEADER);
/* -------------
?column?
4
----------------------------------------- */  -- 欄位名稱 ?column? 是正常的， 因為沒有指定欄位跟表格

-- Deduct -----
SELECT 9 - 1;    -- 8

-- Multiple -----
SELECT 3 * 4;    -- 12

-- Divide(傳回商數) -----
SELECT 11 / 6;	-- 1

-- Modulo(傳回模數) ----- 判斷是否為偶數 -> x % 2 == 0，代表是偶數
SELECT 11 % 6;	-- 5

-- 因為除數或被除數的資料型態是numeric，所以商數的資料型態一定是numeric
SELECT 11.0 / 6;	-- 1.8333333333333333
SELECT CAST (11 AS numeric(3,1)) / 6;	-- 1.8333333333333333

-- !!!! PostgreSQL 14+ 已廢棄 !、|/ 等符號運算子，實務上應一律使用 factorial()、sqrt()、cbrt() 函數，邏輯更清晰且不容易報錯。
SELECT 3 ^ 4;	-- 81
SELECT |/ 10;	-- 3.1622776601683795
SELECT sqrt(10);	-- 3.1622776601683795
SELECT cbrt(10);	-- 2.154434690031884
SELECT factorial(4); -- 4! = 24

-- 以上是PostgreSQL運算子的語法，用其他資料庫的話要看一下他自己的語法是什麼
-- 運算順序
	-- 1.指數、根
	-- 2.乘、除、餘數
	-- 3.加、減

SELECT 7 + 8 * 9;	-- 79
SELECT (7 + 8) * 9;	-- 135
SELECT 3 ^ 3 - 1;	-- 26
SELECT 3 ^ (3 - 1);	-- 9

-- ----------------
SELECT 
	geo_name, 
	state_us_abbreviation AS st,
	p0010001 AS "total population",	-- 新取的欄位名稱有空白要用 " 包起來
	p0010003 AS "white alone",
	p0010004 AS "black",
	p0010005 AS "Am Indian/Alaska Native Alone",
	p0010006 AS "Asian Alone",
	p0010007 AS "Native Hawaiian and Other Pacific Islander Alone",
	p0010008 AS "Some Other Race Alone",
	p0010009 AS "Two or More Races"
FROM us_counties_2010
LIMIT 5;

/*
geo_name|st|total population|white alone|black|Am Indian/Alaska Native Alone|Asian Alone|Native Hawaiian and Other Pacific Islander Alone|Some Other Race Alone|Two or More Races
Autauga County|AL|54571|42855|9643|232|474|32|466|869
Baldwin County|AL|182265|156153|17105|1216|1348|89|3631|2723
Barbour County|AL|27457|13180|12875|114|107|29|894|258
Bibb County|AL|22915|17381|5047|64|22|13|185|203
Blount County|AL|57322|53068|761|307|117|38|2347|684
*/

SELECT 
	geo_name, 
	state_us_abbreviation AS st,
	p0010003 AS "white alone",
	p0010004 AS "black",
	p0010003 + p0010004 AS "Total White and Black"
FROM us_counties_2010
LIMIT 5;

/*
geo_name|st|white alone|black|Total White and Black
Autauga County|AL|42855|9643|52498
Baldwin County|AL|156153|17105|173258
Barbour County|AL|13180|12875|26055
Bibb County|AL|17381|5047|22428
Blount County|AL|53068|761|53829
----------------------------------------- */

SELECT 
	geo_name, 
	state_us_abbreviation AS st,
	p0010001 AS Total,
	p0010003 + p0010004  + p0010005 + p0010006 + p0010007 + p0010008 + p0010009 AS "All Races",
	(p0010003 + p0010004  + p0010005 + p0010006 + p0010007 + p0010008 + p0010009) - p0010001 AS "Difference"
FROM us_counties_2010
ORDER BY "Difference" DESC;

/*
geo_name|st|total|All Races|Difference
Baldwin County|AL|182265|182265|0
Barbour County|AL|27457|27457|0
Bibb County|AL|22915|22915|0
Blount County|AL|57322|57322|0
Autauga County|AL|54571|54571|0		-- Difference 應該都是 0，檢查All Races的數字根Total有沒有對起來
----------------------------------------- */

SELECT 
	geo_name,
	state_us_abbreviation AS st,
	(p0010006::numeric(8,1) / p0010001) * 100 AS pct_asian	-- 因為p0010006本來是integer，p0010006 & p0010001 都是整數，得到的商只會是 0
FROM us_counties_2010
ORDER BY pct_asian DESC;

/*
geo_name|st|pct_asian
Honolulu County|HI|43.89497769109962474000
Aleutians East Borough|AK|35.97580388411333970100
San Francisco County|CA|33.27165361664607226500
Santa Clara County|CA|32.02237037519322063600
Kauai County|HI|31.32461880132953749400
Aleutians West Census Area|AK|28.87969789606185937800
Maui County|HI|28.80181355516230285300
Alameda County|CA|26.12511264534643120300
San Mateo County|CA|24.79194823307365429200
Queens County|NY|22.94266161359416368300
----------------------------------------- */

-- 變化百分比 --------
CREATE TABLE percent_change(
	department varchar(20),
	spend_2014 numeric(10,2),
	spend_2017 numeric(10,2)
);

INSERT INTO percent_change
VALUES
	('Building', 250000, 289000),
	('Assessor', 178556, 179500),
	('Library', 87777, 90001),
	('Clerk', 451980, 650000),
	('Police', 250000, 223000),
	('Recreation', 199000, 195000);

-- FUNCTION_round(), 小數四捨五入 --------
SELECT 
	department, 
	spend_2014,
	spend_2017,
	round((spend_2017 - spend_2014) / spend_2014 * 100, 1) AS pct_change
FROM percent_change;

/*
department|spend_2014|spend_2017|pct_change
Building|250000.00|289000.00|15.6
Assessor|178556.00|179500.00|0.5
Library|87777.00|90001.00|2.5
Clerk|451980.00|650000.00|43.8
Police|250000.00|223000.00|-10.8
Recreation|199000.00|195000.00|-2.0
----------------------------------------- */

-- AGGREGATE FUNCTIONS_sum(), avg(), 匯總函示: 加總、平均 --------
SELECT 
	sum(p0010001) AS "County Sum",
	round(avg(p0010001), 0) AS "County Average"
FROM us_counties_2010;

/*
County Sum|County Average
308745538|98233
----------------------------------------- */

-- median(), 中位數 = pr.50 --------
-- SQL裡沒有, 所以在SQL用percentile函示做這件事
-- 舉例：10,11,10,9,13,12, 中位數是11.5, 按照順序排：9,10,10,11,12,13, 10跟11的中間 -> 10.5
-- percentile_cont(n), 回傳連續的資料值 ***
-- percentile_disc(n), 離散, 回傳 n百分位的最後一個數字
CREATE TABLE percentile_test(
	numbers integer
);

INSERT INTO percentile_test(numbers) VALUES
	(1), (2), (3), (4), (5), (6);

SELECT
	percentile_cont(.5) WITHIN GROUP (ORDER BY numbers),
	percentile_disc(.5) WITHIN GROUP (ORDER BY numbers)
FROM percentile_test;

/*
percentile_cont|percentile_disc
3.5|3
----------------------------------------- */

SELECT 
	sum(p0010001) AS "County Sum",
	round(avg(p0010001), 0) AS "County Average",
	percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001) AS "County Median"
FROM us_counties_2010;

-- 中位數 > 平均值 => 右偏(尾巴在右邊), 大部分數值落在平均數左邊

/*
County Sum|County Average|County Median
308745538|98233|25857
----------------------------------------- */

SELECT percentile_cont(array[.25, .5, .7])
	WITHIN GROUP (ORDER BY p0010001) AS "quartiles"
FROM us_counties_2010;

-- 四分位
-- 構造函式(陣列)， 把資料放在陣列裡

/*
"quartiles"
{11104.5,25857,52364.39999999997}
----------------------------------------- */

SELECT unnest(
	percentile_cont(array[.25, .5, .7])
	WITHIN GROUP (ORDER BY p0010001)
)AS "quartiles"
FROM us_counties_2010;

-- 上面那個是陣列， 用 unnest 轉換成陣列

/*
"quartiles"
11104.5
25857
52364.39999999997
----------------------------------------- */

-- 自建一個函數， 後面會講建立函數， 這邊先帶過
-- 因為PostSQL裡面沒有 median() 

CREATE OR REPLACE FUNCTION _final_median(anyarray)
	RETURNS float8 AS
$$
	WITH q AS
	(
		SELECT val
		FROM unnest($1) val
		WHERE VAL IS NOT NULL
		ORDER BY 1
	),
	cnt AS
	(
		SELECT COUNT(*) AS c FROM q
	)
	SELECT AVG(val)::float8
	FROM
	(
		SELECT val FROM q
		LIMIT 2 - MOD((SELECT c FROM cnt), 2)
		OFFSET GREATEST(CEIL((SELECT c FROM cnt)/ 2.0) - 1.0)
	) q2;
$$
LANGUAGE sql IMMUTABLE;
