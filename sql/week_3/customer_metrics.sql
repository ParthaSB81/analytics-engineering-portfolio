-- Total unique customers(who purchased)
select
	count(distinct dc.customer_unique_id) as total_unique_customers
from analytics.dim_customer dc
join analytics.fact_orders fo
on fo.customer_key = dc.customer_key
where fo.order_status = 'delivered';

-- Customer lifetime order count
select
	dc.customer_unique_id,
	count(fo.order_id) as lifetime_orders
from analytics.dim_customer dc
join analytics.fact_orders fo
on fo.customer_key = dc.customer_key
where fo.order_status = 'delivered'
group by dc.customer_unique_id
order by count(fo.order_id) desc;


-- Repeat customers(Repeat customer as someone with more than one delivered order)
select
	dc.customer_unique_id as repeat_customers
from analytics.dim_customer dc
join analytics.fact_orders fo
on fo.customer_key = dc.customer_key
where fo.order_status = 'delivered'
group by dc.customer_unique_id
having count(fo.order_id) > 1
order by count(fo.order_id) desc;

-- Repeat purchase rate
with customer_orders as (
	select
		dc.customer_unique_id,
		count(distinct fo.order_id) as order_count
	from analytics.dim_customer dc
	join analytics.fact_orders fo
	on fo.customer_key = dc.customer_key
	where fo.order_status = 'delivered'
	group by dc.customer_unique_id
)
select
	count(*) as total_customers,
	sum(
		case 
			when order_count > 1 then 1
			else 0
		end
	) as repeat_customers,
	cast(sum(
		case 
			when order_count > 1 then 1
			else 0
		end
	) * 100.0 
	/ nullif(count(*), 0) as decimal(10,2)) as repeat_purchase_rate
from customer_orders;


-- Customer lifetime value
select
	dc.customer_unique_id,
	count(distinct fo.order_id) as lifetime_orders,
	sum(fo.total_order_value) as customer_lifetime_value
from analytics.dim_customer dc
join analytics.fact_orders as fo
	on fo.customer_key = dc.customer_key
where fo.order_status = 'delivered'
group by dc.customer_unique_id
order by customer_lifetime_value desc;


    SELECT
        dc.customer_unique_id,
        fo.order_id,
        dd.full_date AS order_date,
        DATEFROMPARTS(dd.year, dd.month_number, 1) AS order_month
    FROM analytics.fact_orders fo
    JOIN analytics.dim_customer dc
        ON fo.customer_key = dc.customer_key
    JOIN analytics.dim_date dd
        ON fo.date_key = dd.date_key
    WHERE fo.order_status = 'delivered'