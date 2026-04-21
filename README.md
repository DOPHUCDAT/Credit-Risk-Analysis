# Credit Risk Analysis

## Overview

This project analyzes and predicts credit default risk using a tabular credit dataset.
The repository includes three practical parts:

- Python analysis and modeling workflow
- SQL scripts for table creation, data loading, and business queries
- A Streamlit app for default risk prediction

## Project Structure

- `dataset/Credit_Risk_Dataset.csv`: input dataset
- `models/best_credit_model.pkl`: trained model used by the app
- `scripts/Python/analysis_model.ipynb`: analysis and modeling notebook
- `scripts/Python/app.py`: Streamlit prediction app
- `scripts/SQL/init_database.sql`: recreates the `Credit_Risk` database
- `scripts/SQL/ddl_table.sql`: creates the `credit_risk` table
- `scripts/SQL/proc_load_table.sql`: loads data into `credit_risk` with `BULK INSERT`
- `scripts/SQL/Bussiness_Answer.sql`: business question queries
- `dashboard/Credit_Risk.pbix`: Power BI dashboard file

## Requirements

Install Python dependencies:

```bash
pip install -r requirements.txt
```

## Run The Prediction App

From the project root:

```bash
streamlit run scripts/Python/app.py
```

The app returns:

- Default probability
- Risk label (`High Risk` or `Low Risk`)

## Run The SQL Flow

Recommended execution order in SQL Server:

1. `scripts/SQL/init_database.sql`
2. `scripts/SQL/ddl_table.sql`
3. `scripts/SQL/proc_load_table.sql`
4. `scripts/SQL/Bussiness_Answer.sql`

Notes:

- `proc_load_table.sql` currently uses an absolute CSV path in `BULK INSERT`; update it to your local path if needed.

## Conclusion

This project delivers a complete and practical credit risk workflow in one repository:

- Data storage and loading with SQL Server
- Exploratory/modeling workflow in Python
- A deployable Streamlit interface for risk scoring

With these components, the project can be used as a baseline for credit risk analysis, model demonstration, and internal decision-support prototypes.


