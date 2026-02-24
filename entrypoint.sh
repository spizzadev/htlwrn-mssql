#!/bin/bash
set -e

/opt/mssql/bin/sqlservr &

echo "Waiting for SQL Server to become ready..."
for i in {1..30}; do
  /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" \
    -Q "SELECT 1" -C -l 1 &>/dev/null && break
  echo "  attempt $i/30..."
  sleep 2
done

echo "Importing schema: $DB_NAME into master..."
/opt/mssql-tools18/bin/sqlcmd \
  -S localhost \
  -U sa \
  -P "$MSSQL_SA_PASSWORD" \
  -i /initdb/init.sql \
  -C

echo "Schema $DB_NAME ready in master."
wait
