Drop Table if exists laufen;
Drop Table if exists Beziehung;
Drop Table if exists angemeldet;
Drop Table if exists kundevon;
Drop Table if exists Pfleger;
Drop Table if exists Etappe;
Drop Table if exists Wasserschwein;
Drop Table if exists Katze;
Drop Table if exists Hund;
Drop Table if exists Tour;
Drop Table if exists Unternehmen;
Drop Table if exists Besitzer;
Drop Table if exists Haustier;

GO

CREATE TABLE Haustier (
    ID      INT           NOT NULL,
    Name    VARCHAR(100)  NOT NULL,
    Jahre   INT           NOT NULL,
    CONSTRAINT pk_haustier PRIMARY KEY (id)
);

GO

CREATE TABLE Besitzer (
    SVNR     CHAR(10)      NOT NULL,
    Wohnort  NVARCHAR(100) NOT NULL,
    CONSTRAINT pk_besitzer PRIMARY KEY (SVNR)
);

GO

CREATE TABLE Unternehmen (
    Name     VARCHAR(100)   NOT NULL,
    Adresse  VARCHAR(200)   NULL,
    Umsatz   NUMERIC(14,2)  NULL,
    CONSTRAINT pk_unternehmen PRIMARY KEY (Name)
);

GO

CREATE TABLE Tour (
    Start  VARCHAR(100) NOT NULL,
    Ende   VARCHAR(100) NOT NULL,
    CONSTRAINT pk_tour PRIMARY KEY (Start, Ende)
);

GO

CREATE TABLE Hund (
    ID          INT NOT NULL,
    Hundejahre  INT NULL,
    CONSTRAINT pk_hund PRIMARY KEY (ID),
    CONSTRAINT fk_hund_haustier FOREIGN KEY (ID) REFERENCES Haustier (ID)
);

GO

CREATE TABLE Katze (
    ID     INT NOT NULL,
    Leben  INT NULL,
    CONSTRAINT pk_katze PRIMARY KEY (ID),
    CONSTRAINT fk_katze_haustier FOREIGN KEY (ID) REFERENCES Haustier (ID)
);

GO

CREATE TABLE Wasserschwein (
    ID        INT NOT NULL,
    Charisma  INT NULL,
    CONSTRAINT pk_wasserschwein PRIMARY KEY (ID),
    CONSTRAINT fk_wasserschwein_haustier FOREIGN KEY (ID) REFERENCES Haustier (ID)
);

GO

CREATE TABLE Etappe (
    Start   VARCHAR(100) NOT NULL,
    Ende    VARCHAR(100) NOT NULL,
    Nummer  INT           NOT NULL,
    CONSTRAINT pk_etappe PRIMARY KEY (Start, Ende, Nummer),
    CONSTRAINT fk_etappe_tour FOREIGN KEY (Start, Ende) REFERENCES Tour (Start, Ende)
);

GO

CREATE TABLE Pfleger (
    Unternehmen  VARCHAR(100)  NOT NULL,
    Nummer       INT            NOT NULL,
    Lohn         NUMERIC(10,2)  NULL,
    CONSTRAINT pk_pfleger PRIMARY KEY (Unternehmen, Nummer),
    CONSTRAINT fk_pfleger_in_unternehmen FOREIGN KEY (Unternehmen) REFERENCES Unternehmen (Name)
);

GO

CREATE TABLE kundevon (
    Kunde        CHAR(10)      NOT NULL,
    Unternehmen  VARCHAR(100)  NOT NULL,
    Gebuehr      NUMERIC(10,2) NULL,
    CONSTRAINT pk_kundevon PRIMARY KEY (Kunde, Unternehmen),
    CONSTRAINT fk_kundevon_besitzer_in FOREIGN KEY (Kunde) REFERENCES Besitzer (SVNR),
    CONSTRAINT fk_kundevon_unternehmen FOREIGN KEY (Unternehmen) REFERENCES Unternehmen (Name)
);

GO

CREATE TABLE angemeldet (
    Besitzer      CHAR(10)  NOT NULL,
    Tier          INT       NOT NULL,
    Laufpromonat  INT       NULL,
    CONSTRAINT pk_angemeldet PRIMARY KEY (Besitzer, Tier),
    CONSTRAINT fk_angemeldet_besitzer FOREIGN KEY (Besitzer) REFERENCES Besitzer (SVNR),
    CONSTRAINT fk_angemeldet_haustier FOREIGN KEY (Tier) REFERENCES Haustier (ID)
);

GO

CREATE TABLE Beziehung (
    Von   INT           NOT NULL,
    Mit   INT           NOT NULL,
    Art   NVARCHAR(50)  NOT NULL,
    CONSTRAINT pk_beziehung PRIMARY KEY (Von, Mit, Art),
    CONSTRAINT fk_beziehung_von FOREIGN KEY (Von) REFERENCES Haustier (ID),
    CONSTRAINT fk_beziehung_mit FOREIGN KEY (Mit) REFERENCES Haustier (ID),
    CONSTRAINT chk_beziehung_nicht_selbst CHECK (Von <> Mit)
);

