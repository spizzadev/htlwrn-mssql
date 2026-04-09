# htlwrn-mssql

Pre-seeded MSSQL 2022 Docker images for database exercises. Pull an image and connect — the data is already there.

## Images

### `:latest` — all databases in one image

Pass the database name as the first argument. Shows the build timestamp on startup; prints a help message listing all available databases if the argument is missing or invalid.

```bash
docker run -p 1433:1433 --rm ghcr.io/OWNER/htlwrn-mssql:latest hr
```

### Per-database tags

Each tag is a minimal image with a single pre-loaded database:

```bash
docker run -p 1433:1433 --rm ghcr.io/OWNER/htlwrn-mssql:feuerwehr
```

Replace `OWNER` with the GitHub username hosting this repo.

## Connect

```
Server:    localhost,1433
User:      sa
Password:  Htlwrn_1
```

Per-database tags use `master` as the default database. With `:latest`, the selected database is set as default automatically.

## Available Databases

| Name | Tables |
|------|--------|
| `airport` | Airline, Aircrew, Aircraft, Flight, Flight_leg, Passenger, Flight_schedule_date |
| `books` | Authors, Titles, TitlesAuthors |
| `feuerwehr` | competition, team, person, competitive_troop, pers_rank, is_troop_member, has_participated |
| `flug` | pilot, ftype, flugzeug, flughafen, flug, fliegt |
| `hr` | regions, countries, locations, departments, jobs, employees, job_history, emp_audit |
| `imkerei` | Imker, Bienenstock, Koenigin, Arbeiterin, Brutnest, Feld, Landwirtschaftsbetrieb |
| `lager` | artikel, lager, lieferung |
| `lt` | l, t, lt |
| `mensa` | speise, zutat, menue, lieferant, tag, bestellung, bestellposition, serviert |
| `mondial` | Country, Organization, isMember |
| `orders` | Customer, Product, Inventory, Orders, OrderLine, StockMovement, AuditLog |
| `suppliers` | Suppliers, Parts, SupplierParts |
| `tankstelle` | Kraftstoff, Tagespreis, Zapfsaeule, Verkauf |

## Adding a New Database

1. Create `databases/<name>/init.sql` with `DROP TABLE IF EXISTS` + `CREATE TABLE` + `INSERT` statements — no `CREATE DATABASE` or `USE` needed
2. Push to `main` — CI builds the per-database tag **and** rebuilds `:latest` automatically

See [CLAUDE.md](CLAUDE.md) for the full workflow and build verification steps.
