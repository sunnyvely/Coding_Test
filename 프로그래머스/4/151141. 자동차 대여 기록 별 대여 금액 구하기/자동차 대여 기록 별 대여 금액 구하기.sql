-- 코드를 입력하세요
/* 테이블 정보
1) 대여 중인 자동차 정보를 담은 테이블 : CAR_RENTAL_COMPANY_CAR
자동차 종류 : '세단', 'SUV', '승합차', '트럭', '리무진' 
자동차 옵션 리스트 : 콤마로 구분된 키워드 리스트 (ex. 열선시트,스마트키,주차감지센서)
키워드 종류 : '주차감지센서', '스마트키', '네비게이션', '통풍시트', '열선시트', '후방카메라', '가죽시트' 

2) 자동차 대여 기록 정보를 담은 테이블 : CAR_RENTAL_COMPANY_RENTAL_HISTORY

3) 자동차 종류별 대여 기간, 종류별 할인 정책 정보 : CAR_RENTAL_COMPANY_DISCOUNT_PLAN
할인율이 적용되는 대여 기간 종류 : 
    '7일 이상' (대여 기간이 7일 이상 30일 미만인 경우), 
    '30일 이상' (대여 기간이 30일 이상 90일 미만인 경우), 
    '90일 이상' (대여 기간이 90일 이상인 경우) 이 있습니다. 
    대여 기간이 7일 미만인 경우 할인정책이 없습니다.
*/

--풀이방법1
select n.history_id,
       round(((trunc(n.end_date) - trunc(n.start_date) + 1) * n.daily_fee) * ((100- nvl(d.discount_rate,0))/100)) as fee
from (select h.history_id, c.car_type, c.daily_fee, h.start_date, h.end_date,
             case when (trunc(h.end_date) - trunc(h.start_date) + 1) >= 90 then '90일 이상'
                  when (trunc(h.end_date) - trunc(h.start_date) + 1) >= 30 then '30일 이상'
                  when (trunc(h.end_date) - trunc(h.start_date) + 1) >= 7 then '7일 이상'
                  else '0' end as duration
      from car_rental_company_rental_history h, car_rental_company_car c
      where h.car_id = c.car_id
      and c.car_type = '트럭') n
left join (select duration_type, discount_rate
           from car_rental_company_discount_plan
           where car_type = '트럭') d
on n.duration = d.duration_type
order by fee desc, n.history_id desc


--풀이방법2
/*
WITH TRUCK AS (
  SELECT 
    C.CAR_ID,
    C.CAR_TYPE,
    C.DAILY_FEE,
    H.HISTORY_ID,
    TRUNC(H.END_DATE - H.START_DATE) + 1 AS DURATION
  FROM 
    CAR_RENTAL_COMPANY_CAR C
    JOIN CAR_RENTAL_COMPANY_RENTAL_HISTORY H ON C.CAR_ID = H.CAR_ID
  WHERE 
    C.CAR_TYPE = '트럭'
),
DISCOUNTED AS (
  SELECT
    T.HISTORY_ID,
    T.DAILY_FEE,
    T.DURATION,
    NVL(MAX(D.DISCOUNT_RATE), 0) AS DISCOUNT_RATE
  FROM 
    TRUCK T
    LEFT JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN D
      ON T.CAR_TYPE = D.CAR_TYPE
     AND T.DURATION >= TO_NUMBER(REGEXP_SUBSTR(D.DURATION_TYPE, '[0-9]+'))
  GROUP BY 
    T.HISTORY_ID, T.DAILY_FEE, T.DURATION
)
SELECT 
  HISTORY_ID,
  DAILY_FEE * DURATION * (1 - DISCOUNT_RATE / 100) AS FEE
FROM 
  DISCOUNTED
ORDER BY 
  FEE DESC, HISTORY_ID DESC

*/