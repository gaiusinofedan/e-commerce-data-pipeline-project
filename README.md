# 🧱 Maven Market: dbt Data Pipeline Project

A production-grade dbt project that transforms raw e-commerce data into validated, analytics-ready models in BigQuery. Built for scalable analytics, governed development, and clear business reporting.

---

## 🚀 Overview

This project models data from Maven Market — a fictional retail platform — using dbt Cloud and BigQuery. It follows modern data engineering best practices:

- Modular SQL models (staging, marts)
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

🧾 Raw Data Sources (BigQuery Dataset: mavenmarket_raw)
Table	Description
customers	Customer demographic & account data
products	Product attributes & pricing
returns	Product return records
transactions_1997	Sales transactions (1997)
transactions_1998	Sales transactions (1998)
calendar	Full date dimension
stores	Store details and regions
regions	Geographic classifications
✅ Key Features

    Staging Layer (stg_*)

        Standardizes formats (dates, text, numeric)

        Handles parsing (e.g. "45K" → 45000)

        Adds dq_flag column for row-level data quality status

        Applies BigQuery-friendly typecasting for downstream use

    Schema Validation

        Uses dbt tests for not null and unique constraints

        All models documented via schema.yml

    Git Workflow

        Feature branches for each model (e.g. feature/stg-products)

        Semantic commit messages (feat:, chore:, etc.)

        Pull Requests into main for review and version history

🔧 Tech Stack
Tool	Purpose
dbt Cloud	Data transformation framework
BigQuery	Cloud data warehouse
Git + GitHub	Version control & collaboration
Jinja	Templating in SQL
🧠 Author

Gaius Dan — Data Analyst | dbt Developer
