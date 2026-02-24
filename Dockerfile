FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=Htlwrn_1

ARG DB_NAME
ENV DB_NAME=${DB_NAME}

USER root

COPY databases/${DB_NAME}/init.sql /initdb/init.sql

RUN bash -c '\
    /opt/mssql/bin/sqlservr & \
    MSSQL_PID=$! && \
    echo "Waiting for SQL Server..." && \
    for i in $(seq 1 30); do \
      /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$MSSQL_SA_PASSWORD" \
        -Q "SELECT 1" -C -l 1 >/dev/null 2>&1 && break; \
      echo "  attempt $i/30..."; \
      sleep 2; \
    done && \
    echo "Importing schema..." && \
    /opt/mssql-tools18/bin/sqlcmd \
      -S localhost -U sa -P "$MSSQL_SA_PASSWORD" \
      -i /initdb/init.sql -C && \
    echo "Stopping SQL Server..." && \
    kill $MSSQL_PID && \
    sleep 10'

EXPOSE 1433

ENTRYPOINT ["/opt/mssql/bin/sqlservr"]
