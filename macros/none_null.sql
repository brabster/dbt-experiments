{%- test none_null(model, except_columns=[], force_table_scan=False) -%}

    {%- set relation_columns = adapter.get_columns_in_relation(model) -%}

    {%- set not_null_columns = [] -%}
    {%- set nullable_columns = [] -%}
    {%- for column in relation_columns -%}
        {%- do nullable_columns.append(column.name) if column.name in except_columns else not_null_columns.append(column.name) -%}
    {%- endfor -%}

    WITH results AS (
        SELECT
            list_contains([
                {%- for column in not_null_columns -%}

                    {{column}} IS NULL{% if not loop.last -%},
                    {% endif -%}

                {%- endfor -%}
            ], TRUE) AS contains_null,
            list_contains([
                {%- if force_table_scan -%}
                    {%- for column in nullable_columns -%}
                    -- something that won't be optimised away but is effectively constant false
                    hash({{column}}::VARCHAR) = 0 {% if not loop.last -%},
                    {% endif -%}

                    {%- endfor -%}
                {%- endif %}
            ], TRUE) AS force_scan
        FROM {{ model }}
    )

    SELECT
        1
    FROM results
    WHERE contains_null AND force_scan
    
{%- endtest -%}
