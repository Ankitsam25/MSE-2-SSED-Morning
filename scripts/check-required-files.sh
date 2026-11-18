#!/usr/bin/env bash
set -e

echo "=== Checking Required Submission Files ==="

files=(
  "frontend/Dockerfile"
  "backend/Dockerfile"
  "docker-compose.yml"
  "docker-compose.deploy.yml"
  "submission.json"
)

for f in "${files[@]}"; do
  if [ -f "$f" ]; then
    echo "[OK] Found $f"
  else
    echo "::error::Required file missing: $f"
    exit 1
  fi
done

echo "All required deliverables are present."
