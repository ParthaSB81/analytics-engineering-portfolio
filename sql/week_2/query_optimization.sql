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