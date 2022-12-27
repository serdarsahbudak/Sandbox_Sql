--A. Pizza Metrics
--1. How many pizzas were ordered?
SELECT COUNT(order_id) as unique_orders
FROM pizza_runner.customer_orders;

--2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) as orders
FROM pizza_runner.customer_orders;

--3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(order_id) as succesful_orders
FROM pizza_runner.runner_orders r
WHERE cancellation IS NULL
GROUP BY runner_id;

--4) How many of each type of pizza was delivered?
SELECT pizza_name, COUNT(co.order_id)
FROM customer_orders_temp co, pizza_runner.pizza_names p, runner_orders_temp ro
WHERE co.pizza_id = p.pizza_id
AND ro.order_id = co.order_id
AND cancellation IS NULL
GROUP BY pizza_name;

--5) How many Vegetarian and Meatlovers were ordered by each customer?
SELECT co.customer_id, pizza_name, COUNT(co.order_id)
FROM customer_orders_temp co, pizza_runner.pizza_names p
WHERE co.pizza_id = p.pizza_id
GROUP BY co.customer_id, pizza_name
ORDER BY co.customer_id;

--Alternative solution to show results on the same row
SELECT 
	co.customer_id,
    SUM(CASE WHEN p.pizza_id = 1 THEN 1 ELSE 0 END) AS meatlovers,
    SUM(CASE WHEN p.pizza_id = 2 THEN 1 ELSE 0 END) AS vegetarians
FROM customer_orders_temp co, pizza_runner.pizza_names p
WHERE co.pizza_id = p.pizza_id
GROUP BY co.customer_id
ORDER BY co.customer_id;

--6) What was the maximum number of pizzas delivered in a single order?
SELECT COUNT(pizza_id) as pizza_ordered
FROM customer_orders_temp co, runner_orders_temp ro
WHERE ro.order_id = co.order_id
AND cancellation IS NULL
GROUP BY co.order_id
ORDER BY pizza_ordered DESC
LIMIT 1;

--7) For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
	co.customer_id,
    SUM(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL THEN 1 ELSE 0 END) AS changed,
    SUM(CASE WHEN exclusions IS NULL AND extras IS NULL THEN 1 ELSE 0 END) AS no_changed
FROM customer_orders_temp co, runner_orders_temp ro
WHERE ro.order_id = co.order_id
AND cancellation IS NULL
GROUP BY co.customer_id;

--8) How many pizzas were delivered that had both exclusions and extras?
SELECT SUM(CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1 ELSE 0 END) AS mixed_order
FROM customer_orders_temp co, runner_orders_temp ro
WHERE ro.order_id = co.order_id
AND cancellation IS NULL;

--9) What was the total volume of pizzas ordered for each hour of the day?
SELECT EXTRACT (HOUR FROM order_time) AS hour_of_day, COUNT(order_id)
FROM customer_orders_temp
GROUP BY EXTRACT (HOUR FROM order_time)
ORDER BY hour_of_day

