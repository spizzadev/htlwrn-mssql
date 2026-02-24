# htlwrn-mssql

Ready-to-use MSSQL 2022 Docker images for school database exercises.

One image, one tag per schema. Each container loads its schema directly into `master` — connect and query immediately.

## Available Tags

| Tag | Tabellen |
|-----|----------|
| `airport` | Airline, Aircraft, Aircrew, Flight management |
| `books` | Authors, Titles, TitlesAuthors |
| `feuerwehr` | Competition, Troops, Persons, Ranks |
| `flug` | Pilot, Flugzeug, Flughafen, Fliegt |
| `imkerei` | Imker, Bienenstock, Koenigin, Arbeiterin, Felder |
| `lager` | Artikel, Lager, Lieferung |
| `lt` | Lieferanten, Teile, LT (classic relational DB example) |
| `mensa` | Speise, Menue, Zutat, Bestellung, Serviert |
| `mondial` | Country, Organization, isMember (world geographic data) |
| `suppliers` | Suppliers, Parts, SupplierParts |
| `tankstelle` | Kraftstoff, Zapfsaeule, Tagespreis, Verkauf |

## Usage

```bash
docker run -p 1433:1433 --rm ghcr.io/OWNER/htlwrn-mssql:feuerwehr
docker run -p 1433:1433 --rm ghcr.io/OWNER/htlwrn-mssql:airport
docker run -p 1433:1433 --rm ghcr.io/OWNER/htlwrn-mssql:imkerei
```

Connect with Azure Data Studio or SSMS:
- **Server:** `localhost,1433`
- **User:** `sa`
- **Password:** `YourStrong!Passw0rd`
- **Database:** `master`

## Local Build

```bash
docker build --build-arg DB_NAME=tankstelle -t htlwrn-mssql:tankstelle .
docker run -p 1433:1433 --rm htlwrn-mssql:tankstelle
```

## Adding a New Schema

1. Create `databases/<name>/init.sql` with `DROP TABLE IF EXISTS` + `CREATE TABLE` + `INSERT` statements
2. Push to `main` — CI detects the new folder and builds automatically

## CI / GHCR

Images are built via GitHub Actions on every push to `main`.
The workflow only rebuilds a tag if:
- the corresponding `databases/<name>/` folder changed, **or**
- the tag does not yet exist in GHCR

Trigger a full rebuild manually via *Actions → Run workflow*.
