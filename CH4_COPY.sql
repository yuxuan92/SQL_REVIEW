/* 要被轉入的文字檔們 ***
-先決條件：1.符合匯入格式的文字檔(eg.逗點分隔檔) 2.可容納資料的table 3.COPY指令匯入
-如果資料必須包含 ',' 則用雙引號包覆該筆資料。eg.
John,Doe,"123 Main St., Apart,emt 200",Hyde Park,NY,845-555-1212
                   ^                     ^                          ^
-有些資料庫需要標題列辨別資料，PostgreSQL不需要
*/


COPY table_name
FROM 'C:\YourDirectory\your_file.csv'
WITH (FORMAT CSV, HEARDER)

-- 將 'C:\YourDirectory\your_file.csv' 這個檔案複製到 'table_name' 這個資料庫表格
-- Windows路徑寫法是反斜線 '\'，macOS, Linux是斜線 '/'


-- ------------------
/* 複習一下資料型態
varchar(90)_長度變動的文字,長度上限90
smallint_整數,2 bytes
bigint_整數,8 bytes
integer_整數,4 bytes
numeric(10, 7)_長度固定10的數值,小數7位,numeric(s, p)

*/


CREATE TABLE us_counties_2010 (
    geo_name varchar(90),                    -- Name of the geography
    state_us_abbreviation varchar(2),        -- State/U.S. abbreviation
    summary_level varchar(3),                -- Summary Level
    region smallint,                         -- Region
    division smallint,                       -- Division
    state_fips varchar(2),                   -- State FIPS code
    county_fips varchar(3),                  -- County code
    area_land bigint,                        -- Area (Land) in square meters
    area_water bigint,                        -- Area (Water) in square meters
    population_count_100_percent integer,    -- Population count (100%)
    housing_unit_count_100_percent integer,  -- Housing Unit count (100%)
    internal_point_lat numeric(10,7),        -- Internal point (latitude)
    internal_point_lon numeric(10,7),        -- Internal point (longitude)

    -- This section is referred to as P1. Race:
    p0010001 integer,   -- Total population
    p0010002 integer,   -- Population of one race:
    p0010003 integer,       -- White Alone
    p0010004 integer,       -- Black or African American alone
    p0010005 integer,       -- American Indian and Alaska Native alone
    p0010006 integer,       -- Asian alone
    p0010007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,       -- Some Other Race alone
    p0010009 integer,   -- Population of two or more races
    p0010010 integer,   -- Population of two races:
    p0010011 integer,       -- White; Black or African American
    p0010012 integer,       -- White; American Indian and Alaska Native
    p0010013 integer,       -- White; Asian
    p0010014 integer,       -- White; Native Hawaiian and Other Pacific Islander
    p0010015 integer,       -- White; Some Other Race
    p0010016 integer,       -- Black or African American; American Indian and Alaska Native
    p0010017 integer,       -- Black or African American; Asian
    p0010018 integer,       -- Black or African American; Native Hawaiian and Other Pacific Islander
    p0010019 integer,       -- Black or African American; Some Other Race
    p0010020 integer,       -- American Indian and Alaska Native; Asian
    p0010021 integer,       -- American Indian and Alaska Native; Native Hawaiian and Other Pacific Islander
    p0010022 integer,       -- American Indian and Alaska Native; Some Other Race
    p0010023 integer,       -- Asian; Native Hawaiian and Other Pacific Islander
    p0010024 integer,       -- Asian; Some Other Race
    p0010025 integer,       -- Native Hawaiian and Other Pacific Islander; Some Other Race
    p0010026 integer,   -- Population of three races
    p0010047 integer,   -- Population of four races
    p0010063 integer,   -- Population of five races
    p0010070 integer,   -- Population of six races

    -- This section is referred to as P2. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    p0020001 integer,   -- Total
    p0020002 integer,   -- Hispanic or Latino
    p0020003 integer,   -- Not Hispanic or Latino:
    p0020004 integer,   -- Population of one race:
    p0020005 integer,       -- White Alone
    p0020006 integer,       -- Black or African American alone
    p0020007 integer,       -- American Indian and Alaska Native alone
    p0020008 integer,       -- Asian alone
    p0020009 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0020010 integer,       -- Some Other Race alone
    p0020011 integer,   -- Two or More Races
    p0020012 integer,   -- Population of two races
    p0020028 integer,   -- Population of three races
    p0020049 integer,   -- Population of four races
    p0020065 integer,   -- Population of five races
    p0020072 integer,   -- Population of six races

    -- This section is referred to as P3. RACE FOR THE POPULATION 18 YEARS AND OVER
    p0030001 integer,   -- Total
    p0030002 integer,   -- Population of one race:
    p0030003 integer,       -- White alone
    p0030004 integer,       -- Black or African American alone
    p0030005 integer,       -- American Indian and Alaska Native alone
    p0030006 integer,       -- Asian alone
    p0030007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0030008 integer,       -- Some Other Race alone
    p0030009 integer,   -- Two or More Races
    p0030010 integer,   -- Population of two races
    p0030026 integer,   -- Population of three races
    p0030047 integer,   -- Population of four races
    p0030063 integer,   -- Population of five races
    p0030070 integer,   -- Population of six races

    -- This section is referred to as P4. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    -- FOR THE POPULATION 18 YEARS AND OVER
    p0040001 integer,   -- Total
    p0040002 integer,   -- Hispanic or Latino
    p0040003 integer,   -- Not Hispanic or Latino:
    p0040004 integer,   -- Population of one race:
    p0040005 integer,   -- White alone
    p0040006 integer,   -- Black or African American alone
    p0040007 integer,   -- American Indian and Alaska Native alone
    p0040008 integer,   -- Asian alone
    p0040009 integer,   -- Native Hawaiian and Other Pacific Islander alone
    p0040010 integer,   -- Some Other Race alone
    p0040011 integer,   -- Two or More Races
    p0040012 integer,   -- Population of two races
    p0040028 integer,   -- Population of three races
    p0040049 integer,   -- Population of four races
    p0040065 integer,   -- Population of five races
    p0040072 integer,   -- Population of six races

    -- This section is referred to as H1. OCCUPANCY STATUS
    h0010001 integer,   -- Total housing units
    h0010002 integer,   -- Occupied
    h0010003 integer    -- Vacant
);

