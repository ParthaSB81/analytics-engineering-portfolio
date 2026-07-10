# Query Optimization Details

## Query for : Top 3 products per category by revenue.

Original Query:
---------------
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

New Query:
-----------
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


My original query did not return the top 3 products per category instead it returned only the top 3 products overall, because 
    - SELECT TOP 3
        - limits the complete result set
    - ROW_NUMBER() OVER (ORDER BY Revenue DESC)
        - does not restart ranking for each category.
    
Index needed:
    - product_key is already the primary key, the primary key generally already creates an index.    
    - But the foriegn ket index below will be useful for joining and aggregating:
        CREATE INDEX IX_fact_order_items_product_key
        ON analytics.fact_order_items (product_key)
        INCLUDE (price);



## Query for : Monthly revenue with previous month revenue.


Original Query:
---------------
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
    
New Query:
-----------
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
        dd.month_number desc; <-----


The original query is logically sound, but only one small tweak was needed:
    ORDER BY
    year DESC,
    month_number DESC;

    - For latest month first 

Index needed:
    CREATE INDEX IX_fact_orders_date_key
    ON analytics.fact_orders (date_key)
    INCLUDE (total_order_value);    

    - date_key is used in the join.
    - total_order_value is required for the aggregation.