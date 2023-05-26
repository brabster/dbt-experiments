{{ config(materialized='table') }}

SELECT
    nconst,
    primaryName,
    {{ year_to_int_or_null('birthYear') }} birthYear,
    {{ year_to_int_or_null('deathYear') }} deathYear,
    string_split(primaryProfession, ',') primaryProfessions,
    string_split(knownForTitles, ',') knownForTitles
FROM {{ ref('names_duplicated') }}