---
name: docker-compose-nestjs
description: Set up NestJS application with PostgreSQL, Redis, and optional services in Docker Compose
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: infrastructure
---

## What I do

- Create multi-container Docker Compose setup
- Configure NestJS with PostgreSQL and Redis
- Set up health checks for containers
- Configure networking between services
- Add Nginx as reverse proxy

## When to use me

Use this when deploying NestJS applications with Docker. Combine with observability stack for production monitoring.

## Docker Compose

```yaml
networks:
  public:
  internal:
    internal: true

services:
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
    restart: unless-stopped
    environment:
      - NODE_ENV=production
      - PORT=3000
      - POSTGRES_HOST=postgres
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
      - JWT_ACCESS_SECRET=${JWT_ACCESS_SECRET}
      - JWT_REFLESH_SECRET=${JWT_REFRESH_SECRET}
      - REDIS_HOST=redis
      - REDIS_PASSWORD=${REDIS_PASSWORD}
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started
    networks:
      - internal
    volumes:
      - backend_data:/app
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/api/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  postgres:
    image: postgres:16.3
    restart: unless-stopped
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - internal
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:8.4
    restart: unless-stopped
    command: >
      redis-server
      --requirepass ${REDIS_PASSWORD}
      --save 86400 1
      --appendonly no
    volumes:
      - redis_data:/data
    networks:
      - internal

  nginx:
    image: nginx
    restart: unless-stopped
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - api
    networks:
      - public
      - internal
    ports:
      - "80:80"
      - "443:443"

volumes:
  postgres_data:
  redis_data:
  backend_data:
```

## Environment Variables

```bash
# Database
POSTGRES_USER=app_user
POSTGRES_PASSWORD=change_me_in_production
POSTGRES_DB=app_db

# JWT
JWT_ACCESS_SECRET=your_access_secret_min_32_chars
JWT_REFRESH_SECRET=your_refresh_secret_min_32_chars

# Redis
REDIS_PASSWORD=change_me_in_production

# External services
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
```

## NestJS Dockerfile

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json .

EXPOSE 3000
CMD ["node", "dist/main.js"]
```

## Health Check Endpoint

```typescript
@Controller('health')
export class HealthController {
  @Get()
  check() {
    return { status: 'ok', timestamp: new Date().toISOString() };
  }
}
```

## Commands

```bash
# Build and start
docker-compose up --build

# Run in background
docker-compose up -d

# View logs
docker-compose logs -f api

# Stop
docker-compose down
```
