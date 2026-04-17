# htlwrn-mssql

Pre-seeded Microsoft SQL Server 2022 images for database exercises. Schema and data are baked in at build time — pull the image and start querying immediately.

## Usage

### All databases — `:latest`

One image containing all databases. Each database lives in its own named SQL Server database.

```bash
docker run -d -p 1433:1433 ghcr.io/spizzadev/htlwrn-mssql:latest
```

Connect to a specific database:

```bash
sqlcmd -S localhost -U sa -P Htlwrn_1 -d hr
```

The container prints the list of available databases and the build timestamp on startup.

### Single database — `:<name>`

Lightweight images with one database pre-loaded into `master`.

```bash
docker run -d -p 1433:1433 ghcr.io/spizzadev/htlwrn-mssql:hr
```

```bash
sqlcmd -S localhost -U sa -P Htlwrn_1
```

## Connection Details

| | |
|-|-|
| **Server** | `localhost` |
| **User** | `sa` |
| **Password** | `Htlwrn_1` |

## Available Databases

| Database | Tables |
|----------|--------|
| `airport` | Airline, Aircrew, Aircraft, Flight, Flight_leg, Passenger, Flight_schedule_date |
| `books` | Authors, Titles, TitlesAuthors |
| `feuerwehr` | competition, team, person, competitive_troop, pers_rank, is_troop_member, has_participated |
| `flug` | pilot, ftype, flugzeug, flughafen, flug, fliegt |
| `hr` | regions, countries, locations, departments, jobs, employees, job_history, emp_audit |
| `imkerei` | Imker, Bienenstock, Koenigin, Arbeiterin, Brutnest, Feld, Landwirtschaftsbetrieb |
| `kfz` | Kunde, Fahrzeug, Vermietung, Serviceeintrag, Protokoll |
| `lager` | artikel, lager, lieferung |
| `lt` | l, t, lt |
| `mensa` | speise, zutat, menue, lieferant, tag, bestellung, bestellposition, serviert |
| `mondial` | Country, Organization, isMember |
| `orders` | Customer, Product, Inventory, Orders, OrderLine, StockMovement, AuditLog |
| `suppliers` | Suppliers, Parts, SupplierParts |
| `tankstelle` | Kraftstoff, Tagespreis, Zapfsaeule, Verkauf |

## License

MIT — see [LICENSE](LICENSE)
