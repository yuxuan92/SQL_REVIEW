-- 1.員工＋部門資料
/*--------------------
列出所有員工的：
  first_name
  last_name
  salary
  dept
  city
只需要顯示「有正確對應到部門」的員工。 
要求：
  使用 JOIN
  使用 alias
  不要 SELECT * 
--------------------*/

-- sol.
SELECT e.first_name,
	e.last_name,
	e.salary,
	d.dept,
	d.city
FROM employees AS e JOIN departments AS d
ON e.dept_id = d.dept_id;

-- 2.哪些部門沒有員工？
/*--------------------
假設現在多新增一個部門：
  INSERT INTO departments(dept, city)
  VALUES ('Marketing', 'Chicago');
找出：目前完全沒有任何員工的部門
輸出：
  dept_id
  dept
  city
這題自己判斷：
  哪張表應該完整保留？
  最後要檢查哪個欄位 IS NULL？
--------------------*/

-- sol.
SELECT d.dept_id,
	d.dept,
	d.city
FROM departments AS d LEFT JOIN employees AS e
ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;


--3.找出兩份學校名單的差異
/*--------------------
比較：
  schools_left
  schools_right
只顯示：只存在其中一張表，而不是兩張表都有的學校
輸出：
  left_id
  left_school
  right_id
  right_school
預期概念上會看到：
  Washington Middle School
  Morrison Elementary
  Chase Magnet Academy
但不要自己指定這三間，讓 JOIN 找出來。
--------------------*/

-- sol.
SELECT *
FROM schools_left AS l FULL JOIN schools_right AS r
ON l.id = r.id
WHERE l.id IS NULL 
	OR r.id IS NULL;


--4.完整學校資料
/*--------------------
以 schools_left 為主要名單，列出所有 schools_left 的學校，並接上：
  left_school
  enrollment
  grades
即使某間學校沒有 enrollment 或 grades，也不能因此消失。
最後依：enrollment
由多至少排列。
--------------------*/

-- sol.
SELECT l.left_school,
	e.enrollment,
	g.grades
FROM schools_left AS l 
	LEFT JOIN schools_grades AS g ON l.id = g.id
	LEFT JOIN schools_enrollment AS e ON l.id = e.id
ORDER BY e.enrollment DESC;

--schools_grades(id, grades)
--schools_enrollment(id, enrollment)
--schools_right(id, right_schools)
--schools_left(id, left_schools)


--5.哪個部門平均薪資最高？
/*--------------------
使用：
  employees
  departments
算出每個部門的：
  dept
  city
  avg_salary
再找出：
  平均薪資最高的部門
要求：
  JOIN
  AVG()
  GROUP BY
  ORDER BY
  LIMIT
--------------------*/
--employees(emp_id, first_name, last_name, salary, dept_id)
--departments(dept_id, dept_city)

-- sol.
SELECT d.dept,
	d.city,
	AVG(e.salary) AS avg_salary
FROM departments AS d RIGHT JOIN employees AS e
ON e.dept_id = d.dept_id
GROUP BY d.dept, d.city
ORDER BY avg_salary DESC
LIMIT 1;
-- ----------

--6.2000 → 2010 人口增加最多的 5 個郡
/*--------------------
使用：
  us_counties_2000
  us_counties_2010
輸出：
  geo_name
  state
  pop_2000
  pop_2010
  raw_change
只要：
  人口增加的郡
最後找出人口「增加人數」最多的前 5 名。
注意這次不是 pct_change，而是 實際增加多少人。
--------------------*/

-- sol.
SELECT * FROM us_counties_2000;
SELECT * FROM us_counties_2010;
--(geo_name, state_us_abbreviation, state_flips, county_flips, p0010001)

SELECT a.geo_name AS geo_name,
	a.state_us_abbreviation AS state,
	a.p0010001 AS pop_2000,
	b.p0010001 AS pop_2010,
	b.p0010001 - a.p0010001 AS raw_change
FROM us_counties_2000 AS a LEFT JOIN us_counties_2010 AS b
ON a.state_fips = b.state_fips
	AND a.county_fips = b.county_fips
WHERE b.p0010001 - a.p0010001 > 0
ORDER BY b.p0010001 - a.p0010001 DESC
LIMIT 5;

--7. 「人數增加最多」＝「成長率最高」嗎？
/*--------------------
接續上一題，同時算：
  raw_change
  pct_change
然後分別找：
  A. raw_change 最大的郡
  B. pct_change 最大的郡
各取第一名。
最後不用 SQL 回答一句：
這兩個第一名是不是同一個郡？為什麼可能不同？
這題其實比較接近真正的資料分析。
--------------------*/

-- sol.
SELECT a.geo_name AS geo_name,
	a.state_us_abbreviation AS state,
	a.p0010001 AS pop_2000,
	b.p0010001 AS pop_2010,
	b.p0010001 - a.p0010001 AS raw_change,
	ROUND((b.p0010001::numeric(8,1) - a.p0010001) / a.p0010001 * 100, 1) AS pct_change
