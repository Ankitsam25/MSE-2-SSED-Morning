#!/usr/bin/env bash
set -e

echo "=== Testing PostgreSQL Data Persistence ==="

# Restart PostgreSQL container
echo "Restarting PostgreSQL container to test volume persistence..."
docker compose restart postgres

# Wait for PostgreSQL to become healthy
for attempt in $(seq 1 30); do
  if docker compose exec -T postgres pg_isready -U taskflow_user -d taskflow > /dev/null 2>&1; then
    echo "PostgreSQL is healthy after restart (attempt $attempt/30)"
    break
  fi
  if [ "$attempt" -eq 30 ]; then
    echo "::error::PostgreSQL failed to resume after restart"
    docker compose logs postgres
    exit 1
  fi
  sleep 1
done

# Wait for backend to resume responding
for attempt in $(seq 1 30); do
  if curl --fail --silent http://localhost:3000/health > /dev/null 2>&1; then
    echo "Backend is healthy after PostgreSQL restart"
    break
  fi
  sleep 1
done

echo "PostgreSQL persistence verification successful."
