--  
-- BeRaDaBa - Die Betriebsrat-Datenbank
--


-- Zuerst löschen wir die Datenbank beradaba, falls es sie schon gibt:
SELECT '*** Lösche eventuell vorhandene Datenbank beradaba ...' as 'INFO:';
DROP DATABASE IF EXISTS beradaba;
-- Jetzt legen wir die Datenbank beradaba neu an:
SELECT '*** Erzeuge Datenbank beradaba ...' as 'INFO:';
CREATE DATABASE IF NOT EXISTS beradaba;
USE beradaba;

-- Wir definieren ein paar nützliche Variablen:
set @unknown_date_of_birth='1900-01-01';
set @unknown_date_of_hiring='1920-01-01';
set @unknown_date_of_terminate='2222-01-01';
set @unknown_date_of_probation_end='1920-07-01';
set @begin_of_all_times='1000-01-01';
set @end_of_all_times='9999-12-31';

SELECT '*** Erzeuge Struktur der Datenbank ...' as 'INFO:';

/*!50503 set default_storage_engine = InnoDB */;
/*!50503 select CONCAT('storage engine: ', @@default_storage_engine) as INFO */;

--
-- Die Tabelle 'mitarbeiter' ist das Kernstück unserer Datenbank: Die Liste der Mitarbeiter.
-- 
-- Jeder MA hat eine ein-eindeutige interne Nummer.
-- Jeder MA hat eine beliebige ID, die allerdings einzigartig sein sollte.
-- Jeder MA hat einen Nachnamen.
-- Jeder MA hat einen Vornamen.
-- Jeder MA hat ein Geburtsdatum.
-- Jeder MA kann keinen, einen oder mehrer mittlere Namen haben, z.B. "Hans Walter Max Schmidt" oder "Christian Braun".
-- Jeder MA hat ein Geschlecht, entwder D für divers, M für männlich oder W für weiblich (bei Bedarf kann das natürlich erweitert werden).
-- Jeder MA hat ein Datum, zu dem er in die Firma eintritt (kann auch in der Zukunft liegen).
-- Jeder MA hat ein Datum, zu dem er aus Firma ausscheidet (liegt hoffentlich in der fernen Zukunft).
-- Jeder MA hat ein Datum, an dem seine Probezeit zu Ende geht.
--
CREATE TABLE mitarbeiter (
    nr                    INT                  NOT NULL AUTO_INCREMENT COMMENT 'interne numerische ID, wird als PRIMARY KEY verwendet',
    id                    VARCHAR(64)          NOT NULL DEFAULT '' COMMENT 'beliebige ID, z.B. ETWeb-54321-GEWI, sollte einzigartig sein',
    nachname              VARCHAR(128)         NOT NULL COMMENT 'Der Nachname des Mitarbeiters',
    vorname               VARCHAR(128)         NOT NULL COMMENT 'Der Vorname des Mitarbeiters',
    datum_geburt          DATE                 NOT NULL DEFAULT '1900-01-01' COMMENT 'Geburtsdatum des Mitarbeiters in der Form JJJJ-MM-TT, zb. 1966-02-09 für den 9. Februar 1966',
    mittelnamen           VARCHAR(128)         NOT NULL DEFAULT '' COMMENT 'Der oder die mittleren Namen des Mitarbeiters',
    geschlecht            ENUM ('D','M','W')   NOT NULL DEFAULT 'D' COMMENT 'Das Geschlecht des Mitarbeiters Divers, Männlich oder Weiblich',
    datum_eintritt        DATE                 NOT NULL DEFAULT '1920-01-01' COMMENT 'Das Datum des Eintritts in die Firma in der Form JJJJ-MM-TT, zb. 1986-09-02 für den 2. September 1986',
    datum_austritt        DATE                 NOT NULL DEFAULT '2222-01-01' COMMENT 'Das Datum des Austritts aus der Firma in der Form JJJJ-MM-TT, zb. 2035-10-12 für den 12. Oktober 2035',
    datum_probezeit_ende  DATE                 NOT NULL DEFAULT '1920-07-01' COMMENT 'Das Datum, an dem die Probezeit endet',
    PRIMARY KEY (nr)
) COMMENT 'Liste der Mitarbeiter';
--
-- Wir könnten hier noch weitere Felder hinzufügen, (z.B. Stadt, PLZ, Strasse, Hausnummer, Telefonnummer, etc.). Für die BR-Arbeit 
-- brauchen wir die aber (wahrscheinlich) nicht. Außerdem ist es fraglich, ob wir beispielsweise vom Umzug eines Kollegen erfahren.
-- Ähnliches gilt für den Familienstand oder die Zahl der Kinder und ihr Alter, Mitgleidsachaft in Vereinen, Parteien, ...
-- Für die Personalabteilung sind solche Daten sicherlich interessant, weil man sie einerseits für die Gehaltsabrechnung etc. benötigt 
-- und andererseits daraus Rückschlüsse auf die "Anhänglichkleit" des MAs ziehen kann.
--

