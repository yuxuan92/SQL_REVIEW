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
