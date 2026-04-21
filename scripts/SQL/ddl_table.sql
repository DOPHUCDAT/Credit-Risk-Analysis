IF OBJECT_ID('credit_risk', 'U') IS NOT NULL
    DROP TABLE credit_risk;
GO

CREATE TABLE credit_risk (
    client_ID                  VARCHAR(150),
    person_age                 INT,
    person_income              INT,
    person_home_ownership      VARCHAR(150),
    person_emp_length          INT,
    loan_intent                VARCHAR(150),
    loan_grade                 VARCHAR(110),
    loan_amnt                  INT,
    loan_int_rate              FLOAT,
    loan_status                INT,
    loan_percent_income        FLOAT,
    cb_person_default_on_file  VARCHAR(110),
    cb_person_cred_hist_length INT,
    gender                     VARCHAR(120),
    marital_status             VARCHAR(120),
    education_level            VARCHAR(150),
    country                    VARCHAR(150),
    state                      VARCHAR(150),
    city                       VARCHAR(100),
    city_latitude              FLOAT,
    city_longitude             FLOAT,
    employment_type            VARCHAR(150),
    loan_term_months           INT,
    loan_to_income_ratio       FLOAT,
    other_debt                 FLOAT,
    debt_to_income_ratio       FLOAT,
    open_accounts              INT,
    credit_utilization_ratio   FLOAT,
    past_delinquencies         INT
);
GO