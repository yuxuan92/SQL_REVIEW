/*1*****
資料表：char_data_types
欄位：varchar_column
情境：假設 varchar_column 裡面有一筆資料是 '2026-04-28'。
任務：請寫一段查詢，將這個欄位轉換成 date 型態，並把這個新欄位取名為 target_date。
*/

/*way_1*/
SELECT varchar_column ::date AS target_date
	FROM char_data_types
	WHERE varchar_column LIKE '20%';

/*way_2*/
SELECT 
	CASE 
		WHEN varchar_column LIKE '20%' THEN ::date
		ELSE NULL
	END AS target_date
FROM char_data_types;
