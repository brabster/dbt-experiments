SELECT
    nconst,
    ARRAY_AGG(primaryName) primaryNames
FROM {{ ref('names') }}
GROUP BY nconst