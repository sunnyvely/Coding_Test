(SELECT DISTINCT(CAR_ID), '대여중' AS "AVAILABILITY"
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE CAR_ID IN (
    SELECT DISTINCT(CAR_ID)
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    WHERE 
        START_DATE <= TO_DATE('2022-10-16', 'YYYY-MM-DD') AND END_DATE >= TO_DATE('2022-10-16', 'YYYY-MM-DD')
    )
)
UNION 
(SELECT DISTINCT(CAR_ID), '대여 가능' AS "AVAILABILITY"
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE CAR_ID NOT IN (
    SELECT DISTINCT(CAR_ID)
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    WHERE 
        START_DATE <= TO_DATE('2022-10-16', 'YYYY-MM-DD') AND END_DATE >= TO_DATE('2022-10-16', 'YYYY-MM-DD')
    )
)
ORDER BY CAR_ID DESC