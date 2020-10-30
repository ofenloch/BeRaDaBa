INSERT INTO `abteilung` (`nr`,`name`)
VALUES
(50000,'Board'),
(50001,'Marketing'),
(50002,'Finance'),
(50003,'Human Resources'),
(50004,'Production'),
(50005,'Research & Development'),
(50006,'Quality Management'),
(50007,'Sales'),
(50008,'Customer Service'),
(50009,'IT'),
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
(50004, 50000), -- Production gehört zu Board
(50005, 50000), -- Research & Development gehört zu Board
(50006, 50000), -- Quality Management gehört zum Board
(50007, 50000), -- Sales gehört zum Board
(50008, 50000), -- Customer Service gehört zum Board
(50009, 50000), -- IT gehört zum Board
(50010, 50000), -- HR Development gehört zu HR
(50011, 50000), -- HR Administration gehört zu HR
(50012, 50007), -- Sales Domestic gehört zu Sales
(50013, 50007), -- Sales EMEA gehört zu Sales
(50014, 50007), -- Sales USA gehört zu Sales
(50015, 50005), -- Research Chemical gehört zu Research & Development
(50016, 50005); -- Technical Programming gehört zu Research & Development
