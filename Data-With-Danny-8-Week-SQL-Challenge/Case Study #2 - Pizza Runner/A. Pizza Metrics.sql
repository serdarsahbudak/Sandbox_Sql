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
