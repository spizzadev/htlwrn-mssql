# CLAUDE.md — htlwrn-mssql

## Project Overview

Two image types, one registry (`ghcr.io/spizzadev/htlwrn-mssql`):

| Image | Tag | How it works |
|-------|-----|-------------|
| Singleton | `latest` | All databases baked in at build time, each in its own named SQL Server database, `master` stays empty |
| Per-database | `<name>` | One database baked into `master` at build time |

Repository structure:
```
databases/
  <name>/
    init.sql              ← schema + data for one database
Dockerfile                ← per-database image, takes DB_NAME build-arg
Dockerfile.singleton      ← all-in-one image
entrypoint.sh             ← singleton startup banner, then exec sqlservr
.github/workflows/
  build.yml               ← builds changed per-database tags on push to main
  build-singleton.yml     ← rebuilds :latest on push to main
```

SA password: `Htlwrn_1`

---

## Workflow: Adding a New Database

The user will drop a SQL file (or multiple files) into the repo root. It may be ugly, use the wrong syntax, have Windows line endings, missing DROP statements, wrong GO placement, etc. Follow these steps:

### 1. Inspect the input file(s)

Read the SQL file(s) to understand:
- What tables they create and their foreign key relationships
- Whether there are separate create + insert files (combine them)
- What the database name should be (infer from filename, a `USE` statement, or the content)

### 2. Create `databases/<name>/init.sql`

Transform the raw SQL into a clean `init.sql`. Rules:

- **DROP statements first**, in reverse FK dependency order (child tables before parents), each with `IF EXISTS`
- **CREATE TABLE** statements next
- **INSERT** statements last
- **`GO`** as batch separator throughout — on its own line with a blank line before and after
- **No `CREATE DATABASE` or `USE` statements** — for per-DB images tables go into `master`; the singleton Dockerfile wraps each init.sql with `CREATE DATABASE [name]; GO; USE [name]; GO;` automatically
- **No CRLF** — run `tr -d '\r'` mentally; never write `\r\n` endings
- **No inline comments** from the original that explain the schema structure — keep the SQL clean
- Fix any syntax errors, wrong data types, missing semicolons, or invalid MSSQL syntax from the input

### 3. Delete the input file(s)

```bash
rm <input-file>.sql
```

Only `databases/<name>/init.sql` should remain as the new file.

### 4. Build the per-database image

```bash
docker build --build-arg DB_NAME=<name> -t htlwrn-mssql:<name> .
```

If the build fails:
- Read the error from the RUN layer output
- Fix `databases/<name>/init.sql`
- Rebuild (cache is fine: just `docker build` without `--no-cache`)
- Repeat until it succeeds

### 5. Verify the image

```bash
CID=$(docker run -d htlwrn-mssql:<name>)
sleep 15
docker exec $CID /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P "Htlwrn_1" -C \
  -Q "SELECT t.name, p.rows FROM sys.tables t JOIN sys.partitions p ON t.object_id=p.object_id AND p.index_id<=1 ORDER BY t.name"
docker rm -f $CID
```

Check that all tables appear with the expected row counts.

### 6. Update README.md

Add a row to the **Available Databases** table:

```
| `<name>` | Table1, Table2, Table3 |
```

List only the domain tables (not audit/log tables unless they're meaningful to the user).

### 7. Commit and push

```bash
git add databases/<name>/init.sql README.md
git commit -m "feat: add <name> database"
git push
```

GitHub Actions builds and pushes both the per-database tag (`:<name>`) and rebuilds `:latest` automatically.

---

## MSSQL Notes

- SA password is `Htlwrn_1` — MSSQL requires ≥8 chars with uppercase, lowercase, digit, and special character
- The singleton image uses named databases (`CREATE DATABASE [name]`) — `master` is empty
- Per-database images load everything into `master` — no named database exists
- `IDENTITY` columns work without `SET IDENTITY_INSERT` when not providing explicit IDs

---

## Common Errors and Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `Incorrect syntax near 'goINSERT'` | Missing newline after `go` | Ensure `GO` is on its own line with a blank line after |
| `DROP TABLE` fails | Missing `IF EXISTS` | Use `DROP TABLE IF EXISTS <name>;` |
| Login fails right after container start | SQL Server still starting | Wait 10–15s or poll with sqlcmd |
| Tables created but empty | INSERT block missing or not executed | Confirm INSERT statements are present and after the correct `GO` |
| CRLF causes syntax errors | Windows line endings in file | Remove `\r` — never write CRLF endings |
| `Invalid object name 'dbo.X'` in singleton | Table queried from wrong database context | Use three-part name: `<dbname>.dbo.<table>` |
