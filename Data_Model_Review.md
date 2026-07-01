++++++++++++++++++++++++++++++++++++++

++++ Data Model Review

++++++++++++++++++++++++++++++++++++++

Document Information
====================

Item            Value
--------------------------
Project ::			E-Commerce Analytics

Author ::			Partha Basak

Version ::			1.0

Date ::			    30/06/2026


Business Problem
=================

The business requires a centralized analytics data warehouse to analyze revenue, customers, products, sellers, payments and delivery performance. The raw csv file can not be used for reporting due to normalization, inconsistance data.


Source Systems
=================

File format :: csv
Source of:: customers, orders, product, sellers, paayments, reviews, order items


Business Requirements
======================

The business should be able to answer

	- Monthly revenue
	- Revenue by product category
	- Revenuue by sellers
	- Top customers
	- Delivery delays
	- Repeat customers
	- Average purchase rate
	- Average order Value
	- Customer geography
	- Product category performance
	
Grain Definition
=====================

Table :: Fact orders
Grain  :: One row per order
	
Table :: Fact orders items
Grain  :: One row per product within an order	

Table :: Fact payments
Grain  :: One row per payment transaction

Table :: Dimension Customers
Grain  :: One row per customer

Table :: Dimension Product
Grain  :: One row per product

Table :: Dimension Seller
Grain  :: One row per seller


Star Schema
==============

ER Diagram

![Architecture Diagram](./architecture/er_diagram.png)