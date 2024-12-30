{{
  config(
    materialized = 'table',
    )
}}

WITH AUX AS (
SELECT 
    offer_channel,
    offer_type,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN transaction_status = 'completed' THEN 1 ELSE 0 END) AS completed_offers,
    ROUND(SUM(CASE WHEN transaction_status = 'completed' THEN 1 ELSE 0 END) * 1.0 / COUNT(*), 3) AS conversion_rate,
    ROUND(AVG(offer_difficulty_rank), 2) AS average_difficulty_rank,
    ROUND(AVG(offer_duration), 2) AS average_duration,
    ROUND(AVG(offer_reward), 2) AS average_reward
FROM {{ ref('fct_offer_transactions') }}
GROUP BY 
    offer_channel, 
    offer_type)

SELECT * FROM AUX
ORDER BY conversion_rate DESC

