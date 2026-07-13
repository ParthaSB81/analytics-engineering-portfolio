-- ## Top 2 sellers per state by revenue.
with seller_state_rev as (
	select
		dm.seller_key,
		dm.seller_state,
		sum(foi.price) as state_revenue
	from analytics.fact_order_items foi
	join analytics.dim_seller dm
	on foi.seller_key = dm.seller_key
	group by dm.seller_key,dm.seller_state
),
ranked_sellers as (
	select
		seller_key,
		seller_state,
		state_revenue,
		row_number() over(partition by seller_state order by state_revenue desc,seller_key ) as Row_Num
	from seller_state_rev
)
select
		seller_key,
		seller_state,
		state_revenue,	
		Row_Num
from ranked_sellers
where Row_Num <=2;

-- ## First order date per customer.
WITH customer_monthly_orders AS
(
    SELECT DISTINCT
        dc.customer_unique_id,
        dd.year,
        dd.month_number,
        dd.month_name,
        dd.year * 100 + dd.month_number AS year_month
    FROM analytics.fact_orders fo
    JOIN analytics.dim_customer dc
        ON fo.customer_key = dc.customer_key
    JOIN analytics.dim_date dd
        ON fo.date_key = dd.date_key
),
customer_first_month AS
(
    SELECT
        customer_unique_id,
        MIN(year_month) AS first_order_month
    FROM customer_monthly_orders
    GROUP BY customer_unique_id
),
customer_classification AS
(
    SELECT
        cmo.customer_unique_id,
        cmo.year,
        cmo.month_number,
        cmo.month_name,
        CASE
            WHEN cmo.year_month = cfm.first_order_month
                THEN 'New'
            ELSE 'Repeat'
        END AS customer_type
    FROM customer_monthly_orders cmo
    JOIN customer_first_month cfm
        ON cmo.customer_unique_id = cfm.customer_unique_id
)
SELECT
    year,
    month_number,
    month_name,
    SUM(
        CASE
            WHEN customer_type = 'New' THEN 1
            ELSE 0
        END
    ) AS new_customers,
    SUM(
        CASE
            WHEN customer_type = 'Repeat' THEN 1
            ELSE 0
        END
    ) AS repeat_customers,
    COUNT(*) AS monthly_active_customers
FROM customer_classification
GROUP BY
    year,
    month_number,
    month_name
ORDER BY
    year,
    month_number;


-- ## 7-day repeat purchase rate.
select * from analytics.dim_customer
select * from analytics.fact_order_items
select * from analytics.fact_orders;

