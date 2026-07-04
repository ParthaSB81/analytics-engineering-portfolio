use ecommerce
----//Duplicate Validation//--

--## Business Key Validation ##--

-- Dimension Table : Customer --
select
	customer_id,
	count(*) as duplicates
from analytics.dim_customer
group by customer_id
having count(*) >1;

-- Dimension Table : Product --
select
	product_id,
	count(*) as duplicates
from analytics.dim_product
group by product_id
having count(*) >1;

-- Dimension Table : Seller --
select
	seller_id,
	count(*) as duplicates
from analytics.dim_seller
group by seller_id
having count(*) >1;

-- Dimension Table : Date --
select
	date_key,
	count(*) as duplicates
from analytics.dim_date
group by date_key
having count(*) >1;

SELECT
    full_date,
    COUNT(*) AS duplicate_count
FROM analytics.dim_date
GROUP BY full_date
HAVING COUNT(*) > 1;

--## Surrogate Key Validation ##--

-- Dimension Table : Customer --
SELECT
    customer_key,
    COUNT(*)
FROM analytics.dim_customer
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- Dimension Table : Seller --
SELECT
    seller_key,
    COUNT(*)
FROM analytics.dim_seller
GROUP BY seller_key
HAVING COUNT(*) > 1;

-- Dimension Table : Product --
SELECT
    product_key,
    COUNT(*)
FROM analytics.dim_product
GROUP BY product_key
HAVING COUNT(*) > 1;



--## Orphan Fact Checks ##--

-- Table : Fact Orders --
-- Missing customer_key in dim_customer
SELECT fo.*
FROM analytics.fact_orders fo
LEFT JOIN analytics.dim_customer dc
    ON fo.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;

-- Missing date_key in dim_date
select fo.*
from analytics.fact_orders fo
left join analytics.dim_date dd
    on fo.date_key = dd.date_key
where dd.date_key IS NULL;

-- Table : Fact Payments --
-- Missing customer_key in dim_customer
SELECT fp.*
FROM analytics.fact_payments fp
LEFT JOIN analytics.dim_customer dc
    ON fp.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;

-- Missing date_key in dim_date
select fp.*
from analytics.fact_payments fp
left join analytics.dim_date dd
    on fp.date_key = dd.date_key
where dd.date_key IS NULL;

-- Table : Fact Order Items --
-- Missing customer_key in dim_customer
SELECT foi.*
FROM analytics.fact_order_items foi
LEFT JOIN analytics.dim_customer dc
    ON foi.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;

-- Missing product_key in dim_product
SELECT foi.*
FROM analytics.fact_order_items foi
LEFT JOIN analytics.dim_product dp
    ON foi.product_key = dp.product_key
WHERE dp.product_key IS NULL;

-- Missing product_key in dim_seller
SELECT foi.*
FROM analytics.fact_order_items foi
LEFT JOIN analytics.dim_seller ds
    ON foi.seller_key = ds.seller_key
WHERE ds.seller_key IS NULL;

-- Missing product_key in dim_date
SELECT foi.*
FROM analytics.fact_order_items foi
LEFT JOIN analytics.dim_date dd
    ON foi.date_key = dd.date_key
WHERE dd.date_key IS NULL;



-- // Missing customer check //--
-- Table : Fact orders
select
    count(*) as missing_customer_count
from analytics.fact_orders fo
join analytics.dim_customer dc
on fo.customer_key = dc.customer_key
where dc.customer_key IS NULL;

-- Table : Fact order items
select
    count(*) as missing_customer_count
from analytics.fact_order_items foi
join analytics.dim_customer dc
on foi.customer_key = dc.customer_key
where dc.customer_key IS NULL;

-- Table : Fact Payments
select
    count(*) as missing_customer_count
from analytics.fact_payments fp
join analytics.dim_customer dc
on fp.customer_key = dc.customer_key
where dc.customer_key IS NULL;


--// Missing Product
SELECT foi.*
FROM analytics.fact_order_items foi
LEFT JOIN analytics.dim_product dp
    ON foi.product_key = dp.product_key
WHERE dp.product_key IS NULL;


--// Missing Seller
SELECT foi.*
FROM analytics.fact_order_items foi
LEFT JOIN analytics.dim_seller ds
    ON foi.seller_key = ds.seller_key
WHERE ds.seller_key IS NULL;

--// Negative Revenue //--

-- Table : Fact Orders
select * 
from analytics.fact_orders
where 
total_order_value < 0
    OR
total_freight < 0
    OR
total_payment < 0;

-- Table : Fact Order Items
select * 
from analytics.fact_order_items
where
    price < 0
    OR
    freight_value < 0;

-- Table : Order Payments
select *
from analytics.fact_payments
where
    payment_value < 0;


--## Impossible Delivery Days ##--
SELECT 'Negative delivery days' AS check_name, COUNT(*) AS issue_count
FROM analytics.fact_orders
WHERE delivery_days < 0

UNION ALL

SELECT 'Delivery days > 90', COUNT(*)
FROM analytics.fact_orders
WHERE delivery_days > 90

UNION ALL

SELECT 'Extreme delay days', COUNT(*)
FROM analytics.fact_orders
WHERE delay_days < -365
   OR delay_days > 365;


--// Future Date checks //--
SELECT 'fact_orders' AS table_name, COUNT(*) AS future_date_count
FROM analytics.fact_orders fo
JOIN analytics.dim_date dd
    ON fo.date_key = dd.date_key
WHERE dd.full_date > CAST(GETDATE() AS DATE)

UNION ALL

SELECT 'fact_order_items', COUNT(*)
FROM analytics.fact_order_items foi
JOIN analytics.dim_date dd
    ON foi.date_key = dd.date_key
WHERE dd.full_date > CAST(GETDATE() AS DATE)

UNION ALL

SELECT 'fact_payments', COUNT(*)
FROM analytics.fact_payments fp
JOIN analytics.dim_date dd
    ON fp.date_key = dd.date_key
WHERE dd.full_date > CAST(GETDATE() AS DATE);


--// Duplicate payment key check //--

WITH duplicate_payments AS
(
    SELECT
        order_id,
        payment_sequential
    FROM analytics.fact_payments
    GROUP BY
        order_id,
        payment_sequential
    HAVING COUNT(*) > 1
)
SELECT fp.*
FROM analytics.fact_payments fp
JOIN duplicate_payments d
    ON fp.order_id = d.order_id
   AND fp.payment_sequential = d.payment_sequential
ORDER BY
    fp.order_id,
    fp.payment_sequential;