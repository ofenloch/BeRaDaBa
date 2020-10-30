# BeRaDaBa - Die **Be**triebs**ra**t-**Da**ten**Ba**nk

## Was ist das?

**BeRaDaBa** ist ein Werkzeug für Betriebs- und Personalräte, mit dem 
man - unabhängig von der Personalabteilung - eine Datenbank mit den 
wichtigsten Informationen für die Betriebsratsarbeit aufbauen kann.

Das Herz der **BeRaDaBa** ist eine mysql-Datenbank. Sie enthält alle Daten, die verwendet werden.

In (einer hoffentlich nicht allzu fernen) Zukunft wird es auch eine nette Benutzeroberfläche dazu geben ...


## "Installation"

Mit dem SQL-Scrip **mysql/erzeuge_db.sql** wird die Datenbank angelegt:

```bash
mysql `cat .beradaba` < mysql/erzeuge_db.sql
```

In der Datei **.beradaba** müssen BENUTZERNAME und PASSWORT für den Benutzer der Datenbank in der Form

     -pBENUTZERNAME -uPASSWORT

stehen.

## Einrichten des SQL-Servers

```sql
mysql> CREATE USER 'BENUTZERNAME'@'localhost' IDENTIFIED BY 'PASSWORT';
Query OK, 0 rows affected (0.04 sec)

mysql> GRANT ALL PRIVILEGES ON DATENBANKNAME.* TO 'BENUTZERNAME'@'localhost' WITH GRANT OPTION;
Query OK, 0 rows affected (0.00 sec)

mysql> 
```
## Abfragen

### Liste der Abteilungsleiter

```sql
select
	abt.name as AbtName,
	abt.nr as AbtNr,
	ma.nachname as LeiterName,
	ma.vorname as LeiterVorname,
	ma.mittelnamen as LeiterMittelnamen,
	ma.nr as LeiterNr
from
	beradaba.abteilung as abt,
	beradaba.mitarbeiter as ma,
	beradaba.abteilung_leiter as al
where
	al.mitarbeiter_nr = ma.nr
	and al.abteilung_nr = abt.nr;
```

### Liste der MA einer Abteilung

```sql
select
	ma.nachname as MAName,
	ma.vorname as MAVorname,
	ma.mittelnamen as MAMittelnamen,
	ma.nr as MANr,
	abt.name as AbtName,
	abt.nr as AbtNr
from
	beradaba.mitarbeiter as ma,
	beradaba.abteilung as abt,
	beradaba.abteilung_mitarbeiter am
where
	ma.nr = am.mitarbeiter_nr
	and abt.nr = am.abteilung_nr
	and abt.nr = 50002;
```