# Brasimart E-Commerce Analytics (Azure SQL + Python)

## Overview

This project simulates a production-grade analytics workflow using the public OLIST Brazilian e-commerce dataset. Transactional data was loaded into Azure SQL and analyzed using Python to generate business insights across revenue performance, customer behavior, retention, and operational efficiency.

The objective was to transform raw transactional data into actionable business intelligence using a structured analytics pipeline.

---

## Architecture

Data Source → Azure SQL Database → Python (Pandas) → Analytics Fact Table → Business Insights

- Data Storage: Azure SQL
- Authentication: Microsoft Entra ID (token-based via Azure CLI)
- Analytics & Modeling: Python (Pandas, NumPy)
- Visualization: Matplotlib, Seaborn
- Version Control: Git & GitHub

---

## Key Analyses

### Revenue Trend Analysis
- Evaluated monthly revenue growth patterns
- Identified seasonality and revenue expansion trends

### Customer Lifetime Value (CLV)
- Calculated lifetime spend per customer
- Identified strong revenue concentration among top customers
- Demonstrated Pareto-like revenue distribution

### Cohort Retention Analysis
- Grouped customers by first purchase month
- Measured retention decay over time
- Identified limited repeat purchase behavior

### RFM Segmentation
- Segmented customers by Recency, Frequency, and Monetary value
- Identified high-value and at-risk segments
- Quantified behavioral differences across segments

### Operational Performance
- Measured delivery delay relative to estimated delivery dates
- Found majority of deliveries occurred earlier than promised
- Identified satisfaction impact of late deliveries

### Product & Category Insights
- Analyzed revenue concentration across product categories
- Compared category-level revenue vs customer satisfaction
- Highlighted potential optimization opportunities

---

## Business Insights

- Revenue is highly concentrated among a small subset of customers.
- Customer retention declines sharply after initial purchase.
- Delivery reliability significantly influences customer satisfaction.
- High-revenue categories do not always align with highest review scores.
- Strategic retention of high-value segments could materially improve profitability.

---

## Skills Demonstrated

- SQL data modeling and table design
- Secure Azure SQL connectivity using Microsoft Entra authentication
- Fact table construction and feature engineering
- Customer analytics (CLV, RFM, Cohort analysis)
- Operational performance evaluation
- Business storytelling with data

---

## Repository Structure

- `notebooks/` – End-to-end analytics notebook
- `sql/` – Table creation and database scripts
- `docs/` – ER diagram and visuals

---

## Data Source

OLIST Brazilian E-commerce Public Dataset (Kaggle)
