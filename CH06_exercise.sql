-- 1.資料表us_counties_2010共有3143筆資料，us_counties_2000有3141筆。
--  這反應一項事實：政府會隨時因決策因素而持續調整郡級地域。
--  使用正確結合和NULL資料值， 找出哪些郡是資料表中沒有的。

SELECT c2010.geo_name,
	c2000.geo_name
FROM us_counties_2010 c2010
FULL OUTER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
	AND c2010.county_fips = c2000.county_fips
WHERE c2010.geo_name IS NULL OR
	c2000.geo_name IS NULL;

/*
"geo_name"	                          "geo_name-2"
"Hoonah-Angoon Census Area"	
"Petersburg Census Area"	
"Prince of Wales-Hyder Census Area"	
	                                    "Prince of Wales-Outer Ketchikan Census Area, Alaska"
"Skagway Municipality"	
	                                    "Skagway-Hoonah-Angoon Census Area, Alaska"
"Wrangell City and Borough"	
	                                    "Wrangell-Petersburg Census Area, Alaska"
"Broomfield County"	
	                                    "Clifton Forge city, Virginia"
*/
-- --------------------------------------------------------------
-- 2.使用 median(), percentile_cont() 找出每郡人口變化百分比的中位數

SELECT PERCENTILE_CONT(.5) WITHIN GROUP(ORDER BY pct_change)
FROM(
	SELECT 
		ROUND((c2010.p0010001::numeric - c2000.p0010001) / 
			c2000.p0010001 * 100, 1) AS pct_change
	FROM us_counties_2010 c2010
	JOIN us_counties_2000 c2000
	ON c2010.state_fips = c2000.state_fips
		AND c2010.county_fips = c2000.county_fips
		AND c2010.p0010001 <> c2000.p0010001
) AS country_change;

/*
"percentile_cont"
3.2
*/
-- -----------------------------------
-- 3.哪一郡在2000到2010年間損失人口最眾?
SELECT A.geo_name, A.state, pct_change
FROM(
	SELECT c2010.geo_name AS geo_name,
			c2010.state_us_abbreviation AS state,
			ROUND((c2010.p0010001::numeric - c2000.p0010001) / 
				c2000.p0010001 * 100, 1) AS pct_change
		FROM us_counties_2010 c2010
		JOIN us_counties_2000 c2000
		ON c2010.state_fips = c2000.state_fips
			AND c2010.county_fips = c2000.county_fips
			AND c2010.p0010001 <> c2000.p0010001
)AS A
ORDER BY pct_change ASC
LIMIT 1;

/*
"geo_name"	"state"	"pct_change"
"St. Bernard Parish"	"LA"	-46.6
*/
