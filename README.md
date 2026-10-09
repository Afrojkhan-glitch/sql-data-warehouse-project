# Data Warehouse and Analytics Project

An end-to-end data warehouse and analytics project built with **MySQL**, using the **Medallion Architecture** (Bronze, Silver, Gold layers). It consolidates sales data from two source systems (ERP and CRM), cleans it, models it as a star schema, and answers business questions with SQL.

> **Credit:** I built this project while following [CHANGE THIS: course name] by [CHANGE THIS: creator name] ([CHANGE THIS: course link]). The project design comes from that course. I implemented and ran it on MySQL.

## Architecture

| Layer | Purpose |
|-------|---------|
| **Bronze** | Raw data loaded as-is from the ERP and CRM CSV files |
| **Silver** | Cleaned and standardized data: handled missing values, fixed data quality issues |
| **Gold** | Business-ready star schema (`dim_` and `fact_` tables) and reporting views |

<!-- Optional: add an architecture diagram image here later -->

## Data Sources

- **ERP** and **CRM** operational data, provided as CSV files in the `datasets/` folder
- Scope: current snapshot analytics only (no historization or slowly changing dimensions)

## What the Project Covers

**Data engineering**
- Ingesting raw CSV data into the Bronze layer
- Cleaning, standardizing, and validating data in the Silver layer
- Building a star schema in the Gold layer

**Analytics**
- Customer behavior: high-value customers, order frequency, retention
- Product performance: top categories and revenue drivers
- Sales trends: monthly revenue growth, running totals, moving averages
- Techniques used: window functions, views, aggregations

## Key Insights

- [CHANGE THIS: one finding from your queries, e.g. which product category earns the most revenue]
- [CHANGE THIS: a second finding]
- [CHANGE THIS: a third finding]

## Repository Structure

```
sql-data-warehouse-project/
├── datasets/                  # Raw ERP and CRM CSV source files
├── docs/                       # Documentation, schema diagrams, data dictionary
├── scripts/
│   ├── 01_bronze_layer.sql    # Table creation and raw data ingestion
│   ├── 02_silver_layer.sql    # Cleansing, standardization, quality checks
│   ├── 03_gold_layer.sql      # Star schema: dimension and fact tables
│   ├── 04_gold_reports.sql    # Reporting views (customers, products)
│   └── 05_eda_exploration.sql # Exploratory analysis and business metrics
├── tests/                     # [CHANGE THIS: what these files check]
├── LICENSE
└── README.md
```

## How to Run

1. Install **MySQL** (8.0 or later) and a client such as MySQL Workbench.
2. Clone the repository:
```bash
   git clone https://github.com/Afrojkhan-glitch/sql-data-warehouse-project.git
```
3. Open the scripts in the `scripts/` folder in your MySQL client and run them **in numerical order**, from `01` to `05`.
4. In the Bronze script, update the file paths so they point to the CSV files in the `datasets/` folder on your computer.

## Tech Stack

- MySQL
- SQL (window functions, views, joins, aggregations)
- Git and GitHub

## License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share it with proper attribution.

## About Me

Hi, I'm **Afroj Ahmad Khan**, an aspiring Data Analyst who enjoys building data pipelines, writing performant SQL, and turning data into business insights.
