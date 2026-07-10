--- Fact Orders ---
CREATE INDEX IX_fact_orders_customer_key
ON analytics.fact_orders(customer_key);

CREATE INDEX IX_fact_orders_status
ON analytics.fact_orders(order_status);

CREATE INDEX IX_fact_orders_date_key
ON analytics.fact_orders (date_key)
INCLUDE (total_order_value);

--- Fact Payments ---
CREATE INDEX IX_fact_payments_customer
ON analytics.fact_payments(customer_key);

CREATE INDEX IX_fact_payments_date
ON analytics.fact_payments(date_key);

CREATE INDEX IX_fact_payments_type
ON analytics.fact_payments(payment_type);

--- Fact Order Items ---
CREATE INDEX IX_fact_order_items_product_key
ON analytics.fact_order_items (product_key)
INCLUDE (price);
