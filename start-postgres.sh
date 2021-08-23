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
