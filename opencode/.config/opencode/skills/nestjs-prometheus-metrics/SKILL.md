---
name: nestjs-prometheus-metrics
description: Implement Prometheus metrics for HTTP requests, database queries, and connections using prom-client
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Define Prometheus metrics: Counter, Gauge, Histogram
- Create metrics endpoint for Prometheus scraping
- Track HTTP request count, duration, and in-progress requests
- Monitor database query metrics

## When to use me

Use this for monitoring NestJS applications with Prometheus. Combine with docker-compose-observability for full stack.

## Metrics Definitions

```typescript
import { Counter, Gauge, Histogram } from 'prom-client';

export const httpRequestsTotal = new Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'route', 'status'],
});

export const httpRequestDuration = new Histogram({
  name: 'http_request_duration_ms',
  help: 'HTTP request duration in milliseconds',
  labelNames: ['method', 'route', 'status'],
  buckets: [10, 50, 100, 200, 500, 1000, 2000, 5000],
});

export const httpRequestsInProgress = new Gauge({
  name: 'http_requests_in_progress',
  help: 'Number of active HTTP requests',
  labelNames: ['method', 'route'],
});

export const dbQueryTotal = new Counter({
  name: 'db_query_total',
  help: 'Total database queries executed',
  labelNames: ['model', 'type'],
});

export const dbQueryDuration = new Histogram({
  name: 'db_query_duration_seconds',
  help: 'Database query execution duration',
  labelNames: ['model', 'type'],
  buckets: [0.001, 0.005, 0.01, 0.05, 0.1, 0.3, 0.5, 1, 2],
});

export const dbConnections = new Gauge({
  name: 'db_connections',
  help: 'Open database connections',
});

export const dbErrorsTotal = new Counter({
  name: 'db_errors_total',
  help: 'Total database query errors',
  labelNames: ['model', 'type'],
});
```

## Metrics Controller

```typescript
import { Controller, Get } from '@nestjs/common';
import * as client from 'prom-client';

@Controller('metrics')
export class MetricsController {
  @Get()
  async getMetrics() {
    const registry = new client.Registry();
    client.collectDefaultMetrics({ register: registry });
    return registry.metrics();
  }

  @Get('json')
  async getMetricsJson() {
    const registry = new client.Registry();
    client.collectDefaultMetrics({ register: registry });
    return registry.getMetricsAsJSON();
  }
}
```

## Metrics Interceptor

```typescript
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap, finalize } from 'rxjs/operators';
import { httpRequestsTotal, httpRequestDuration, httpRequestsInProgress } from 'src/metrics/metrics';

@Injectable()
export class HttpMetricsInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const now = Date.now();
    const req = context.switchToHttp().getRequest();
    const res = context.switchToHttp().getResponse();

    const method = req.method;
    const route = req.route?.path || req.originalUrl;

    httpRequestsInProgress.inc({ method, route });

    return next.handle().pipe(
      finalize(() => {
        const duration = Date.now() - now;

        httpRequestsTotal.inc({ method, route, status: res.statusCode });
        httpRequestDuration.observe({ method, route, status: res.statusCode }, duration);
        httpRequestsInProgress.dec({ method, route });
      }),
    );
  }
}
```

## Global Interceptor Registration

```typescript
import { APP_INTERCEPTOR } from '@nestjs/core';

@Module({
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: HttpMetricsInterceptor,
    },
  ],
})
export class AppModule {}
```

## Prometheus Configuration

```yaml
scrape_configs:
  - job_name: "api"
    metrics_path: /api/metrics
    static_configs:
      - targets: ["api:3000"]
```

## Installation

```bash
npm install prom-client
```
