CREATE TABLE char_data_types (
	varchar_column varchar(10),
	char_column char(10),
	text_column text
);

INSERT INTO char_data_types
VALUES
	('abc', 'abc', 'abc'),
	('defghi', 'defghi', 'defghi');

COPY char_data_types TO 'C:\temp\SQL.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');
/*--------------------------------------
varchar_column|char_column|text_column
abc|abc       |abc
defghi|defghi    |defghi

char(n)_長度n, 長度固定的字元串列
varchar(n)_長度n, 長度不固定的字元串列
text_長度不固定且無上限
*/--------------------------------------

/*--------------------------------------
整數
	smallint_2 bytes
	integer_4 bytes
	bigint_8 bytes
自動遞增的整數(不算真真正的整數型態)
	smallserial_2 bytes
	serial_4 bytes
	bigserial_8 bytes
*/--------------------------------------

CREATE TABLE number_data_types (
	numeric_column numeric(20,5),
	real_column real,
	double_column double precision
);

INSERT INTO number_data_types
VALUES
	(.7, .7, .7),
	(2.13579, 2.13579, 2.13579),
	(2.1357987654, 2.1357987654, 2.1357987654);

COPY number_data_types TO 'C:\temp\NUM.txt'
WITH(FORMAT CSV, HEADER, DELIMITER '|');
/*--------------------------------------
numeric_column|real_column|double_column
0.70000|0.7|0.7
2.13579|2.13579|2.13579
2.13580|2.1357987|2.1357987654

numeric(n, m), decimal(n, m)_整位數固定，小數位固定
real_6位數精度
double_15位數精度
*/--------------------------------------

SELECT
	numeric_column * 10000000 AS Fixed,
	real_column * 10000000AS Float
FROM number_data_types
WHERE numeric_column = 0.7;
/*--------------------------------------
fixed|float
7000000.00000|6999999.88079071
浮點數小數位計算會有不精確的問題
*/--------------------------------------

CREATE TABLE date_time_types (
	timestamp_column timestamp with time zone,
	interval_column interval
);

INSERT INTO date_time_types
VALUES
	('2018-12-31 01:00 EST', '2 days'), -時區
	('2018-12-31 01:00 -8', '1 month'), -與UTC的時差
	('2018-12-31 01:00 Australia/Melbourne', '1 century'), -區域或位置指定時區
	(now(), '1 week'); -硬體當下時間

SELECT * FROM date_time_types;

COPY date_time_types TO 'C:\temp\NUM.txt'
WITH(FORMAT CSV, HEADER, DELIMITER '|');
/*--------------------------------------
timestamp_column|interval_column
2018-12-31 14:00:00+08|2 days
2018-12-31 17:00:00+08|1 mon
2018-12-30 22:00:00+08|100 years
2026-04-22 15:26:55.820941+08|7 days

timestamp_8 bytes, 日期+時間 (with time zone), YYYY-MM-DD HH:MM:SS(ISO格式)
date_4 bytes, 日期
time_8 bytes, 時間 (with time zone)
interval_16 bytes. 時間區隔
*/--------------------------------------

SELECT
	timestamp_column,
	interval_column,
	timestamp_column - interval_column AS new_date
FROM date_time_types;

/*--------------------------------------
timestamp_column|interval_column|new_date
2018-12-31 14:00:00+08|2 days|2018-12-29 14:00:00+08
2018-12-31 17:00:00+08|1 mon|2018-11-30 17:00:00+08
2018-12-30 22:00:00+08|100 years|1918-12-30 22:00:00+08
2026-04-22 15:26:55.820941+08|7 days|2026-04-15 15:26:55.820941+08

時間計算欄位mew_date的預設格式是 stamptime with time zone
*/--------------------------------------

SELECT timestamp_column, CAST(timestamp_column AS varchar(10))
FROM date_time_types;
/*--------------------------------------
timestamp_column|timestamp_column
2018-12-31 14:00:00+08|2018-12-31
2018-12-31 17:00:00+08|2018-12-31
2018-12-30 22:00:00+08|2018-12-30
2026-04-22 15:26:55.820941+08|2026-04-22

2026-04-22
^^^^^^^^^^
1234567890
*/--------------------------------------

SELECT
	timestamp_column,
	timestamp_column::varchar(10)
FROM date_time_types;
/*--------------------------------------
CAST(timestamp_column AS varchar(10))
縮寫
timestamp_column::varchar(10)
                ^^
*/--------------------------------------

COPY(
	SELECT 
		numeric_column, 
		CAST(numeric_column AS integer), 
		CAST(numeric_column AS varchar(6))
	FROM number_data_types
) TO 'C:\temp\NUM.txt'
WITH(FORMAT CSV, HEADER, DELIMITER '|');
/*--------------------------------------
numeric_column|numeric_column|numeric_column
0.70000|1|0.7000
2.13579|2|2.1357
2.13580|2|2.1358
^^^^^^^
1234567

numeric_column::integer
四捨五入
*/--------------------------------------
