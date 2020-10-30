INSERT INTO `abteilung` (`abteilung_nr`,`abteilung_name`)
VALUES
(50000,'Board'),
(50001,'Marketing'),
(50002,'Finance'),
(50003,'Human Resources'),
(50004,'Production'),
(50005,'Development'),
(50006,'Quality Management'),
(50007,'Sales'),
(50008,'Research'),
(50009,'Customer Service'),
(50010,'HR Development'),
(50011,'HR Administration'),
(50012,'Sales Domestic'),
(50013,'Sales EMEA'),
(50014,'Sales USA'),
(50015,'Research Chemical'),
(50016,'Technical Programming');

INSERT INTO `abteilung_unterabteilung` (`unterabteilung_nr`,`abteilung_nr`)
VALUES
(50001, 50000), -- Marketing gehört zu Board
(50002, 50000), -- Finance gehört zu Board
(50003, 50000), -- HR gehört zu Board
(50010, 50000), -- HR Development gehört zu HR
(50011, 50000); -- HR Administration gehört zu HR
