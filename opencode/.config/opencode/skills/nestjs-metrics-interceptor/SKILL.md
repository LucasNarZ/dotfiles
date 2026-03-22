---
name: nestjs-metrics-interceptor
description: Create NestJS interceptor to capture and record HTTP request metrics (duration, size, status)
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Create HTTP metrics interceptor for request tracking
- Record request/response duration and size
- Track in-progress requests
- Export metrics for Prometheus scraping

## When to use me

Use this for HTTP monitoring. Combine with nestjs-prometheus-metrics for full observability stack.

## Metrics Interceptor

```typescript
import { Injectable, NestInterceptor, ExecutionContext, CallHandler, Logger } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap, finalize } from 'rxjs/operators';
import { Request, Response } from 'express';
import {
  httpRequestsTotal,
  httpRequestDuration,
  httpRequestsInProgress,
  httpRequestSize,
  httpResponseSize,
} from 'src/metrics/metrics';

@Injectable()
export class HttpMetricsInterceptor implements NestInterceptor {
  private readonly logger = new Logger(HttpMetricsInterceptor.name);

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const now = Date.now();
    const req: Request = context.switchToHttp().getRequest();
    const res: Response = context.switchToHttp().getResponse();

    const method = req.method;
    const route = req.route?.path || req.originalUrl;

    httpRequestsInProgress.inc({ method, route });

    if (req.headers['content-length']) {
      httpRequestSize.observe(
        { method, route },
        parseInt(req.headers['content-length'], 10),
      );
    }

    return next.handle().pipe(
      tap((data) => {
        if (res.getHeader('content-length')) {
          httpResponseSize.observe(
            { method, route, status: res.statusCode },
            parseInt(res.getHeader('content-length') as string, 10),
          );
        }
      }),
      finalize(() => {
        const duration = Date.now() - now;

        httpRequestsTotal.inc({
          method,
          route,
          status: res.statusCode,
        });

        httpRequestDuration.observe(
          { method, route, status: res.statusCode },
          duration,
        );

        httpRequestsInProgress.dec({ method, route });

        this.logger.debug(`${method} ${route} - ${res.statusCode} - ${duration}ms`);
      }),
    );
  }
}
```

## Global Registration

```typescript
import { APP_INTERCEPTOR } from '@nestjs/core';
import { HttpMetricsInterceptor } from './interceptors/metrics.interceptor';

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

## Module-Level Registration

```typescript
import { Module } from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { HttpMetricsInterceptor } from 'src/interceptors/metrics.interceptor';

@Module({
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: HttpMetricsInterceptor,
    },
  ],
})
export class ApiModule {}
```

## Controller-Level Registration

```typescript
import { Controller, Get, UseInterceptors } from '@nestjs/common';
import { HttpMetricsInterceptor } from 'src/interceptors/metrics.interceptor';

@Controller('posts')
@UseInterceptors(HttpMetricsInterceptor)
export class PostsController {
  @Get()
  findAll() {
    // metrics will be recorded for this endpoint
  }
}
```

## Testing Metrics

```bash
curl http://localhost:3000/api/metrics

# Or use Prometheus UI at http://localhost:9090
# Query: http_requests_total
```
