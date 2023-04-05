{{
    config(
        materialized='view'
    )
}}

WITH top_2_vendors_per_country_for_each_year AS {
    SELECT year, 
           country_name, 
           vendor_name, 
           ROUND(total_gmv,2)
    FROM (
        SELECT FORMAT_DATETIME('%Y-01-01T00:00:00',o.date_local) AS year, 
               v.country_name, 
               v.vendor_name, 
               SUM(o.gmv_local) AS total_gmv, 
               ROW_NUMBER() OVER (
                PARTITION BY o.date_local, 
                             v.country_name ORDER BY SUM(o.gmv_local) DESC
                             ) AS row_num
        FROM ds.orders o 
        JOIN ds.vendors v 
        ON o.vendor_id = v.id
        GROUP BY date_local, 
                 country_name, 
                 vendor_name
        )
    WHERE row_num <= 2
    ORDER BY year, 
             country_name, 
             total_gmv DESC
}


