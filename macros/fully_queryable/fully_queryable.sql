{%- test fully_queryable(model, nullable_columns='all') -%}

    {%- set relation_columns = adapter.get_columns_in_relation(model) -%}

    {%- set not_null_column_list = [] -%}
    {%- set nullable_column_list = [] -%}
    {%- if nullable_columns == 'all' -%}
        {%- set nullable_column_list = relation_columns -%}
    {%- else -%}
        {%- for column in relation_columns -%}
            {%- do nullable_column_list.append(column) if column.name in nullable_columns else not_null_column_list.append(column) -%}
        {%- endfor -%}
    {%- endif -%}

    WITH results AS (
        SELECT
            list_contains([
                {%- for column in not_null_column_list -%}

                    {{column.name}} IS NULL{% if not loop.last -%},
                    {% endif -%}

                {%- endfor -%}
            ], TRUE) AS contains_null,
            -- something that won't be optimised away but is effectively constant false
            list_contains([
                {%- for column in nullable_column_list -%}
                hash({{column.name}}::VARCHAR) = 0 {% if not loop.last -%},
                {% endif -%}

                {%- endfor -%}
            ], TRUE) AS force_scan
        FROM {{ model }}
    )

    SELECT
        1
    FROM results
    WHERE contains_null AND force_scan
    
{%- endtest -%}
