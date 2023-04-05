{{
    config(
        materialized='view'
    )
}}

WITH total_gmv_by_country AS {
    SELECT o.country_name, 
           ROUND(SUM(gmv_local),2) AS total_gmv
    FROM orders o
    GROUP BY o.country_name
}