--
-- Tabelle mit den Abteilungen der Firma
--
-- Jede Abteilung hat eine ein-eindeutige interne Nummer.
-- Jede Abteilung hat einen beliebigen Namen, der allerdings einzigartig sein sollte.
CREATE TABLE abteilung (
    nr                   INT                  NOT NULL AUTO_INCREMENT COMMENT 'interne numerische ID, wird als PRIMARY KEY verwendet',
    name                 VARCHAR(40)          NOT NULL DEFAULT '' COMMENT 'beliebige ID, z.B. LPT-12.5.4.7, sollte einzigartig sein',
    PRIMARY KEY (nr),
    UNIQUE  KEY (name)
) COMMENT 'Liste der Abteilungen';

--
-- Tabelle mit der Zuordnung Abteilung / Abteilungsleiter
--
-- Der Abteilungsleiter ist in der Regel ein MA und hat eine MA-Nummer.
-- Jede Abteilung hat eine ein-eindeutige interne Nummer.
-- Der Abteilungsleiter ist im Zeitraum datum_von bis datum_bis Leiter der Abteilung.
--
CREATE TABLE abteilung_leiter (
   mitarbeiter_nr         INT                  NOT NULL REFERENCES mitarbeiter(nr),
   abteilung_nr           INT                  NOT NULL REFERENCES abteilung(nr),
   datum_von              DATE                 NOT NULL DEFAULT '1000-01-01',
   datum_bis              DATE                 NOT NULL DEFAULT '9999-12-31',
   FOREIGN KEY (mitarbeiter_nr)                REFERENCES mitarbeiter(nr) ON DELETE CASCADE,
   FOREIGN KEY (abteilung_nr)                  REFERENCES abteilung(nr) ON DELETE CASCADE,
   PRIMARY KEY (mitarbeiter_nr, abteilung_nr, datum_von)
) COMMENT 'Zuordnung Abteilung / Abteilungsleiter';

--
-- Tabelle mit der Zuordnung Abteilung / Mitarbeiter
--
-- Der Mitarbeiter hat eine MA-Nummer.
-- Jede Abteilung hat eine ein-eindeutige interne Nummer.
-- Der MA ist im Zeitraum datum_von bis datum_bis Mitglied der Abteilung.
--
CREATE TABLE abteilung_mitarbeiter (
   mitarbeiter_nr         INT                  NOT NULL REFERENCES mitarbeiter(nr),
   abteilung_nr           INT                  NOT NULL REFERENCES abteilung(nr),
   datum_von              DATE                 NOT NULL DEFAULT '1000-01-01',
   datum_bis              DATE                 NOT NULL DEFAULT '9999-12-31',
   FOREIGN KEY (mitarbeiter_nr)                REFERENCES mitarbeiter(nr) ON DELETE CASCADE,
   FOREIGN KEY (abteilung_nr)                  REFERENCES abteilung(nr) ON DELETE CASCADE,
   PRIMARY KEY (mitarbeiter_nr, abteilung_nr, datum_von)
) COMMENT 'Zuordnung Abteilung / Mitarbeiter';

--
-- Tabelle der Unterabteilungen (Organigramm der Firma)
--
-- Fast alle Abteilungen gehören zu einer anderen Abteilung
-- Eine Abteilung kann nur zu einer übergeordneten Abteilung gehören
-- Zu einer Abteilung können keine, eine, zwei oder mehr Abteilungen gehören
--
-- (Hat eine Abteilung mit nur einer Unterabteilung Sinn?)
-- (Sollte man das Organigramm über die Abteilungsleiter abhandeln, oder ist das zu kompliziert?)
-- 
CREATE TABLE abteilung_unterabteilung (
   unterabteilung_nr      INT                  NOT NULL REFERENCES abteilung(nr),
   abteilung_nr           INT                  NOT NULL REFERENCES abteilung(nr),
   datum_von              DATE                 NOT NULL DEFAULT '1000-01-01',
   datum_bis              DATE                 NOT NULL DEFAULT '9999-12-31',
   FOREIGN KEY (unterabteilung_nr)             REFERENCES abteilung(nr) ON DELETE CASCADE,
   FOREIGN KEY (abteilung_nr)                  REFERENCES abteilung(nr) ON DELETE CASCADE,
   PRIMARY KEY (unterabteilung_nr, abteilung_nr, datum_von)
) COMMENT 'Zuordnung Abteilung / (Unter-)Abteilung';


