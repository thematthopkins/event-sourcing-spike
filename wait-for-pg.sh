#!/bin/bash
set -euo pipefail

echo "waiting for pg at $1..."
until psql "${1}" -c ''; do
    >&2 echo "waiting for pg..."
    sleep 1
done
echo "pg started"
