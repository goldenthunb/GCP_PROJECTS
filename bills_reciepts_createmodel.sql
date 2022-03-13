CREATE OR REPLACE MODEL `bills_reciepts.classification_model`
OPTIONS
(
model_type='logistic_reg',
labels = ['will_buy_on_next_visit']
)
AS
#standardSQL
SELECT
  * 
FROM
  # features
  (SELECT
    transaction_date,
    IFNULL(item_id, 0) AS item_id,
    IFNULL(item_qty, 0) AS item_qty
  FROM
    `bills_reciepts.reciept_info`
  WHERE
    item_id > -1
    AND transaction_date BETWEEN '2022-01-01' AND '2022-03-06') # train on first 2 months
  JOIN
  (SELECT
    item_id, transaction_date, 
    IF(sum(item_qty) > 0  , 1, 0) AS will_buy_on_next_visit
  FROM
      `bills_reciepts.reciept_info`
  GROUP BY item_id, transaction_date)
  USING (item_id, transaction_date)
;
