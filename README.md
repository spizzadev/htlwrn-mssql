# htlwrn-mssql

Pre-seeded MSSQL 2022 Docker images for database exercises. Pull an image and connect — the data is already there.

## Connect

```
Server:    localhost,1433
User:      sa
Password:  Htlwrn_1
```

## Images

### `:latest` — all databases in one image

Pass the database name as the first argument. Shows the build timestamp on startup. Prints a help message with all available databases if the argument is missing or invalid.

```bash
docker run -p 1433:1433 --rm ghcr.io/OWNER/htlwrn-mssql:latest hr
```

### Per-database tags

Each tag is a standalone image with one pre-loaded database (connects to `master`):

```bash
docker run -p 1433:1433 --rm ghcr.io/OWNER/htlwrn-mssql:feuerwehr
```

Replace `OWNER` with the GitHub username hosting this repo.

## Available Databases

| Tag / Name | Tables |
|------------|--------|
| `airport` | Airline, Aircraft, Aircrew, Flight |
| `books` | Authors, Titles, TitlesAuthors |
| `feuerwehr` | Competition, Troops, Persons, Ranks |
| `flug` | Pilot, Flugzeug, Flughafen, Fliegt |
| `hr` | Regions, Countries, Locations, Departments, Jobs, Employees |
| `imkerei` | Imker, Bienenstock, Koenigin, Arbeiterin, Felder |
| `lager` | Artikel, Lager, Lieferung |
| `lt` | Lieferanten, Teile, LT |
| `mensa` | Speise, Menue, Zutat, Bestellung, Serviert |
| `mondial` | Country, Organization, isMember |
| `orders` | Customers, Orders, Products, OrderDetails |
| `suppliers` | Suppliers, Parts, SupplierParts |
| `tankstelle` | Kraftstoff, Zapfsaeule, Tagespreis, Verkauf |

## Adding a New Database

1. Create `databases/<name>/init.sql` with `DROP TABLE IF EXISTS` + `CREATE TABLE` + `INSERT` statements (no `CREATE DATABASE` or `USE` needed — per-DB images use `master`, the `:latest` image creates a named database automatically)
2. Push to `main` — CI builds the new per-database tag **and** rebuilds `:latest` automatically

See [CLAUDE.md](CLAUDE.md) for the full workflow including build verification steps.
