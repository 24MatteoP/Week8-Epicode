show databases;
create database w8d4;
use w8d4;

#Descrivi la struttura delle tabelle che reputi utili e sufficienti a modellare lo scenario proposto tramite la sintassi DDL
#Implementa fisicamente le tabelle utilizzando il DBMS SQL Server(o altro).

create table Product (
	IdProduct int primary key unique not null,
    Nome varchar (250),
    IdCategory int,
    Prezzo decimal(4,2)
);

alter table Product
add constraint IdCategory
foreign key (IdCategory) references Category (IdCategory);

create table Category (
	IdCategory int primary key unique not null,
    Nome varchar (100),
    IdProduct int,
    foreign key (IdProduct) references Product (IdProduct)
);

create table RegionStates (
	IdStates int primary key unique not null,
    Nome varchar (100),
    IdRegion int
);

alter table RegionStates
add constraint IdRegion
foreign key (IdRegion) references Region (IdRegion);

create table Region (
	IdRegion int primary key unique not null,
    Nome varchar(100),
    IdStates int,
    foreign key (IdStates) references RegionStates (IdStates)
);

create table Sales (
	IdSales int primary key unique not null,
    IdProduct int,
    NomeProdotto varchar (250),
    Prezzo decimal (4,2),
    DataOrdine date,
    IdRegion int,
    IdStates int,
    foreign key (IdProduct) references Product (IdProduct),
    foreign key (IdRegion) references Region (IdRegion),
    foreign key (IdStates) references RegionStates (IdStates)
);


#Popola le tabelle utilizzando dati a tua discrezione 

Insert into Product (IdProduct, Nome, Prezzo)
values (1, 'Hot Wheels', 25),
(2, 'Palla Calcio', 15),
(3, 'Ferrari', 10),
(4, 'Ps4', 30),
(5, 'Orso', 9);
insert into Product (IdProduct, Nome, Prezzo) values
(6, 'Porsche', 20)
insert into Product (IdProduct, Nome, Prezzo) values
(7, 'BMW', 20)

update Product
set IdCategory = 5
where IdProduct = 4;

Insert into Category (IdCategory, Nome, IdProduct)
values (1, 'Macchine', 1),
(2, 'Peluche', 5),
(3, 'Bambole', NULL ),
(4, 'Sport', 2),
(5, 'VideoGames', 4);

Insert into RegionStates (IdStates, Nome, IdRegion)
values (1, 'Italia', NULL),
(2, 'Francia', NULL),
(3, 'Portogallo', NULL),
(4, 'Spagna', NULL),
(5, 'Romania', NULL);

update RegionStates
set IdRegion = 4
where IdStates = 5;

Insert into Region (IdRegion, Nome, IdStates)
values (1, 'SudEU', 1),
(2, 'OvestEU', 3),
(3, 'OvestEU', 4),
(4, 'NordEU', 2),
(5, 'EstEU', 5);

insert into Sales (IdSales, IdProduct, NomeProdotto, Prezzo, DataOrdine, IdRegion, IdStates)
values (1, 3, 'Ferrari', 10, '2025-02-01', 3, 2),
(2, 1, 'Hot Wheels', 25, '2025-02-25', 2, 4),
(3, 5, 'Orso', 9, '2025-03-03', 3, 2),
(4, 4, 'Ps4', 30, '2025-03-05', 2, 3),
(5, 4, 'Ps4', 30, '2025-03-31', 1, 1),
(6, 2, 'Palla Calcio', 15, '2025-05-01', 2, 4),
(7, 3, 'Ferrari', 10, '2025-05-27', 1, 1),
(8, 2, 'Palla Calcio', 15, '2025-06-10', 4, 5);


select *
from Sales;

#Dopo aver popolate le tabelle, scrivi delle query utili a:

#1)	Verificare che i campi definiti come PK siano univoci. 
#In altre parole, scrivi una query per determinare l’univocità dei valori di ciascuna PK 
#(una query per tabella implementata).

select IdProduct, count(*) as Ripetizioni
from Product
group by IdProduct
having count(*) > 1;

