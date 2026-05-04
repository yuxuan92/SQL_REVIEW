-- --CONSTRAINTS-- ----------------------------
--假設有10個欄位，但入資料庫只給1-5個欄位
--剩下的 6 到 10 欄會怎樣取決當初建表時的設定
--所以INSERT INTO時不用給 sale_id 的欄位

CREATE TABLE sales_records (
    sale_id bigserial PRIMARY KEY,          -- 設定為主鍵，且自動跳號
    store_name varchar(50) NOT NULL,        -- NOT NULL：這欄一定要填，不填會報錯
    product_name varchar(50) DEFAULT '未分類', -- DEFAULT：沒填的話，自動填入 '未分類'
    sale_amount numeric(20, 2) DEFAULT 0,    -- DEFAULT：沒填的話，預設金額為 0
    sale_date date DEFAULT CURRENT_DATE,    -- DEFAULT：沒填的話，自動抓「今天」
    is_active boolean DEFAULT true          -- 常用於標記資料是否有效
);

-- -- CHECK CONSTRAINTS -- ----------------------------

CREATE TABLE sales_records (
    sale_id bigserial PRIMARY KEY,
    payment_method varchar(20) CHECK (payment_method IN ('信用卡', '現金', '行動支付')), -- 設定支付方式只能是這三種
    discount_rate numeric(3, 2) CHECK (discount_rate <= 1.0) -- 設定折扣率不能超過100%
);

-- -- ENUM -- ----------------------------

CREATE TYPE order_status AS ENUM ('待處理', '已出貨', '已完工', '已取消'); -- 建立清單型別 order_status

CREATE TABLE sales_records (
    id bigserial PRIMARY KEY,
    status order_status DEFAULT '待處理' 
    --     ^^^^^^^^^^^^^^^^^^^^^^^^^^^ status欄位預設值帶入清單order_status的'待處理'
);

-- -- Foreign Key -- ----------------------------
--如 ERP 或 POS 的做法。會有一張獨立的「參數表」或「代碼表」