GO

CREATE TABLE laufen (
    Tier                 INT            NOT NULL,
    Pfleger_unternehmen  VARCHAR(100)  NOT NULL,
    Pfleger_nummer       INT            NOT NULL,
    Tour_start           VARCHAR(100)  NOT NULL,
    Tour_ende            VARCHAR(100)  NOT NULL,
    Datum                DATE           NOT NULL,
    CONSTRAINT pk_laufen PRIMARY KEY (Tier, Pfleger_unternehmen, Pfleger_nummer, Tour_start, Tour_ende, Datum),
    CONSTRAINT fk_laufen_haustier FOREIGN KEY (Tier) REFERENCES Haustier (ID),
    CONSTRAINT fk_laufen_pfleger_in FOREIGN KEY (Pfleger_unternehmen, Pfleger_nummer) REFERENCES Pfleger (Unternehmen, Nummer),
    CONSTRAINT fk_laufen_tour FOREIGN KEY (Tour_start, Tour_ende) REFERENCES Tour (Start, Ende)
);

GO

INSERT INTO Haustier (ID, Name, Jahre) VALUES
 (1, 'Bello', 3),
 (2, 'Rex', 4),
 (3, 'Fiffi', 7),
 (4, 'Minka', 2),
 (5, 'Lucy', 5),
 (6, 'Whiskers', 8),
 (7, 'Carlos', 3),
 (8, 'Pepe', 4),
 (9, 'Nacho', 6),
 (10, 'Bruno', 2),
 (11, 'Mimi', 9),
 (12, 'Rocky', 5),
 (13, 'Chico', 2),
 (14, 'Luna', 3);

GO

INSERT INTO Hund (ID, Hundejahre) VALUES
 (1, 21),
 (2, 28),
 (3, 49),
 (10, 14),
 (12, 35);

GO

INSERT INTO Katze (ID, Leben) VALUES
 (4, 9),
 (5, 7),
 (6, 5),
 (11, 3),
 (14, 8);

GO

INSERT INTO Wasserschwein (ID, Charisma) VALUES
 (7, 9),
 (8, 6),
 (9, 7),
 (13, 10);

GO

INSERT INTO Besitzer (SVNR, Wohnort) VALUES
 ('1234010190', 'Wien'),
 ('2345020285', 'Graz'),
 ('3456030380', 'Linz'),
 ('4567040475', 'Salzburg'),
 ('5678050570', 'Innsbruck'),
 ('6789060665', 'Klagenfurt');

GO

INSERT INTO Unternehmen (Name, Adresse, Umsatz) VALUES
 ('Gassi Wien GmbH', 'Mariahilfer Straße 12, 1060 Wien', 850000.00),
 ('Pfotenglück OG', 'Landstraßer Hauptstraße 45, 1030 Wien', 210000.00);

GO

INSERT INTO Tour (Start, Ende) VALUES
 ('Stadtpark', 'Donaukanal'),
 ('Prater', 'Hauptbahnhof'),
 ('Rathaus', 'Naschmarkt'),
 ('Augarten', 'Nordbahnhof');

GO

INSERT INTO Etappe (Start, Ende, Nummer) VALUES
 ('Stadtpark', 'Donaukanal', 1),
 ('Stadtpark', 'Donaukanal', 2),
 ('Stadtpark', 'Donaukanal', 3),
 ('Stadtpark', 'Donaukanal', 4),
 ('Prater', 'Hauptbahnhof', 1),
 ('Prater', 'Hauptbahnhof', 2),
 ('Prater', 'Hauptbahnhof', 3),
 ('Prater', 'Hauptbahnhof', 4),
 ('Rathaus', 'Naschmarkt', 1),
 ('Rathaus', 'Naschmarkt', 2),
 ('Augarten', 'Nordbahnhof', 1),
 ('Augarten', 'Nordbahnhof', 2),
 ('Augarten', 'Nordbahnhof', 3),
 ('Augarten', 'Nordbahnhof', 4),
 ('Augarten', 'Nordbahnhof', 5);

GO

INSERT INTO Pfleger (Unternehmen, Nummer, Lohn) VALUES
 ('Gassi Wien GmbH', 1, 2100.00),
 ('Gassi Wien GmbH', 2, 2250.00),
 ('Gassi Wien GmbH', 3, 1980.00),
 ('Gassi Wien GmbH', 4, 2400.00),
 ('Gassi Wien GmbH', 5, 2050.00),
 ('Gassi Wien GmbH', 6, 2300.00),
 ('Gassi Wien GmbH', 7, 1900.00),
 ('Gassi Wien GmbH', 8, 2150.00),
 ('Pfotenglück OG', 1, 1850.00),
 ('Pfotenglück OG', 2, 1950.00),
 ('Pfotenglück OG', 3, 2000.00);

