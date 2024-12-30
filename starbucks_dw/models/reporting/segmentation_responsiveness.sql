{{
  config(
    materialized = 'table',
    )
}}

SELECT gender
    , age
    , ROUND (AVG (income),2) AS average_income
    , COUNT(CASE WHEN transaction_status = 'received' THEN 1 END) AS total_received
    , COUNT(CASE WHEN transaction_status = 'viewed' THEN 1 END) AS total_viewed
    , COUNT(CASE WHEN transaction_status = 'completed' THEN 1 END) AS total_completed
    , CASE 
        WHEN COUNT(CASE WHEN transaction_status = 'received' THEN 1 END) > 0
        THEN ROUND(
            100.0 * COUNT(CASE WHEN transaction_status = 'viewed' THEN 1 END) / 
            COUNT(CASE WHEN transaction_status = 'received' THEN 1 END), 2)
        ELSE 0
    END AS percentage_viewed_of_received
    , CASE 
        WHEN COUNT(CASE WHEN transaction_status = 'viewed' THEN 1 END) > 0
        THEN ROUND(
            100.0 * COUNT(CASE WHEN transaction_status = 'completed' THEN 1 END) / 
            COUNT(CASE WHEN transaction_status = 'viewed' THEN 1 END), 2)
        ELSE 0
    END AS percentage_completed_of_viewed
    , CASE 
        WHEN COUNT(CASE WHEN transaction_status = 'received' THEN 1 END) > 0
        THEN ROUND(
            100.0 * COUNT(CASE WHEN transaction_status = 'completed' THEN 1 END) / 
            COUNT(CASE WHEN transaction_status = 'received' THEN 1 END), 2)
        ELSE 0
    END AS percentage_completed_of_received
FROM {{ ref('fct_customer_transactions') }}
GROUP BY gender, age

