{{
    config(
        materialized='view'
    )
}}

WITH taiwan_vendors_ordered_by_cust_count AS {
    SELECT vendor_name, 
           COUNT(vendor_name) AS customer_count, 
           ROUND(SUM(gmv_local),2) AS total_gmv
    FROM orders o 
    LEFT JOIN vendors v 
    ON o.vendor_id = v.id
    WHERE o.country_name = "Taiwan"
    GROUP BY vendor_name
    ORDER BY customer_count DESC ;
}