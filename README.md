## Data Warehouse and Analytics Project
Welcome to the Data Warehouse Project repository! 🚀
# SQL Data Warehouse Project
Building a modern data warehouse with **SQL Server**, using **ETL processes** and **data modeling** to turn raw source data into analytics-ready tables.
## 📂 Repository Structure

```
sql_data_warehouse_project_1/
│
├── datasets/                 # Raw source data (CRM and ERP CSV files)
│   ├── source_crm/           # Customers, products, sales details
│   └── source_erp/           # Customer birthdates and gender, locations, product categories
│
├── docs/                     # Architecture, data flow, data model, naming conventions
│
├── scripts/                  # SQL scripts for the ETL process
│   ├── init_database.sql     # Creates the database and the three schemas
│   ├── bronze/               # Loads the raw files as they are
│   ├── silver/               # Cleans and standardizes the data
│   └── gold/                 # Star schema for analytics
│
├── tests/                    # Quality checks for the Silver and Gold layers
│
└── README.md                 # Project overview
```
## 🏗️ Architecture

The data warehouse follows the Medallion Architecture with three layers:
![Data Architecture](docs/Architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV files into the SQL Server database.
2. **Silver Layer**: Handles data cleansing, standardization, and normalization to prepare the data for analysis.
3. **Gold Layer**: Houses business-ready data modeled into a star schema for reporting and analytics.

## 🔄 Data Flow

![Data Flow Diagram](docs/data_flow_diagram.drawio.png)
1. **Fact Tables**: Fact tables are the heart of a data warehouse. They contain quantitative data, often referred to as measures or metrics, and are the focus of most data analysis.
2. **Dimension Tables**:  Dimension tables, offer context to the data stored in fact tables. They provide descriptive information that helps users understand
the “who,” “where,” and “when” aspects of the data.
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a modern data warehouse using the Medallion Architecture with **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards for actionable insights.

## 🌟 About Me

Hi, I'm **imad**, a Master's student in  **Digital Sciences and Artificial Intelligence** . I'm passionate about data and data engineering, and I enjoy building pipelines, modeling data, and turning raw data into useful insights.

This project is part of my learning journey in data warehousing with SQL Server, ETL, and data modeling.

- GitHub: [@chaibimad](https://github.com/chaibimad)
- LinkedIn: [ imad ](https://www.linkedin.com/in/imadchaib/)