-- ---------------------------------------------------------------

-- 用COPY將CSV檔匯入======================

COPY us_counties_2010
FROM 'C:\temp\us_counties_2010.csv'
WITH(FORMAT CSV, HEADER);

SELECT * FROM us_counties_2010;

-- 資料太多筆， 看土地面積的前3個郡就好

SELECT geo_name, state_us_abbreviation, area_land
FROM us_counties_2010
ORDER BY area_land DESC
LIMIT 3;

-- ------------------------
"geo_name"	"state_us_abbreviation"	"area_land"
"Yukon-Koyukuk Census Area"	"AK"	376855656455
"North Slope Borough"	"AK"	229720054439
"Bethel Census Area"	"AK"	105075822708
-- ------------------------

-- 按照經度，取前5筆資料(降冪)

SELECT geo_name, state_us_abbreviation, internal_point_lon
FROM us_counties_2010
ORDER BY internal_point_lon DESC
LIMIT 5;

-- ------------------------
"geo_name"	"state_us_abbreviation"	"internal_point_lon"
"Aleutians West Census Area"	"AK"	178.3388130
"Washington County"	"ME"	-67.6093542
"Hancock County"	"ME"	-68.3707034
"Aroostook County"	"ME"	-68.6494098
"Penobscot County"	"ME"	-68.6574869
-- ------------------------
-- 經度小於 0 代表子午線以西



-- 如果COPY只會入部分欄位 -- ------------------------

