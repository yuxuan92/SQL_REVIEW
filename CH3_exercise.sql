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
		WHEN varchar_column LIKE '20%' THEN varchar_column::date
		ELSE NULL
	END AS target_date
FROM char_data_types;
/*因為有時候欄位沒那麼乾淨etc可能不是純日期資料，
資料轉換出來可能會長下面的樣子:

varchar_column|target_date
2026-04-28|2026-04-28
abc|[NULL]
defghi|[NULL]  */
----------------------------------------------

/*2*****
表：number_data_types
運算：numeric_column * 1.05
轉型：精確到小數點後 2 位。
*/

SELECT (numeric_column * 1.05)::numeric(20,2) AS tax_included;

-Precision（總位數）時，原則是 「寧大勿小」`,PostgreSQL numeric(p, s)Precision最大可以設定到 1000。
-金額欄位需要處理到億位數 -> numeric(20,2)
-利率與百分比要精確的小數位 -> numeric(10,6)
-重量與體積小數預留3為剛好可以從公克/毫升轉公斤/升 -> numeric(10,3)
-如果真的不確定就不設定，但不嚴謹 -> numeric

/*我記得以前毛利率是設定四位小數，
金額欄位至少能處理10億的金額 -> numeric(18, 2), numeric(20, 2)
毛利率小數位四位 -> numeric(10, 4), numeric(5, 4)*/
----------------------------------------------

/*3*****
資料表：date_time_types
欄位：timestamp_column, interval_column
任務：請用 timestamp_column 減去 interval_column。
關鍵限制：最後的結果，請轉型為 varchar(10)（這樣匯出時就只會看到 YYYY-MM-DD）。
*/

SELECT (timestamp_column - interval_column)::date::varchar(10)
	FROM date_time_types;
----------------------------------------------

/*4*****
資料表：number_data_types
欄位：real_column (妳筆記裡有一筆資料是 2.1357987)
任務：請將 real_column 直接轉換成 integer。
請寫出語法，並在執行後觀察：
對於 2.1357987 這種數字，轉成 integer 後會變成 2 還是 3？如果是 0.7 呢？
妳覺得 real 型態轉整數，會是「無條件捨去」還是「四捨五入」？
*/

/****轉換整數****
如果小數點是 .5：它會向最近的 「偶數」 靠攏。
	1.5::integer 可能會變成 2
	2.5::integer 竟然也會變成 2
如果不是 .5：.7 進位成 1，.1 捨去成 0。
這是為了在處理極大量數據時，避免因為「.5 永遠進位」導致統計結果長期偏大。
*/

SELECT EXTRACT(YEAR FROM timestamp_column)::varchar(4)
	FROM date_time_types;
----------------------------------------------

/*5*****
資料表：date_time_types
欄位：timestamp_column
任務：請將它轉換成 varchar(4)。
目標：看看它是不是真的只剩下「年份」。
*/

SELECT EXTRACT(YEAR FROM timestamp_column)::varchar(4)
	FROM date_time_types;

-1. EXTRACT萃取各種時間&時間單位&世紀&千禧年
-2. 轉換文字後10會排在2前面
