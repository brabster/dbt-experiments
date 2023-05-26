SELECT
    *
FROM {{ ref('names') }}
WHERE birthYear >= 2000