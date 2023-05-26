import json
import networkx as nx

EXECUTION_TIME='execution_time'
DOWNSTREAM_EXECUTIONS='downstream_executions'

G = nx.read_gpickle('target/graph.gpickle')

with open('target/run_results.json') as rr:
    run_results = json.load(rr)['results']

results_by_node = {result['unique_id']: result[EXECUTION_TIME] for result in run_results}

for u, v in G.edges:
    G.nodes[v][EXECUTION_TIME] = results_by_node.get(v, 0)

test_nodes = [n for n in G.nodes if n.startswith('test.')]

for u, v, k in nx.edge_bfs(G, test_nodes, orientation='reverse'):
    node_u = G.nodes[u]
    node_v = G.nodes[v]
    node_u[DOWNSTREAM_EXECUTIONS] = node_u.get(DOWNSTREAM_EXECUTIONS, []) + [(v, node_v.get(EXECUTION_TIME, 0))]

def downstream_execution_metrics(executions):
    if executions:
        downstream_execution_time = sum(map(lambda x: x[1], executions))
        mean_downstream_execution_time = downstream_execution_time / len(executions)
        return {
            'mean_execution_time': round(mean_downstream_execution_time, 2),
            'executions_count': len(executions),
            'total_execution_time': round(downstream_execution_time, 2)
        }
    else:
        return {}
    
# remove edges starting at tests
for u, v in list(G.edges):
    if u.startswith('test.'):
        G.remove_edge(u, v)

for u, v, d in G.edges(data=True):
    if not u.startswith('test.') and not v.startswith('test.'):
        u_metrics = downstream_execution_metrics(G.nodes[u][DOWNSTREAM_EXECUTIONS])
        v_metrics = downstream_execution_metrics(G.nodes[v][DOWNSTREAM_EXECUTIONS])
        G.nodes[u]['metrics'] = u_metrics
        G.nodes[v]['metrics'] = v_metrics
        d['mean_execution_time_delta'] = round(v_metrics['mean_execution_time'] - u_metrics['mean_execution_time'], 2)


for u, v, d in sorted(G.edges(data=True), key=lambda edge: edge[2].get('mean_execution_time_delta', 0), reverse=True):
    if not u.startswith('test.') and not v.startswith('test.'):
        node_u = G.nodes[u]
        node_v = G.nodes[v]
        print(v, node_v['metrics']['mean_execution_time'], u, node_u['metrics']['mean_execution_time'], d.get('mean_execution_time_delta', 0))

for n in test_nodes:
    paths = list(nx.all_simple_paths(G, 'source.dbt_experiments.imdb.name_basics', n))
    if paths:
        debug_path = [(node, G.nodes[node].get('metrics', {})) for node in paths[0]]
        print(debug_path)