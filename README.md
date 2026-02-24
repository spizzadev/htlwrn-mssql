# htlwrn-mssql

Pre-seeded MSSQL 2022 Docker images for database exercises. Pull an image and connect — the data is already there.

## Connect

```
Server:    localhost,1433
User:      sa
Password:  Htlwrn_1
Database:  master
```

## Available Tags

| Tag | Tables |
|-----|--------|
| `airport` | Airline, Aircraft, Aircrew, Flight |
| `books` | Authors, Titles, TitlesAuthors |
| `feuerwehr` | Competition, Troops, Persons, Ranks |
| `flug` | Pilot, Flugzeug, Flughafen, Fliegt |
| `imkerei` | Imker, Bienenstock, Koenigin, Arbeiterin, Felder |
| `lager` | Artikel, Lager, Lieferung |
| `lt` | Lieferanten, Teile, LT |
| `mensa` | Speise, Menue, Zutat, Bestellung, Serviert |
| `mondial` | Country, Organization, isMember |
| `suppliers` | Suppliers, Parts, SupplierParts |
| `tankstelle` | Kraftstoff, Zapfsaeule, Tagespreis, Verkauf |

## Usage

```bash
docker run -p 1433:1433 --rm ghcr.io/OWNER/htlwrn-mssql:feuerwehr
```

Replace `OWNER` with the GitHub username hosting this repo.

## Adding a New Database

1. Create `databases/<name>/init.sql` with `DROP TABLE IF EXISTS` + `CREATE TABLE` + `INSERT` statements (tables load into `master`, no `CREATE DATABASE` needed)
2. Push to `main` — CI builds and pushes the new tag automatically

See [CLAUDE.md](CLAUDE.md) for the full workflow including build verification steps.
