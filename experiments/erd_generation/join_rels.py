import json
from sqlglot import parse_one, exp

def relation_ref_str(relation):
    if relation:
        return f'{relation.db}.{relation.catalog}.{relation.name}'
    return None


def tables_by_alias(parsed):
    return {t.alias: t for t in parsed.find_all(exp.Table)}


def tables(expr):
    return [relation_ref_str(t) for t in expr.find_all(exp.Table)]

def ctes_by_alias(parsed):
    return {cte.alias: cte for cte in parsed.find_all(exp.CTE)}


def map_join_col_aliases(relations_by_alias, column):
    relation = relations_by_alias.get(column.table)
    return {
        'relation': relation_ref_str(relation),
        'column': column.name
    }

def extract_joins(tables, parsed):
    joins = parsed.find_all(exp.Join)

    def extract_join_cols(join_on):
        return [map_join_col_aliases(tables, col) for col in join_on.find_all(exp.Column)]

    joins = parsed.find_all(exp.Join)

    return [extract_join_cols(join) for join in joins]
                

with open('target/manifest.json') as mf:
    manifest = json.load(mf)
    
    for node, info in manifest['nodes'].items():
        if info['resource_type'] == 'model':
            sql = info['compiled_code']
            if 'join' in sql.lower():
                parsed = parse_one(sql)

                #tables = tables_by_alias(parsed)
                # for table, detail in tables.items():
                #     print(table, detail)

                ctes = ctes_by_alias(parsed)

                # relations_by_alias = {**ctes, **tables_by_alias(parsed)}

                for id, cte in ctes.items():
                    print(id, tables(cte))
        
                #joins = extract_joins(relations_by_alias, parsed)

                
        