WITH ranked_orders AS
(
    SELECT
        dc.customer_unique_id,
        fo.order_id,
        dd.full_date AS order_date,
        ROW_NUMBER() OVER
        (
            PARTITION BY dc.customer_unique_id
            ORDER BY dd.full_date, fo.order_id
        ) AS order_rank
    FROM analytics.fact_orders fo
    JOIN analytics.dim_customer dc
        ON fo.customer_key = dc.customer_key
    JOIN analytics.dim_date dd
        ON fo.date_key = dd.date_key
    WHERE fo.order_status = 'delivered'
),
customer_first_second_orders AS
(
    SELECT
        customer_unique_id,
        MAX(CASE WHEN order_rank = 1 THEN order_date END) AS first_order_date,
        MAX(CASE WHEN order_rank = 2 THEN order_date END) AS second_order_date
    FROM ranked_orders
    WHERE order_rank <= 2
    GROUP BY customer_unique_id
)
SELECT
    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN second_order_date IS NOT NULL
             AND DATEDIFF(DAY, first_order_date, second_order_date)
                 BETWEEN 0 AND 7
            THEN 1
            ELSE 0
        END
    ) AS customers_repeated_within_7_days,

    CAST(
        SUM(
            CASE
                WHEN second_order_date IS NOT NULL
                 AND DATEDIFF(DAY, first_order_date, second_order_date)
                     BETWEEN 0 AND 7
                THEN 1
                ELSE 0
            END
        ) * 100.0
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS repeat_purchase_rate_7_day_pct
FROM customer_first_second_orders;


 
 -- ## Products never sold.
  select 
    dp.product_key,
    count(foi.order_id) as product_sell_count
 from analytics.fact_order_items foi
 left join analytics.dim_product dp
 on foi.product_key = dp.product_key
 group by dp.product_key
 having count(foi.order_id) = 0;

 -- Alternative approach
 SELECT
    dp.product_key
FROM analytics.dim_product dp
WHERE NOT EXISTS
(
    SELECT 1
    FROM analytics.fact_order_items foi
    WHERE foi.product_key = dp.product_key
);

-- ## Sellers with declining revenue for 3 consecutive months.
with seller_monthly_revenue as ( 
  select 
    ds.seller_key,
    dd.year,
    dd.month_number,
    dd.year * 100 + dd.month_number AS year_month,
    sum(foi.price) as Revenue
  from analytics.fact_order_items foi
  join analytics.dim_seller ds
  on foi.seller_key = ds.seller_key
  join analytics.dim_date dd
  on foi.date_key = dd.date_key
  group by 
    ds.seller_key,
    dd.year,
    dd.month_number
),
months AS
(
    SELECT DISTINCT
        year,
        month_number,
        year * 100 + month_number AS year_month
    FROM analytics.dim_date
),
sellers AS
(
    SELECT seller_key
    FROM analytics.dim_seller
),
seller_months AS
(
    SELECT
        s.seller_key,
        m.year,
        m.month_number,
        m.year_month
    FROM sellers s
    CROSS JOIN months m
),
complete_seller_revenue AS
(
    SELECT
        sm.seller_key,
        sm.year,
        sm.month_number,
        sm.year_month,
        COALESCE(smr.revenue, 0) AS revenue
    FROM seller_months sm
    LEFT JOIN seller_monthly_revenue smr
        ON sm.seller_key = smr.seller_key
       AND sm.year_month = smr.year_month
),
revenue_history AS
(
    SELECT
        seller_key,
        year_month,
        revenue,

        LAG(revenue, 1) OVER
        (
            PARTITION BY seller_key
            ORDER BY year_month
        ) AS revenue_1_month_ago,

        LAG(revenue, 2) OVER
        (
            PARTITION BY seller_key
            ORDER BY year_month
        ) AS revenue_2_months_ago,

        LAG(revenue, 3) OVER
        (
            PARTITION BY seller_key
            ORDER BY year_month
        ) AS revenue_3_months_ago
    FROM complete_seller_revenue
)
SELECT
    seller_key,
    year_month AS decline_ending_month,
    revenue_3_months_ago,
    revenue_2_months_ago,
    revenue_1_month_ago,
    revenue AS current_month_revenue
FROM revenue_history
WHERE revenue_2_months_ago < revenue_3_months_ago
  AND revenue_1_month_ago < revenue_2_months_ago
  AND revenue < revenue_1_month_ago
ORDER BY
    seller_key,
    year_month;

-- ## Customers with highest lifetime value.
select top 5
    dc.customer_unique_id,
    sum(fo.total_order_value) as customer_lifetime_value
from analytics.fact_orders fo
join analytics.dim_customer dc
on fo.customer_key = dc.customer_key
where fo.order_status = 'delivered'
group by dc.customer_unique_id
order by customer_lifetime_value desc;

-- ## Delivery delay by product category.
select
    dp.product_category_name,
    sum(foi.delay_days) as Delivery_delay
from analytics.fact_order_items foi
join analytics.dim_product dp
on foi.product_key = dp.product_key
where foi.delay_days >0
group by dp.product_category_name
order by Delivery_delay desc;


-- ## Payment method contribution.
with total_payment_by_type as (
    select
        payment_type,
        sum(payment_value) as payment_by_type
    from 
    analytics.fact_payments
    where payment_type != 'not_defined'
    group by payment_type
)
select
    payment_type,
    payment_by_type,
    cast(payment_by_type * 100.0 /NULLIF(sum(payment_by_type) over(),0) as decimal(10,2)) as 'Contribution%'
from total_payment_by_type
order by payment_by_type desc;


-- ## Month-over-month revenue growth.
with monthly_revenue as (
SELECT
    dd.year,
    dd.month_number,
    SUM(fo.total_order_value) AS monthly_revenue
FROM analytics.fact_orders fo
JOIN analytics.dim_date dd
    ON fo.date_key = dd.date_key
GROUP BY
    dd.year,
    dd.month_number
)
SELECT
    year,
    month_number,
    monthly_revenue,

    LAG(monthly_revenue)
    OVER(
        ORDER BY year, month_number
    ) AS previous_month_revenue,

    CAST(
        (
            monthly_revenue -
            LAG(monthly_revenue)
            OVER(ORDER BY year, month_number)
        )
        *100.0
        /
        NULLIF(
            LAG(monthly_revenue)
            OVER(ORDER BY year, month_number),
            0
        )
        AS DECIMAL(10,2)
    ) AS mom_growth_pct

FROM monthly_revenue
ORDER BY
    year,
    month_number;