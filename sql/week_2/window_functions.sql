--use ecommerce

select * from analytics.dim_customer
select * from analytics.fact_orders
--select * from analytics.fact_order_items
--select * from analytics.dim_product
--select * from analytics.fact_payments
select * from analytics.dim_date
--select * from analytics.dim_seller


--## Top 5 sellers by revenue.
with t5_revenue as (
	select 
		seller_key,
		sum(price) as Revenue
	from analytics.fact_order_items
	group by seller_key
)
select top 5
*,
row_number() over(order by Revenue desc) as Row_num
from t5_revenue;

-- ## Top 3 products per category by revenue.
with product_cat_by_rev as (
	select
		dp.product_key,
		dp.product_category_name as product_category,
		sum(foi.price) as Revenue
	from analytics.fact_order_items foi
	join analytics.dim_product dp
	on foi.product_key = dp.product_key
		group by dp.product_key, dp.product_category_name
)
select top 3
*,
row_number() over(order by Revenue desc) as row_num
from product_cat_by_rev;

-- ## Monthly revenue with previous month revenue.
select
	dd.year,
	dd.month_number,
	dd.month_name,
	sum(fo.total_order_value) as monthly_revenue,
	LAG(sum(fo.total_order_value)) over(order by dd.year,dd.month_number) as previous_month_revenue
from analytics.fact_orders fo
join analytics.dim_date dd
on fo.date_key = dd.date_key
group by
	dd.year,
	dd.month_number,
	dd.month_name
order by 
	dd.year desc,
	dd.month_number;


-- ## Monthly revenue growth percentage.
select
	dd.year,
	dd.month_number,
	dd.month_name,
	sum(fo.total_order_value) as monthly_revenue,
	LAG(sum(fo.total_order_value)) over(order by dd.year,dd.month_number) as previous_month_revenue,
	cast((sum(fo.total_order_value) - LAG(sum(fo.total_order_value)) over(order by dd.year,dd.month_number)) *100 /NULLIF(LAG(sum(fo.total_order_value)) over(order by dd.year,dd.month_number),0) as decimal(10,2)) as revenue_growth_percentage
from analytics.fact_orders fo
join analytics.dim_date dd
on fo.date_key = dd.date_key
group by
	dd.year,
	dd.month_number,
	dd.month_name
order by 
	dd.year desc,
	dd.month_number;

-- ## Customer order ranking by purchase date.
WITH customer_orders AS
(
    SELECT
        dc.customer_unique_id,
        fo.order_id,
        fo.date_key
    FROM analytics.fact_orders fo
    JOIN analytics.dim_customer dc
        ON fo.customer_key = dc.customer_key
)
SELECT
    customer_unique_id,
    order_id,
    date_key,
    ROW_NUMBER() OVER (
        PARTITION BY customer_unique_id
        ORDER BY date_key ASC, order_id
    ) AS purchase_rank
FROM customer_orders
WHERE customer_unique_id IN
(
    SELECT customer_unique_id
    FROM customer_orders
    GROUP BY customer_unique_id
    HAVING COUNT(DISTINCT order_id) > 1
)
ORDER BY customer_unique_id, purchase_rank;