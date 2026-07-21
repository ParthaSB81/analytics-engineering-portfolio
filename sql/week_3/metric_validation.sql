use ecommerce
-- Validation 1:Seller revenue equals item revenue
select * from analytics.fact_order_items;
with seller_total_revenue as (
	select
		sum(price) as seller_revenue
	from analytics.fact_order_items
),
item_total_revenue as (
	select
		sum(price) as item_revenue
	from analytics.fact_order_items
)
select
	seller_revenue,
	item_revenue
from seller_total_revenue
cross join item_total_revenue;

-- Validation 2: Seller contribution totals approximately 100%
WITH seller_revenue AS (
    SELECT
        seller_key,
        SUM(price) AS revenue
    FROM analytics.fact_order_items
    GROUP BY seller_key
),
seller_contribution AS (
    SELECT
        revenue * 100.0
        / NULLIF(SUM(revenue) OVER (), 0) AS contribution_pct
    FROM seller_revenue
)
SELECT
    SUM(contribution_pct) AS total_contribution_pct
FROM seller_contribution;

-- ## Validation 3: New plus repeat customers
with customer_order as (
    select
        dc.customer_unique_id,
        fo.order_id,
        fo.date_key
    from analytics.dim_customer dc
    join analytics.fact_orders fo
    on fo.customer_key = dc.customer_key
    where fo.order_status = 'delivered'
),
customer_month as (
    select distinct
         co.customer_unique_id,
         DATEFROMPARTS(dd.year, dd.month_number, 1) AS order_month
    from customer_order co
    join analytics.dim_date dd
    on co.date_key = dd.date_key
),
customer_type as (
    select
             customer_unique_id,
             order_month,
             min(order_month) over(partition by customer_unique_id) as first_order_month,
             CASE
                 WHEN order_month = min(order_month) over(partition by customer_unique_id) THEN 'New'
                 ELSE 'Repeat'
             END AS customer_type
    from customer_month
)
select
    sum(case 
        when customer_type = 'New' then 1
        else 0
    end) as New_Customers,
    sum(case 
        when customer_type = 'Repeat' then 1
        else 0
    end) as Repeat_Customers,
    count(*) as Total_Custsomers
from customer_type;


-- ## Validation 4: Revenue source reconciliation
WITH order_metrics AS (
    SELECT
        SUM(total_order_value) AS order_merchandise_value,
        SUM(total_freight) AS order_freight_value,
        SUM(total_payment) AS order_payment_value
    FROM analytics.fact_orders
),
item_metrics AS (
    SELECT
        SUM(price) AS item_merchandise_value,
        SUM(freight_value) AS item_freight_value,
        SUM(price + freight_value) AS item_gross_value
    FROM analytics.fact_order_items
),
payment_metrics AS (
    SELECT
        SUM(payment_value) AS payment_value
    FROM analytics.fact_payments
)
SELECT
    om.order_merchandise_value,
    im.item_merchandise_value,
    om.order_merchandise_value - im.item_merchandise_value
        AS merchandise_variance,

    om.order_freight_value,
    im.item_freight_value,
    om.order_freight_value - im.item_freight_value
        AS freight_variance,

    om.order_merchandise_value + om.order_freight_value
        AS order_gross_value,
    im.item_gross_value,
    (om.order_merchandise_value + om.order_freight_value)
        - im.item_gross_value AS gross_value_variance,

    om.order_payment_value,
    pm.payment_value,
    om.order_payment_value - pm.payment_value
        AS payment_variance
FROM order_metrics om
CROSS JOIN item_metrics im
CROSS JOIN payment_metrics pm;

-- ## Validation 5: Status filter impact
select sum(total_order_value) as revenue 
from analytics.fact_orders;

-- This will be the right metric as it shows the realized revenue
select sum(total_order_value) as revenue 
from analytics.fact_orders
where order_status = 'delivered';

select sum(total_order_value) as revenue 
from analytics.fact_orders
where order_status not in ('canceled', 'unavailable');

-- ## Validation 6: Grain checks
SELECT
    order_id,
    COUNT(*) AS row_count
FROM analytics.fact_orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT
    order_id,
    product_key,
    seller_key,
    COUNT(*) AS row_count
FROM analytics.fact_order_items
GROUP BY
    order_id,
    product_key,
    seller_key
HAVING COUNT(*) > 1;

-- The above query validates the Grain of one row per order item

