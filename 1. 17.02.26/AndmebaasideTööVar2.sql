--variant 2

--punkt 1
Create database AndmebaasideTööVar2

create table Liikmed
(
Id int not null primary key,
Eesnimi varchar(50),
Perenimi varchar(50),
Vanus int,
Liitumise_aasta int
)


--punkt 2
Insert into Liikmed (Id, Eesnimi, Perenimi, Vanus, Liitumise_aasta)
values (1, 'Toomas', 'Mets', 26, 2009), 
(2, 'Siim', 'Laan', 18, 2018),
(3, 'Anna', 'Siig', 21, 2015), 
(4, 'Ott', 'Tamm', 35, 2002), 
(5, 'Arno', 'Hiis', 24, 2020), 
(6, 'Mari', 'Liis', 27, 2025)

select * from Liikmed

--punkt 3
update Liikmed 
set Vanus = 20
Where Id = 6

update Liikmed
set Perenimi = 'Laanemeri'
Where Id = 3

--punkt 4
alter table Liikmed
add Kuutasu DECIMAL(5,2)

update Liikmed
set Kuutasu = 700.0
Where Id = 1

update Liikmed
set Kuutasu = 999.9
Where Id = 4

update Liikmed
set Kuutasu = 800.0
Where Id = 6

--punkt 5
alter table Liikmed 
drop column Liitumise_aasta

select * from Liikmed

--punkt 6
delete from Liikmed
Where Id = 5
