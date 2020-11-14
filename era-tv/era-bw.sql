--  
-- BeRaDaBa - Die Betriebsrat-Datenbank
-- erabw - Die ERA-DB für Baden-Württemberg 
--


-- Zuerst löschen wir die Datenbank erabw, falls es sie schon gibt:
SELECT '*** Lösche eventuell vorhandene Datenbank erabw ...' as 'INFO:';
DROP DATABASE IF EXISTS erabw;
-- Jetzt legen wir die Datenbank erabw neu an:
SELECT '*** Erzeuge Datenbank erabw ...' as 'INFO:';
CREATE DATABASE IF NOT EXISTS erabw;
USE erabw;


--
-- Tabelle mit Entgeltgruppen
-- 
CREATE TABLE entgeltgruppe (
    nr          INT                  NOT NULL AUTO_INCREMENT COMMENT 'interne numerische ID, wird als PRIMARY KEY verwendet',
    name        VARCHAR(40)          NOT NULL DEFAULT '' COMMENT 'beliebige ID, z.B. EG13, sollte einzigartig sein',
    punkte_von  INT                  NOT NULL DEFAULT 1000 COMMENT 'untere Punktezahl',
    punkte_bis  INT                  NOT NULL DEFAULT 1000 COMMENT 'obere Punktezahl',
    PRIMARY KEY (nr),
    UNIQUE  KEY (name)
) COMMENT 'Liste der Entgeltgruppen';

INSERT INTO `entgeltgruppe` (`nr`, `name`, `punkte_von`, `punkte_bis`)
VALUES
(1, "EG 1" , 6 , 6) ,
(2, "EG 2" , 7 , 8) ,
(3, "EG 3" , 9 , 11) ,
(4, "EG 4" , 12 , 14) ,
(5, "EG 5" , 15 , 18) ,
(6, "EG 6" , 19 , 22) ,
(7, "EG 7" , 23 , 26) ,
(8, "EG 8" , 27 , 30) ,
(9, "EG 9" , 31 , 34) ,
(10, "EG 10" , 35 , 38) ,
(11, "EG 11" , 39 , 42) ,
(12, "EG 12" , 43 , 46) ,
(13, "EG 13" , 47 , 50) ,
(14, "EG 14" , 51 , 54) ,
(15, "EG 15" , 55 , 58) ,
(16, "EG 16" , 59 , 63) ,
(17, "EG 17" , 64 , 94) ,
(18, "EG 18" , 95 , 10000) COMMENT 'Definition der Entgelgruppen und ihrer Punktzahlen';

--
-- Tabelle mit (tariflichen) Niveaubeispielen
--
CREATE TABLE niveaubeispiel (
    nr                       INT                  NOT NULL AUTO_INCREMENT COMMENT 'interne numerische ID, wird als PRIMARY KEY verwendet',
    Organisationsschlüssel   VARCHAR(40)          NOT NULL DEFAULT '' COMMENT 'beliebige ID, z.B. 02.03.01.15, sollte einzigartig sein',
    Beschreibung             VARCHAR(256)         NOT NULL DEFAULT '' COMMENT 'Beschreibung des NivBsp, z.B. "Softwareentwickler/-in 1 Entwickeln und Einführen von Software"',
    Anlernen_Ausbildung      VARCHAR(8)           NOT NULL DEFAULT '' COMMENT 'Stufe Anlernen/Ausbildung, z.B. "B 5"',
    Erfahrung                VARCHAR(8)           NOT NULL DEFAULT '' COMMENT 'Stufe Erfahrung, z.B. "E 3"',
    Denken                   VARCHAR(8)           NOT NULL DEFAULT '' COMMENT 'Stufe Anlernen/Ausbildung, z.B. "B 5"',
    Handlungsspielraum       VARCHAR(8)           NOT NULL DEFAULT '' COMMENT 'Stufe Anlernen/Ausbildung, z.B. "B 5"',
    Kommunikation            VARCHAR(8)           NOT NULL DEFAULT '' COMMENT 'Stufe Anlernen/Ausbildung, z.B. "B 5"',
    Führung                  VARCHAR(8)           NOT NULL DEFAULT '' COMMENT 'Stufe Anlernen/Ausbildung, z.B. "B 5"',
    Punkte                   INT                  NOT NULL COMMENT 'Gesamtpunktzahl de NivBsp, daraus ergibt sich die Entgeltgruppe',
    Entgeltgruppe            INT                  NOT NULL,
    tariflich                BOOLEAN              NOT NULL DEFAULT TRUE COMMENT 'TRUE: tarfiliches NivBsp oder FALSE: firmenweites NivBsp',
    PRIMARY KEY (nr),
    UNIQUE  KEY (Organisationsschlüssel),
    FOREIGN KEY (Entgeltgruppe)                   REFERENCES entgeltgruppe(nr) ON DELETE CASCADE
) COMMENT 'Liste der Niveaubeispiele';