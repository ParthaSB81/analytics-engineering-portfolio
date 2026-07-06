--// Data reconciliation //--

-- ## customer data reconciliation ## --
-- customer count
select 
'raw' as schema_name,
count(distinct(customer_unique_id)) as customer_count 
from raw.raw_customers

UNION ALL

select
'stg',
count(distinct(customer_unique_id)) as customer_count 
from stg.stg_customers

UNION ALL

select 
'analytics',
count(distinct(customer_unique_id)) as customer_count 
from analytics.dim_customer;


-- ## product data reconciliation ## --
-- product count
select 
'raw' as schema_name,
count(distinct(product_id)) as product_count 
from raw.raw_products

UNION ALL

select
'stg',
count(distinct(product_id)) as product_count 
from stg.stg_products

UNION ALL

select 
'analytics',
count(distinct(product_id)) as product_count 
from analytics.dim_product;

-- product category count
select 
'raw' as schema_name,
count(distinct(product_category_name)) as product_category_count 
from raw.raw_products

UNION ALL

select
'stg',
count(distinct(product_category_name)) as product_category_count 
from stg.stg_products

UNION ALL

select 
'analytics',
count(distinct(product_category_name)) as product_category_count 
from analytics.dim_product;


-- ## seller data reconciliation ## --
-- seller count
select 
'raw' as schema_name,
count(distinct(seller_id)) as seller_count 
from raw.raw_sellers

UNION ALL

select
'stg',
count(distinct(seller_id)) as seller_count 
from stg.stg_sellers

UNION ALL

select 
'analytics',
count(distinct(seller_id)) as seller_count 
from analytics.dim_seller;


-- ## order data reconciliation ## --
-- order count
select 
'raw' as schema_name,
count(distinct(order_id)) as order_count 
from raw.raw_orders

UNION ALL

select
'stg',
count(distinct(order_id)) as order_count 
from stg.stg_orders

UNION ALL

select 
'analytics',
count(distinct(order_id)) as order_count 
from analytics.fact_orders;

-- order payment total
select 
'raw' as schema_name,
sum(payment_value) as total_payment
from raw.raw_order_payments

UNION ALL

select
'stg',
sum(payment_value) as total_payment 
from stg.stg_order_payments

UNION ALL

select 
'analytics',
sum(total_payment) as total_payment 
from analytics.fact_orders;


-- order freight total
select 
'raw' as schema_name,
sum(freight_value) as total_freight
from raw.raw_order_items

UNION ALL

select
'stg',
sum(freight_value) as total_freight 
from stg.stg_order_items

UNION ALL

select 
'analytics',
sum(total_freight) as total_freight 
from analytics.fact_orders;

-- total revenue
select 
'raw' as schema_name,
sum(price) as total_revenue
from raw.raw_order_items

UNION ALL

select
'stg',
sum(price) as total_revenue 
from stg.stg_order_items

UNION ALL

select 
'analytics',
sum(total_order_value) as total_revenue 
from analytics.fact_orders;
