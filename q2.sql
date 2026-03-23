SELECT 
    COUNT(1) AS qualified_user_count
FROM (
    SELECT 
        user_id
    FROM 
        event_log
    WHERE 
        user_id IS NOT NULL 
        AND FROM_UNIXTIME(event_timestamp, 'yyyy-MM') = '2020-09'
    GROUP BY 
        user_id
    HAVING 
        COUNT(1) >= 1000 
        AND COUNT(1) < 2000
) t;
