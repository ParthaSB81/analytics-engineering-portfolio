
-- Validation 1:Seller revenue equals item revenue
select * from analytics.fact_order_items;
with seller_total_revenue as (
	select
		sum(price) as seller_revenue
	from analytics.fact_order_items
),
item_total_revenue as (
	select
		sum(price) as item_revenue
	from analytics.fact_order_items
)
select
	seller_revenue,
	item_revenue
from seller_total_revenue
cross join item_total_revenue;

-- Validation 2: Seller contribution totals approximately 100%
WITH seller_revenue AS (
    SELECT
        seller_key,
        SUM(price) AS revenue
    FROM analytics.fact_order_items
    GROUP BY seller_key
),
seller_contribution AS (
    SELECT
        revenue * 100.0
        / NULLIF(SUM(revenue) OVER (), 0) AS contribution_pct
    FROM seller_revenue
)
SELECT
    SUM(contribution_pct) AS total_contribution_pct
FROM seller_contribution;