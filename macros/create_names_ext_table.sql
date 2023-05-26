{%- macro create_names_ext_table() -%}

CREATE TABLE IF NOT EXISTS main.name_basics AS
SELECT
    *
FROM read_csv('uncommitted/name.basics.tsv', 
    delim='\t',
    header=True,
    quote='',
    columns={
        'nconst': 'VARCHAR',
        'primaryName': 'VARCHAR',
        'birthYear': 'VARCHAR',
        'deathYear': 'VARCHAR',
        'primaryProfession': 'VARCHAR',
        'knownForTitles': 'VARCHAR'
    });

{%- endmacro -%}