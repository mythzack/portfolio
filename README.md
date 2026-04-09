# **📊 Supply Chain Analytics & BI Engineering Portfolio**

## Overview

This repository demonstrates my approach to designing analytics‑ready data models, ERP‑agnostic data extraction logic, and automation patterns to support supply chain, warehouse, and operational decision‑making.
The work showcased here is intentionally tool‑ and ERP‑neutral, focusing on business concepts, data modeling principles, and repeatable patterns rather than vendor‑specific implementations.

While the underlying inspiration comes from real operational environments, all examples use abstracted schemas, normalized terminology, and non-proprietary logic suitable for public demonstration.


## What This Portfolio Demonstrates

* ✅ Translating operational processes into analytics-friendly data models
* ✅ Designing fact‑level datasets with clear grain and business rules
* ✅ Abstracting ERP and WMS systems without vendor lock‑in
* ✅ Building automation patterns to compensate for BI tool limitations
* ✅ Delivering data intended for real operational consumption, not demos

This portfolio emphasizes clarity, intent, and maintainability over volume.

## Repository Structure
~~~

.
├── sql/
│   ├── fct_open_purchase_order_schedule.sql
│   ├── fct_kanban_status.sql
│
├── python/
│   ├── extract_production_orders.py
│   └── extract_warehouse_tasks.py
│
├── automation/
│   ├── snapshot_framework.md
│   └── flow_architecture.png
│
└── README.md

~~~


## SQL Analytics Models
The SQL layer represents analytics‑engineered datasets, not raw extracts.
Each model includes:

Explicit grain definition
Business rules documented in header comments
ERP‑agnostic naming and schema abstraction
Designed for direct BI consumption or downstream snapshotting

## Example Models
### fct_open_purchase_order_schedule.sql

* Line‑level, schedule‑date visibility into open purchase orders
* Supports inbound planning, supplier performance review, and inventory forecasting
* Modeled as current‑state data, with snapshot‑readiness explicitly considered

### fct_kanban_status.sql

* Represents current operational status of kanban‑controlled materials
* Includes quantities, container configuration, status, and aging indicators
* Designed for operational exception reporting and replenishment monitoring


## Python: ERP‑Agnostic Data Extraction Patterns
The Python modules demonstrate how operational data can be programmatically extracted and prepared for analytics without tight coupling to any specific ERP or WMS.
### Design Principles

* Separation of data access and business logic
* Declarative filtering using business concepts (status, dates, locations)
* Outputs structured for BI tools and historical persistence
* No GUI automation or vendor‑specific scripting

## Example Patterns
ERPClient
Defines a generic interface for interacting with an ERP or WMS system:

### Report‑driven extraction
* Business‑level filter definitions
* No assumptions about authentication, transport, or UI mechanics

### extract_production_orders.py

* Extracts actionable production orders within a rolling planning window
* Derives open quantities and excludes completed demand
* Intended to feed BI dashboards and historical snapshot processes

### extract_warehouse_tasks.py

* Extracts open warehouse movement tasks
* Filters to overdue or currently actionable work
* Represents execution‑level warehouse operations independent of ERP terminology


## Automation & Snapshotting (Conceptual)
Many operational KPIs cannot be reliably trended using current‑state BI tools alone due to late postings, corrections, or backdated transactions.
The automation/ section documents a snapshot framework designed to address this gap.
### Key Concepts

* Scheduled extraction of analytical outputs
* Point‑in‑time persistence of KPI values
* Append‑only historical storage
* Minimal transformation to preserve operational truth

This pattern is designed to complement BI platforms rather than replace them.

> The implementation examples focus on architecture and logic, not platform‑specific configuration (e.g., Power Automate UI flows).


## Intended Audience
This portfolio is oriented toward roles such as:

* Business Intelligence Engineer
* Analytics Engineer
* Supply Chain Analyst
* Operations / Fulfillment Analyst
* Data Analyst with domain specialization

It is especially relevant for teams operating in:

* Manufacturing
* Distribution & fulfillment
* Warehouse operations
* Procurement & inbound logistics


## Notes on Abstraction & Data Safety

* No proprietary schemas, identifiers, or company data are used
* ERP concepts are normalized to industry‑standard terminology
* Examples represent patterns, not production exports
* Any resemblance to specific systems is conceptual, not literal


## Final Note
The goal of this portfolio is not to showcase tools, but to demonstrate:

> How operational reality becomes trustworthy, decision‑ready data.

If you are reviewing this repository and would like to discuss design decisions, tradeoffs, or extensions of these patterns, I welcome the conversation.
