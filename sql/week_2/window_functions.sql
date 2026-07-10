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
WITH product_cat_by_rev AS
(
    SELECT
        dp.product_key,
        dp.product_category_name AS product_category,
        SUM(foi.price) AS revenue
    FROM analytics.fact_order_items foi
    JOIN analytics.dim_product dp
        ON foi.product_key = dp.product_key
    GROUP BY
        dp.product_key,
        dp.product_category_name
),
ranked_products AS
(
    SELECT
        product_key,
        product_category,
        revenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY product_category
            ORDER BY revenue DESC, product_key
        ) AS row_num
    FROM product_cat_by_rev
)
SELECT
    product_key,
    product_category,
    revenue,
    row_num
FROM ranked_products
WHERE row_num <= 3
ORDER BY
    product_category,
    row_num;

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
	dd.month_number desc;


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