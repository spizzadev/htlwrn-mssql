FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=YourStrong!Passw0rd

ARG DB_NAME
ENV DB_NAME=${DB_NAME}

USER root

COPY databases/${DB_NAME}/init.sql /initdb/init.sql
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1433

ENTRYPOINT ["/entrypoint.sh"]
