

DROP TABLE lt
go
DROP TABLE l
go
DROP TABLE t
go

---------------------------------------------------------
-- Tabelle der Lieferanten
---------------------------------------------------------
CREATE TABLE l (
       lnr    CHAR(2) PRIMARY KEY,
       lname  VARCHAR(6),
       rabatt DECIMAL(2),
       stadt  VARCHAR(6))
go

---------------------------------------------------------
-- Tabelle der Teile
---------------------------------------------------------
CREATE TABLE t (
       tnr    CHAR(2) PRIMARY KEY,
       tname  VARCHAR(8),
       farbe  VARCHAR(5),
       preis  DECIMAL(10,2),
       stadt  VARCHAR(6))
go

---------------------------------------------------------
-- Tabelle der Lieferungen
---------------------------------------------------------
CREATE TABLE lt (
       lnr    CHAR(2) REFERENCES l,
       tnr    CHAR(2) REFERENCES t,
       menge  DECIMAL(4),
       PRIMARY KEY (lnr,tnr))
go

INSERT INTO l VALUES ('L1','Schmid',20,'London')
INSERT INTO l VALUES ('L2','Jonas', 10,'Paris' )
INSERT INTO l VALUES ('L3','Berger',30,'Paris' )
INSERT INTO l VALUES ('L4','Klein', 20,'London')
INSERT INTO l VALUES ('L5','Adam',  30,'Athen' )
go
INSERT INTO t VALUES ('T1','Mutter',  'rot',  12,'London')
INSERT INTO t VALUES ('T2','Bolzen',  'gelb', 17,'Paris' )
INSERT INTO t VALUES ('T3','Schraube','blau', 17,'Rom'   )
INSERT INTO t VALUES ('T4','Schraube','rot',  14,'London')
INSERT INTO t VALUES ('T5','Welle',   'blau', 12,'Paris' )
INSERT INTO t VALUES ('T6','Zahnrad', 'rot',  19,'London')
go
INSERT INTO lt VALUES ('L1','T1',300)
INSERT INTO lt VALUES ('L1','T2',200)
INSERT INTO lt VALUES ('L1','T3',400)
INSERT INTO lt VALUES ('L1','T4',200)
INSERT INTO lt VALUES ('L1','T5',100)
INSERT INTO lt VALUES ('L1','T6',100)
INSERT INTO lt VALUES ('L2','T1',300)
INSERT INTO lt VALUES ('L2','T2',400)
INSERT INTO lt VALUES ('L3','T2',200)
INSERT INTO lt VALUES ('L4','T2',200)
INSERT INTO lt VALUES ('L4','T4',300)
INSERT INTO lt VALUES ('L4','T5',400)
go

select * from l;
select * from t;
select * from lt;

--------------------------------------------------------------
--------------------------------------------------------------
-- Die Verwendung von IF 
-- Wenn die Anzahl der Teile am Lager 'L1' größer als 10 ist, dann Meldung ausgeben,
-- sonst von jedem Teil am Lager 'L1' Name des Teils, Farbe, Menge ausgeben

 

--------------------------------------------------------------
--------------------------------------------------------------
-- Die while Anweisung
-- Solange die Summe der Menge aller Artikel im Lager kleiner als 10000 ist,
-- soll die Menge um 10 % erhöht werden. 
-- Wenn jedoch der Maximalwert der Menge eines Teiles größer als 500 ist,
-- soll abgebrochen werden


-- Variante 1 (mit If und break)
 

-- Variante 2
 

----------------------------------------------------------
----------------------------------------------------------
-- Lokale Variablen
-- 'Durchschnitt' und 'Grenze' sind zwei Variablen
-- 'Grenze' hat den fixen Wert 300
-- 'Durchschnitt' von Menge in Tabelle lt
-- Falls die Maximalmenge eines Artikels im Lager 'L1' größer als 'Grenze' ist,
-- soll die Menge vom 'L1'im Lager um den Durchschnitt erhöht werden.


--------------------------
-- BEURTEILUNGSRELEVANT --
--------------------------





-------------------------------------------------------
-------------------------------------------------------
-- Stored Procedure 1
-- die Mengen der Tabelle lt sollen um einen mitübergebenen Prozentwert erhöht werden
-- anlegen:



---------------------------------------------------------
---------------------------------------------------------
-- stored Procedure 2
-- es soll der übergebene Artikel aus lt gelöscht werden und die mengen der restlichen artikel
-- um 5 % erhöht werden. - verschachtelter prozeduraufruf
-- anlegen:





-------------------------------------------------------------
-- Erstellen Sie eine Prozedur del_l (lnr) mit Output-Parameter:
-- Zeile aus L löschen; dabei eventuell vorher entsprechende Zeilen aus lt löschen;
-- zurückgeben, wie viele Zeilen aus lt gelöscht werden mußten


--------------------------
-- BEURTEILUNGSRELEVANT --
--------------------------


-----------------------------------------------------------------
-- Erstellen Sie eine Prozedur clear_lt(m) returning
-- Solange die Summe der Mengen in lt größer als m ist, die Lieferung mit der jeweils niedrigsten Menge
-- löschen; zurückgeben, wie viele Lieferungen gelöscht wurden; keine rekursive Lösung einsetzen
------------------------------------



--------------------------
-- BEURTEILUNGSRELEVANT --
--------------------------