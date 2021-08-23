#!/bin/bash
set -euo pipefail

POSTGRES="$1"
INITDB="$2"
DB_DIR="$3"
SQL_DEBUG_LOGGING="${4:-}"

tempDBPass=$(mktemp)

echo password > "${tempDBPass}"
$INITDB -A password -U superuser "${DB_DIR}" --pwfile="${tempDBPass}"

# things don't flush to disk, so postgres is quicker
{
    echo ""
    echo "fsync = off"
    echo "full_page_writes = off"
    echo "synchronous_commit = off"
    echo "timezone = UTC"
    echo "log_min_messages = 'notice'"
    echo "jit = off"
} >> "${DB_DIR}/postgresql.conf"

if [ "$SQL_DEBUG_LOGGING" == "true" ]; then
    {
        echo "log_statement = 'all'"
        echo "log_duration = 1"
    } >> "${DB_DIR}/postgresql.conf"
fi

echo "" >> "${DB_DIR}/postgresql.conf"


"${POSTGRES}" -D "${DB_DIR}" -k /tmp &

./wait-for-pg.sh "postgres://superuser:password@localhost:5432/postgres"

psql "postgres://superuser:password@localhost:5432/postgres" -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'development';" > /dev/null
psql "postgres://superuser:password@localhost:5432/postgres" -c 'drop database if exists development' > /dev/null
psql "postgres://superuser:password@localhost:5432/postgres" -c 'create database development' > /dev/null

psql "postgres://superuser:password@localhost:5432/postgres" -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'test';" > /dev/null
psql "postgres://superuser:password@localhost:5432/postgres" -c 'drop database if exists test' > /dev/null
psql "postgres://superuser:password@localhost:5432/postgres" -c 'create database test' > /dev/null

