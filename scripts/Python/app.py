import streamlit as st
import joblib
import pandas as pd


model = joblib.load("models/best_credit_model.pkl")

# Class 1 in this project is the default/bad outcome.
DEFAULT_CLASS = 1
MODEL_CLASSES = list(model.named_steps["classifier"].classes_)
DEFAULT_CLASS_INDEX = MODEL_CLASSES.index(DEFAULT_CLASS)

st.set_page_config(page_title="Credit Risk Prediction", layout="centered")

st.title("Credit Risk Prediction App")
st.write("Predict whether a customer will default (1) or not (0)")


st.subheader("Customer Information")

person_age = st.number_input("Age", 18, 100, 30)
person_income = st.number_input("Income (USD)", 0, 1000000, 50000)
person_emp_length = st.number_input("Employment Length (years)", 0, 50, 5)

person_home_ownership = st.selectbox(
    "Home Ownership", ["Rent", "Own", "Mortgage", "Other"]
)

loan_intent = st.selectbox(
    "Loan Purpose", ["Personal", "Education", "Medical", "Debtconsolidation", "Homeimprovement", "Venture"]
)

loan_grade = st.selectbox("Loan Grade", ["A", "B", "C", "D", "E", "F", "G"])

loan_amnt = st.number_input("Loan Amount", 0, 1000000, 10000)
loan_int_rate = st.number_input("Interest Rate (%)", 0.0, 50.0, 10.0)

other_debt = st.number_input("Other Debt", 0.0, 1000000.0, 0.0)

# Keep ratio features consistent with primary financial inputs.
safe_income = max(float(person_income), 1.0)
loan_percent_income = float(loan_amnt) / safe_income
loan_to_income_ratio = float(loan_amnt) / safe_income
debt_to_income_ratio = float(other_debt) / safe_income

st.caption(f"Loan % Income (auto): {loan_percent_income:.4f}")
st.caption(f"Loan to Income Ratio (auto): {loan_to_income_ratio:.4f}")
st.caption(f"Debt to Income Ratio (auto): {debt_to_income_ratio:.4f}")

cb_person_default_on_file = st.selectbox(
    "Previous Default", ["Y", "N"], index=1
)

cb_person_cred_hist_length = st.number_input(
    "Credit History Length", 0, 50, 5
)

employment_type = st.selectbox(
    "Employment Type", ["Full-Time", "Part-Time", "Self-Employed", "Unemployed"]
)

loan_term_months = st.selectbox("Loan Term (months)", [12, 24, 36, 60])

open_accounts = st.number_input("Open Accounts", 0, 50, 5)
credit_utilization_ratio = st.number_input(
    "Credit Utilization", 0.0, 1.0, 0.3
)

past_delinquencies = st.number_input("Past Delinquencies", 0, 20, 0)

country = st.selectbox("Country", ["USA", "UK", "CANADA"])


if st.button("Predict"):

    input_data = pd.DataFrame([{
        "person_age": person_age,
        "person_income": person_income,
        "person_emp_length": person_emp_length,
        "person_home_ownership": person_home_ownership,
        "loan_intent": loan_intent,
        "loan_grade": loan_grade,
        "loan_amnt": loan_amnt,
        "loan_int_rate": loan_int_rate,
        "loan_percent_income": loan_percent_income,
        "cb_person_default_on_file": cb_person_default_on_file,
        "cb_person_cred_hist_length": cb_person_cred_hist_length,
        "employment_type": employment_type,
        "loan_term_months": loan_term_months,
        "loan_to_income_ratio": loan_to_income_ratio,
        "other_debt": other_debt,
        "debt_to_income_ratio": debt_to_income_ratio,
        "open_accounts": open_accounts,
        "credit_utilization_ratio": credit_utilization_ratio,
        "past_delinquencies": past_delinquencies,
        "country": country
    }])

    prediction = model.predict(input_data)[0]
    default_probability = float(model.predict_proba(input_data)[0][DEFAULT_CLASS_INDEX])

    st.subheader("Prediction Result")
    st.metric("Default probability", f"{default_probability * 100:.2f}%")

    if prediction == DEFAULT_CLASS:
        st.error("High Risk: Likely to Default")
    else:
        st.success("Low Risk: Safe Customer")
