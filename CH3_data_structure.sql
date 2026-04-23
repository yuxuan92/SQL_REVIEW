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


