# railway-prometheus

Prometheus for the bapp API, deployed on Railway. It scrapes bapp's `/metrics` endpoint
(job `bapp`) every 15s and keeps data for 365 days. Grafana (the `railway-grafana` repo) reads
from it.

The scrape config is written at container start by `entrypoint.sh`, with the target taken from
`METRICS_TARGET`. To change the target, update the Railway env var and redeploy. No rebuild is
needed.

## Environment variables

| Name | Purpose | Default |
|---|---|---|
| `METRICS_TARGET` | `host:port` of the bapp metrics endpoint (`/metrics` is appended) | `localhost:8081` |

See [AGENTS.md](AGENTS.md) for details: files, deploy settings, and how to validate changes.
