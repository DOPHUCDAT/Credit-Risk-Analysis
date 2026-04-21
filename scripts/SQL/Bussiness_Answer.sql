--Q1: Loại người vay có khả năng nợ quá hạn 
--Answer: Những người vay là người thất nghiệp có tỉ lệ nợ quá hạn cao nhất 
SELECT 
    employment_type,
    COUNT(*) AS total_customers,
    AVG(CAST(loan_status AS FLOAT)) AS default_rate
FROM credit_risk
GROUP BY employment_type
HAVING COUNT(*) > 100
ORDER BY default_rate DESC;

--Q2: Các mục đích vay cụ thể (giáo dục, y tế, cá nhân, hợp nhất nợ) có mang lại rủi ro cao hơn không?
--Answer: Các mục đích vay như hợp nhất nợ và y tế có tỷ lệ nợ quá hạn cao hơn so với các mục đích khác như cá nhân.
--Tuy nhiên việc có mang lại rủi ro cao hơn không thì là có nhưng tỉ lệ khá nhỏ nên cần phải xem xét thêm các yếu tố khác như thu nhập, lịch sử tín dụng, v.v... để đưa ra kết luận chính xác hơn.
SELECT 
    loan_intent,
    COUNT(*) AS total,
    AVG(loan_amnt) AS avg_loan,
    AVG(person_income) AS avg_income,
    AVG(CAST(loan_status AS FLOAT)) AS default_rate
FROM credit_risk
GROUP BY loan_intent
ORDER BY default_rate DESC;

--Q3: Tỷ lệ khoản vay trên thu nhập và tỷ lệ nợ trên thu nhập liên quan như thế nào đến việc hoàn trả?
--Answer: Những người có tỷ lệ khoản vay trên thu nhập cao hơn thường có tỷ lệ nợ quá hạn cao hơn, cho thấy rằng họ có thể gặp khó khăn trong việc quản lý các khoản thanh toán của mình.
SELECT 
    CASE 
        WHEN loan_to_income_ratio < 0.2 THEN 'Low'
        WHEN loan_to_income_ratio < 0.5 THEN 'Medium'
        ELSE 'High'
    END AS loan_ratio_bucket,
    
    COUNT(*) AS total,
    AVG(CAST(loan_status AS FLOAT)) AS default_rate
FROM credit_risk
GROUP BY 
    CASE 
        WHEN loan_to_income_ratio < 0.2 THEN 'Low'
        WHEN loan_to_income_ratio < 0.5 THEN 'Medium'
        ELSE 'High'
    END
ORDER BY default_rate DESC;

--Q4: Loại hình việc làm hoặc việc sở hữu nhà có tạo ra sự khác biệt không?
--Answer: Có sự khác biệt rõ rệt giữa những người sở hữu nhà và những người thuê nhà, cũng như giữa những người làm việc toàn thời gian và những người thất nghiệp về tỷ lệ nợ quá hạn.
--Những người thuê nhà và những người thất nghiệp có tỷ lệ nợ quá hạn cao hơn đáng kể so với những người sở hữu nhà và những người làm việc toàn thời gian.
SELECT 
    person_home_ownership,
    employment_type,
    COUNT(*) AS total,
    AVG(CAST(loan_status AS FLOAT)) AS default_rate
FROM credit_risk
GROUP BY person_home_ownership, employment_type
ORDER BY default_rate DESC;

--Q5: Lịch sử nợ quá hạn trong quá khứ hoặc lịch sử tín dụng dài hạn ảnh hưởng thế nào đến kết quả khoản vay?
--Answer: Những người có lịch sử nợ quá hạn trong quá khứ hoặc lịch sử tín dụng dài hạn có tỷ lệ nợ quá hạn cao hơn, cho thấy rằng họ có thể gặp khó khăn trong việc quản lý các khoản thanh toán của mình.
SELECT 
    cb_person_default_on_file,
    COUNT(*) AS total,
    AVG(past_delinquencies) AS avg_late,
    AVG(cb_person_cred_hist_length) AS credit_length,
    AVG(CAST(loan_status AS FLOAT)) AS default_rate
FROM credit_risk
GROUP BY cb_person_default_on_file;

--Q6: Có sự khác biệt rõ rệt nào giữa những người vay ở Mỹ, Anh và Canada không?
-- Answer: Không có sự khác biệt rõ rệt nào giữa những người vay ở Mỹ, Anh và Canada về tỷ lệ nợ quá hạn
SELECT 
    country,
    COUNT(*) AS total,
    AVG(person_income) AS avg_income,
    AVG(CAST(loan_status AS FLOAT)) AS default_rate
FROM credit_risk
WHERE country IN ('USA','UK','CANADA')
GROUP BY country;

--Q7: Xếp hạng khoản vay (loan grades) hoặc điều khoản nào có vẻ an toàn hơn, và loại nào rủi ro hơn?
--Answer: Các khoản vay có xếp hạng cao hơn (ví dụ: A, B) thường có tỷ lệ nợ quá hạn thấp hơn so với các khoản vay có xếp hạng thấp hơn (ví dụ: D, E, F, G), cho thấy rằng các khoản vay có xếp hạng cao hơn có vẻ an toàn hơn.
SELECT loan_grade,
       AVG(CAST(loan_status AS FLOAT)) AS default_rate
FROM credit_risk
GROUP BY loan_grade
ORDER BY default_rate ASC;

--Q8: Có thể xác định được các nhóm người vay trông có vẻ "an toàn" so với nhóm "rủi ro" không?
--Answer: Dựa trên các yếu tố như tỷ lệ nợ trên thu nhập, tỷ lệ sử dụng tín dụng và lịch sử nợ quá hạn, chúng ta có thể phân loại người vay thành các nhóm rủi ro khác nhau. Những người có tỷ lệ nợ trên thu nhập thấp, tỷ lệ sử dụng tín dụng thấp và không có lịch sử nợ quá hạn có thể được coi là "an toàn", trong khi những người có tỷ lệ nợ trên thu nhập cao, tỷ lệ sử dụng tín dụng cao và có lịch sử nợ quá hạn có thể được coi là "rủi ro".
SELECT 
    CASE 
        WHEN debt_to_income_ratio < 0.3 
             AND credit_utilization_ratio < 0.5 
             AND past_delinquencies = 0 
        THEN 'LOW_RISK'

        WHEN debt_to_income_ratio < 0.6 
        THEN 'MEDIUM_RISK'

        ELSE 'HIGH_RISK'
    END AS risk_segment,

    COUNT(*) AS total,
    AVG(CAST(loan_status AS FLOAT)) AS default_rate
FROM credit_risk
GROUP BY 
    CASE 
        WHEN debt_to_income_ratio < 0.3 
             AND credit_utilization_ratio < 0.5 
             AND past_delinquencies = 0 
        THEN 'LOW_RISK'

        WHEN debt_to_income_ratio < 0.6 
        THEN 'MEDIUM_RISK'

        ELSE 'HIGH_RISK'
    END;
