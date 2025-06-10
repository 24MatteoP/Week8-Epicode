#È necessario implementare uno schema che consenta di gestire le anagrafiche degli store di unʼipotetica azienda. 
#Uno store è collocato in una precisa area geografica. In unʼarea geografica possono essere collocati store diversi. 
#Cosa devi fare:
# 1. Crea una tabella Store per la gestione degli store (ID, nome, data apertura, ecc.) 
# 2. Crea una tabella Region per la gestione delle aree geografiche (ID, città, regione, area geografica, …) 
# 3. Popola le tabelle con pochi record esemplificativi 
# 4. Esegui operazioni di aggiornamento, modifica ed eliminazione record

show databases;
create database w8d1;
use w8d1;
show tables;
describe Store;
describe Region;

Create table Region (
IdRegion int primary key not null,
Citta varchar (100),
Regione varchar (100),
AreaGeografica varchar (100)
);

Create Table Store (
IdStore int primary key not null,
Nome varchar (100),
DataApertura date,
Titolare varchar (200),
IdTitolare int not null,
IdRegion int not null
);

alter table Store 
Add constraint IdRegion foreign key (IdRegion)
references Region (IdRegion);

INSERT INTO Region (IdRegion, Citta, Regione, AreaGeografica) 
VALUES (1, 'Milano', 'Lombardia', 'Nord Italia'),
(2, 'Torino', 'Piemonte', 'Nord Italia'),
(3, 'Venezia', 'Veneto', 'Nord Italia'),
(4, 'Firenze', 'Toscana', 'Centro Italia'),
(5, 'Roma', 'Lazio', 'Centro Italia'),
(6, 'Napoli', 'Campania', 'Sud Italia'),
(7, 'Bari', 'Puglia', 'Sud Italia'),
(8, 'Palermo', 'Sicilia', 'Sud Italia'),
(9, 'Cagliari', 'Sardegna', 'Isole'),
(10, 'Genova', 'Liguria', 'Nord Italia');

select *
from Region;

INSERT INTO Store (IdStore, Nome, DataApertura, Titolare, IdTitolare, IdRegion) VALUES
(1, 'SuperMarket Milano', '2015-06-10', 'Mario Rossi', 101, 1),
(2, 'Torino Fashion', '2018-03-22', 'Giulia Bianchi', 102, 2),
(3, 'Venezia Books', '2019-11-05', 'Luca Verdi', 103, 3),
(4, 'Firenze Art Gallery', '2016-07-15', 'Anna Ferrari', 104, 4),
(5, 'Roma Tech', '2020-01-30', 'Paolo Romano', 105, 5),
(6, 'Napoli Bakery', '2017-05-18', 'Sara De Luca', 106, 6),
(7, 'Bari Market', '2014-09-25', 'Marco Esposito', 107, 7),
(8, 'Palermo Vintage', '2021-08-12', 'Elisa Moretti', 108, 8),
(9, 'Cagliari Sport', '2013-04-02', 'Fabio Gallo', 109, 9),
(10, 'Genova Music', '2016-12-07', 'Roberta Fontana', 110, 10),
(11, 'Lombardia Tech', '2015-10-14', 'Andrea Ricci', 111, 1),
(12, 'Piemonte Boutique', '2019-06-20', 'Francesca Leone', 112, 2),
(13, 'Veneto Jewelry', '2018-11-01', 'Giorgio Riva', 113, 3),
(14, 'Toscana Wine', '2022-02-15', 'Marta Serra', 114, 4),
(15, 'Lazio Bookstore', '2017-08-09', 'Davide Conti', 115, 5),
(16, 'Campania Shoes', '2020-05-25', 'Stefania Vitale', 116, 6),
(17, 'Puglia Restaurant', '2016-03-10', 'Matteo Greco', 117, 7),
(18, 'Sicilia Coffee', '2019-07-30', 'Giovanna Bellini', 118, 8),
(19, 'Sardegna Surf Shop', '2014-11-22', 'Federico Mancini', 119, 9),
(20, 'Liguria Handmade', '2021-09-05', 'Alessia Fabbri', 120, 10);

select *
from Store;


select S.IdStore, S.Nome, S.DataApertura, S.Titolare, S.IdTitolare, R.IdRegion, R.Citta, R.Regione, R.AreaGeografica
from Store as S
left join Region as R on S.IdRegion = R.IdRegion;

SET SQL_SAFE_UPDATES = 0;

Update Region
Set AreaGeografica = 'Isole Italia' 
where Regione = 'Sardegna';

Delete from Store
Where IdStore = 1;
