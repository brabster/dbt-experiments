Test [fully_queryable](macros/fully_queryable) forces a full table scan and includes relation-level nullability testing to make better use of the scan.

Useful for "external tables" where there could say a corrupt file or bad config that prevents querying of a particular column, and will only be noticed if something explicitly exercises a specific column - so - ensures all columns are scanned.