GO

INSERT INTO kundevon (Kunde, Unternehmen, Gebuehr) VALUES
 ('1234010190', 'Gassi Wien GmbH', 25.50),
 ('1234010190', 'Pfotenglück OG', 20.00),
 ('2345020285', 'Gassi Wien GmbH', 30.00),
 ('4567040475', 'Pfotenglück OG', 18.50),
 ('5678050570', 'Gassi Wien GmbH', 22.00),
 ('5678050570', 'Pfotenglück OG', 19.90);

GO

INSERT INTO angemeldet (Besitzer, Tier, Laufpromonat) VALUES
 ('1234010190', 1, 8),
 ('1234010190', 2, 10),
 ('1234010190', 4, 12),
 ('2345020285', 3, 6),
 ('2345020285', 5, 4),
 ('3456030380', 6, 5),
 ('4567040475', 7, 9),
 ('4567040475', 8, 7),
 ('5678050570', 9, 11),
 ('5678050570', 10, 6),
 ('5678050570', 11, 8),
 ('6789060665', 12, 4),
 ('6789060665', 13, 9),
 ('6789060665', 14, 10);

GO

INSERT INTO Beziehung (Von, Mit, Art) VALUES
 (1, 2, 'Freund'),
 (1, 4, 'Freund'),
 (1, 7, 'Freund'),
 (1, 10, 'Freund'),
 (2, 1, 'Freund'),
 (3, 5, 'Rivale'),
 (5, 6, 'Freund'),
 (10, 1, 'Freund'),
 (9, 13, 'Freund');

GO

INSERT INTO laufen (Tier, Pfleger_unternehmen, Pfleger_nummer, Tour_start, Tour_ende, Datum) VALUES
 (1, 'Gassi Wien GmbH', 1, 'Stadtpark', 'Donaukanal', '2026-01-05'),
 (1, 'Gassi Wien GmbH', 2, 'Prater', 'Hauptbahnhof', '2026-01-06'),
 (1, 'Pfotenglück OG', 1, 'Rathaus', 'Naschmarkt', '2026-01-07'),
 (1, 'Gassi Wien GmbH', 3, 'Augarten', 'Nordbahnhof', '2026-01-08'),
 (2, 'Gassi Wien GmbH', 1, 'Stadtpark', 'Donaukanal', '2026-01-10'),
 (2, 'Gassi Wien GmbH', 4, 'Prater', 'Hauptbahnhof', '2026-01-11'),
 (3, 'Pfotenglück OG', 2, 'Rathaus', 'Naschmarkt', '2026-01-12'),
 (10, 'Gassi Wien GmbH', 5, 'Augarten', 'Nordbahnhof', '2026-01-13'),
 (10, 'Gassi Wien GmbH', 2, 'Stadtpark', 'Donaukanal', '2026-01-14'),
 (12, 'Pfotenglück OG', 3, 'Prater', 'Hauptbahnhof', '2026-01-15'),
 (4, 'Gassi Wien GmbH', 1, 'Stadtpark', 'Donaukanal', '2026-01-16'),
 (5, 'Gassi Wien GmbH', 6, 'Prater', 'Hauptbahnhof', '2026-01-17'),
 (6, 'Pfotenglück OG', 1, 'Rathaus', 'Naschmarkt', '2026-01-18'),
 (11, 'Gassi Wien GmbH', 7, 'Augarten', 'Nordbahnhof', '2026-01-19'),
 (14, 'Gassi Wien GmbH', 2, 'Stadtpark', 'Donaukanal', '2026-01-20'),
 (4, 'Gassi Wien GmbH', 8, 'Prater', 'Hauptbahnhof', '2026-01-21'),
 (7, 'Gassi Wien GmbH', 1, 'Stadtpark', 'Donaukanal', '2026-01-22'),
 (9, 'Gassi Wien GmbH', 3, 'Stadtpark', 'Donaukanal', '2026-01-23'),
 (13, 'Gassi Wien GmbH', 4, 'Augarten', 'Nordbahnhof', '2026-01-24'),
 (7, 'Pfotenglück OG', 2, 'Rathaus', 'Naschmarkt', '2026-01-25'),
 (9, 'Gassi Wien GmbH', 5, 'Augarten', 'Nordbahnhof', '2026-01-26'),
 (2, 'Pfotenglück OG', 3, 'Rathaus', 'Naschmarkt', '2026-02-01'),
 (5, 'Pfotenglück OG', 1, 'Rathaus', 'Naschmarkt', '2026-02-02'),
 (12, 'Gassi Wien GmbH', 6, 'Prater', 'Hauptbahnhof', '2026-02-03'),
 (6, 'Gassi Wien GmbH', 7, 'Augarten', 'Nordbahnhof', '2026-02-04');

GO