--
-- Tabelle mit Entgeltgruppen
-- 
CREATE TABLE entgeltgruppe (
    nr          INT                  NOT NULL AUTO_INCREMENT COMMENT 'interne numerische ID, wird als PRIMARY KEY verwendet',
    name        VARCHAR(40)          NOT NULL DEFAULT '' COMMENT 'beliebige ID, z.B. EG13, sollte einzigartig sein',
    PRIMARY KEY (nr),
    UNIQUE  KEY (name)
) COMMENT 'Liste der Entgeltgruppen';

--
-- Tabelle mit der Zuordnung Entgeltgruppe / Mitarbeiter
--
-- Der Mitarbeiter hat eine MA-Nummer.
-- Jedem MA ist eine Entgeltgruppe zugeordnet.
-- Der MA ist im Zeitraum datum_von bis datum_bis in der Entgeltgruppe
--
CREATE TABLE entgeltgruppe_mitarbeiter (
   mitarbeiter_nr         INT                  NOT NULL REFERENCES mitarbeiter(nr),
   entgeltgruppe_nr       INT                  NOT NULL REFERENCES entgeltgruppe(nr),
   datum_von              DATE                 NOT NULL DEFAULT '1000-01-01',
   datum_bis              DATE                 NOT NULL DEFAULT '9999-12-31',
   FOREIGN KEY (mitarbeiter_nr)                REFERENCES mitarbeiter(nr) ON DELETE CASCADE,
   FOREIGN KEY (entgeltgruppe_nr)              REFERENCES entgeltgruppe(nr) ON DELETE CASCADE,
   PRIMARY KEY (mitarbeiter_nr, entgeltgruppe_nr, datum_von)
) COMMENT 'Zuordnung Entgeltgruppe / Mitarbeiter';

--
-- Tabelle mit (Gleit-)Zeitmodellen
-- 
CREATE TABLE zeitmodell (
    nr            INT                  NOT NULL AUTO_INCREMENT COMMENT 'interne numerische ID, wird als PRIMARY KEY verwendet',
    name          VARCHAR(40)          NOT NULL DEFAULT '' COMMENT 'beliebige ID, z.B. GLZ35, sollte einzigartig sein',
    wochenstunden FLOAT                NOT NULL DEFAULT 35.0 COMMENT 'wöchentliche Arbeitszeit',
    PRIMARY KEY (nr),
    UNIQUE  KEY (name)
) COMMENT 'Liste der Abteilungen';

--
-- Tabelle mit der Zuordnung Zeitmodell / Mitarbeiter
--
-- Der Mitarbeiter hat eine MA-Nummer.
-- Jedem MA ist ein Zeitmodell zugeordnet.
-- Der MA ist im Zeitraum datum_von bis datum_bis im Zeitmodell
--
CREATE TABLE zeitmodell_mitarbeiter (
   mitarbeiter_nr         INT                  NOT NULL REFERENCES mitarbeiter(nr),
   zeitmodell_nr          INT                  NOT NULL REFERENCES zeitmodell(nr),
   datum_von              DATE                 NOT NULL DEFAULT '1000-01-01',
   datum_bis              DATE                 NOT NULL DEFAULT '9999-12-31',
   FOREIGN KEY (mitarbeiter_nr)                REFERENCES mitarbeiter(nr) ON DELETE CASCADE,
   FOREIGN KEY (zeitmodell_nr)                 REFERENCES zeitmodell(nr) ON DELETE CASCADE,
   PRIMARY KEY (mitarbeiter_nr, zeitmodell_nr, datum_von)
) COMMENT 'Zuordnung Zeitmodell / Mitarbeiter';



--
-- Jetzt laden wir ein paar Daten in die neu angelegte Datenbank
--
SELECT '*** Lade Daten der Mitarbeiter ...' as 'INFO:';
source mysql/daten_mitarbeiter.sql ;
SELECT CONCAT('    ', COUNT(*), ' Mitarbeiter') as 'INFO:' FROM mitarbeiter;

