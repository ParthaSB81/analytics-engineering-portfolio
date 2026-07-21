# Metics Catalog

## Query: Monthly Revenue

**Execution time:** 137 ms  
**CPU time:** 78 ms  
**Logical reads:** 11563  
**Main operation:** Clustered index scan  
**Observation:** fact_orders is scanned because date_key and order_status are used together.


## Query: Seller contribution percentage

**Execution time:** 295 ms  
**CPU time:** 141 ms  
**Logical reads:** 43686  
**Main operation:** fact_order_items scan 
**Observation:** The fact_order_items scan is the main estimated cost driver, but it is not automatically a performance problem because this query intentionally aggregates the entire table.

## Query: Repeat purchase rate

**Execution time:** 899 ms  
**CPU time:** 828 ms  
**Logical reads:** 13958  
**Main operation:** fact_orders table sort operation DISTINCT(sort)
**Observation:**fact_orders grain is one row per order. If order_id is unique in fact_orders, then after joining to dim_customer, each order should still appear once, hence DISTINCT can be avoided

## Query: Revenue by product category

**Execution time:** 218 ms  
**CPU time:** 156 ms  
**Logical reads:** 782  
**Main operation:** Index Scan(Non-Clustered)
**Observation:** It is better to consider Delivered orders to keep the revenue consistent wit other reporting metric.   


## Query: Delivery performance by state

**Execution time:** 386 ms  
**CPU time:** 313 ms  
**Logical reads:** 13958  
**Main operation:** Hash Match(Inner Join) 
**Observation:** A covering Index can be used.