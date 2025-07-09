# 🧱 Maven Market: dbt Data Pipeline Project

A production-grade dbt project that transforms raw e-commerce data into validated, analytics-ready models in BigQuery. Built for scalable analytics, governed development, and clear business reporting.

---

## 🚀 Overview

This project models data from Maven Market — a fictional retail platform — using dbt Cloud and BigQuery. It follows modern data engineering best practices:

- Modular SQL models (`staging`, `marts`)
- Semantic Git versioning and branching
- Row-level validation using data quality flags
- Centralized schema testing and documentation

All models are version-controlled in GitHub, developed in dbt Cloud, and deployed to BigQuery.

---

## 🗂 Project Structure

```bash
models/
├── staging/                  # stg_* models: cleaned raw data
│   ├── stg_customers.sql
│   ├── stg_products.sql
│   ├── stg_returns.sql
│   └── schema.yml
├── marts/                    # dim_* and fact_* models (TBD)
└── dbt_project.yml

📦 Raw Data Sources (BigQuery Dataset: mavenmarket_raw)
Table	Description
customers	Customer demographic & account data
products	Product attributes & pricing
returns	Product return records
transactions_1997	Sales transactions (1997)
transactions_1998	Sales transactions (1998)
calendar	Full date dimension
stores	Store metadata
regions	Geographic classifications
```

✅ Key Features

    Staging Layer (stg_*)

        Cleans and standardizes raw data

        Typecasts all numeric and boolean fields

        Adds dq_flag for row-level validation

        Includes gross margin, boolean fields, and parsed values

    Schema Testing

        Uses not_null and unique dbt tests

        YAML-driven documentation with column descriptions

    Version Control

        Feature branches per model (feature/stg-customers, etc.)

        Semantic commits (feat:, chore:, etc.)

        Pull request review and clean Git history

🧰 Tech Stack
Tool	Purpose
dbt Cloud	Transformation framework
BigQuery	Data warehouse
Git + GitHub	Version control & collaboration
Jinja	SQL templating
🧪 Coming Soon

    dim_customers and dim_products for reporting

    fact_sales combining transactions and returns

    dbt Docs deployment

    Source freshness & volume testing

    Advanced model-level documentation

👤 Author

Gaius Dan
Data Analyst | dbt Developer
