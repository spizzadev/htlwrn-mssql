#!/bin/sh

TIMESTAMP=$(cat /commit_timestamp.txt 2>/dev/null || printf 'unknown')

printf 'Available databases:\n'
while IFS= read -r db; do
    printf '  %s\n' "$db"
done < /available_databases.txt
printf '\nBuilt at: %s\n\n' "$TIMESTAMP"

exec /opt/mssql/bin/sqlservr
