---
name: docker-compose-observability
description: Set up Prometheus, Grafana, Loki, and Promtail in Docker Compose for full observability stack
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: infrastructure
---

## What I do

- Set up Prometheus for metrics collection
- Configure Grafana dashboards and datasources
- Add Loki for log aggregation
- Configure Promtail for Docker container log scraping
- Auto-provision datasources and dashboards

## When to use me

Use this for production monitoring. Combine with nestjs-prometheus-metrics for complete observability.

## Docker Compose

```yaml
networks:
  internal:
    internal: true

services:
  prometheus:
    image: prom/prometheus:latest
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
    networks:
      - internal
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    restart: unless-stopped
    environment:
      - GF_SERVER_ROOT_URL=%(protocol)s://%(domain)s/grafana/
      - GF_SERVER_SERVE_FROM_SUB_PATH=true
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - ./grafana/provisioning:/etc/grafana/provisioning
      - ./grafana/dashboards:/etc/grafana/dashboards
      - grafana_data:/var/lib/grafana
    networks:
      - internal
    ports:
      - "3000:3000"
    depends_on:
      - prometheus

  loki:
    image: grafana/loki:2.9.0
    restart: unless-stopped
    command: -config.file=/etc/loki/local-config.yaml
    volumes:
      - loki_data:/loki
    networks:
      - internal
    ports:
      - "3100:3100"

  promtail:
    image: grafana/promtail:3.5.9
    restart: unless-stopped
    volumes:
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock
      - ./promtail-config.yml:/etc/promtail/config.yml
    command: -config.file=/etc/promtail/config.yml
    networks:
      - internal
    depends_on:
      - loki

volumes:
  prometheus_data:
  grafana_data:
  loki_data:
```

## Prometheus Configuration

```yaml
global:
  scrape_interval: 60s

scrape_configs:
  - job_name: "api"
    metrics_path: /api/metrics
    static_configs:
      - targets: ["api:3000"]

  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
```

## Promtail Configuration

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 9081

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: containers
    pipeline_stages:
      - docker: {}
    static_configs:
      - targets:
          - localhost
        labels:
          job: containerlogs
          __path__: /var/lib/docker/containers/*/*.log
```

## Container Labels

```yaml
services:
  api:
    labels:
      logging: "promtail"
      service: "api"
    
  worker:
    labels:
      logging: "promtail"
      service: "worker"
```

## Grafana Datasources

```yaml
# grafana/provisioning/datasources/datasources.yml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true

  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
```

## Commands

```bash
docker-compose -f docker-compose.observability.yml up -d

# Access services
# Prometheus: http://localhost:9090
# Grafana: http://localhost:3000 (admin/admin)
```
