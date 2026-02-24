# CLAUDE.md — dbi-containers

## Project Overview

One Docker image (`htlwrn-mssql`) with one tag per database schema.
Each tag is a self-contained MSSQL 2022 image where the schema is baked in at build time.
Tables live in the default `master` database.

Repository structure:
```
databases/
  <name>/
    init.sql      ← schema + data for one database
Dockerfile        ← generic, takes DB_NAME build-arg
.github/workflows/build.yml  ← auto-builds changed tags on push
```

SA password: `Htlwrn_1`

---

## Workflow: Adding a New Database

When the user adds SQL files (untracked or staged), follow these steps automatically:

### 1. Inspect the files

Read the SQL files to understand:
- What tables they create
- Whether there are separate create + insert files (combine them)
- What the database name should be (infer from filename or content)

### 2. Create `databases/<name>/init.sql`

Rules for a valid `init.sql`:
- Start with `DROP TABLE IF EXISTS` for each table **in reverse dependency order** (child tables first)
- Then `CREATE TABLE` statements
- Then `INSERT` statements
- Use `GO` as batch separator throughout (MSSQL syntax)
- Ensure every `GO` is on its own line with a newline before AND after it (common mistake: `go` directly followed by next statement without newline when concatenating files)
- Fix CRLF line endings: run `tr -d '\r'` on any Windows-format files before writing
- Do NOT add `CREATE DATABASE` or `USE` statements — tables go into `master`

### 3. Build the Docker image

```bash
docker build --build-arg DB_NAME=<name> -t htlwrn-mssql:<name> .
```

If the build fails:
- Read the error from the RUN layer output
- Fix the `databases/<name>/init.sql` accordingly
- Rebuild (can use cache: just `docker build` without `--no-cache`)
- Repeat until build succeeds

### 4. Verify the image

```bash
CID=$(docker run -d htlwrn-mssql:<name>)
sleep 15  # wait for SQL Server to load pre-seeded data
docker exec $CID /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "Htlwrn_1" -C \
  -Q "SELECT t.name, p.rows FROM sys.tables t JOIN sys.partitions p ON t.object_id=p.object_id AND p.index_id<=1 ORDER BY t.name"
docker rm -f $CID
```

Check that all tables have the expected row counts.

### 5. Commit and push

```bash
git add databases/<name>/init.sql
git commit -m "feat: add <name> database"
git push
```

GitHub Actions will automatically build and push to GHCR.

### 6. Update README.md

Add the new database tag to the table in README.md.

---

## MSSQL Password Notes

The SA password is `Htlwrn_1`. MSSQL requires at least 8 characters with uppercase, lowercase, digit, and special character — plain `htlwrn` is rejected by the server.

---

## Common Errors and Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `Incorrect syntax near 'goINSERT'` | Missing newline after `go` when concatenating files | Add `\n` between the `go` and next statement |
| `DROP TABLE` fails | Missing `IF EXISTS` keyword | Use `DROP TABLE IF EXISTS <name>;` |
| Login fails right after container start | SQL Server still starting | Wait 10-15s; use a poll loop |
| Tables created but empty | INSERT file not included in init.sql | Append the insert file content |
| CRLF issue in sed patterns | Windows line endings prevent `$` anchor matching | Pipe through `tr -d '\r'` first |