FROM us_counties_2000 AS a LEFT JOIN us_counties_2010 AS b
ON a.state_fips = b.state_fips
	AND a.county_fips = b.county_fips
WHERE b.p0010001 - a.p0010001 > 0;
--raw_change(Maricopa County, Arizona(3072149,3817117,744968,24.2))
--pct_change(Kendall County, Illinois(54544,114736,60192,110.4))
--差異數大的郡基數本來就大，不代表成長率就大

--8. 找出人口衰退超過 10% 的郡
/*--------------------
比較 2000 與 2010，只留下：
  pct_change < -10
輸出：
  geo_name
  state
  pop_2000
  pop_2010
  pct_change
最後按照人口衰退幅度：
  最嚴重 → 最輕微
排序。
限制：
  這次不要把整段百分比公式在 SELECT、WHERE 裡各寫一次。
想辦法利用：
  FROM (
      ...
  ) AS ...
先算好 pct_change，外層再篩選。
--------------------*/

-- sol.
SELECT * FROM
	(SELECT a.geo_name,
		a.state_us_abbreviation AS state,
		a.p0010001 AS pop_2000,
		b.p0010001 AS pop_2010,
		ROUND((b.p0010001::numeric(8,1) - a.p0010001) / a.p0010001 * 100, 1) AS pct_change
	FROM us_counties_2000 AS a LEFT JOIN us_counties_2010 AS b
	ON a.state_fips = b.state_fips
		AND a.county_fips = b.county_fips)
WHERE pct_change < -10
ORDER BY pct_change ASC;

--9.找出「新增 / 消失」的郡，並標記狀態
/*--------------------
你前面已經成功找出：
  2010 有、2000 沒有
  2000 有、2010 沒有
這次再進一步。
輸出：
  county_2000
  county_2010
  status
其中 status 希望長這樣：
  ----------
  NULL                         Hoonah-Angoon Census Area     Added
  Clifton Forge city...        NULL                          Removed
  ----------
也就是：
  2010 有、2000 沒有 → Added
  2000 有、2010 沒有 → Removed
這題需要一個你可能還沒有正式學過的東西：
  CASE
      WHEN 條件 THEN '...'
      WHEN 條件 THEN '...'
  END
這題可以查書/查語法。 我故意放一題讓你自己摸新東西。
--------------------*/

-- sol.
SELECT
	county_2000,
	county_2010,
	CASE
		WHEN county_2000 IS NULL THEN 'Added'
		WHEN county_2010 IS NULL THEN 'Removed'
	END AS status
FROM
(SELECT a.geo_name AS county_2000,
	b.geo_name AS county_2010
FROM us_counties_2000 AS a FULL JOIN us_counties_2010 AS b
ON a.state_fips = b.state_fips
	AND a.county_fips = b.county_fips
WHERE a.geo_name IS NULL OR
	b.geo_name IS NULL);
-- ----
SELECT a.geo_name AS county_2000,
	b.geo_name AS county_2010,
	CASE
		WHEN a.geo_name IS NULL THEN 'Added'
		WHEN b.geo_name IS NULL THEN 'Removed'
	END AS status
FROM us_counties_2000 AS a FULL JOIN us_counties_2010 AS b
ON a.state_fips = b.state_fips
	AND a.county_fips = b.county_fips
WHERE a.geo_name IS NULL OR
	b.geo_name IS NULL;

--10.綜合分析題：人口成長最快的州
/*--------------------
這次不要找 county，而是回答：
  2000 → 2010，哪個州的總人口成長率最高？
輸出：
  state
  total_pop_2000
  total_pop_2010
  raw_change
  pct_change
思路你自己組，但會需要用到：
  JOIN
  SUM()
  GROUP BY
  numeric / CAST
  ROUND()
  ORDER BY
  LIMIT
注意一個分析上的陷阱：
  不要先算每個 county 的 pct_change 再 AVG()。
你真正想比較的是：
  州 2000 總人口
  vs.
  州 2010 總人口
所以應該先把人口 SUM() 到州層級，再算百分比。
--------------------*/

-- sol.
SELECT a.state_us_abbreviation AS state,
	SUM(a.p0010001) AS total_pop_2000,
	SUM(b.p0010001) AS total_pop_2010,
	SUM(b.p0010001) - SUM(a.p0010001) AS raw_change,
	ROUND((SUM(b.p0010001) - SUM(a.p0010001)::numeric) / SUM(a.p0010001) * 100, 1) AS pct_change
FROM us_counties_2000 AS a JOIN us_counties_2010 AS b
ON a.state_fips = b.state_fips
	AND a.county_fips = b.county_fips
GROUP BY a.state_us_abbreviation
ORDER BY pct_change DESC
LIMIT 1;
