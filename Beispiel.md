# Das "Leben" eines Mitarbeiters in BeRaDaBa in Form von SQL-Statments

## Einstellung

Der neue Kollege Max Rainer Muster, geboren am 19.05.1998, wird am 01.03.2019 eingestellt (die Probezeit beträgt sechs Monate): 

```sql
mysql> USE beradaba; 
INSERT INTO `mitarbeiter` (`datum_geburt`,`vorname`,`nachname`,`mittelnamen`,`geschlecht`,`datum_eintritt`, `datum_probezeit_ende`) 
VALUES("1998-03-01", "Max", "Muster", "Rainer", 'M', "2019-03-01", "2019-09-01");
```

Der Datensatz des neuen Kollegen sieht so aus:

    mysql> select * from mitarbeiter where nachname="Muster";
    +--------+----+----------+---------+--------------+-------------+------------+----------------+----------------+----------------------+
    | nr     | id | nachname | vorname | datum_geburt | mittelnamen | geschlecht | datum_eintritt | datum_austritt | datum_probezeit_ende |
    +--------+----+----------+---------+--------------+-------------+------------+----------------+----------------+----------------------+
    | 500001 |    | Muster   | Max     | 1998-03-01   | Rainer      | M          | 2019-03-01     | 2222-01-01     | 2019-09-01           |
    +--------+----+----------+---------+--------------+-------------+------------+----------------+----------------+----------------------+
    1 row in set (0.15 sec)

    mysql>


Er arbeitet in der Abteilung "IT":

```sql
INSERT INTO `abteilung_mitarbeiter` (`mitarbeiter_nr`, `abteilung_nr`, `datum_von`)
VALUES (500001, 50009, "2019-03-01");
```

Max Rainer Muster hat das Gleitzeitmodell "GLZ 8":

```sql
INSERT INTO `zeitmodell_mitarbeiter` (`mitarbeiter_nr`, `zeitmodell_nr`, `datum_von`)
VALUES(500001, 8, "2019-03-01");
```

Bezahlt wird er nach Entgeltgruppe "EG 13":

```sql
INSERT INTO `entgeltgruppe_mitarbeiter` (`mitarbeiter_nr`, `entgeltgruppe_nr`, `datum_von`)
VALUES(500001, 13, "2019-03-01");
```

## Korrekturen

Die Personalabteilung hat leider einen Fehler gemacht: Die Probezeit von sechs Monaten endet am 30.09.2019 und nicht am 01.09.2019:

```sql
UPDATE `mitarbeiter` SET `datum_probezeit_ende`="2019-09-30" WHERE nr=500001;
```
Wenn wir beim Datum übrigens etwas Unsinniges eingeben, etwa den 31. September, verweigert die Datenbank das UPDATE mit einer Fehlermeldung:

    mysql> UPDATE `mitarbeiter` SET `datum_probezeit_ende`="2019-09-31" WHERE nr=500001;
    ERROR 1292 (22007): Incorrect date value: '2019-09-31' for column 'datum_probezeit_ende' at row 1
    mysql>

## Umgruppierung

Gute Nachrichten: Zum Ende der Probezeit bekommt Max Muster mehr Geld. Er wird von "EG 13" nach "EG 14" hochgruppiert. Dazu müssen zwei Dinge gemacht werden:

* Die alte Entegeltgruppe bekommt das entsprechende Enddatum
* Die neue Entgeltgruppe wird (mit offenem Enddatum) eingetragen

```sql
UPDATE `entgeltgruppe_mitarbeiter` SET `datum_bis`="2019-09-30" WHERE mitarbeiter_nr=500001 AND entgeltgruppe_nr=13;
```

```sql
INSERT INTO `entgeltgruppe_mitarbeiter` (`mitarbeiter_nr`, `entgeltgruppe_nr`, `datum_von`)
VALUES(500001, 14, "2019-10-01");
```

Wenn wir das richtig gemacht haben, sollte das Ergebnis so aussehen:

    mysql> select * from entgeltgruppe_mitarbeiter where mitarbeiter_nr=500001;
    +----------------+------------------+------------+------------+
    | mitarbeiter_nr | entgeltgruppe_nr | datum_von  | datum_bis  |
    +----------------+------------------+------------+------------+
    |         500001 |               13 | 2019-03-01 | 2019-09-30 |
    |         500001 |               14 | 2019-10-01 | 9999-12-31 |
    +----------------+------------------+------------+------------+
    2 rows in set (0.00 sec)

    mysql>

## Versetzung

Der neue Kollege Max Muster soll zum 01.02.2020 von der IT-Abteilung in die Abteilung 
"Technical Programming" versetzt werden. Auch in diesem Fall müssen zwei Dinge in die 
Datenbank eingetragen werden:

* Die alte Abteilung des Kollegen bekommt das entsprechende Enddatum
* Die neue Abteiulung des Kollegen wird (mit offenem Enddatum) eingetragen

```sql
UPDATE `abteilung_mitarbeiter` SET `datum_bis`="2020-01-31" WHERE mitarbeiter_nr=500001 AND abteilung_nr=50009;
```

```sql
INSERT INTO `abteilung_mitarbeiter` (`mitarbeiter_nr`, `abteilung_nr`, `datum_von`)
VALUES(500001, 50016, "2020-02-01");
```