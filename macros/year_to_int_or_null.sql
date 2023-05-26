{%- macro year_to_int_or_null(year_string_column) -%}
(CASE WHEN {{ year_string_column }} SIMILAR TO '[0-9]{4}' THEN {{ year_string_column }}::INTEGER ELSE NULL END)
{%- endmacro -%}