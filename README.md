# BeRaDaBa - Die **Be**triebs**ra**t-**Da**ten**Ba**nk

## Was ist das?

**BeRaDaBa** ist ein Werkzeug für Betriebs- und Personalräte, mit dem 
man - unabhängig von der Personalabteilung - eine Datenbank mit den 
wichtigsten Informationen für die Betriebsratsarbeit aufbauen kann.

Das Herz der **BeRaDaBa** ist eine mysql-Datenbank. Sie enthält alle Daten, die verwendet werden.

In (einer hoffentlich nicht allzu fernen) Zukunft wird es auch eine nette Benutzeroberfläche dazu geben ...


## "Installation"

Mit dem SQL-Scrip **mysql/erzeuge_db.sql** wird die Datenbank angelegt:

``bash
mysql `cat .beradaba` < mysql/erzeuge_db.sql
``

In der Datei **.beradaba** müssen BENUTZERNAME und PASSWORT für den Benutzer der Datenbank stehen:

     -pBENUTZERNAME -uPASSWORT


## Einrichten des SQL-Servers

``sql
mysql> CREATE USER 'BENUTZERNAME'@'localhost' IDENTIFIED BY 'PASSWORT';
Query OK, 0 rows affected (0.04 sec)

mysql> GRANT ALL PRIVILEGES ON DATENBANKNAME.* TO 'BENUTZERNAME'@'localhost' WITH GRANT OPTION;
Query OK, 0 rows affected (0.00 sec)

mysql> 
``