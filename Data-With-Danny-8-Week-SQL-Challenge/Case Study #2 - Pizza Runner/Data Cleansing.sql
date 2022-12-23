/*
-----DATA CLEANSING-----
                      */
 
--TABLE: runner_orders

--pickup_time - remove nulls and replace ''
--distance - remove km and null. change data type from varchar to integer
--duration - remove null and mins, and minutes
--cancelation - remove null and replace ''

CREATE TEMP TABLE runner_orders_temp AS
SELECT order_id, runner_id,
CASE 
	WHEN pickup_time LIKE 'null' THEN ' '
	ELSE pickup_time END as pickup_time,
CASE 	
	WHEN distance LIKE 'null' THEN  ' '
    WHEN distance LIKE '%km' THEN TRIM('km' from distance)
    ELSE distance END as distance,
CASE
	WHEN duration LIKE 'null' THEN ' '
    WHEN duration LIKE '%mins' THEN TRIM('mins' from duration) 
    WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
    WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
    ELSE duration END as duration,
CASE 
	WHEN cancellation IS NULL OR cancellation LIKE 'null' THEN ' '
    ELSE cancellation END as cancellation
FROM pizza_runner.runner_orders;

SELECT * 
FROM runner_orders_temp;

ALTER TABLE runner_orders_temp
ALTER COLUMN pickup_time TYPE TIMESTAMP,
ALTER COLUMN distance TYPE FLOAT,
ALTER COLUMN duration TYPE INTEGER;

--TABLE: customer_orders

--exclusions - remove nulls and replace ''
--extras - remove nulls and replace ''


CREATE TEMP TABLE customer_orders_temp AS
SELECT order_id, runner_id, pizza_id,
CASE 
	WHEN exclusions IS NULL OR exclusions LIKE 'null' THEN ' '
	ELSE exclusions END as exclusions,
CASE 	
	WHEN extras IS NULL OR extras LIKE 'null' OR extras LIKE '%NaN' THEN  ' ' 
    ELSE extras END as extras, order_time
FROM pizza_runner.customer_orders;

SELECT * 
FROM customer_orders_temp;
