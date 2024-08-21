SELECT A.USER_ID, 
       A.NICKNAME,
       (A.CITY || ' ' || A.STREET_ADDRESS1 || ' ' || A.STREET_ADDRESS2) AS ADDRESS,
       (SUBSTR(A.TLNO, 1, 3) || '-' || SUBSTR(A.TLNO, 4, 4) || '-' || SUBSTR(A.TLNO, 8)) AS TLNO
FROM USED_GOODS_USER A
INNER JOIN 
    (SELECT WRITER_ID 
     FROM USED_GOODS_BOARD 
     GROUP BY WRITER_ID 
     HAVING COUNT(WRITER_ID) >= 3) B
ON A.USER_ID = B.WRITER_ID
ORDER BY A.USER_ID DESC;