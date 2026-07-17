--use ecommerce

--Seller revenue
select
	ds.seller_key,
	sum(foi.price) as seller_revenue
from analytics.fact_order_items foi
join analytics.dim_seller ds
on foi.seller_key = ds.seller_key
group by ds.seller_key;

-- Seller contribution percentage
with seller_revenue_all as (
	select
		ds.seller_key,
		sum(foi.price) as seller_revenue
	from analytics.fact_order_items foi
	join analytics.dim_seller ds
	on foi.seller_key = ds.seller_key
	group by ds.seller_key
)
select
	seller_key,
	seller_revenue,
	cast(seller_revenue * 100.0 / sum(seller_revenue) over() as decimal(10,2)) as seller_revenue_contrinution
from seller_revenue_all;

-- Orders per seller
select
	ds.seller_key,
	count(distinct foi.order_id) as seller_orders
from analytics.fact_order_items foi
join analytics.dim_seller ds
on foi.seller_key = ds.seller_key
group by ds.seller_key;

-- Average revenue per seller
select
	ds.seller_key,
	cast(avg(foi.price) as decimal(10,2)) as avg_seller_revenue
from analytics.fact_order_items foi
join analytics.dim_seller ds
on foi.seller_key = ds.seller_key
group by ds.seller_key;
