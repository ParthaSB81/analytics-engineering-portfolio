++++++++++++++++++++++++++++++++++++++

++++ Project Overview

++++++++++++++++++++++++++++++++++++++

This is a Ecommerce Analytics Engineering Project, showcased as Protfolio.
The source dataset used is Bazillian Ecommerce dataset.
The purpose of this project is to showcase different phases of Analytics engineering, e.g

	- Source Data extraction
	- Data clean-up & starderdization
	- Schema design
	- Data Layers
	- KPI/metrics calculation
	- Data Visualization
	- Data Storytelling
	
++++++++++++++++++++++++++++++++++++++

++++ Dataset

++++++++++++++++++++++++++++++++++++++

Brazillian Ecommerce Dataset - Olist
 
 
++++++++++++++++++++++++++++++++++++++

++++ Architecture

++++++++++++++++++++++++++++++++++++++

Raw Layer:(Schema = raw)

----------

raw_customers	


|-> raw_geolocation

raw_orders

|-> raw_order_items	raw_order_payments	raw_order_reviews


raw_products

|->	raw_product_category_name_translation

raw_sellers

Stagging Layer:(Schema = stg)

----------------

stg_customers	


|-> stg_geolocation


stg_orders


|-> stg_order_items	stg_order_payments	stg_order_reviews


stg_products


|->	stg_product_category_name_translation

stg_sellers

Mart Layer:(Schema = analytics)

------------

Dimension Layer

================

dim_customers

dim_date

dim_seller


Fact Layer

===========

fact_orders

fact_order_items

fact_payments



++++++++++++++++++++++++++++++++++++++

++++ Tech Stack

++++++++++++++++++++++++++++++++++++++

	- sql
	- python
	- dbt(ETl/ELT)
	- data warehouse(snowflake)
	- data Visualization(power BI)
	- git
	
++++++++++++++++++++++++++++++++++++++

++++ Project Goals

++++++++++++++++++++++++++++++++++++++	

To build and showcase an end to end analytics engineering project portfolio.
This project shall be using each starderdize process/techniques and layers of analytics.
Also the work shall use real production data avalibale and will follow steps or best practices used in real production environment.

++++++++++++++++++++++++++++++++++++++

++++ Folder Structure

++++++++++++++++++++++++++++++++++++++	


architecture/

	- Architecture level design. and diagrams.
	
dashboards/

	- End user dashboard snapshots
	
data/

	- raw data(e.g csv files)
	
docs/

	- project documentation
	
sql/

	- sql scripts
	
tests/

	- test scripts
