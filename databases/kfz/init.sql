DROP TABLE IF EXISTS Protokoll;
GO
DROP TABLE IF EXISTS Serviceeintrag;
GO
DROP TABLE IF EXISTS Vermietung;
GO
DROP TABLE IF EXISTS Fahrzeug;
GO
DROP TABLE IF EXISTS Kunde;
GO

CREATE TABLE Kunde (
    KundeID       INT           PRIMARY KEY IDENTITY,
    Vorname       VARCHAR(50)   NOT NULL,
    Nachname      VARCHAR(50)   NOT NULL,
    Email         VARCHAR(100),
    Fuehrerschein BIT           NOT NULL DEFAULT 1,
    Gesperrt      BIT           NOT NULL DEFAULT 0
);
GO

CREATE TABLE Fahrzeug (
    FahrzeugID  INT           PRIMARY KEY IDENTITY,
    Kennzeichen VARCHAR(12)   NOT NULL UNIQUE,
    Marke       VARCHAR(50),
    Modell      VARCHAR(50),
    Baujahr     INT,
    KmStand     INT           NOT NULL DEFAULT 0,
    Status      VARCHAR(20)   NOT NULL DEFAULT 'Verfügbar',
    BesitzerID  INT           REFERENCES Kunde(KundeID)
);
GO

CREATE TABLE Vermietung (
    VermietungID  INT             PRIMARY KEY IDENTITY,
    FahrzeugID    INT             NOT NULL REFERENCES Fahrzeug(FahrzeugID),
    KundeID       INT             NOT NULL REFERENCES Kunde(KundeID),
    DatumVon      DATE            NOT NULL,
    DatumBis      DATE            NOT NULL,
    Gesamtpreis   DECIMAL(10,2),
    Abgeschlossen BIT             NOT NULL DEFAULT 0
);
GO

CREATE TABLE Serviceeintrag (
    ServiceID          INT             PRIMARY KEY IDENTITY,
    FahrzeugID         INT             NOT NULL REFERENCES Fahrzeug(FahrzeugID),
    Datum              DATE            NOT NULL,
    Beschreibung       VARCHAR(255),
    Kosten             DECIMAL(10,2),
    KmStandBeiService  INT             NOT NULL
);
GO

CREATE TABLE Protokoll (
    ProtokollID   INT           PRIMARY KEY IDENTITY,
    Zeitstempel   DATETIME      NOT NULL DEFAULT GETDATE(),
    Tabelle       VARCHAR(50),
    Aktion        VARCHAR(10),
    Beschreibung  VARCHAR(500),
    BenutzerName  VARCHAR(100)
);
GO

INSERT INTO Kunde (Vorname, Nachname, Email, Fuehrerschein, Gesperrt) VALUES
    ('Hans',   'Müller',  'hans.mueller@mail.at',  1, 0),
    ('Anna',   'Maier',   'anna.maier@mail.at',    1, 0),
    ('Peter',  'Schmidt', 'p.schmidt@mail.at',     0, 0),
    ('Lisa',   'Wagner',  'l.wagner@mail.at',      1, 1);
GO

INSERT INTO Fahrzeug (Kennzeichen, Marke, Modell, Baujahr, KmStand, Status) VALUES
    ('WN-123AB', 'VW',     'Golf',    2020, 15000, 'Verfügbar'),
    ('WN-456CD', 'BMW',    '3er',     2021, 22000, 'Verfügbar'),
    ('WN-789EF', 'Audi',   'A4',      2019, 45000, 'Verfügbar'),
    ('WN-321GH', 'Skoda',  'Octavia', 2022,  8000, 'Verfügbar'),
    ('WN-654IJ', 'Ford',   'Focus',   2018, 60000, 'Gesperrt'),
    ('WN-987KL', 'Toyota', 'Corolla', 2023,  3000, 'Verfügbar');
GO

INSERT INTO Vermietung (FahrzeugID, KundeID, DatumVon, DatumBis, Gesamtpreis, Abgeschlossen) VALUES
    (3, 1, '2025-01-10', '2025-01-15', 350.00, 1),
    (3, 1, '2025-02-05', '2025-02-10', 300.00, 1),
    (3, 1, '2025-03-01', '2025-03-08', 420.00, 1),
    (2, 1, '2025-04-01', '2025-04-07', 390.00, 0);
GO
