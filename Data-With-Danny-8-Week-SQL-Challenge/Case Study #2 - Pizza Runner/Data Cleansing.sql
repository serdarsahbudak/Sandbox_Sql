/*
-----DATA CLEANSING-----
                      */
 
--TABLE: runner_orders

--pickup_time - remove nulls and replace ''
--distance - remove km and null. change data type from varchar to integer
--duration - remove null and mins, and minutes
--cancelation - remove null and replace ''

DROP TABLE IF EXISTS runner_orders_temp;
CREATE TEMP TABLE runner_orders_temp AS
SELECT order_id, runner_id,
CAST(CASE 
	WHEN pickup_time LIKE 'null' THEN NULL
	ELSE pickup_time END AS TIMESTAMP) AS pickup_time,
CAST(CASE 	
	WHEN distance LIKE 'null' THEN NULL
    	WHEN distance LIKE '' THEN NULL
    	WHEN distance LIKE '%km' THEN TRIM('km' from distance)
    	ELSE distance END AS DECIMAL(5,2)) AS distance,
CAST(CASE
	WHEN duration LIKE 'null' THEN NULL
   	WHEN duration LIKE '%mins' THEN TRIM('mins' from duration) 
    	WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
    	WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)
    	ELSE duration END AS INT) AS duration,
CASE 
	WHEN cancellation LIKE 'null' THEN NULL
    	WHEN cancellation LIKE '' THEN NULL
    	ELSE cancellation END AS cancellation
FROM pizza_runner.runner_orders;

SELECT * 
FROM runner_orders_temp;


--TABLE: customer_orders

--exclusions - remove nulls and replace ''
--extras - remove nulls and replace ''

DROP TABLE IF EXISTS customer_orders_temp;
CREATE TEMP TABLE customer_orders_temp AS
SELECT order_id, customer_id, pizza_id,
CASE 
	WHEN exclusions LIKE 'null' THEN NULL
    WHEN exclusions LIKE '' THEN NULL
	ELSE exclusions END AS exclusions,
CASE 	
	WHEN extras LIKE 'null' THEN NULL
    WHEN extras LIKE '' THEN NULL
    ELSE extras END AS extras, order_time
FROM pizza_runner.customer_orders;

SELECT * 
FROM customer_orders_temp;
