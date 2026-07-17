-- Revenue by product category
select
	dp.product_category_name,
	cast(sum(foi.price) as decimal(10,2)) as product_revenue
from analytics.fact_order_items foi
join analytics.dim_product dp
on foi.product_key = dp.product_key
group by 
	dp.product_category_name
order by sum(foi.price) desc;

-- Product contribution percentage
with product_rev_cat as (
	select
		dp.product_category_name,
		cast(sum(foi.price) as decimal(10,2)) as product_revenue
	from analytics.fact_order_items foi
	join analytics.dim_product dp
	on foi.product_key = dp.product_key
	group by 
		dp.product_category_name
)
select
	product_category_name,
	product_revenue as product_revenue_by_cat,
	cast(product_revenue * 100.0 / nullif(sum(product_revenue) over(),0) as decimal(10,2)) as product_contri_percentage
from product_rev_cat
order by product_revenue desc;
-- Average Order Value (AOV) by Product Category
with product_category_order_price as (
	select
		dp.product_category_name,
		count(distinct foi.order_id) as cat_orders,
		sum(foi.price) as cat_orders_price
	from analytics.fact_order_items foi
	join analytics.dim_product dp
	on foi.product_key = dp.product_key
	group by 
		dp.product_category_name
)
select
	product_category_name,
	cat_orders,
	cast(cat_orders_price / cat_orders as decimal(10,2)) as avg_selling_price_cat
from product_category_order_price
order by avg_selling_price_cat desc;

-- Average selling price by category
SELECT
    dp.product_category_name,
    CAST(AVG(foi.price) AS DECIMAL(18,2)) AS avg_selling_price
FROM analytics.fact_order_items foi
JOIN analytics.dim_product dp
    ON foi.product_key = dp.product_key
GROUP BY
    dp.product_category_name
ORDER BY
    avg_selling_price DESC;