# Data Warehouse and Analytics Project

Welcome to the **Data Warehouse and Analytics Project** repository! 

This project demonstrates a comprehensive, end-to-end data warehousing and analytics solution—from building a structured data warehouse to generating actionable business insights. Designed as a hands-on portfolio project, it highlights industry best practices in data engineering, data modeling, and business analytics.

---

## Project Requirements

### 1. Data Warehouse Architecture (Data Engineering)

#### Objectives
Develop a modern Data Warehouse using **MySQL** implementing the **Medallion Architecture (Bronze, Silver, Gold layers)** to consolidate enterprise sales data, enable clean analytical reporting, and support data-driven decision-making.

#### Key Specifications
- **Data Sources:** Ingested and consolidated raw operational data from two distinct source systems (**ERP** and **CRM**) provided as CSV files.
- **Data Quality & Transformation:** Cleanse, standardize, handle missing values, and resolve data quality issues in the Silver layer prior to downstream analysis.
- **Data Integration & Modeling:** Combine cleaned datasets into a user-friendly Star Schema (Fact and Dimension tables) in the Gold layer optimized for analytical queries.
- **Scope:** Focus on current snapshot analytics; historization (SCDs) is not required for this scope.
- **Documentation:** Provide clear documentation of the data pipeline and data model to support both technical teams and business stakeholders.

---

### 2. Business Intelligence & Analytics (Data Analytics)

#### Objectives
Develop advanced SQL queries, window functions, and views to deliver granular business insights into:
- **Customer Behavior:** Tracking high-value customers, order frequency, and retention.
- **Product Performance:** Identifying top-selling product categories, revenue drivers, and item movement.
- **Sales Trends & Seasonality:** Analyzing monthly revenue growth, cumulative running totals, and moving average price trends over time.

These analytical outputs empower stakeholders with key performance indicators (KPIs) to drive strategic business decisions.

---

## Repository Structure

```text
├── docs/                      # Documentation, schema diagrams, and data dictionary
├── scripts/
│   ├── 01_bronze_layer.sql    # Raw data ingestion and table creation
│   ├── 02_silver_layer.sql    # Data cleansing, standardization, and quality checks
│   ├── 03_gold_layer.sql      # Star Schema dimension/fact tables & analytical views
│   └── 04_eda_exploration.sql # Exploratory Data Analysis & business metrics queries
└── README.md                  # Project documentation
```
## License
This project is licensed under the [MIT LICENSED](LICENSE). You are free to use, modify, and share this project with proper with proper attribution.

## About Me
Hi there! My name is **Afroj Ahmad Khan**. I am an aspiring Data Analyst passionate about building scalable data pipelines, writing performant SQL queries, and translating complex data into strategic business insights.
