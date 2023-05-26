Test [fully_queryable](/macros/fully_queryable) forces a full table scan and includes relation-level nullability testing to make better use of the scan.

Useful for "external tables" where there could say a corrupt file or bad config that prevents querying of a particular column, and will only be noticed if something explicitly exercises a specific column - so - ensures all columns are scanned.

Usage:

```yml

version: 2

models:
  - name: unique_names
    tests:
      - fully_queryable: # fully scan all columns of table data
          nullable_columns: [] # all columns must be non-null
    columns:
      - name: primaryName
        tests:
          - unique
      - name: count
        tests:
          - dbt_utils.accepted_range:
              min_value: 0
      
```

Example: see [aliases](/models/aliases)
