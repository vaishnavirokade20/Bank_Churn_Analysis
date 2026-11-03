# 🏦 Retail Banking Customer Churn & Retention Analytics

An end-to-end data analytics project examining customer attrition across **10,000 retail banking accounts** holding **€185.59M in lost balances**. This project implements a **3-tier data pipeline** (Python → SQL Server → Power BI) to identify core risk drivers, quantify financial exposure, and deliver actionable retention strategies.

---

## 📌 1. Business Problem & Project Objective

### Business Problem
Retail banks face severe financial risk when high-value customers close their accounts without warning. In this dataset of **10,000 customers**, the bank experienced an overall **20.37% churn rate**, resulting in **€185.59 Million in total lost capital**. 

Without a centralized analytical system, management lacked visibility into:
* Which geographic markets were bleeding the most capital.
* What customer behavioral patterns (e.g., account inactivity, product holdings) preceded account closures.
* How to prioritize retention budgets effectively to prevent major balance drain.

### Project Objective
To design and deploy an **end-to-end 3-tier data analytics architecture** that:
1. **Quantifies Capital Risk:** Measures customer attrition and total vulnerable account balances across regions and demographics.
2. **Isolates Behavioral Triggers:** Identifies core risk factors (such as single-product ownership, digital inactivity, and country-specific churn anomalies).
3. **Delivers Executive Visibility:** Builds an interactive executive dashboard enabling leadership and relationship managers to target high-value, high-risk accounts with proactive cross-selling and re-engagement strategies.

---

## 📌 2. Key Findings & Executive Summary

* **Macro Baseline:** Overall customer churn rate is **20.37%** (2,037 of 10,000 accounts), representing **€185.59M in total lost capital**.
* **Geographic Risk:** German customers exhibit a **32.44% churn rate** (nearly double France at 16.15% and Spain at 16.67%) and account for **€96.9M** of total lost capital due to higher average balances (€119.7K).
* **Product Stickiness Effect:** Single-product account holders churn at **27.71%**, but cross-selling a 2nd product reduces churn by **72% down to 7.58%**. However, holding 3 or 4 products results in severe churn (>82%).
* **Digital Inactivity Trigger:** Inactivity doubles churn risk across all markets, peaking at **38.9% among inactive German members**.

---

## 🛠️ 3. End-to-End Technical Architecture

```text
┌──────────────────────┐     ┌──────────────────────┐     ┌──────────────────────┐
│  Tier 1: Python      │ ──> │  Tier 2: SQL Server  │ ──> │  Tier 3: Power BI    │
│  (Data Prep / ETL)   │     │  (Exploratory Analytics)│  │  (Executive BI)      │
└──────────────────────┘     └──────────────────────┘     └──────────────────────┘

## 📊 Dashboard Preview

![Bank Churn Analysis Dashboard](Dashboard%20Preview.png)
