`not_null` checks on dbt models and sources run one query per column tested.

Hypothesis: in environments where concurrency is limited, or those where there is a per-query overhead, are there benefits to running a single query to check all not_null columns in a table at once?

Scenarios:
- Thread counts 1, 2, 4, 6
- Columns 2, 10, 100

(a more interesting test would be on a real, complex dbt graph but start with these)