#2)	Esporre l’elenco delle transazioni indicando nel result set il codice documento, la data, il nome del prodotto, 
#la categoria del prodotto, il nome dello stato, il nome della regione di vendita e un campo booleano valorizzato in base alla condizione che siano passati più di 180 giorni dalla data vendita o meno 
#(>180 -> True, <= 180 -> False)

select s.IdSales as codicedocumento, 
s.DataOrdine as dataordine, 
p.Nome as prodotto, 
c.Nome as categoria, 
rs.Nome as Stato, 
r.Nome as Regione, 
datediff(curdate(),s.DataOrdine) as giornitrascorsi, 
case 
	WHEN DATEDIFF(CURDATE(), s.DataOrdine) > 180 THEN 'Consegnato'
           ELSE 'In Lavorazione'
       END AS stato_ordine
from Sales as s
left join Product as p on s.IdProduct = p.IdProduct
left join Category as c on p.IdCategory = c.IdCategory
left join RegionStates as rs on s.IdStates = rs.IdStates
left join Region as r on rs.IdRegion = r.IdRegion;


#3)	Esporre l’elenco dei prodotti che hanno venduto, in totale, una quantità maggiore della media delle vendite realizzate nell’ultimo anno censito. 
#(ogni valore della condizione deve risultare da una query e non deve essere inserito a mano). Nel result set devono comparire solo il codice prodotto e il totale venduto.

SELECT p.Nome, SUM(s.Prezzo) AS totale_venduto
FROM Sales AS s
JOIN Product AS p ON s.IdProduct = p.IdProduct
WHERE YEAR(s.DataOrdine) = '2025'
GROUP BY p.Nome
HAVING SUM(s.Prezzo) > (
    SELECT AVG(totale_vendite)
    FROM (
        SELECT SUM(Prezzo) AS totale_vendite
        FROM Sales
        WHERE YEAR(DataOrdine) = '2025'
        GROUP BY IdProduct
    ) AS vendite_anno
);


#4)	Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno. 

select IdProduct, NomeProdotto,  year(DataOrdine) as Anno, sum(Prezzo) as Fatturato
from Sales as s
group by IdProduct, NomeProdotto, year(DataOrdine)
order by IdProduct;


#5)	Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente.

select rs.IdStates, rs.Nome, year(DataOrdine) as Anno, sum(Prezzo) as FatturatoAnnuale
from Sales as s
left join RegionStates as rs on s.IdStates = rs.IdStates
group by rs.IdStates, rs.Nome, year (DataOrdine)
order by year (DataOrdine), sum(Prezzo) DESC;

#6)	Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato?
select c.IdCategory, c.Nome, count(s.IdProduct) as Venduto
from Sales as s
left join Product as p on s.IdProduct = p.IdProduct
left join Category as c on p.IdCategory = c.IdCategory
group by c.IdCategory, c.Nome;
#La Cateogoria di articoli più richiesta dal mercato sono le Macchine, con una vendita di ben 7 articoli;


#7)	Rispondere alla seguente domanda: quali sono i prodotti invenduti? Proponi due approcci risolutivi differenti.
select p.IdProduct, p.Nome
from Product as p
left join Sales as s on p.IdProduct = s.IdProduct
where s.IdProduct is NULL;

select IdProduct, Nome
from Product
where IdProduct not in (select distinct IdProduct from Sales);


#8)	Creare una vista sui prodotti in modo tale da esporre una “versione denormalizzata” delle informazioni utili 
#(codice prodotto, nome prodotto, nome categoria)

create view InfoProdotti as(
select p.IdProduct as CodiceProdotto, p.Nome as Prodotto, c.Nome as Categoria
from Product as p
left join Category as c on p.IdCategory = c.IdCategory
);


#9)	Creare una vista per le informazioni geografiche

create view InfoGeo as (
select r.IdRegion as CodiceRegione, r.Nome as Regione, rs.Nome as Stato
from Region as r
left join RegionStates as rs on r.IdStates = rs.IdStates
);