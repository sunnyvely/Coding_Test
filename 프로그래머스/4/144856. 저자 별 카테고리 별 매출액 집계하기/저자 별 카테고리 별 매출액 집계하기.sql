WITH SALES AS (
    SELECT *
    FROM BOOK_SALES
    WHERE SALES_DATE BETWEEN TO_DATE('20220101','YYYYMMDD')
                         AND TO_DATE('20220131','YYYYMMDD')
),
BOOKS AS (
    SELECT b.book_id, b.author_id, b.category, b.price, a.author_name
    FROM BOOK b
    JOIN AUTHOR a ON b.author_id = a.author_id
)
SELECT 
    bo.author_id,
    bo.author_name,
    bo.category,
    SUM(bo.price * s.sales) AS total_sales
FROM SALES s
JOIN BOOKS bo ON s.book_id = bo.book_id
GROUP BY bo.author_id, bo.author_name, bo.category
ORDER BY bo.author_id ASC, bo.category DESC;