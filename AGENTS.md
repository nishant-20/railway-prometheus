# AGENTS.md

## What this repo is
A minimal Prometheus image deployed on Railway. It scrapes the **bapp** API's metrics endpoint
(job `bapp`, path `/metrics`) every 15s and keeps data for 365 days. The Grafana side of the
monitoring stack is a separate repo, `railway-grafana`.

Files:
- `Dockerfile` — `FROM prom/prometheus`, copies `entrypoint.sh`, exposes `9090`.
- `entrypoint.sh` — writes `/etc/prometheus/prometheus.yml` at container start (filling in
  `METRICS_TARGET`), then `exec`s Prometheus with the storage/retention flags.
- `prometheus.yml` — reference copy of the config structure only. It is **not** copied into
  the image; the live config is the heredoc in `entrypoint.sh`. Keep the two in sync if you
  change the config shape.
- `railway.toml` — Railway build/deploy settings.
- `README.md` — upstream Railway template text (its "self-monitor + demo app" description is
  out of date; the config now scrapes bapp only).

## How it runs and deploys
- Railway builds from `Dockerfile` (`builder = "DOCKERFILE"`), runs 1 replica, restart policy
  `ON_FAILURE` with up to 10 retries.
- Prometheus listens on port 9090; TSDB data lives at `/prometheus`.
- Changing the scrape target needs no rebuild: update the Railway env var and redeploy.
- Agents never deploy. Deploys happen through Railway after changes are merged.

## Environment variables
| Name | Purpose | Default |
|---|---|---|
| `METRICS_TARGET` | `host:port` of the bapp metrics endpoint to scrape (`/metrics` is appended by `metrics_path`) | `localhost:8081` |

## Validating a change
- `sh -n entrypoint.sh` — syntax check of the entrypoint (the required check).
- Optional, if Docker is available: `docker build -t railway-prometheus .` and run it with
  `-e METRICS_TARGET=host:port -p 9090:9090`, then check `http://localhost:9090/targets`.
- Optional, if `promtool` is available: `promtool check config prometheus.yml`.

## Rules
- No secrets in the repo — targets and credentials go in Railway env vars.
- Never commit to `main`; work on a branch and open a PR.
- Keep the config minimal: one scrape job unless a change explicitly asks for more. Don't add
  files, tooling, or flags that aren't needed.
