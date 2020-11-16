--
-- Wähle Datenbank beradaba aus.
--

USE beradaba; 


--
-- Einstellung / Anlegen des neuen Kollegen Max Muster
-- (wir verwenden hier eine feste Nummer, damit die Abfragen immer gleich lauten)
-- 
INSERT INTO `mitarbeiter` (`nr`, `datum_geburt`,`vorname`,`nachname`,`mittelnamen`,`geschlecht`,`datum_eintritt`, `datum_probezeit_ende`) 
  VALUES(500001, "1998-03-01", "Max", "Muster", "Rainer", 'M', "2019-03-01", "2019-09-01");

--
--  Dem Kollegen die Abteilung "IT" zuordnen
--
INSERT INTO `abteilung_mitarbeiter` (`mitarbeiter_nr`, `abteilung_nr`, `datum_von`)
  VALUES (500001, 50009, "2019-03-01");

--
-- Dem Kollegen das Gleitzeitmodell "GLZ 8" zuordnen
--
INSERT INTO `zeitmodell_mitarbeiter` (`mitarbeiter_nr`, `zeitmodell_nr`, `datum_von`)
  VALUES(500001, 8, "2019-03-01");

--
-- Dem Kollegen die Entgeltgruppe "EG 13" zuordnen
--
INSERT INTO `entgeltgruppe_mitarbeiter` (`mitarbeiter_nr`, `entgeltgruppe_nr`, `datum_von`)
  VALUES(500001, 13, "2019-03-01");

--
-- Das falsch eigegebene Ende der Probezeit korrigieren
--
UPDATE `mitarbeiter` SET `datum_probezeit_ende`="2019-09-30" 
  WHERE nr=500001;


--
-- Die Höhergruppierung des neuen Kollegen zum 01.10.2019
-- 
-- Schritt 1: das Enddatum der aktuellen Eingruppierung setzen
UPDATE `entgeltgruppe_mitarbeiter` SET `datum_bis`="2019-09-30" 
  WHERE mitarbeiter_nr=500001 AND entgeltgruppe_nr=13;
-- Schritt 2: neue Zuordnung Entgeltgruppe / Mitarbeiter anlegen
INSERT INTO `entgeltgruppe_mitarbeiter` (`mitarbeiter_nr`, `entgeltgruppe_nr`, `datum_von`)
  VALUES(500001, 14, "2019-10-01");

--
-- Die Versetzung des Kollegen in die Abteilung "Technical Programming" zum 01.02.2020
--
-- Schritt 1: das Enddatum der aktuellen Abteilung setzen
UPDATE `abteilung_mitarbeiter` SET `datum_bis`="2020-01-31" 
  WHERE mitarbeiter_nr=500001 AND abteilung_nr=50009;
-- Schritt 2: neue Zuordnung Abteilung / Mitarbeiter anlegen
INSERT INTO `abteilung_mitarbeiter` (`mitarbeiter_nr`, `abteilung_nr`, `datum_von`)
  VALUES(500001, 50016, "2020-02-01");



