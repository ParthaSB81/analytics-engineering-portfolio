-- Dimention table : customer --
ALTER TABLE analytics.dim_customer
ADD CONSTRAINT PK_dim_customer
PRIMARY KEY (customer_key);

ALTER TABLE analytics.dim_customer
ALTER COLUMN  customer_key INT NOT NULL;

ALTER TABLE analytics.dim_customer
ALTER COLUMN  customer_id varchar(50) NOT NULL;

ALTER TABLE analytics.dim_customer
ALTER COLUMN  customer_unique_id varchar(50) NOT NULL;

ALTER TABLE analytics.dim_customer
ALTER COLUMN  customer_city varchar(100) NOT NULL;

ALTER TABLE analytics.dim_customer
ALTER COLUMN  customer_state char(2) NOT NULL;

-- Dimention table : product --

ALTER TABLE analytics.dim_product
ADD CONSTRAINT PK_dim_product
PRIMARY KEY (product_key);

ALTER TABLE analytics.dim_product
ADD CONSTRAINT UQ_dim_product_product_id
UNIQUE (product_id);

ALTER TABLE analytics.dim_product
ADD CONSTRAINT CHK_dim_product_weight
CHECK (
    product_weight_g IS NULL
    OR product_weight_g >= 0
);

ALTER TABLE analytics.dim_product
ADD CONSTRAINT CHK_dim_product_dimensions
CHECK (
    (product_length_cm IS NULL OR product_length_cm >= 0)
    AND
    (product_height_cm IS NULL OR product_height_cm >= 0)
    AND
    (product_width_cm IS NULL OR product_width_cm >= 0)
);


-- Dimention table : Date --
ALTER TABLE analytics.dim_date
ADD CONSTRAINT PK_dim_date
PRIMARY KEY (date_key);

ALTER TABLE analytics.dim_date
ADD CONSTRAINT UQ_dim_date_full_date
UNIQUE (full_date);

ALTER TABLE analytics.dim_date
ADD CONSTRAINT CHK_dim_date_month
CHECK (month_number BETWEEN 1 AND 12);

ALTER TABLE analytics.dim_date
ADD CONSTRAINT CHK_dim_date_quarter
CHECK (quarter BETWEEN 1 AND 4);

ALTER TABLE analytics.dim_date
ADD CONSTRAINT CHK_dim_date_day
CHECK (day_number BETWEEN 1 AND 31);


-- Dimention table : Seller --
ALTER TABLE analytics.dim_seller
ADD CONSTRAINT PK_dim_seller
PRIMARY KEY (seller_key);

ALTER TABLE analytics.dim_seller
ADD CONSTRAINT CHK_seller_state
CHECK (LEN(seller_state) = 2);


-- Fact table : Orders --
ALTER TABLE analytics.dim_customer
ADD CONSTRAINT FK_fact_orders_customer
FOREIGN KEY (customer_key)
REFERENCES analytics.dim_customer(customer_key);

ALTER TABLE analytics.dim_date
ADD CONSTRAINT FK_fact_orders_date
FOREIGN KEY (date_key)
REFERENCES analytics.dim_date(date_key);

ALTER TABLE analytics.fact_orders
ADD CONSTRAINT CHK_fact_total_order_value
CHECK (total_order_value >= 0);

ALTER TABLE analytics.fact_orders
ADD CONSTRAINT CHK_fact_total_freight
CHECK (total_freight >= 0);

ALTER TABLE analytics.fact_orders
ADD CONSTRAINT CHK_fact_total_payment
CHECK (total_payment >= 0);

-- Fact table : Orders Items--

ALTER TABLE analytics.fact_order_items
ADD CONSTRAINT FK_fact_order_items_product
FOREIGN KEY (product_key)
REFERENCES analytics.dim_product(product_key);

ALTER TABLE analytics.fact_order_items
ADD CONSTRAINT FK_fact_order_items_seller
FOREIGN KEY (seller_key)
REFERENCES analytics.dim_seller(seller_key);

ALTER TABLE analytics.fact_order_items
ADD CONSTRAINT FK_fact_order_items_date
FOREIGN KEY (date_key)
REFERENCES analytics.dim_date(date_key);

ALTER TABLE analytics.fact_order_items
ADD CONSTRAINT CHK_fact_order_items_price
CHECK (price >= 0);

ALTER TABLE analytics.fact_order_items
ADD CONSTRAINT CHK_fact_order_items_freight
CHECK (freight_value >= 0);

--Fact table : Payments--
ALTER TABLE analytics.fact_payments
ADD CONSTRAINT PK_fact_payments
PRIMARY KEY (order_id, payment_sequential);

ALTER TABLE analytics.fact_payments
ADD CONSTRAINT FK_fact_payments_customer
FOREIGN KEY (customer_key)
REFERENCES analytics.dim_customer(customer_key);

ALTER TABLE analytics.fact_payments
ADD CONSTRAINT FK_fact_payments_date
FOREIGN KEY (date_key)
REFERENCES analytics.dim_date(date_key);

ALTER TABLE analytics.fact_payments
ADD CONSTRAINT CHK_payment_sequential
CHECK (payment_sequential >= 1);

ALTER TABLE analytics.fact_payments
ADD CONSTRAINT CHK_payment_installments
CHECK (payment_installments >= 0);

ALTER TABLE analytics.fact_payments
ADD CONSTRAINT CHK_payment_value
CHECK (payment_value  >= 0);

