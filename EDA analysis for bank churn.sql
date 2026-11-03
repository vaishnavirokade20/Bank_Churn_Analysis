create database BankDB;
USE BankDB;

SELECT COUNT(*) AS Total_Records
FROM bank_churn_cleaned;


SELECT TOP 5 *
FROM bank_churn_cleaned;



--- Exploratory data analysis ---


-- QUERY 1: Overall Macro Baseline & Financial Exposure
-- Purpose: Calculates total customer count, churn volume, retention volume, macro churn rate, and total balance loss.

Select 
     count(customerid) as total_customers ,
     sum(exited) as churned_customers ,
     COUNT(customerid) - SUM(exited) as retained_customers ,
     round(CAST(SUM(exited) as float) * 100.0 / COUNT(customerid),2) as overall_churned_rate_pct ,
     ROUND(sum(case when exited = 1 then balance else 0 end ),2) as total_capital_at_risk
     from bank_churn_cleaned;

-- QUERY 2: Regional Cohort Analysis (The German Market Anomaly)
-- Purpose: Compares churn rates, average balances, and capital losses across Germany, France, and Spain.

Select 
   geography,
   COUNT(customerid) as total_customers ,
   SUM(exited) as churned_customers,
   ROUND(CAST(sum(exited) as float) * 100.0 / count(customerid),2) as churned_rate_pct,
   ROUND(AVG(Balance), 2) AS Avg_Customer_Balance,
   ROUND(sum(case when exited = 1 then balance else 0 end),2) as regional_lost_balance
   from bank_churn_cleaned
   group by Geography
   order by churned_rate_pct desc;


-- QUERY 3: Product Holdings vs. Churn Rate (Cross-Selling Opportunity)
-- Purpose: Evaluates retention rates across 1, 2, 3, and 4 product holders.

Select 
   numofproducts,
   COUNT(customerid) as total_customers,
   SUM(exited) as churned_customers ,
   ROUND(CAST(sum(exited) as float) *100.0/ COUNT(customerid), 2) as churned_rate_pct,
   ROUND(AVG(balance) ,2) as avg_balance
   from bank_churn_cleaned
   group by numofproducts
   order by numofproducts asc;


-- QUERY 4: Impact of Customer Engagement (Active vs. Inactive Members)
-- Purpose: Quantifies how active engagement impacts churn propensity.

Select
 case when isactivemember = 1 then 'Active Member' else 'Inactive Member' end as engagement_status,
 COUNT(customerid) as total_customers ,
 SUM(exited) as churned_customers ,
 ROUND(CAST(sum(exited) as float) * 100.0 / COUNT(customerid),2) as churned_rate_pct
 from bank_churn_cleaned
 group by isactivemember;



 -- QUERY 5: Gender Discrepancy by Geography
-- Purpose: Identifies high-risk gender segments within each country.

Select 
 geography,
 gender,
 COUNT(customerid) as total_customers,
 SUM(exited) as churned_customers,
 ROUND(CAST(sum(exited) as float)*100.0/COUNT(customerid) ,2) as churned_rate_pct
 from bank_churn_cleaned
 group by  geography,gender
 order by  geography, churned_rate_pct desc;


 -- QUERY 6: Age Bracket Risk Profiling
-- Purpose: Groups customers into age cohorts to isolate older, high-churn age groups.
SELECT 
    CASE 
        WHEN Age < 30 THEN '1. Under 30'
        WHEN Age BETWEEN 30 AND 40 THEN '2. 30 - 40'
        WHEN Age BETWEEN 41 AND 50 THEN '3. 41 - 50'
        WHEN Age BETWEEN 51 AND 60 THEN '4. 51 - 60'
        ELSE '5. Above 60'
    END AS Age_Group,
    COUNT(CustomerId) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(CAST(SUM(Exited) AS FLOAT) * 100.0 / COUNT(CustomerId), 2) AS Churn_Rate_Pct,
    ROUND(AVG(Balance), 2) AS Avg_Balance
FROM bank_churn_cleaned
GROUP BY 
    CASE 
        WHEN Age < 30 THEN '1. Under 30'
        WHEN Age BETWEEN 30 AND 40 THEN '2. 30 - 40'
        WHEN Age BETWEEN 41 AND 50 THEN '3. 41 - 50'
        WHEN Age BETWEEN 51 AND 60 THEN '4. 51 - 60'
        ELSE '5. Above 60'
    END
ORDER BY Age_Group ASC;



-- QUERY 7: Credit Score Tier Segmentation
-- Purpose: Analyzes whether low credit scores correlate with higher account abandonment.
SELECT 
    CASE 
        WHEN CreditScore < 580 THEN '1. Poor (<580)'
        WHEN CreditScore BETWEEN 580 AND 669 THEN '2. Fair (580-669)'
        WHEN CreditScore BETWEEN 670 AND 739 THEN '3. Good (670-739)'
        WHEN CreditScore BETWEEN 740 AND 799 THEN '4. Very Good (740-799)'
        ELSE '5. Exceptional (800+)'
    END AS Credit_Score_Tier,
    COUNT(CustomerId) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(CAST(SUM(Exited) AS FLOAT) * 100.0 / COUNT(CustomerId), 2) AS Churn_Rate_Pct
FROM bank_churn_cleaned
GROUP BY 
    CASE 
        WHEN CreditScore < 580 THEN '1. Poor (<580)'
        WHEN CreditScore BETWEEN 580 AND 669 THEN '2. Fair (580-669)'
        WHEN CreditScore BETWEEN 670 AND 739 THEN '3. Good (670-739)'
        WHEN CreditScore BETWEEN 740 AND 799 THEN '4. Very Good (740-799)'
        ELSE '5. Exceptional (800+)'
    END
ORDER BY Credit_Score_Tier ASC;


-- QUERY 8: Zero Balance vs. Active Balance Account Risk
-- Purpose: Checks if zero-balance account holders churn more frequently than funded accounts.
SELECT 
    CASE WHEN Balance = 0 THEN 'Zero Balance Account' ELSE 'Funded Account' END AS Account_Status,
    COUNT(CustomerId) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(CAST(SUM(Exited) AS FLOAT) * 100.0 / COUNT(CustomerId), 2) AS Churn_Rate_Pct,
    ROUND(AVG(EstimatedSalary), 2) AS Avg_Estimated_Salary
FROM bank_churn_cleaned
GROUP BY CASE WHEN Balance = 0 THEN 'Zero Balance Account' ELSE 'Funded Account' END;


-- QUERY 9: Customer Tenure Cohort Loyalty Analysis
-- Purpose: Measures churn rates across tenure years (0 to 10 years with the bank).
SELECT 
    Tenure AS Years_With_Bank,
    COUNT(CustomerId) AS Total_Customers,
    SUM(Exited) AS Churned_Customers,
    ROUND(CAST(SUM(Exited) AS FLOAT) * 100.0 / COUNT(CustomerId), 2) AS Churn_Rate_Pct
FROM bank_churn_cleaned
GROUP BY Tenure
ORDER BY Tenure ASC;


-- QUERY 10: Actionable Flag — High-Value, At-Risk Active Customers
-- Purpose: Identifies existing, non-churned customers with >€100k balance who are inactive and hold 1 product so retention teams can intervene immediately.
SELECT 
    CustomerId,
    Surname,
    Geography,
    Gender,
    Age,
    ROUND(Balance, 2) AS Account_Balance,
    NumOfProducts,
    IsActiveMember
FROM bank_churn_cleaned
WHERE Exited = 0 
  AND IsActiveMember = 0 
  AND NumOfProducts = 1 
  AND Balance > 100000
ORDER BY Balance DESC;

