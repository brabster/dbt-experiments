SELECT
    primaryName,
    COUNT(1) count
FROM {{ ref('names') }}
GROUP BY primaryName
ORDER BY count DESC