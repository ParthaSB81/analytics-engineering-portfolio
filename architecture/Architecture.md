# Architecture

## Project Overview

This project implements an end-to-end analytics platform for the Brazilian Olist e-commerce dataset.

The objective is to transform raw CSV files into a dimensional data warehouse that supports business reporting and interactive Power BI dashboards.

Technology Stack

- SQL Server
- SQL
- Python (Pandas)
- Power BI
- GitHub

## Architecture Diagram

![Architecture Diagram](./documents/arcitechture_diagram.png)

## Technology Stack

| Layer           | Technology   |
| --------------- | ------------ |
| Source          | CSV          |
| Database        | SQL Server   |
| Cleaning        | Python + SQL |
| Data Warehouse  | Star Schema  |
| Reporting       | Power BI     |
| Version Control | Git          |
| Documentation   | Markdown     |


## Source Layer

| Dataset   | Description        |
| --------- | ------------------ |
| Customers | Customer master    |
| Orders    | Order transactions |
| Products  | Product metadata   |
| Sellers   | Seller information |
| Payments  | Payment records    |
| Reviews   | Customer reviews   |


## Raw Layer
- Store original data exactly as received.
- No cleaning.

Raw Tables:
- raw.raw_orders
- raw.raw_customers
- raw.raw_products
- raw.raw_order_payments
- raw.raw_order_items
- raw.raw_order_reveiws
- raw.raw_geolocation

## Staging Layer

- Clean data.

Performed:
- Remove duplicates
- Handle missing values
- Create flags
- Calculated
   - delivery_days
   - delay days
   - approval_hours
   - estimated delivery days

## Analytics Layer

# Star Schema

![Architecture Diagram](./star_schema.png)


