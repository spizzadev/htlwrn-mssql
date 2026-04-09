#!/bin/sh

TIMESTAMP=$(cat /commit_timestamp.txt 2>/dev/null || printf 'unknown')
DB_ARG="$1"

if [ -z "$DB_ARG" ] || ! grep -qx "$DB_ARG" /available_databases.txt 2>/dev/null; then
    printf 'Usage: docker run <image> <database>\n\n'
    printf 'Available databases:\n'
    while IFS= read -r db; do
        printf '  %s\n' "$db"
    done < /available_databases.txt
    printf '\nBuilt at: %s\n' "$TIMESTAMP"
    exit 1
fi

printf 'Starting SQL Server — database: %s\n' "$DB_ARG"
printf 'Built at: %s\n' "$TIMESTAMP"

/opt/mssql/bin/sqlservr &
MSSQL_PID=$!

printf 'Waiting for SQL Server...\n'
i=0
while [ "$i" -lt 30 ]; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" \
        -Q "SELECT 1" -C -l 1 >/dev/null 2>&1; then
        break
    fi
    i=$((i + 1))
    printf '  attempt %s/30...\n' "$i"
    sleep 2
done

/opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P "$MSSQL_SA_PASSWORD" \
    -Q "ALTER LOGIN sa WITH DEFAULT_DATABASE = [$DB_ARG];" -C

printf 'Ready. Connect: sa / Htlwrn_1 / default db: %s\n' "$DB_ARG"

wait "$MSSQL_PID"
