{%- macro create_titles_ext_table() -%}

CREATE TABLE IF NOT EXISTS main.title AS
SELECT
    *
FROM read_csv('uncommitted/title.akas.tsv', 
    delim='\t',
    header=True,
    quote='',
    columns={
        'titleId': 'VARCHAR',
        'ordering': 'VARCHAR',
        'title': 'VARCHAR',
        'region': 'VARCHAR',
        'lanquage': 'VARCHAR',
        'types': 'VARCHAR',
        'attributes': 'VARCHAR',
        'isOriginalTitle': 'VARCHAR'
    });

{%- endmacro -%}