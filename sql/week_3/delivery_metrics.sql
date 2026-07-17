--use ecommerce
-- Average delivery days
select 
	avg(delivery_days) as avg_delivery_days	
from analytics.fact_orders
where order_status = 'delivered'
	and delivery_days is not null
	and delivery_days >0;

-- Late delivery percentage
select 
	count(order_id) as total_delivery,
	sum( case
				when delay_days > 0 then 1
				else 0
			end	
	) as late_delivery,

	cast(sum( case
				when delay_days > 0 then 1
				else 0
			end	
	) * 100.0
	/ 
	nullif(count(order_id),0) as decimal(10,2)) as late_delivery_percentage

from analytics.fact_orders
where order_status = 'delivered'
	and delay_days is not null;


-- On-time delivery percentage
select 
	count(order_id) as total_delivery,
	sum( case
				when delay_days <= 0 then 1
				else 0
			end	
	) as ontime_delivery,

	cast(sum( case
				when delay_days <= 0 then 1
				else 0
			end	
	) * 100.0
	/ 
	nullif(count(order_id),0) as decimal(10,2)) as ontime_delivery_percentage

from analytics.fact_orders
where order_status = 'delivered'
	and delay_days is not null;

-- Delivery performance by state
SELECT
    dc.customer_state,
    COUNT(*) AS delivered_orders,

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
--The HAVING COUNT(*) >= 30 condition prevents very small states or groups from appearing as the worst performers due to only one or two orders.