{{
    config(
        materialized='view'
    )
}}

WITH top_active_vendors_by_gmv_country AS {
    SELECT j.country_name, 
           k.vendor_name, 
           ROUND(j.total_gmv,2) AS total_gmv
    FROM (
        SELECT v.vendor_name, 
               SUM(o.gmv_local) AS total_gmv
        FROM orders o, 
             vendors v
        WHERE o.vendor_id = v.id
        GROUP BY vendor_name
        ) k JOIN (
            SELECT country_name, 
                   MAX(total_gmv) AS total_gmv
            FROM (
                SELECT v.country_name, 
                       v.vendor_name, 
                       SUM(o.gmv_local) AS total_gmv
                FROM orders o, 
                     vendors v
                WHERE o.vendor_id = v.id
                GROUP BY vendor_name, 
                         country_name
                ) 
            GROUP BY country_name
            ) j 
            ON j.total_gmv = k.total_gmv
    ORDER BY country_name ;
}