-- 建一個新的表來演示這件事

CREATE TABLE supervisor_salaries (
  town varchar(30),
  county varchar(30),
  supervisor varchar(30),
  start_date date,
  salary money,
  benifits money
);

-- 匯入檔案到 supervisor_salaries表格

COPY supervisor_salaries
FROM 'C:\temp\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

/*錯誤訊息---------
ERROR:  missing data for column "start_date"
CONTEXT:  COPY supervisor_salaries, line 2: "Anytown,Jones,27000" 

SQL state: 22P04
--------*/

-- 每個欄位的格式不盡相同，所以匯不進去
-- 指定匯入欄位

COPY supervisor_salaries (town, supervisor, salary)
FROM 'C:\temp\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER);

-- 不過因為postgreSQL不讀表頭，只要匯入欄位的格式對了，就算表頭錯誤也能匯入

COPY(
  
) TO 'C:\temp\CH4_test.txt' 
WITH(FORMAT CSV, HEADER, DELIMETER "|");

-- ------------------------
town|county|supervisor|start_date|salary|benifits
Anytown||Jones||NT$27,000.00|
Bumblyburg||Baker||NT$24,999.00|
Moetown||Smith||NT$32,100.00|
Bigville||Kao||NT$31,500.00|
New Brillig||Carroll||NT$72,690.00|
aaa|||||
bbb|||||
ccc|||||
-- ------------------------

-- ------------------------------------------------------------------------------

-- 刪除資料表 supervisor_salaries裡的資料
DELETE FROM supervisor_salaries; 

-- 建立一個臨時資料表，欄位跟supervisor_salaries一樣
-- TEMPORARY TABLE放在記憶體，運算數度快，但資料庫斷線他就會消失
CREATE TEMPORARY TABLE supervisor_salaries_temp (LIKE supervisor_salaries);

COPY supervisor_salaries_temp (town, supervisor, salary)
FROM 'C:\temp\supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER, DELIMITER '|');
-- ------------------------
town|county|supervisor|start_date|salary|benifits
Anytown||Jones||NT$27,000.00|
Bumblyburg||Baker||NT$24,999.00|
Moetown||Smith||NT$32,100.00|
Bigville||Kao||NT$31,500.00|
New Brillig||Carroll||NT$72,690.00|
-- ------------------------

-- 將supervisor_salaries_temp裡的資料都匯到supervisor_salaries, 除了county欄位指定帶入值'Some County'
-- 因為只有twon, county, supervisor, salary四個欄位帶入資料，所以start_date, benifits不會有值
INSERT INTO supervisor_salaries (town, county, supervisor, salary)
SELECT town, 'Some County', supervisor, salary
FROM supervisor_salaries_temp;

COPY(
  SELECT * FROM supervisor_salaries
) TO 'C:\temp\CH4_test.txt'
WITH(FORMAT CSV, HEADER, DELIMITER '|');
-- ------------------------
town|county|supervisor|start_date|salary|benifits
Anytown|Some County|Jones||NT$27,000.00|
Bumblyburg|Some County|Baker||NT$24,999.00|
Moetown|Some County|Smith||NT$32,100.00|
Bigville|Some County|Kao||NT$31,500.00|
New Brillig|Some County|Carroll||NT$72,690.00|
-- ------------------------

DROP TABLE supervisor_salaries_temp;

-- COPY匯出資料 -- ------------------------

-- 匯出整個資料表
COPY US_counties_2010
TO 'C:\temp\us_counties_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- 匯出特定的資料表欄位
COPY us_counties_2010 (geo_name, internal_point_lat, internal_point_lon)
TO 'C:\temp\us_counties_latlon_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- 匯出查詢的結果
COPY (
  SELECT geo_name, state_us_abbreviation
  FROM us_counties_2010
  WHERE geo_name ILIKE '%mill%' --不分大小寫的 LIKE
)
TO 'C:\temp\us_counties_mill_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');
