--use ecommerce

SET STATISTICS IO ON;
SET STATISTICS TIME ON;

/*-- Monthly revenue
select
	dd.year,
	dd.month_number,
	dd.month_name,
	cast(sum(fo.total_order_value) as decimal(10,0)) as Monthly_Revenue
from analytics.dim_date dd
join analytics.fact_orders fo
on fo.date_key = dd.date_key
where fo.order_status = 'delivered'
group by 
	dd.year,
	dd.month_number,
	dd.month_name
order by
	dd.year,
	dd.month_number;


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
*/

-- Delivery performance by state
SELECT
    dc.customer_state,
    COUNT(*) AS valid_delivered_orders,

    CAST(
        AVG(fo.delivery_days * 1.0)
        AS DECIMAL(10,2)
    ) AS avg_delivery_days,

    CAST(
        SUM(
            CASE
                WHEN fo.delay_days > 0 THEN 1
                ELSE 0
            END
        ) * 100.0
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS late_delivery_pct
FROM analytics.fact_orders fo
JOIN analytics.dim_customer dc
    ON fo.customer_key = dc.customer_key
WHERE fo.order_status = 'delivered'
  AND fo.delivery_days IS NOT NULL
  AND fo.delay_days IS NOT NULL
GROUP BY
    dc.customer_state
HAVING COUNT(*) >= 30
ORDER BY
    late_delivery_pct DESC;