SELECT '*** Lade Abteilungen ...' as 'INFO:';
source mysql/daten_abteilungen.sql ;
SELECT CONCAT('    ', COUNT(*), ' Abteilungen') as 'INFO:' FROM abteilung;

SELECT '*** Lade Entgeltgruppen ...' as 'INFO:';
source mysql/daten_entgeltgruppen.sql ;
SELECT CONCAT('    ', COUNT(*), ' Entgeltgruppen') as 'INFO:' FROM entgeltgruppe;

SELECT '*** Lade Zeitmodelle ...' as 'INFO:';
source mysql/daten_zeitmodelle.sql ;
SELECT CONCAT('    ', COUNT(*), ' Zeitmodelle') as 'INFO:' FROM zeitmodell;


--
-- Jetzt besetzen wir ein paar Posten in der Firma
-- (erst mal ohne Datum, die Leute haben den Job quasi immer)
--

-- Leiter der Abteilung 'Board' ist der MA mit der Nummer 10100
INSERT INTO `abteilung_leiter` (`mitarbeiter_nr`, `abteilung_nr`)
VALUES (10100, 50000);
-- Der Leiter der Abteilung 'Board' hat ein gutes Gehalt (AT 5)
INSERT INTO `entgeltgruppe_mitarbeiter` (`mitarbeiter_nr`, `entgeltgruppe_nr`)
VALUES (10100, 25);
-- Das Zeitmodell des Abteilungsleiter 'Board'
INSERT INTO `zeitmodell_mitarbeiter` (`mitarbeiter_nr`, `zeitmodell_nr`)
VALUES (10100, 14);

-- MA in der Abteilung 'Board'
INSERT INTO `abteilung_mitarbeiter` (`mitarbeiter_nr`, `abteilung_nr`)
VALUES
(10101, 50000),
(10102, 50000),
(10103, 50000),
(10104, 50000);
-- Entgeltgruppen der MA in der Abteilung 'Board'
INSERT INTO `entgeltgruppe_mitarbeiter` (`mitarbeiter_nr`, `entgeltgruppe_nr`)
VALUES 
(10101, 24),
(10102, 24),
(10103, 24),
(10104, 24);
-- Zeitmodelle der MA in der Abteilung 'Board'
INSERT INTO `zeitmodell_mitarbeiter` (`mitarbeiter_nr`, `zeitmodell_nr`)
VALUES 
(10101, 13),
(10102, 13),
(10103, 13),
(10104, 13);

-- Leiter der Abteilung 'Marketing' ist der MA mit der Nummer 15200
INSERT INTO `abteilung_leiter` (`mitarbeiter_nr`, `abteilung_nr`)
VALUES (15200, 50001);
-- Leiter der Abteilung 'Finance' ist der MA mit der Nummer 15300
INSERT INTO `abteilung_leiter` (`mitarbeiter_nr`, `abteilung_nr`)
VALUES (15300, 50002);
-- Leiter der Abteilung 'Human Resources' ist der MA mit der Nummer 15400
INSERT INTO `abteilung_leiter` (`mitarbeiter_nr`, `abteilung_nr`)
VALUES (15400, 50003);
-- Leiter der Abteilung 'Production' ist der MA mit der Nummer 15500
INSERT INTO `abteilung_leiter` (`mitarbeiter_nr`, `abteilung_nr`)
VALUES (15500, 50004);

-- MA der Abteilung 'Marketing'
INSERT INTO `abteilung_mitarbeiter` (`mitarbeiter_nr`, `abteilung_nr`)
VALUES
(15201, 50001),
(15202, 50001),
(15203, 50001),
(15204, 50001),
(15205, 50001);
-- Entgeltgruppen der MA in der Abteilung 'Marketing'
INSERT INTO `entgeltgruppe_mitarbeiter` (`mitarbeiter_nr`, `entgeltgruppe_nr`)
VALUES 
(15201, 24),
(15202, 24),
(15203, 24),
(15204, 24);

-- Zeitmodelle der MA in der Abteilung 'Marketing'
INSERT INTO `zeitmodell_mitarbeiter` (`mitarbeiter_nr`, `zeitmodell_nr`)
VALUES 
(15201, 13),
(15202, 13),
(15203, 13),
(15204, 13);

-- MA der Abteilung 'Finance'
INSERT INTO `abteilung_mitarbeiter` (`mitarbeiter_nr`, `abteilung_nr`)
VALUES
(15301, 50002),
(15302, 50002),
(15303, 50002),
(15304, 50002),
(15305, 50002),
(15306, 50002);