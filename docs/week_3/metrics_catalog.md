# Metics Catalog

## Total Revenue

**Business definition:**  
Total value of completed customer orders.

**Formula:**  
SUM(total_order_value)

**Source table:**  
analytics.fact_orders

**Grain:**  
One row per order

**Filters:**  
order_status = 'delivered'

**Refresh frequency:**  
Daily

**Known limitations:**  
Cancelled and unavailable orders are excluded.


## Total orders

**Business definition:**  
Total order count of delivered orders.

**Formula:**  
count(distinct order_id)

**Source table:**  
analytics.fact_orders

**Grain:**  
One row per order

**Filters:**  
order_status = 'delivered'

**Refresh frequency:**  
Daily

**Known limitations:**  
Only delivered orders are accounted for.


## Average order value

**Business definition:** 
Average order values for the entire order inventory.

**Formula:**  
sum(price)/count(distinct order_id)

**Source table:**  
analytics.fact_orders

**Grain:**  
One row per completed order.

**Filters:**  
order_status = 'delivered'

**Refresh frequency:**  
Daily

**Known limitations:**  
Only delivered orders are accounted for.


## Total customers

**Business definition:** 
Total customer count.

**Formula:**
count(distinct(customer_unique_id))

**Source table:** 
analytics.dim_customer

**Grain:**  
One row = one customer.

**Filters:**
Customers with customer_unique_id

**Refresh frequency:**  
Daily

**Known limitations:**  
Only customers with customer_unique_id are considered.


## Repeat customer rate

**Business definition:** 
Percentage of customers with more than one completed purchase.

**Formula:**
Repeat Customer Rate =
(Repeat Customers / Total Customers) × 100

**Source table:**
analytics.fact_orders
analytics.dim_customer

**Grain:**  
One row = one customer.

**Filters:**
Include only delivered orders.

**Refresh frequency:**  
Daily

**Known limitations:**  
Only delivered orders are accounted for.


## Seller contribution percentage

**Business definition:** 
Percentage of total revenue contributed by each seller.

**Formula:**
Seller contribution percentage =
(sum(price) / Total sum(price)) x 100

**Source table:**
analytics.fact_order_items

**Grain:**  
One row = one seller.

**Filters:**
Freight charges are excluded from seller revenue.

**Refresh frequency:**  
Daily



## Payment-method contribution

**Business definition:** 
Percentage of total payment by each payment type.

**Formula:**
Payment By Type /SUM(Payment By Type) x 100

**Source table:**
analytics.fact_payments

**Grain:** 
One Row = One Payment Method

**Filters:**
Exclused where Payment Method in undefined.

**Refresh frequency:**  
Daily

**Known limitations:**
Only defined Payment methods are considered


## Average delivery days

**Business definition:**
Average of total delivery days for delivered orders.

**Formula:**
avg(delivery_days)

**Source table:**
analytics.fact_orders

**Grain:** 
One row = One completed order.

**Filters:**
Order Status = Delivered

**Refresh frequency:**  
Daily

**Known limitations:**
Only delivered are considered

## Delivery delay by product category.

**Business definition:**
Delay days by product category

**Formula:**
sum(delay_days) per product category

**Source table:**
analytics.fact_payments

**Grain:** 
Total delay days per product category = one row

**Filters:**
Delivery daelay days greater than one

**Refresh frequency:**  
Daily

**Known limitations:**
Only delivery delay days greater than one are considered


## Cancellation rate

**Business definition:**
The percentage of order cancelled out of all orders

**Formula:**
Cancelled Orders / Total Orders x 100

**Source table:**
analytics.fact_orders

**Grain:** 
One row = entire business

**Filters:**
Only cancelled orders are considered.

**Refresh frequency:**  
Daily