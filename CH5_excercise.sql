-- 【習題】
-- 1. 撰寫一道SQL陳述， 計算半徑5英寸的圓面積
SELECT 5^2 * pi();

-- 2. 資料：2010年人口普查，計算紐約州有哪一個郡的「只包含美裔印地安人或阿拉斯加原住民(p0010005)」人口比例最高。網路中有很多研究，解釋何以該地相較紐約州其他地區有更多的美裔印地安人，從中習得什麼?

SELECT geo_name, p0010001, p0010005, 
	ROUND(p0010005::numeric/ p0010001, 4) * 100 AS "proportion"
FROM us_counties_2010
WHERE state_us_abbreviation = 'NY'
ORDER BY proportion DESC;


-- 3. 2010年的每郡人口中位數，是加州比較高還是紐約州?

SELECT state_us_abbreviation,
	percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001) AS "50th per"
FROM us_counties_2010
WHERE state_us_abbreviation IN ('NY','CA')
GROUP BY state_us_abbreviation;

/*
"state_us_abbreviation"	"50th per"
"CA"	179140.5
"NY"	91301
---------- */

-- ANS：加州

-- chatGPT習題------------------------------
/* 1. 運算順序與資料型態
請判斷下列 SQL 各自會回傳什麼數值，並說明回傳型態較可能是 integer、numeric 還是浮點數。
SELECT 18 / 5;
SELECT 18.0 / 5;
SELECT 4 + 3 * 2 ^ 2;
SELECT (4 + 3) * 2 ^ 2; */

SELECT 18 / 5;	integer
SELECT 18.0 / 5;	numeric
SELECT 4 + 3 * 2 ^ 2;	-- X：integer, 因為有指數運算所以是numeric
SELECT (4 + 3) * 2 ^ 2;	-- X：integer, 因為有指數運算所以是numeric
-- ----------
/*2. 偶數與餘數
請撰寫 SQL，從 percentile_test 資料表中找出所有偶數，並新增一個欄位 remainder，顯示每個數字除以 2 的餘數。
預期欄位：
numbers | remainder*/

SELECT numbers,
	numbers%2 AS remainder
FROM percentile_test
WHERE numbers % 2 = 0;
-- ----------
/*3. 人口比例計算
使用 us_counties_2010，計算每個郡的黑人居民 p0010004 占總人口 p0010001 的百分比。
要求：
	欄位包含 geo_name、州縮寫、總人口、黑人居民人數及百分比。
	百分比四捨五入至小數點後 2 位。
	由比例最高排到最低。
	只顯示前 10 筆。
	注意避免整數相除。*/

SELECT geo_name, 
	state_us_abbreviation, 
	p0010001, 
	p0010004,
	round(p0010004::numeric/p0010001*100, 2) AS "percentage"
FROM us_counties_2010
ORDER BY percentage DESC
LIMIT 10;
-- ----------
/*5. 部門支出分析
使用 percent_change 資料表，撰寫 SQL 顯示：
	部門名稱
	2014 年支出
	2017 年支出
	支出金額差異
	支出變化百分比
變化百分比需四捨五入至小數點後 1 位，並只顯示支出下降的部門，按照下降幅度由大到小排列。*/

SELECT
    department,
    spend_2014,
    spend_2017,
    spend_2017 - spend_2014 AS "Difference",
    round( (spend_2017 - spend_2014) / spend_2014 * 100,1) AS "Rate"
FROM percent_change
WHERE Rate < 0	-- 比較有效率的寫法：WHERE spend_2017 < spend_2014
ORDER BY "Rate" ASC;
-- ----------
/*6. 州人口統計比較
使用 us_counties_2010，比較加州 CA、紐約州 NY、德州 TX 各郡總人口的下列統計量：
	郡的數量
	人口總和
	平均數
	中位數
	第 25 百分位數
	第 75 百分位數
	眾數
每一州顯示一列，並按照人口中位數由高到低排序。*/

SELECT state_us_abbreviation,
	count(*) AS "Geo Numbers",
	sum(p0010001) AS "Sum",
	avg(p0010001) AS "Average",
	percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001) AS "Median",
	percentile_cont(.25) WITHIN GROUP (ORDER BY p0010001) AS "percentage_25",
	percentile_cont(.75) WITHIN GROUP (ORDER BY p0010001) AS "percentage_75",
	mode() WITHIN GROUP (ORDER BY p0010001) AS "Mode"
FROM us_counties_2010
WHERE state_us_abbreviation IN ('CA','NY','TX')
GROUP BY state_us_abbreviation DESC
ORDER BY Median;
