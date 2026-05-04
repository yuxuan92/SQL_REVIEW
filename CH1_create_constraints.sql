--假設有10個欄位，但入資料庫只給1-5個欄位
--剩下的 6 到 10 欄會怎樣取決當初建表時的設定

CREATE TABLE sales_records (
    sale_id bigserial PRIMARY KEY,          -- 設定為主鍵，且自動跳號
    store_name varchar(50) NOT NULL,        -- NOT NULL：這欄一定要填，不填會報錯
    product_name varchar(50) DEFAULT '未分類', -- DEFAULT：沒填的話，自動填入 '未分類'
    sale_amount numeric(20, 2) DEFAULT 0,    -- DEFAULT：沒填的話，預設金額為 0
    sale_date date DEFAULT CURRENT_DATE,    -- DEFAULT：沒填的話，自動抓「今天」
    is_active boolean DEFAULT true          -- 常用於標記資料是否有效
);
