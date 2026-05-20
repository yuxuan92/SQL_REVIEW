-- p.71練習題
-- 1.撰寫一道COPY陳述，再加上WITH，以便匯入一個假想的文字檔，他的前幾列會像這樣：
/*--------
id:movie:actor
50:#Mission: Impossible#:Tom Cruise
--------*/

  -- 1.分隔符號是 ':'
  -- 2.中間有一個 ':'，題目用 '#' 取代 '"'

-- sol
COPY movies
FROM 'C:\temp\files.txt'
WITH(FORMAT CSV, HEADER, DELIMITER ':', QUOTE '#'); -- 這邊有一個參數 QUOTE 之前沒看過
-- -------------------------------------------------------

-- 2.使用在本張建立的 us_counties_2010 資料表。將其匯出一個CSV檔案，內有美國住宅最多的20個郡，要確認你只會匯出每個郡的名稱、州別、以及住宅數目都放在housing_unit_count_100_percent欄位裡)

-- sol
COPY(
	SELECT 
		geo_name, 
		state_us_abbreviation, 
		housing_unit_count_100_percent 
	FROM us_counties_2010
	ORDER BY housing_unit_count_100_percent DESC
	LIMIT 20
)TO 'C:\temp\ch4_ex2.txt'
WITH(FORMAT CSV, HEADER);
-- -------------------------------------------------------

-- 3.假想欲匯入一個檔案，其中有一個欄位資料項這樣：
/*--------
17519.668
20084.461
18976.335
--------*/
如果目標資料選用numeric(3,8)的資料類型，可行？

-- sol: 應該用 numeric(8,3)
-- -------------------------------------------------------

/* 2.1 基礎 COPY 匯出
主管需要一份全美郡縣的清單，請撰寫一段語法，將 us_counties_2010 資料表中的 所有資料，匯出到 C:\report\all_counties.csv。
要求：格式必須是 CSV，且必須包含表頭（Header），並使用逗號 , 作為分隔符號。 */

COPY us_counties_2010
TO 'C:\report\all_counties.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');
-- -------------------------------------------------------

/* 2.2 指定欄位與不分大小寫篩選匯出
承上題，主管發現檔案太大，改口說只要「郡名（geo_name）」和「州別代碼（state_us_abbreviation）」這兩個欄位就好，而且只要名字裡包含 gold（不分大小寫，例如 Gold, gold, GOLD）的郡。
要求：將查詢結果匯出到 C:\report\gold_counties.txt，格式為 CSV，包含表頭，並改用管線符號 | 作為分隔符號。 */

COPY (
  SELECT geo_name, state_us_abbreviation
  FROM us_counties_2010
  WHERE geo_name ILIKE '%gold%'   
) TO 'C:\report\gold_counties.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- ***「包含」要用萬用字元 '%' ***
-- -------------------------------------------------------

/* 2.3 建立一模一樣的複製表
為了做資料清洗，請撰寫一段語法，建立一張名為 us_counties_staging 的永久正式表（不是臨時表喔！），且這張表的欄位結構要完全複製 us_counties_2010 的結構。 */

CREATE TABLE us_counties_staging (LIKE us_counties_2010);
-- -------------------------------------------------------

/* 2.4 指定欄位匯入與防呆
假設妳有一個文字檔路徑為 C:\data\short_salaries.csv，裡面只有兩欄資料，內容長這樣（有表頭）：

town,salary
Anytown,27000
Moetown,32100
請撰寫一段 COPY 語法，把這個檔案的資料正確匯入到妳筆記中的 supervisor_salaries 資料表對應的欄位中。 */

COPY supervisor_salaries (town, salary)
FROM 'C:\data\short_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- -------------------------------------------------------

/* 2.5 進階 Staging ETL 拋轉
妳建立了一張臨時表 CREATE TEMPORARY TABLE branch_temp (LIKE supervisor_salaries);，並已經成功把資料 COPY 進去了。
現在請撰寫一段 INSERT INTO ... SELECT 語法，把臨時表裡的所有資料轉入正式表 supervisor_salaries 中，但轉入時有兩個特殊要求：

	1.正式表的 county 欄位，請一律寫死填入字串 'Taipei Store'。
	2.正式表的 start_date 欄位，請一律填入今天的日期（提示：利用妳在 CH1 學到的獲取當前日期函數，或直接用妳筆記中 start_date 欄位的型態）。
	3.其餘欄位則正常對應帶入。 */

INSERT INTO supervisor_salaries (town, county, supervisor, start_date, salary, benefits)
SELECT town, 'Taipei Store', supervisor, current_date, salary, benefits
FROM branch_temp;

-- ***「今天日期」使用的函數 -> current_date ***
