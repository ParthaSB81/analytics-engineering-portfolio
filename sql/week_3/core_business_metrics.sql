-- Total Revenue
select 
	cast(sum(total_order_value) as decimal(15,2)) as Total_Revenue
from analytics.fact_orders
where order_status = 'delivered';

-- Total Orders
select 
	count(distinct order_id) as Total_Orders
from analytics.fact_orders
where order_status = 'delivered';

-- Average Order Value
select
	cast(sum(total_order_value) / nullif(count(distinct order_id),0) as decimal(10,2)) as Average_Order_Value
from analytics.fact_orders;

-- Monthly revenue
select
	dd.year,
	dd.month_number,
	dd.month_name,
	cast(sum(fo.total_order_value) as decimal(10,0)) as Monthly_Revenue
from analytics.dim_date dd
join analytics.fact_orders fo
on fo.date_key = dd.date_key
group by 
	dd.year,
	dd.month_number,
	dd.month_name
order by
	dd.year,
	dd.month_number;

-- Month-over-month revenue growth
with monthly_revenue as (
	select
		dd.year,
		dd.month_number,
		dd.month_name,
		cast(sum(fo.total_order_value) as decimal(10,2)) as Monthly_Revenue
	from analytics.dim_date dd
	join analytics.fact_orders fo
	on fo.date_key = dd.date_key
	group by 
		dd.year,
		dd.month_number,
		dd.month_name
),
previous_month_revenue as (
	select
		year,
		month_number,
		month_name,
		Monthly_Revenue,
		LAG(Monthly_Revenue) over(order by year,month_number) as Previous_Month_Revenue	
	from monthly_revenue
)
select
		year,
		month_number,
		month_name,
		Monthly_Revenue,
		Previous_Month_Revenue,
		cast((Monthly_Revenue - Previous_Month_Revenue) * 100 / nullif(Previous_Month_Revenue,0) as decimal(10,2)) as Monthly_Revenue_Growth
from previous_month_revenue
	order by 
		year,
		month_number;


-- Cancellation Rate
select
	count(distinct order_id) as total_orders,
	sum(
		case 
			when order_status = 'canceled' then 1
			else 0
		end
		) as cancelled_orders,
		cast( sum(
		case 
			when order_status = 'canceled' then 1
			else 0
		end
		) * 100.0
		/ nullif(count(distinct order_id), 0) as decimal(10,2) ) as cancellation_rate
from analytics.fact_orders;


-- New versus repeat customers by month
with customer_orders as (
	select
		dc.customer_unique_id,
		fo.order_id,
		dd.full_date as order_date,
		DATEFROMPARTS(dd.year, dd.month_number, 1) AS order_month
		from analytics.fact_orders fo
		join analytics.dim_customer dc
		on fo.customer_key = dc.customer_key
		join analytics.dim_date dd
		on fo.date_key = dd.date_key
		WHERE fo.order_status = 'delivered'
),
first_purchase as (
	select 
		customer_unique_id,
		MIN(order_date) as first_purchase_date
from customer_orders
group by customer_unique_id
)
select
	co.order_month,
	count(distinct case
					when co.order_date = fp.first_purchase_date then co.customer_unique_id
					else null
				   end
	) as New_Customers,

	count(distinct case
					when co.order_date > fp.first_purchase_date then co.customer_unique_id
					else null
				   end
	) as Repeat_customers
from customer_orders co
join first_purchase fp
on co.customer_unique_id = fp.customer_unique_id
group by 
	co.order_month
order by 
	co.order_month;