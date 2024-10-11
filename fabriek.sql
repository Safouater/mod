DROP TABLE IF EXISTS aankoop CASCADE;
DROP TABLE IF EXISTS transactie CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS filiaal CASCADE;
DROP TABLE IF EXISTS bonuskaart CASCADE;
--aanmaak van tabel bonuskaart
create table bonuskaart(
	bonuskaartnummer INT primary key
	,naam VARCHAR(255) NULL
	,adres VARCHAR(255) NULL
	,woonplaats VARCHAR(255) NULL	
);

--aanmaak van tabel filiaal
create table filiaal(
	filiaalnummer INT primary key
	,plaats VARCHAR(255) NOT NULL
	,adres VARCHAR(255) NOT NULL
);

--aanmaak van tabel transactie
create table Transactie(
	transactienummer INT primary key
	,datum date NOT NULL
	,tijd time NOT NULL
	,bonuskaartnummer INT references bonuskaart(bonuskaartnummer)
	,filiaalnummer INT references filiaal(filiaalnummer)
	
);

--aanmaak van tabel product
create table product(
	productnummer INT primary key
	,omschrijving VARCHAR(255) NOT NULL
	,prijs DECIMAL(6,2) NOT NULL
	
);

--aanmaak van tabel aankoop
create table aankoop(
	transactienummer INT references Transactie(transactienummer)
	,productnummer INT references product(productnummer)
	,aantal INTEGER NOT NULL
);



--bonuskaart
INSERT into bonuskaart VALUES(65472335, NULL, NULL, NULL);
INSERT into bonuskaart values(12345678, 'Annette', 'Vredenburg 12', 'Utrecht');
INSERT into bonuskaart values(98765, 'Jazim', 'Trekkerspad 5', 'Houten');

--filiaal
INSERT INTO filiaal VALUES (35, 'Stationsplein 1', 'Utrecht');
INSERT INTO filiaal VALUES (48, 'Roelantdreef 41', 'Utrecht');
INSERT INTO filiaal VALUES (50, 'Biltstraat 90', 'Utrecht');

--product
INSERT INTO product VALUES (1, 'Pak AH halfvolle melk', 0.99);
INSERT INTO product VALUES (2, 'Pot AH pindakaas', 2.39);
INSERT INTO product VALUES (3, 'Tandenborstel', 1.35);
INSERT INTO product VALUES (4, 'Zak Lays ribbelchips paprika', 1.19);
INSERT INTO product VALUES (5, '2 kg handsinaasappels', 3.45);

--transactie
INSERT INTO transactie VALUES (1, '2019-12-01', '17:35:00', 65472335, 35);
INSERT INTO transactie VALUES (2, '2020-01-03', '12:25:00', 65472335, 48);
INSERT INTO transactie VALUES (3, '2019-12-10', '08:30:00', 12345678, 35);

-- Aankopen voor transactie 1 (Van anonieme bonuskaart op Stationsplein)
INSERT INTO aankoop VALUES (1, 1, 2);  
INSERT INTO aankoop VALUES (1, 2, 1);  
INSERT INTO aankoop VALUES (1, 3, 1); 

-- Aankoop voor transactie 2 (Van anonieme bonuskaart op Roelantdreef)
INSERT INTO aankoop VALUES (2, 1, 1); 

-- Aankoop voor transactie 3 (Van Annette op Stationsplein)
INSERT INTO aankoop VALUES (3, 1, 2); 



--Toon de verschillende filialen (toon filiaalnummer, adres en plaats) waar een klant met bonuskaartnummer 65472335 boodschappen heeft gedaan en op welke datum.
SELECT DISTINCT f.filiaalnummer, f.adres, f.plaats, t.datum
FROM filiaal f
JOIN transactie t ON f.filiaalnummer = t.filiaalnummer
WHERE t.bonuskaartnummer = 65472335;

--Toon het totaalbedrag dat de klant met bonuskaartnummer 65472335 heeft besteed aan boodschappen. Je hoeft dus alleen het totaalbedrag (1 waarde) te tonen, niet wat of wie of wanneer.
SELECT SUM(p.prijs * a.aantal) AS totaalbedrag
FROM transactie t
JOIN aankoop a ON t.transactienummer = a.transactienummer
JOIN product p ON a.productnummer = p.productnummer
WHERE t.bonuskaartnummer = 65472335;

--Toon het aantal maal dat de 'AH halfvolle melk' is verkocht in de maand december 2019 bij een filiaal in Utrecht. Toon dus ook weer 1 waarde (niet in welk filiaal dat was of welk product etc.).
SELECT SUM(a.aantal) AS totaal_verkocht
FROM aankoop a
JOIN transactie t ON a.transactienummer = t.transactienummer
JOIN product p ON a.productnummer = p.productnummer
WHERE p.omschrijving = 'Pak AH halfvolle melk'
AND t.datum BETWEEN '2019-12-01' AND '2019-12-31';