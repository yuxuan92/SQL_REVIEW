-- p.71練習題
-- 1.撰寫一道COPY陳述，再加上WITH，以便匯入一個假想的文字檔，他的前幾列會像這樣：
/*--------
id:movie:actor
50:#Mission: Impossible#:Tom Cruise
--------*/

-- SOL
-- 1.分隔符號是 ':'
-- 2.中間有一個 ':'，題目用 '#' 取代 '"'

COPY movies
FROM ''
WITH(FORMAT CSV, HEADER, DELIMITER ':', QUOTE '#');
