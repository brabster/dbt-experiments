{%- for i in range(0, 1) -%}
SELECT * FROM {{ source('imdb', 'name_basics') }}
{% if not loop.last %}
UNION ALL
{% endif %}
{%- endfor -%}
    