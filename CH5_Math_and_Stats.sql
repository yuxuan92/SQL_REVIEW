-- 數學運算子
  -- +, add
  -- -, deduct
  -- *, multiple
  -- /, devide
  -- %, 模數(傳回餘數)
  -- ^, 指數
  -- |/, 平方根
  -- ||/, 立方根
  -- !, 階乘

-- 1.兩個integer做運算， 會回傳integer
-- 2.運算子任一側有numeric, 會回傳numeric
-- 3.只要有處理到浮點數, 會回傳double
    -- numeric(n, m), decimal(n, m)_整位數固定，小數位固定
    -- real_6位數精度 (變動)
    -- double_15位數精度 (變動)

-- 指數(^)、根數(|/)、階層(!)，經過左述運算子處裡的任何數值，會回傳 numeric, real, double(反正就是會回傳小數)

-- Add -----
COPY(
	SELECT 2 + 2	
)TO 'C:\temp\ch5_1.txt'
WITH(FORMAT CSV, HEADER);
/* -------------
?column?
4
------------- */  -- 欄位名稱 ?column? 是正常的， 因為沒有指定欄位跟表格

-- Deduct -----
SELECT 9 - 1;    -- 8

-- Multiple -----
SELECT 3 * 4;    -- 12

-- Divide(傳回商數) -----
SELECT 11 / 6;	-- 1

-- Modulo(傳回模數) ----- 判斷是否為偶數 -> x % 2 == 0，代表是偶數
SELECT 11 % 6;	-- 5

-- 因為除數或被除數的資料型態是numeric，所以商數的資料型態一定是numeric
SELECT 11.0 / 6;	-- 1.8333333333333333
SELECT CAST (11 AS numeric(3,1)) / 6;	-- 1.8333333333333333

-- !!!! PostgreSQL 14+ 已廢棄 !、|/ 等符號運算子，實務上應一律使用 factorial()、sqrt()、cbrt() 函數，邏輯更清晰且不容易報錯。
SELECT 3 ^ 4;	-- 81
SELECT |/ 10;	-- 3.1622776601683795
SELECT sqrt(10);	-- 3.1622776601683795
SELECT cbrt(10);	-- 2.154434690031884
SELECT factorial(4); -- 4! = 24
