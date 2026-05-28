--teeme andmebaasi ehk db
create database IKT25tar

--andmebaasi valimine
use IKT25tar

--andmebaasi kustutamine
drop database IKT25tar

--teeme uuesti andmebaasi IKT25tar
create database IKT25tar

--teeme tabeli
create table Gender
(
--Meil on muutuja Id,
--mis on täisarv andmetüüp,
--kui sisestad andmed, 
--siis see veerg peab olema täidetud,
--tegemist on primaarvõtmega 
Id int not null primary key,
--veeru nimi on Gender,
--10 tähemärki on max pikkus,
--andmed peavad olema sisestatud ehk
--ei tohi olla tühi
Gender nvarchar(10) not null
)

--andmete sisestamine Gender tabelisse
-- Id = 1, Gender = Male
-- Id = 2, Gender = Female

insert into Gender (Id, Gender)
values (1, 'Male'), 
(2, 'Female')

--vaatame tabeli sisu
-- * tähendab, et näita kõike seal sees olevat infot 
select * from Gender 

--teeme tabeli nimega Person
--veeru nimed: Id int not null primary key,
-- Name nvarchar (30)
-- Email nvarchar (30)
-- GenderId int

create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'c@c.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

--näen tabelis olevat infot
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel

alter table Person add constraint tlbPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla
--väärtust, siis automaatselt sisestab sellele reale väärtuse 3
--ehk unknown
alter table Person
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Gender (Id, Gender)
values (3, 'Unknown')

insert into Person (Id, Name, Email, GenderId)
values (7, 'Black Panther', 'b@b.com', NULL)

insert into Person (Id, Name, Email)
values (9, 'Spiderman', 'spider@man.com')

select * from Person

--piirangu kustutamine
alter table Person
drop constraint DF_Persons_GenderId

--kuidas lisada veergu tabelile Person
--veeru nimi on Age nvarchar(10)

alter table Person
add Age nvarchar(10)

alter table Person
add constraint CK_Person_Age check(Age > 0 and Age < 155)

--kuidas uuendada andmeid
update Person
set Age = 159
where Id = 7

select * from Person

--soovin kustutada ühe rea
delete from Person
where Id = 8

--lisame uue veeru City nvarchar(50)
alter table Person
add City nvarchar(50)

select * from Person

--kõik, kes elavad Gothami linnas 
select * from Person where City = 'Gotham'
--kõik, kes ei ela Gothamis
select * from Person where City != 'Gotham'
--variant nr 2. kõik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'

--näitab teatud vanusega inimesi 
--valime 151, 35, 26
select * from Person where Age in (151, 35, 26)
--variant nr 2. kõik vanusega 151, 35, 26
select * from Person where Age = 151 or Age = 35 or Age = 26

--soovin näha inimesi vahemikus 22 kuni 41
select * from Person where Age between 22 and 41

--wildcard ehk näitab kõik g-tähega linnad
select * from Person where City like 'g%'
--otsib emailid @-märgiga
select * from Person where Email like '%@%'

--tahan näha, kellel on emailis ees ja peale @-märki üks täht
select * from Person where Email like '_@_.com'

--kõik kelle nimes ei ole esimene täht W, A, S
select * from Person where Name like '[^WAS]%'

--kõik, kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

--kõik, kes elavad Gothamis ja New Yorkis ning peavad olema 
--vanemad, kui 29
select * from Person where (City = 'Gotham' or City = 'New York') and Age >= 30

--kuvab tähestikulises järjekorras inimesi ja võtab aluseks
--Name veeru
select * from Person
select * from Person order by Name

--võtab kolm esimest rida Person tabelist
select top 3 * from Person

--kolm esimest, aga tabeli järjestus on Age ja siis Name
select top 3 Age, Name from Person

--näita esimesed 50% tabelist
select top 50 percent * from Person

--järjestab vanuse järgi isikud
select * from Person order by Age desc

--muudab Age muutuja int-ks ja näitab vanuselises järjestuses
--cast abil saab andmetüüpi muuta
select * from Person order by cast (Age as int) desc

--kõikide isikute koondvanus
select sum(cast(Age as int)) from Person

--kõige noorem isik tuleb üles leida
select min(cast(Age as int)) from Person

--kõige vanem isik
select max(cast(Age as int)) from Person

--muudame Age muutuja int peale
--näeme konkreetsetes linnades olevate isikute koondvanust

select City, sum(Age) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmetüüpi ja selle pikkust
alter table Person
alter column Name nvarchar(25)

--kuvab esimeses reas välja toodud järjestuses ja kuvab Age-i
--TotalAge-ks
--järjestab City-s olevate nimede järgi ja siis GenderId järgi 
--kasutada group by-d ja order by-d
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId
order by City

--näitab, et mitu rida andmeid on selles tabelis
select count(*) from Person

--näitab tulemust, et mitu inimest on GenderId väärusega 2
--konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person 
where GenderId = '1'
group by GenderId, City

--näitab ära inimeste koondvanuse, mis on üle 41 a ja
--kui palju neid igas linnas elab
--eristab inimese soo ära 
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person 
where GenderId = '2'
group by GenderId, City having sum(Age) > 41 

--loome tabelid Employees and Department
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees 
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int 
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russell', 'Male', 8800, NULL)

insert into Department (Id, DepartmentName, Location, DepartmentHead)
values (1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Department
select * from Employees

---
select Name, Gender, Salary, DepartmentName
from Employees 
left join Department
on Employees.DepartmentId = Department.Id
---

--arvutab kõikide palgad kokku
select sum(cast(Salary as int)) from Employees --arvutab kõikide palgad kokku

--kõige väiksema palga saaja
select min(cast(Salary as int)) from Employees

--näitab veerge Location ja Palka. Palga veerg kuvatakse TotalSalary-ks
--teha left join Department tabeliga
--gruppitab Locationiga

select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location

select *from Employees
select sum(cast(Salary as int)) from Employees --arvutab kõikide palgad kokku

--lisame veeru City ja pikkus on 30
--Employees tabelisse lisada

alter table Employees
add City nvarchar(30)

select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees
group by City, Gender

--peaaegu sama päring, aga linnad on tähestikulises järjestuses
select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees
group by City, Gender
order by City

--on vaja teada, et mitu inimest on nimekirjas 
select count(*) from Employees

--mitu töötajat on soo ja linna kaupa töötamas
select City, Gender, sum(cast(Salary as int)) as TotalSalary, 
count(Id) as [TotalEmployees(s)]
from Employees
group by City, Gender
order by City

--kuvab kas naised või mehed linnade kaupa
--kasutage where
select City, Gender, sum(cast(Salary as int)) as TotalSalary, 
count(Id) as [TotalEmployees(s)]
from Employees
where Gender = 'Male' --saad panna kas Male või Female
group by Gender, City

--sama tulemus nagu eelmine kord, aga kasutage having
select City, Gender, sum(cast(Salary as int)) as TotalSalary, 
count(Id) as [TotalEmployees(s)]
from Employees
group by Gender, City
having Gender = 'Female'

--kõik kes teenivad rohkem, kui 4000
select * from Employees where sum(cast(Salary as int)) < 4000

--teeme variandi, kus saame tulemuse
select Gender, City, sum(cast(Salary as int)) as TotalSalary, 
count(Id) as [TotalEmployees(s)]
from Employees
group by Gender, City
having sum(cast(Salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')
select * from Test1

--kustutame veeru nimega City Employee tabelist 
alter table Employees
drop column City

--inner join
--kuvab neid, kellel on DepartmentName all olemas väärtus
--mitte kattuvad read eemaldatakse tulemusest 
--ja sellepärast ei näidata Jamesi ja Russelit
--kuna neil on DepartmentId NULL
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left join
select Name, Gender, Salary, DepartmentName
from Employees
left join Department --võib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--näitab andmeid, kus vasakpoolsest tabelist isegi, siis kui seal puudub 
--võõrvõtme reas väärtus 

--right join
select Name, Gender, Salary, DepartmentName
from Employees
right join Department --võib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--right join näitab paremas (Department) tabelis olevaid väärtuseid,
--mis ei ühti vasaku (Employees) tabeliga

--outer join
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id
--mõlema tabeli read kuvab 

--teha cross join 
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department
--korrutab kõik omavahel läbi

--teha left join, kus Employee tabelist DepartmentId on 0
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL

--teine variant ja sama tulemus
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is NULL
--näitab ainult neid, kellel on vasakus tabelis (Employees)
--DepartmentId NULL

select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL
--näitab ainult paremas tabelis olevat rida,
--mis ei kattu Employees-ga

--full join
--mõlema tabeli mitte-kattuvate väärtustega read kuvab välja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL
or Department.Id is NULL

--teete AdventureWorksLT2019 andmebaasile join päringud:
--inner join, left join, right join, cross join, full ja full join
--tabeleid sellesse andmebaasi juurde ei tohi teha

--mõnikord peab muutuja ette kirjutama tabeli nimetuse nagu on Product.Name,
--et editor saaks aru, et kumma tabeli muutujat soovitaksid kasutada ja ei tekiks
--segadust 
select Product.Name as [Product Name], ProductNumber, ListPrice, 
ProductModel.Name as [Product Model Name],
Product.ProductModelId, ProductModel.ProductModelId
--mõnikord peab ka tabeli ette kirjutama täpsustava info
--nagu on SalesLT.Product
from SalesLT.Product
inner join SalesLT.ProductModel
--antud juhul Producti tabelis ProductModelId võõrvõti,
--mis ProductModeli tabelis on primaarvõti
on Product.ProductModelId = ProductModel.ProductModelId

--isnull funktsiooni kasutamine
select isnull('Ingvar', 'No Manager') as Manager

--NULL asemel kuvab No Manager
select coalesce(NULL, 'No Manager') as Manager

alter table Employees
add ManagerId int

select * from Employees

--neile, kellel ei ole ülemust, siis paneb neile No Manager teksti
--kasutage left joini
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--kasutame inner joini
--kuvab ainult ManagerId all olevate isikute väärtuseid
select E.Name as Employee, M.Name as Manager
from  Employees E
inner join Employees M
on E.ManagerId = M.Id

--kõik saavad kõikide ülemused olla
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

--lisame tabelisse uued veerud 
--MiddleName nvarchar 30 
--LastName nvarchar 30

alter table Employees
add MiddleName nvarchar(30)

alter table Employees
add LastName nvarchar(30)

select * from Employees

--muudame olemasoleva veeru nimetust
sp_rename 'Employees.Name', 'FirstName'

Update Employees
set MiddleName = 'Nick',
LastName = 'Jones'
where Id = 1

Update Employees
set LastName = 'Anderson'
where Id = 2

Update Employees
set LastName = 'Smith' 
where Id = 4

Update Employees
set FirstName = NULL, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5

Update Employees
set MiddleName = 'Ten', LastName = 'Sven'
where Id = 6

Update Employees
set LastName = 'Connor'
where Id = 7

Update Employees
set MiddleName = 'Balerine'
where Id = 8

Update Employees
set MiddleName = '007', LastName = 'Bond'
where Id = 9

Update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe'
where Id = 10

--igast reast võtab esimesena täidetud lahtri ja kuvab ainult seda
--
select * from Employees
select Id, coalesce(FirstName, MiddleName,LastName) as Name from Employees

--loome kask tabelit
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

--sisestame tabelisse andmeid
insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--kasutame union all, mis näitab kõiki ridu
--union all ühendab tabelid ja näitab sisu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--korduvate väärtustega read ühte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--kasutad union all, aga sorteerid nime järgi
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
order by Name

--stored procedure
--tavaliselt pannakse nimetuse ette sp, mis tähendab stored procedure
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--nüüd saab kasutada selle nimelist sp-d
spGetEmployees
exec spGetEmployees
execute spGetEmployees

create proc spGetEmployeesByGenderAndDepartment
--@ tähendab muutujat
@Gender nvarchar(20),
@DepartmentId int 
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

--kui nüüd on allolevast käsklust käima panna, siis nõuab gender parameetrit
spGetEmployeesByGenderAndDepartment

--õige variant
spGetEmployeesByGenderAndDepartment 'Male', 1 --saab muuta kas Male või Female 

--niimoodi saab sp kirja pandud järjekorrast mööda minna, kui ise paned muutja paika
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'male'

--saab svaadata sp sisu result vaates
sp_helptext spGetEmployeesByGenderAndDepartment

--kuidas muuta sp-d ja panna sinna võti peale, et keegi teine peale teie ei saaks muuta
--kuskile tuleb lisada with encryption 
alter proc spGetEmployeesByGenderAndDepartment
@Gender nvarchar(20),  
@DepartmentId int
with encryption
as begin 
 select FirstName, Gender, DepartmentId from Employees where Gender = @Gender  
 and DepartmentId = @DepartmentId  
end

--sp tegemine
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end

--annab tulemuse, kus loendab ära nõuetele vastavad read
--prindib ka tulemuse kirja teel
--tuleb teha declare muutuja @TotlaCount, mis on int
declare @TotalCount int
--execute spGetEmployeeCountByGender sp, kus on parameetrid Male ja TotalCount
execute spGetEmployeeCountByGender 'Male', @TotalCount out
--if ja else, kui TotalCount = 0, siis tuleb tekst TotalCount is null
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@Total is not null'
print @TotalCount
--lõpus kasuta print @TotalCounti puhul

--näitab ära, mitu rida vastab nõuetele

--deklareerime muutuja @TotalCount, mis on int andmetüüp
declare @TotalCount int 
--käivitame stored procedure spGetEmployeeCountByGender, kus on parameetrid
--@EmployeeCount = @TotalCount out ja @Gender
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Female'
--prindib konsooli välja, kui TotalCount on null või mitte null
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
--tabeli info vaatamine
sp_help Employees
--kui soovid sp teksti näha
sp_helptext spGetEmployeeCountByGender

--vaatame, millest sõltub meie valitud sp
sp_depends spGetEmployeeCountByGender
--näitab, et sp sõltub Employees tabelist, kuna seal on count(Id)
--ja Id on Employees tabelis

--vaatame tabelit
sp_depends Employees

--teeme sp, mis annab andmeid Id ja Name veergude kohta Employees tabelis
create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin
	select @Id = Id, @Name = FirstName from Employees
end

--annab kogu tabeli ridade arvu
create proc spTotalCount2
@TotalCount int output
as begin
	select @TotalCount = count(Id) from Employees
end

--on vaja teha uus päring, kus kasutame spTotalCount2 sp-d, 
--et saada tabelite ridade arv

--tuleb deklareerida muutuja @TotalCount, mis on int andmetüüp
declare @TotalEmployees int 
--tuleb execute spTotalCount2, kus on parameeter @TotalEmployees
exec spTotalCount2 @TotalEmployees output
print @TotalEmployees

--mis Id all on keegi nime järgi 
create proc spGetNameById1
@Id int,
@FirstName nvarchar(20) output
as begin
	select @FirstName = FirstName from Employees where Id = @Id
end

--annab tulemuse, kus Id 1(seda numbrit saab muuta) real on keegi koos nimega
--printi tuleb kasutada, et näidata tulemust
declare @FirstName nvarchar(20)
exec spGetNameById1 3, @FirstName output --numbrit peale spGetNameById saab muuta
print 'Name of the employee = ' + @FirstName

--tehke sama, mis eelmine, aga kasutage spGetNameById sp-d
--FirstName lõpus on out
declare @FirstName nvarchar(20)
exec spGetNameById 1, @FirstName out
print 'Name = ' + @FirstName

--output tagastab muudetud read kohe päringu tulemusena
--see on salvestatud protseduuris ja ühe väärtuse tagastamine

--out ei anna mitte midagi, kui seda ei määra execute käsus

sp_help spGetNameById

create proc spGetNameById2
@Id int
--kui on being, siis on ka end kuskil olemas
as begin
	return (select FirstName from Employees where Id = @Id)
end

--tuleb veateade kuna kutsusime välja int-i, aga Tom on nvarchar
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'Name of the employee = ' + @EmployeeName

--sisseehitatud string funktisoonid
--see konverteerib ASCII tähe väärtuse numbriks
select ASCII('A')

select char(65)

--prindime kogu tähestiku välja
declare @Start int
set @Start = 97
--kasutate while, et näidata kogu tähestik ette
While (@Start <= 122)
Begin
	select char(@Start)
	set @Start = @Start + 1
end

--eemaldame tühjad kohad sulgudes
select ('               Hello')
select LTRIM('               Hello')

--tühikute eemaldamine veerust, mis on tabelis
select FirstName, MiddleName, LastName from Employees
--eemaldage tühikud FirstName veerust ära
select LTRIM(FirstName) as FirstName, MiddleName, LastName from Employees

--paremalt poolt tühjad stringid lõikab ära
select rtrim('    Hello    ')

--keerab kooloni sees olevad andmed vastupidiseks
--vastavalt lower-ga ja upper-ga saan muuta märkide suurus
--reverse funktsioon pöörab kõik ümber 
select Reverse(upper(ltrim(FirstName))) as FirstName, MiddleName, lower(LastName),
rtrim(ltrim(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

--left, right, substring
--vasakult poolt neli esimest tähte
select left('ABCDEF', 4)
--paremalt poolt kolm tähte
select right('ABCDEF', 3)

--kuvab @-tähemärgi asetust e mitmes on @-märk
select CHARINDEX('@', 'sara@aaa.com')

--esimene nr peale komakohta näitab, et mitmendast alustab ja 
--siis mitu nr peale seda kuvada
select SUBSTRING('pam@bbb.com', 5, 2)

--@-märgist kuvab kolm tähemärki. Viimase nr saab määrata pikkust
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 3)

--peale @-märki hakkab kuvama tulemust, nr saab kaugust seadistada 
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 2,
len('pam@bbb.com') - charindex('@', 'pam@bbb.com'))

alter table Employees
add Email nvarchar(20)

select * from Employees

update Employees
set Email = 'Tom@aaa.com'
where Id = 1

update Employees
set Email = 'Pam@bbb.com'
where Id = 2

update Employees
set Email = 'John@aaa.com'
where Id = 3

update Employees
set Email = 'Sam@bbb.com'
where Id = 4

update Employees
set Email = 'Todd@.bbb.com'
where Id = 5

update Employees
set Email = 'Ben@ccc.com'
where Id = 6

update Employees
set Email = 'Sara@ccc.com'
where Id = 7

update Employees
set Email = 'Valarie@aaa.com'
where Id = 8

update Employees
set Email = 'James@bbb.com'
where Id = 9

update Employees
set Email = 'Russel@bbb.com'
where Id = 10

--soovime teada saada domeeninimesid emailides
select SUBSTRING (Email, CHARINDEX('@', Email) + 1,
len (Email) - CHARINDEX('@', Email)) as EmailDomain
from Employees

--alates teisest tähest emailis kuni @ märgini on tärnid

select FirstName, LastName,
substring(Email, 1, 2) + replicate('*', 5) +
substring(Email, charindex('@', Email), len(Email) - charindex('@', Email)+1) as Email
from Employees

--kolm korda näitab stringis olevat väärtust
select replicate('asd', 3)

--tühiku sisestamine
select space(5)

--tühiku sisestamine FirstName ja LastName vahele
select FirstName + space(25) + LastName as FullName
from Employees

--PATINDEX
--sama, mis charindex, aga dünaamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0
--leian kõik selle domeeni esindajad ja alates mitmendast märgist algab @

--kõik .com emailid asnedab .net-ga
select Email, replace(Email, '.com', '.net') as ConvertedEmail
from Employees

--soovin asendada peale esimest märki kolm tähte viie tärniga
select FirstName, LastName,
	stuff(Email, 2, 3, '*****') as StuffedEmail
from Employees

create table DateTime
(
	c_time time,
	c_date date,
	c_smalldatetime smalldatetime,
	c_datetime datetime,
	c_datetime2 datetime2,
	c_datetimeoffset datetimeoffset
)

select * from DateTime

--konkreetse masina kellaaeg
select getdate(), 'GETDATE()'

insert into DateTime
values (getdate(), getdate(), getdate(), getdate(), getdate(), getdate())

select * from DateTime

update DateTime
set c_datetimeoffset = '2026-04-08 14:49:28.1933333 +10:00'

select CURRENT_TIMESTAMP, 'CURRENT_TIMESTAMP' --aja päring
select SYSDATETIME(), 'SYSDATETIME' --veel täpsem aja päring
select SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET' --täpne aeg koos ajalise nihkega
select GETUTCDATE(), 'GETUTCDATE' --UTC aeg

--saab kontrollida, kas on õige andmetüüp
select isdate('asd') --tagastab 0 kuna srtring ei ole date
	   --kuidas saada vastuseks 1 isdate puhul?
select isdate(GETDATE())
select isdate('2026-04-08 14:49:28.193333') --tagastab 0 kuna max kolm komakohta võib olla
select isdate('2026-04-08 14:49:28.193') --tagastab 1
select DAY(GETDATE()) --annab tänase päeva nr
select DAY('01/24/2026') --annab stringis oleva kp ja järjestus peab olema õige

select Month(GETDATE()) --annab jooksva kuu nr
select Month('01/24/2026') --annab stringis oleva kuu ja järjestus peab olema õige

select Year(GETDATE()) --annab jooksva aasta nr
select Year('01/24/2026') --annab stringis oleva aasta ja järjestus peab olema õige

select datename(day, '2026-04-08 14:49:28.193') --annab stringis oleva päeva nr
select datename(weekday, '2026-04-08 14:49:28.193') --annab stringis oleva päeva sõnana
select datename(month, '2026-04-08 14:49:28.193') --annab stringis oleva kuu sõnana

create table EmployeeWithDates
(
	Id nvarchar(2),
	Name nvarchar(20),
	DateOfBirth datetime
)

select * from EmployeeWithDates

insert into EmployeeWithDates (Id, Name, DateOfBirth)
values (1, 'Sam', '1980-12-30 00:00:00:000');
insert into EmployeeWithDates (Id, Name, DateOfBirth)
values (2, 'Pam', '1982-09-01 12:02:36:260');
insert into EmployeeWithDates (Id, Name, DateOfBirth)
values (3, 'John', '1985-08-22 12:03:30:370');
insert into EmployeeWithDates (Id, Name, DateOfBirth)
values (4, 'Sara', '1979-11-29 12:59:30:670');

--kuidas võtta ühest veerust andmeid ja selle abil luua veerud 

--vaatab DoB veerust päeva ja kuvab päeva nimetuse sõnana
select Name, DateOfBirth, Datename(weekday, DateOfBirth) as [Day],
	--vaatab veerust kuupäevasid ja kuvab kuu nr
	Month(DateOfBirth) as MonthNumber,
	--vaatab DoB veerust kuud ja kuvab sõnana
	DateName(Month, DateOfBirth) as [MonthName],
	--võtab DoB veerust aasta
	Year(DateOfBirth) as [Year]
from EmployeeWithDates

--kuvab 13 kuna USA nädal aslagb pühapäevaga
select Datepart(weekday, '2026-03-24 12:59:30:670')
--tehke sama, aga kasutage kuu-d
select Datepart(month, '2026-03-24 12:59:30:670')
--liidab stringis olevale kuupäevale 20 päeva juurde 
select Dateadd(day, 20, '2026-03-24 12:59:30:670')
--lahutab 20 päeva maha 
select Dateadd(day, -20, '2026-03-24 12:59:30:670')
--kuvab kahe stirngis oleva kuudevahelist aega nr-na
select Datediff(month, '11/20/2026', '01/20/2024')
--tehke sama, aga kasutage aastat
select Datediff(Year, '11/20/2026', '01/20/2028')

--alguses uurite, mis on funktsioon MS SQL 
--Andmebaasifunktsioonid on SQL-käskude kogum, mida kasutatakse konkreetsete andmebaasitehingute tegemiseks.
--eelkirjutatud toimingud, salvestatud tegevus

--miks seda on vaja
--pakkuda DB-s korduvkasutatud funktsionaalsust

--mis on selle eelised ja puudused
--Eelised - Järjepidev, modulaarne, kompaktsem, potentsiaalselt vähendab muudatuste arvu
--saad kiiresti kasutada toiminguid ja ei pea uuesti koodi kirjutama

--Puudused - Funktsioon ei tohi muuta DB olekut

create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin 
	declare @tempdate datetime, @years int, @months int, @days int
	select @tempdate = @DOB
	
	select @years = datediff(year, @tempdate, getdate()) - case when (month(@DOB) >
	month(getdate())) or (month(@DOB) = month(getdate()) and day(@DOB) > day(getdate()))
	then 1 else 0 end
	select @tempdate = dateadd(year, @Years, @tempdate)

	select @months = datediff(month, @tempdate, getdate()) - case when day(@DOB) > day(getdate())
	then 1 else 0 end
	select @tempdate = dateadd(month, @months, @tempdate)

	select @days = datediff(day, @tempdate, getdate())

	declare @Age nvarchar(50)
		set @Age = cast(@years as nvarchar(4)) + ' Years ' + cast(@months as nvarchar(2))
		+ ' Months ' + cast(@days as nvarchar(2)) + ' Days old '
	return @Age
end

select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from EmployeeWithDates

select CustomerID, FirstName, LastName, City
from SalesLT.Customer
inner join SalesLT.Address
    on SalesLT.Customer.CustomerID = SalesLT.Address.AddressID;

select SalesLT.Customer.CustomerID, FirstName, LastName, City
from SalesLT.Customer
left join SalesLT.CustomerAddress
    on SalesLT.Customer.CustomerID = SalesLT.CustomerAddress.CustomerID
left join SalesLT.Address
    on SalesLT.CustomerAddress.AddressID = SalesLT.Address.AddressID;

select SalesLT.Customer.CustomerID, FirstName, LastName, City
from SalesLT.Customer
right join SalesLT.CustomerAddress
    on SalesLT.Customer.CustomerID = SalesLT.CustomerAddress.CustomerID
right join SalesLT.Address
    on SalesLT.CustomerAddress.AddressID = SalesLT.Address.AddressID;

select SalesLT.Customer.CustomerID, FirstName, LastName, SalesLT.CustomerAddress.AddressID
from SalesLT.Customer
full outer join SalesLT.CustomerAddress
    on SalesLT.Customer.CustomerID = SalesLT.CustomerAddress.CustomerID;

select CustomerID, ProductID
from SalesLT.Customer
cross join SalesLT.Product;

--1.
create proc GetAllCustomers
as begin
	select CustomerID, FirstName, MiddleName, LastName from SalesLT.Customer
end

execute GetAllCustomers

--2.
create proc GetCustomerByID
@CustomerID int
as begin
	select FirstName,LastName,EmailAddress from SalesLT.Customer
end

GetCustomerByID 1

--3.
create proc GetOrdersByDateRange
@StartDate Date,
@EndDate Date

as begin
	select OrderDate from SalesLT.SalesOrderHeader
end

execute GetOrdersByDateRange @StartDate = '2008-06-01 00:00:00.000', @EndDate = '2008-06-08 00:00:00.000'

--4. 
create proc AddNewProduct
@Name nvarchar(20),
@ProductNumber int,
@ListPrice int,
@StandardCost int,
@SellStartDate int = GETDATE()
as begin
	insert into SalesLT.Product values (@Name, @ProductNumber, @ListPrice, @StandardCost, @SellStartDate)
end

--5
create proc UpdateProductPrice
@ProductID int,
@NewPrice int
as begin
	update SalesLT.Product set ListPrice = @NewPrice
end

---
select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from EmployeeWithDates
--kui kasutame seda funktsiooni, siis saame teada tänase päeva vahet stringis välja tooduga
select dbo.fnComputeAge('02/24/2010') as Age

--nr peale DOB muutujat näitab, et mismoodi kuvada DOB-d
select Id, Name, DateOfBirth,
convert(nvarchar, DateOfBirth, 110) as ConvertedDOB
from EmployeeWithDates

select Id, Name, Name + ' - ' + cast(Id as nvarchar) as [Name-Id] from EmployeeWithDates

select cast(getdate() as date) --tänane kp
--tänane kp, aga kasutate convert-i, et kuvada stringina

select convert(date, getdate())

--matemaatilised funktsioonid
select ABS(-5) --abs on absoluutväärtusega number ja tulemuseks saame ilma miinus märgita 5
select ceiling(4.2) --ceiling on funktsioon, mis ümardab ülespoole ja tulemuseks saame 5
select ceiling(-4.2) --ceiling ümardab ka miinus numbrid ülespoole, mis tähendab, et saame -4
select floor(15.2) --floor on funktsioon, mis ümardab alla ja tulemuseks saame 15
select floor(-15.2) --floor ümardab ka miinus numbrid alla, mis tähendab, et saame -16
select power(2, 4) --kaks astmes neli
select square(9) --antud juhul 9 ruudus
select sqrt(16) --antud juhul 16 ruutjuur

select rand() --rand on funktsioon, mis genereerib juhusliku numbri vahemikus 0 kuni 1
--kuidas saada täisnumber iga kord
select floor(rand() * 100) --korrutab sajaga iga suvalise numbri

--iga kord näitab 10 suvalist numbrit
declare @counter int
set @counter = 1
while (@counter <= 10)
begin
	print floor(rand() * 100)
	set @counter = @counter + 1
end

select round(850.556, 2) --round on funktsioon, mis ümardab kaks komakohta 
--ja tulemuseks saame 850.56
select round(850.556, 2, 1) --round on funktsioon, mis ümardab kaks komakohta ja 
--kui kolmas parameeter on 1, siis ümardab alla
select round(850.566, 1) --round on funktsioon, mis ümardab ühe komakohta ja
--tulemuseks saame 850.6
select round(850.556, 1, 1) --ümardab alla ühe komakoha peal
--ja tulemuseks saame 850.5
select round(850.556, -2) --ümardab täisnr ülespoole ja tulemus on 900
select round(850.556, -1) --ümardab täisnr alla ja tulemus on 850

---
create function dbo.CalculateAge(@DOB date)
returns int
as begin 
declare @Age int

	set @Age = datediff(year, @DOB, getdate()) -
	case
		when (month(@DOB) > month(getdate())) or
			 (month(@DOB) = month(getdate()) and day(@DOB) > day(getdate()))
			 then 1 else 0 end
		return @Age
end

--kui valmis, siis proovige seda funktsiooni 
--ja vaadake, kas annab õige vanuse
exec dbo.CalculateAge '1980-12-30'

--arvutab välja, kui vana on isik ja võtab arvesse kuud ning päevad
--antud juhul näitab kõiki, kes on üle 36 a vanad
select Id, Name, dbo.CalculateAge(DateOfBirth) as Age from EmployeeWithDates
where dbo.CalculateAge(DateOfBirth) > 36

--inline table valued functions 
alter table EmployeeWithDates
add DepartmentId int
alter table EmployeeWithDates
add Gender nvarchar(10)

select * from EmployeeWithDates

Update EmployeeWithDates
set DepartmentId = 1, Gender = 'Male'
where Id = 1

Update EmployeeWithDates
set DepartmentId = 2, Gender = 'Female'
where Id = 2

Update EmployeeWithDates
set DepartmentId = 1, Gender = 'Male'
where Id = 3

Update EmployeeWithDates
set DepartmentId = 3, Gender = 'Female'
where Id = 4

insert into EmployeeWithDates (Id, Name, DateOfBirth, DepartmentId, Gender)
values (5, 'Todd', '1978-11-29 12:59:30:670', 1, 'Male')

--scalar function annab mingis vahemikus olevaid andmeid,
--inline table values ei kasuta begin ja end funktsioone
--scalar annab väärtused ja inline annab tabeli

create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, Name, DateOfBirth, DepartmentId, Gender
		from EmployeeWithDates
		where Gender = @Gender)

--kuidas leida kõik naised tabelis EmployeeWithDates
--ja kasutada funktsiooni fn_EmployeesByGender
select * from fn_EmployeesByGender('female')

--tahaks ainult Pami
select * from fn_EmployeesByGender('Female')
where Name = 'Pam'

select * from Department

--kahest erinevast tabelist andmete võtmine ja koos kuvamine
--esimene on funktsioon ja teine tabel

select Name, Gender, DepartmentName
from fn_EmployeesByGender('Male') E
join Department D on D.Id = E.DepartmentId

--multi tabel statement
--inline funktsioon
create function fn_GetEmployees()
returns table as
return (select Id, Name, cast(DateOfBirth as date)
		as DOB
		from EmployeeWithDates)

select * from fn_GetEmployees()

--multi-state puhul peab defineerima uue tabeli veerud kood muutujatega 
--funktsiooni nimi on fn_MS_GetEmployees()
--peab edastama meile Id, Name, DOB tabelist EmployeeWithDates

create function fn_MS_GetEmployees()
returns @Table Table (Id int, Name nvarchar(20), DOB date)
as begin
	insert into @Table
	select Id, Name, cast(DateOfBirth as date) from EmployeeWithDates
	return
end

select * from fn_MS_GetEmployees()

--inline tabeli funktsioonid on paremini töötamas kuna käsitletakse vaatena
--multi puhul on pm tegemist stored proceduriga ja kulutab ressurssi rohkem

--muudame andmied ja vaatame, kas inline funktsioonis on muutused kajastatud
update fn_GetEmployees() set Name = 'Sam1' where Id = 1
select * from fn_MS_GetEmployees() --saab muuta andmeid

update fn_MS_GetEmployees() set Name = 'Sam2' where Id = 1
--ei saa muuta andmeid multi state funktsioonis,
--kuna see on nagu stored procedure

--deterministic vs non-deterministic functions
--deterministlic funktsioonid annavad alati sama tulemuse, kui sisend on sama
select count(*) from EmployeeWithDates
select square(4)

--non-deterministic fuktsioonid annavad erineva tulemuse, kui sisend on sama
select getdate()
select current_timestamp
select rand()

---
--AdventureWorksLY2019 tunni töö

--GetAllCustomers_ITVF
create function fn_GetAllCustomers_ITVF()
returns table as
return (select * from SalesLT.Customer)

select * from fn_GetAllCustomers_ITVF()

--GetCustomerByID_ITVF
create function fn_GetCustomerByID_ITVF(@CustomerID int)
returns table as
return (select FirstName, LastName from SalesLT.Customer
where CustomerID = @CustomerID)

select * from fn_GetCustomerByID_ITVF(1) --numbrit saab muuta vastavalt soovile

--GetOrdersByCustomer_ITVF
create function GetOrdersByCustomer_ITVF(@CustomerID int)
returns table as
return (select * from SalesLT.SalesOrderHeader 
where CustomerID = CustomerID)

select * from GetOrdersByCustomer_ITVF(1)

--GetProductsByPrice_ITVF
create function GetProductsByPrice(@MinPrice int, @MaxPrice int)
returns table as
return (select * from SalesLT.Product 
where (ListPrice between @MinPrice and @MaxPrice))

select * from GetProductsByPrice(50, 100)

--loome funktsiooni
create function fn_GetNameById(@id int)
returns nvarchar(30)
as begin
	return (select Name from EmployeesWithDates where Id = @id)
end

--kasutame funktsiooni, leides Id 1 all olev inimene
select dbo.fn_GetNameById(1)

select * from EmployeesWithDates

--saab näha functsiooni sisu
sp_helptext fn_GetNameById

--nüüd muudate funktsiooni nimega fn_GetNameById
--ja panete sinna encryption, et keegi peale teie ei saaks sisu näha
alter function fn_GetNameById(@id int)
returns nvarchar(30)
with encryption
as begin
	return (select Name from EmployeesWithDates where Id = @id)
end

--kui nüüdsp_helptexti kasutada, siis ei näe funktsiooni sisu
sp_helptext fn_GetNameById

--kas´utame schemabindingut, et näha, mis on funktsiooni sisu
alter function dbo.fn_GetNameById(@id int)
returns nvarchar(30)
with schemabinding
as begin
	return (select Name from dbo.EmployeesWithDates where Id = @id)
end

--schemabinding tähendab, et kui keegi üritab muuta EmployeesWithDates
--tabelist, siis ei lase seda teha, kuna see on seotud
--fn_GetNameById funktsiooniga

--ei saa kustutada ega muuta tabelit EmployeesWithDates,
--kuna see on seotud fn_GetNameById funktsiooniga
drop table dbo.EmployeesWithDates

--temporary tables
--see on olemas ainult selle sessiooni jooksul
--kasutatakse # sümbolit, et saada aru, et tegemist on temporary tabeliga
create table #PersonDetails (Id int, Name nvarchar(20))

insert into #PersonDetails values (1, 'Sam')
insert into #PersonDetails values (2, 'Pam')
insert into #PersonDetails values (3, 'John')

select * from #PersonDetails

--temporary tabelite nimekirja ei näe, kui kasutada sysobjects
--tabelit, kuna need on ajutised
select Name from sysobjects
where name like '#PersonDetails%'

--kustutame temporary tabeli
drop table #PersonDetails

--loome sp, mis loob temporary tabeli ja paneb sinna andmed
create proc spCreateLocalTempTable
as begin
create table #PersonDetails (Id int, Name nvarchar(20))

insert into #PersonDetails values (1, 'Sam')
insert into #PersonDetails values (2, 'Pam')
insert into #PersonDetails values (3, 'John')

select * from #PersonDetails
end

exec spCreateLocalTempTable

--globaalne temp tabel on olemas kogu
--serveris ja kõigile kasutajatele, kes on ühendatud
create table ##GlobalPersonDetails (Id int, Name nvarchar(20))

--index
create table EmployeeWithSalary
(
	Id int primary key,
	Name nvarchar(20),
	Salary int,
	Gender nvarchar(10)
)

insert into EmployeeWithSalary(Id, Name, Salary, Gender)
values (1, 'Sam', 2500, 'Male'),
(2, 'Pam', 6500, 'Female'),
(3, 'John', 4500, 'Male'),
(4, 'Sara', 5500, 'Female'),
(5, 'Todd', 3100, 'Male')

select * from EmployeeWithSalary

--otsime inimesi, kelle palgavahemik on 5000 kuni 7000
select * from EmployeeWithSalary 
where Salary between 5000 and 7000

--loome indeksi Salary veerule, et kiirendada otsingut
--mis asetab andmed Salary veeru järgi järjestatult
create index IX_EmployeeSalary on EmployeeWithSalary(Salary asc)

--saame teada, et mis on selle tabeli primaarvõti ja index
exec sys.sp_helpindex @objname = 'EmployeeWithSalary'

--tahaks IX_EmployeeSalary indeksi kasutada, et otsing oleks kiirem
select * from EmployeeWithSalary 
where Salary between 5000 and 7000

--n'itab, et kasutatakse indeksi IX_EmployeeSalary
--kuna see on järjestatud Salary veeru järgi
select * from EmployeeWithSalary with (index(IX_EmployeeSalary))

--indeksi kustutamine
drop index IX_EmployeeSalary on EmployeeWithSalary --1 var
drop index EmployeeWithSalary.IX_EmployeeSalary --2 var

---indexi tüübid:
--1. Klastrites olevad
--2. Mitte-klastris olevad
--3. Unikaalsed
--4. Filtreeritud
--5. XML
--6. Töistekst
--7. Ruumiline
--8. Veerusäilitav
--9. Veergude indeksid
--10. Välja arvatud veeruga indeksid

--klastris olev indeks määrab ära tabelis oleva füüsilise järjestuse
--ja selle tulemusel saab tabelis olla ainult üks klastris olev indeks

create table EmployeeCity
(
	Id int primary key,
	Name nvarchar(20),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(50)
)

exec sp_helpindex EmployeeCity

--andmete õige järjestuse loovad klastris olevad indeksid
--ja kasutab selleks Id nr-t
--põhjus, miks antud juhul kasutab Id-d, tuleneb primaarvõtmest
insert into EmployeeCity values(3, 'John', 4500, 'Male', 'New York')
insert into EmployeeCity values(1, 'Sam', 2500, 'Male', 'London')
insert into EmployeeCity values(4, 'Sara', 5500, 'Female', 'Tokyo')
insert into EmployeeCity values(5, 'Todd', 3100, 'Male', 'Toronto')
insert into EmployeeCity values(2, 'Pam', 6500, 'Male', 'Sydney')

--klastris olevad indeksid dikteerivad säilitatud andmete järjestuse tabelis
--ja seda saab klastrite puhul olla ainult üks

select * from EmployeeCity
create clustered index IX_EmployeeCityName
on EmployeeCity(Name)
--põhjus, miks ei saa luua klastris olevat
--indeksit Name veerule, on see, et tabelis on juba klastris
--olev indeks Id veerul, kuna see on primaarvõti

--loome composite indeksi, mis tähendab, et see on mitme veeru indeks
--enne tuleb kustutada klastris olev indeks, kuna composite indeks
--on klastris olev indeksi tüüp
create clustered index IX_EmployeeGenderSalary
on EmployeeCity(Gender desc, Salary asc)
--kui teed select päringu sellele tabelile, siis peaksid nägema andmeid,
--mis on järjestatud selliselt: Esimeseks võetakse aluseks Gender veerg
--kahanevas järjestuses ja siis Salary veerg tõusvas järjestuses

select * from EmployeeCity

--mitte klastris olev indeks on eraldi struktuur,
--mis hoiab indeksi veeru väärtusi
create nonclustered index IX_EmployeeCityName
on EmployeeCity(Name)
--kui nüüd teed select päringu, siis näed, et andmed on
--järjestatud Id veeru järgi 
select * from EmployeeCity

---erinevused kahe indeksi vahel
--1. ainult üks klastris olev indeks saab olla tabeli peale,
--miite-klastris olevaid indekseid saab olla mitu
--2. klastris olevad indeksid on kiiremad kuna indeks peab tagasi
--viitama tabelile Juhul, kui selekteeritud veerg ei ole olemas indeksis
--3. Klastris olev indeks määratleb ära tabeli ridade salvestusjärjestuse
--ja ei nõua kettal lisa ruumi. Samas mitte klastris olevad indeksid on
--salvestatud tabelist eraldi ja nõuab lisa ruumi

create table EmployeeFirstName
(
	Id int primary key,
	FirstName nvarchar(20),
	LastName nvarchar(20),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(50)
)

exec sp_helpindex EmployeeFirstName

insert into EmployeeFirstName values(1, 'John', 'Smith', 4500, 'Male', 'New York')
insert into EmployeeFirstName values(1, 'Mike', 'Sandoz', 2500, 'Male', 'London')

drop index EmployeeFirstName.PK__Employee__3214EC076493A170
--kui käivitada ülevalpool oleva koodi, siis tuleb veateade
--et SQL server kasutab UNIQUE indeksit jõustamaks väärtuste
--unikaalsust ja primaarvõtit koodiga Unikaalseid Indekseid
--ei saa kustutada, aga käsitsi saab

create unique nonclustered index UIX_Employee_FirstName_LastName
on EmployeeFirstName(FirstName, LastName)

--lisame uue piirangu peale
alter table EmployeeFirstName
add constraint UQ_EmployeeFirstNameCity
unique nonclustered (City)

--sisestage kolmas rida andmetega, mis on id-3, FirstName-s John,
--LastName-s Menco ja linn on London

insert into EmployeeFirstName values(3, 'John', 'Menco', 3500, 'Male', 'London')

--saab vaadata indeksite infot
exec sp_helpconstraint EmployeeFirstName

--1. Vaikimisi primaarvõti loob unikaalse klastris oleva indeksi,
--samas unikaalne piiran loob unikaalse mitte-klastris oleva indeksi
--2. Unikaalset indeksit või piirangut ei saa luua olemasolevasse tabelis
--kui tabel juba sisaldab väärtusi võtmeveerus
--3. Vaikimisi korduvaid väärtuseid ei ole veerus lubatud,
--kui peaks olema unikaalne indeks või piirang. Nt, kui tahad sisestada
--10 rida andmeid, millest 5 sisaldavad korduvaid andmeid,
--siis kõik 10 lükatakse tagasi. Kui soovin ainult 5 
--rea tagasi lükkamist ja ülejäänud 5 rea sisestamist, siis selleks 
--kasutatakse IGNORE_DUP_KEY

--näide
create unique index IX_EmployeeFirstName
on EmployeeFirstName(City)
with ignore_dup_key

insert into EmployeeFirstName values(5, 'John', 'Menco', 3512, 'Male', 'London1')
insert into EmployeeFirstName values(6, 'John', 'Menco', 3123, 'Male', 'London2')
insert into EmployeeFirstName values(6, 'John', 'Menco', 3220, 'Male', 'London2')
--enne ignore käsku oleks kõik kolm rida tagasi lükatud, aga
--nüüd läks keskmine rida läbi kuna lina nimi oli unikaalne
select * from EmployeeFirstName

--view on virtuaalne tabel, mis on loodud ühe või mitme tabeli põhjal
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.Id = Employees.DepartmentId

create view vw_EmployeesByDetails
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.Id = Employees.DepartmentId
--otsige ülesse view 

--kuidas view-d kasutada: vw_EmployeesByDetails
select * from vw_EmployeesByDetails
--view ei salvesta andmeid vaikimisi
--seda tasub võtta, kui salvestatud virtuaalse tabelina

--milleks vaja:
--saab kasutada andmebaasi skeemi keerukuse lihtsutamiseks
--mitte IT-inimesele
--piiratud ligipääs andmetele, ei näe kõiki veerge 

--teeme view, mis näeb ainult IT-töötajaid
create view vITEmployeesInDepartment
as
select FirstName, Salary, Gender, DepartmentName
from Employees
join Department
on Department.Id = Employees.DepartmentId
where Department.DepartmentName = 'IT'
--ülevalpool olevat päringut saab liigitada reataseme turvalisuse
--alla. Tahan ainult näidata IT osakonna töötajaid

select * from vITEmployeesInDepartment

--veeru taseme turvalisus 
--peale selecti määratled veergude näitamise ära 
create view vEmployeesInDepartmentSalaryNoShow
as
select FirstName, Gender, DepartmentName
from Employees
join Department
on Employees.DepartmentId = Department.Id

select * from vEmployeesInDepartmentSalaryNoShow

--saab kasutada esitlemaks koondandmeid ja üksikasjalike andmeid
--view, mis tagastab summeeritud andmeid 
create view vEmployeesCountByDepartment
as
select DepartmentName, count(Employees.Id) as TotalEmployees
from Employees
join Department
on Employees.DepartmentId = Department.Id
group by DepartmentName

select * from vEmployeesCountByDepartment

--kui soovid vaadata view sisu
sp_helptext vEmployeesCountByDepartment
--kui soovid muuta, siis kasutad alter view

--kui soovid kustutada, siis asutad drop view
drop view vEmployeesCountByDepartment

--andmete uuendamine läbi view 
create view vEmployeesDataExceptSalary
as
select Id, FirstName, Gender, DepartmentId
from Employees 

update vEmployeesDataExceptSalary
set[FirstName] = 'Pam' where Id = 2

select * from Employees

--kustutage Id 2 rida ära
delete from vEmployeesDataExceptSalary where Id = 2
--andmete sisestamine läbi view: vEmployeesDataExceptSalary
--Id 2, Female, osakond 2, ja nimi on Pam
insert into vEmployeesDataExceptSalary(Id, FirstName, Gender, DepartmentId)
values(2, 'Pam', 'Female', 2)

--indekseeritud view 
--MS SQL-s on indekseeritud view nime all ja 
--Oracles materjaliseeritud view nimega 

create table Product
(
Id int primary key,
Name nvarchar(20),
UnitPrice int
)

Insert into Product(Id, Name, UnitPrice)
values(1, 'Books', 20),
(2, 'Pens', 14),
(3, 'Pencils', 11),
(4, 'Clips', 10)

select * from Product

create table ProductSales
(
Id int,
QuantitySold int
)

Insert into ProductSales(Id, QuantitySold)
values(1, 10), 
(2, 23),
(3, 21),
(4, 12),
(5, 13),
(6, 12),
(7, 13),
(8, 11),
(9, 12),
(10, 14)

select * from ProductSales

--loome view, mis annab meile veerud TotalSales ja TotalTransaction

create view vTotalSalesByProduct
with schemabinding
as
select Name,
sum(isnull((QuantitySold * UnitPrice), 0)) as TotalSales,
count_big(*) as TotalTransactions
from dbo.ProductSales
join dbo.Product
on dbo.Product.Id = dbo.ProductSales.Id
group by Name

select * from vTotalSalesByProduct

--kui soovid luua indeksi view sisse, siis peab järgima teatud reegleid
--1. view tuleb luua koos schemabinding-ga
--2. kui lisafunktsioon select list viitab väljendile ja selle tulemuseks
--võib olla NULL, siis asendusväärtus peaks olema täpsustatud.
--Antud juhul kasutasime ISNULL funktsiooni asendamaks NULL väärtust
--3. kui GroupBy non täpsustatud, siis view select list peab
--sisaldama COUNT_BIG(*) väljendit
--4. Baastabelis peaksid view-d olema viidatud kaheosalise nimega
--ehk antud juhul dbo.Product ja dbo.ProductSales.

create unique clustered index UIX_vTotalSalesByProduct_Name
on vTotalSalesByProduct(Name)

select * from vTotalSalesByProduct

--view piirangud
create view vEmployeeDetails
@Gender nvarchar(20)
as
Select Id, FirstName, Gender,DepartmentId
from Employees
where Gender = @Gender
--mis on sellel views valesti???
--vaatesse ehk view-sse ei saa kaasa panna parameetreid ehk antud juhul Gender

--teha funktsioon, kus parameetriks on Gender
--soovin näha veerge: Id, FirstName, Gender,DepartmentId
--tabeli nimi on Employees
--funktsiooni nimi fnEmployeeDetails

create function fnEmployeesDetails(@Gender nvarchar(20))
returns table
as return
(select Id, FirstName, Gender, DepartmentId
from Employees where Gender = @Gender)

--kasutame funktsiooni fnEmployeeDetails koos parameetriga
select * from fnEmployeesDetails('Male')

--order by kasutamine
create view vEmployeeDetailsStored
as
select Id, FirstName, Gender, DepartmentId 
from Employees
order by Id
--order by-d ei saa kasutada

--temp tabeli kasutamine
create table ##TestTempTable
(Id int, FirstName nvarchar(20), Gender nvarchar(20))

insert into ##TestTempTable values(101, 'Mart', 'Male')
insert into ##TestTempTable values(102, 'Joe', 'Female')
insert into ##TestTempTable values(103, 'Pam', 'Female')
insert into ##TestTempTable values(104, 'James', 'Male')

--view nimi on vOnTempTable
--kasutame ##TestTempTable
create view vOnTempTable
as
select Id, FirstName, Gender
from ##TestTempTable
--view-id ja funktsioone ei saa teha ajutistile tabelitele

--Triggerid

--DML trigger
--kokku on kolme tüüpi: DML, DDL ja LOGON

--trigger on stored procedure eriliik, mis automaatselt käivitub,
--kui mingi tegevus 
--peaks andmebaasis aset leidma

--DML - data manipulation language
--DML-i põhilised käsklused: insert, update ja delete

--DML triggereid saab klassifitseerida kahte tüüpi:
--1. After trigger (kutsutakse ka FOR triggeriks)
--2. Instead of trigger (selmet trigger ehk selle asemel trigger)

--after trigger käivitub peale sündmust, kui kuskil on tehtud insert,
--update ja delete

--loome uue tabeli
create table EmployeeAudit
(
Id int identity(1, 1) primary key,
AuditData nvarchar(1000)
)

--peale iga töötaja sisestamist tahame teada saada töötaja Id-d,
--päeva ning aega(millal sisestati)
--kõik andmed tulevad EmployeeAudit tabelisse
--andmeid sisestame Employees tabelisse

create trigger trEmployeeForInsert
on Employees
for insert
as begin
declare @Id int
select @Id = Id from inserted
insert into EmployeeAudit
values ('New employee with Id = ' + cast(@Id as nvarchar(5)) + ' is added at '
+ cast(getdate() as nvarchar(20)))
end

select * from Employees

insert into Employees values
(11, 'Bob', 'Blob', 'Bomb', 'Male', 3000, 1, 3, 'bob@bob.com')
go
select * from EmployeeAudit

--delete trigger
create trigger trEmployeesForDelete
on Employees
for delete
as begin
	declare @Id int
	select @Id = Id from deleted

	insert into EmployeeAudit
	values('An existing employee with Id = ' + cast(@Id as nvarchar(5)) +
	' is deleted at ' + cast(getdate() as nvarchar(20)))
end

delete from Employees where Id = 11
select * from EmployeeAudit

--update trigger
create trigger trEmployeeForUpdate
on Employees
for update
as begin
	--muutujate deklareerimine
	declare @Id int
	declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	declare @OldSalary int, @NewSalary int
	declare @OldDepartmentId int, @NewDepartmentId int
	declare @OldManagerId int, @NewManagerId int
	declare @OldFirstName nvarchar(20), @NewFirstName nvarchar(20)
	declare @OldMiddleName nvarchar(20), @NewMiddleName nvarchar(20)
	declare @OldLastName nvarchar(20), @NewLastName nvarchar(20)
	declare @OldEmail nvarchar(50), @NewEmail nvarchar(50)

	---muutuja, kuhu läheb lõpptekst
	declare @AuditString nvarchar(1000)

	-- laeb kõik uuendatud andmed temp tabeli alla
	select * into #TempTable
	from inserted

	-- käib läbi kõik andmed temp tabelist
	while(exists(select Id from #TempTable))
	begin
		set @AuditString = ''
		-- selekteerib esimese rea andmed temp tabel-st
		select top 1 @Id = Id, @NewGender = Gender,
		@NewSalary = Salary, @NewDepartmentId = DepartmentId,
		@NewManagerId = ManagerId, @NewFirstName = FirstName,
		@NewMiddleName = MiddleName, @NewLastName = LastName,
		@NewEmail = Email
		from #TempTable
		--võtab vanad andmed kustutatud tabelist
		select @OldGender = Gender,
		@OldSalary = Salary, @OldDepartmentId = DepartmentId,
		@OldManagerId = ManagerId, @OldFirstName = FirstName,
		@OldMiddleName = MiddleName, @OldLastName = LastName,
		@OldEmail = Email
		from deleted where Id = @Id

		---rida 1677
		---tund 14
		---30.04.26
		--hakkab võrdlema igat muutujat, et kas toimus andmete muutus
		set @AuditString = 'Employee with Id = ' + cast(@Id as nvarchar(4)) + ' changed '
		if(@OldGender <> @NewGender)
			set @AuditString = @AuditString + ' Gender from ' + @OldGender + ' to ' +
			@NewGender

		if(@OldSalary <> @NewSalary)
			set @AuditString = @AuditString + ' Salary from ' + cast(@OldSalary as nvarchar(20)) + ' to ' +
			cast(@NewSalary as nvarchar(20))

		if(@OldDepartmentId <> @NewDepartmentId)
			set @AuditString = @AuditString + ' DepartmentId from ' + cast(@OldDepartmentId as nvarchar(20)) + ' to ' +
			cast(@NewDepartmentId as nvarchar(20))

		if(@OldManagerId <> @NewManagerId)
			set @AuditString = @AuditString + ' ManagerId from ' + cast(@OldManagerId as nvarchar(20)) + ' to ' +
			cast(@NewManagerId as nvarchar(20))

		if(@OldFirstName <> @NewFirstName)
			set @AuditString = @AuditString + ' FirstName from ' + @OldFirstName + ' to ' +
			@NewFirstName

		if(@OldMiddleName <> @NewMiddleName)
			set @AuditString = @AuditString + ' Middlename from ' + @OldMiddleName + ' to ' +
			@NewMiddleName

		if(@OldLastName <> @NewLastName)
			set @AuditString = @AuditString + ' Lastname from ' + @OldLastName + ' to ' +
			@NewLastName

		if(@OldEmail <> @NewEmail)
			set @AuditString = @AuditString + ' Email from ' + @OldEmail + ' to ' +
			@NewEmail

		insert into dbo.EmployeeAudit values (@AuditString)
		--kustutab temp tabelist rea
		delete from #TempTable where Id = @Id
	end
end
--triggeri lõpp

update Employees set FirstName = 'test123', Salary = 4000, MiddleName = 'test456'
where Id = 10

select * from Employees
select * from EmployeeAudit
----

--instead of trigger
create table Employee
(
Id int primary key,
Name nvarchar(30),
Gender nvarchar(10),
DepartmentId int
)

insert into Employee(Id, Name, Gender, DepartmentId)
values(1, 'John', 'Male', 3),
(2, 'Mike', 'Male', 2),
(3, 'Pam', 'Female', 1),
(4, 'Todd', 'Male', 4),
(5, 'Sara', 'Female', 1),
(6, 'Ben', 'Male', 3)

select * from Employee

create view vEmployeeDetails
as
select Employee.Id, Name, Gender, DepartmentName
from Employee
join Department
on Employee.DepartmentId = Department.Id

select * from vEmployeeDetails

--tuleb veateade
insert into vEmployeeDetails values(7, 'Valarie', 'Female', 'IT')

--nüüd proovime lahendada probleemi, kui kasutame instead of trigger-it
create trigger tr_vEmployeeDetails_InsteadOfInsert
on vEmployeeDetails
instead of insert
as begin
	declare @DeptId int

	select @DeptId = dbo.Department.Id
	from Department 
	join inserted 
	on inserted.DepartmentName = Department.DepartmentName

	if(@DeptId is null)
		begin 
		raiserror('Invalid department name. statement terminated', 16, 1)
	end

	insert into dbo.Employee(Id, Name, Gender, DepartmentId)
	select Id, Name, Gender, @DeptId
	from inserted
end
--raiserror funktsioon
--selle eesmärk on tuua välja veateade, kui DepartmentName veerus ei ole väärtust
--ja ei klapi uue sisestatud väärtustega.
--Esimene on parameeter ja veateate sisu, teine on veataseme nr 
--(nr 16 tähendab üldiseid vigu) ja kolmas on olek

--nüüd saab l'bi view sisestada andmeid
insert into vEmployeeDetails values(7, 'Valarie', 'Female', 'IT')

--uuendame andmeid
update vEmployeeDetails 
set Name = 'Johnny', DepartmentName = 'IT'
where Id = 1
--ei saa uuendada andmeid kuna mitu tabelit on sellest mõjutatud

update vEmployeeDetails
set DepartmentName = 'IT'
where Id = 1

select * from vEmployeeDetails

--instead of Update trigger
create trigger tr_vEmployeeDetails_InsteadOfUpdate
on vEmployeeDetails
instead of update
as begin

	if(update(Id))
	begin
		raiserror('Id cannot be changed', 16, 1)
		return
	end

	if(update(DepartmentName))
	begin
		declare @DeptId int
		select @DeptId = Department.Id
		from Department
		join inserted
		on inserted.DepartmentName = Department.DepartmentName

		if(@DeptId is null)
		begin
			raiserror('Invalid Department Name', 16, 1)
			return
		end

		update Employee set DepartmentId = @DeptId
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end

	if(update(Gender))
	begin
		update Employee set Gender = inserted.Gender
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end

	if(update(Name))
	begin
		update Employee set Name = inserted.Name
		from inserted
		join Employee
		on Employee.Id = inserted.id
	end
end

--uuendame andmeid, kasutada view
--uuendada seal, kus Id on 1
update Employee set Name = 'John123', Gender = 'Male', DepartmentId = 3
where Id = 1

select * from vEmployeeDetails

--delete trigger
create view vEmployeeCount
as
select DepartmentId, DepartmentName, count(*) as TotalEmployees
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentId

select * from vEmployeeCount

--vaja teha päring, kus on töötajaid 2tk või rohkem
--kasutada vEmployeeCount

select * from vEmployeeCount where TotalEmployees >= 2

--
select DepartmentName, DepartmentId, count(*) as TotalEmployees
into #TempEmployeeCount
from Employee
join Department
on Employee.DepartmentId = Department.Id
group by DepartmentName, DepartmentId

select * from #TempEmployeeCount

--läbi ajutise tabeli saab samu andmeid vaadata, kui seal on info olemas
select DepartmentName, TotalEmployees from #TempEmployeeCount
where TotalEmployees >= 2

--tuleb teha trigger nimega trEmployeeDetails_InsteadOfDelete
--ja kasutada vEmployeeDetails
--triggeri tüüp on instead of delete
create trigger trEmployeeDetails_InsteadOfDelete
on vEmployeeDetails
instead of delete
as begin
	delete Employee
	from Employee
	join deleted
	on Employee.Id = deleted.Id
end

delete from vEmployeeDetails where Id = 7

select * from Employee

--CTE ehk common table expression

--CTE näide
with EmployeeCount(DepartmentName, DepartmentId, TotalEmployees)
as
	(
	select DepartmentName, DepartmentId, count(*) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName, DepartmentId
	)
select DepartmentName, TotalEmployees
from EmployeeCount
where TotalEmployees >= 2

--CTE-d võivad sarnaneda temp tabeliga
--sarnane päritud tabelile ja ei ole salvestatud objektina
--ning kestab päringu ulatuses

--päritud tabel
select DepartmentName, TotalEmployees
from
(
	select DepartmentName, DepartmentId, count(*) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName, DepartmentId
)
as EmployeeCount
where TotalEmployees >= 2

--tehke päring, kus on kaks CTE päringut sees
with EmployeeCountBy_Payroll_IT_Dept(DepartmentName, Total)
as
(
	select DepartmentName, count(Employee.Id) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	where DepartmentName in ('Payroll', 'IT')
	group by DepartmentName
),
EmployeeCountBy_HR_Admin_Dept(DepartmentName, Total)
as
(
	select DepartmentName, count(Employee.Id) as TotalEmployees
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
	group by DepartmentName
)
--kui on kaks CTE-d, siis unioni abil ühendab päringu
select * from EmployeeCountBy_Payroll_IT_Dept
union
select * from EmployeeCountBy_HR_Admin_Dept

--teha CTE päring nimega EmployeeCount
--järjestaks DepartmentName järgi ära
with EmployeeCount(DepartmentId, TotalEmployees)
as
(
	select DepartmentId, count(Employee.Id) as TotalEmployees
	from Employee
	group by DepartmentId
)
--select 'Hello'
--peale CTE-d peab kohe tulema käsklus SELECT, INSERT, UPDATE või DELETE
--kui proovid midagi muud, siis tuleb veateade
select DepartmentName
from Department
join Employee
on Department.Id = Employee.DepartmentId
order by DepartmentName

--uuendame CTE-s

--lihtne CTE
with Employees_Name_Gender
as
(
	select Id, Name, Gender from Employee
)
select * from Employees_Name_Gender

--kasutame JOIN-i CTE tegemiseks
with EmployeesByDepartment
as
(
	select Employee.Id, Employee.Name, Department.DepartmentName
	from Employee
	join Department
	on Employee.DepartmentId = Department.Id
)
select * from EmployeesByDepartment

--nüüd muudame andmeid CTE-s
with EmployeesByDepartment
as
(
	select Employee.Id, Employee.Name, Gender, DepartmentName
	from Employee
	join Department
	on Department.Id = Employee.DepartmentId
)
update EmployeesByDepartment set Gender = 'Male' where Id = 1

--kasutage eelmist CTE andmete muutmiseks,
--aga seekord muutke Id 1 töötaja Gender female peale ja
--DepartmentName PayRoll peale
with EmployeesByDepartment
as
(
	select Employee.Id, Employee.Name, Gender, DepartmentName
	from Employee
	join Department
	on Department.Id = Employee.DepartmentId
)
update EmployeesByDepartment set Gender = 'Female', DepartmentName = 'Payroll' 
where Id = 1
--ei luba mitmes tabelis korraga andmeid muuta, kui on tegemist CTE-ga

--kokkuvõtte CTE-st
--1. kui CTE baseerub ühel tabelil, siis uuendus töötab
--2. kui CTE baseerub mitmel tabelil, siis tuleb veateade
--3. kui CTE baseerub mitmel tabelil ja tahame muuta ainult ühte tabelit,
--siis uuendus saab tehtud

--korduv CTE
--CTE, misiseendale viitab, kutsutakse korduvaks CE-ks
--kui tahad andmeid näidata hierarhiliselt
Create Table Employee
(
	EmployeeId int Primary key,
	Name nvarchar(20),
	ManagerId int
)

Insert into Employee (EmployeeId, Name, ManagerId)
values(1, 'Tom', 2),
(2, 'Josh', NULL),
(3, 'Mike', 2),
(4, 'John', 3),
(5, 'Pam', 1),
(6, 'Mary', 3),
(7, 'James', 1),
(8, 'Sam', 5),
(9, 'Simon', 1)

select * from Employee
--kasutame left joini, et näha kõiki töötajaid ja nende juhte
select Emp.Name as [Employee Name],
isnull(Manager.Name, 'Super Boss') as [Manager Name]
from dbo.Employee Emp
left join Employee Manager
on Emp.ManagerId = Manager.EmployeeId

--peab samasuguse tulemuse saavutama, aga kasutage CTE-d
--seal sees kasutab joini koos union all
with EmployeeCTE(Id, Name, ManagerId, [Level])
as
(
	select Employee.EmployeeId, Name, ManagerId, 1
	from Employee
	where ManagerId is null

	union all

	select Employee.EmployeeId, Employee.Name, Employee.ManagerId,
	EmployeeCTE.[Level] + 1
	from Employee
	join EmployeeCTE
	on Employee.ManagerId = EmployeeCTE.Id
)
select EmpCTE.Name as [Employee Name],
isnull(MgrCTE.Name, 'Super Boss') as [Manager Name],
EmpCTE.Level as  [Boss Level]
from EmployeeCTE EmpCTE
left join EmployeeCTE MgrCTE
on EmpCTE.ManagerId = MgrCTE.Id

--PIVOT
--mis on PIVOT?
--PIVOT os SQL-i operatsioon, mis võimaldab teisendada ridu veergudeks
create table Sales
(
	SalesAgent nvarchar(20),
	SalesCountry nvarchar(20),
	SalesAmount int
)

insert into Sales(SalesAgent, SalesCountry, SalesAmount)
values('Tom', 'UK', 200),
('John', 'US', 180),
('John', 'UK', 260),
('David', 'India', 450),
('Tom', 'India', 350),
('David', 'US', 200),
('Tom', 'US', 130),
('John', 'India', 540),
('John', 'UK', 120),
('David', 'UK', 220),
('John', 'UK', 420),
('David', 'US', 320),
('Tom', 'US', 340),
('Tom', 'UK', 660),
('John', 'India', 430),
('David', 'India', 230),
('David', 'India', 280),
('Tom', 'UK', 480),
('John', 'UK', 360),
('David', 'UK', 140)

select * from Sales

select SalesCountry, SalesAgent, sum(SalesAmount) as TotalSales
from Sales
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent

--kasuta pivotit, et saada sama tulemus nagu ülemises päringus
select SalesAgent, India, US, UK
from Sales
PIVOT
(
	sum(SalesAmount)
	for SalesCountry in (India, US, UK)
)
as PivotTable

--päring muudab unikaalsete veergude väärtust (India, US ja UK) SalesCountry veerus
--omaette veergudeks koos veergude SalesAmount liitmisega.

create table SalesWithId
(
	Id int primary key,
	SalesAgent nvarchar(20),
	SalesCountry nvarchar(20),
	SalesAmount int
)

insert into SalesWithId (Id, SalesAgent, SalesCountry, SalesAmount)
values(1, 'Tom', 'UK', 200),
(2, 'John', 'US', 180),
(3, 'John', 'UK', 260),
(4, 'David', 'India', 450),
(5, 'Tom', 'India', 350),
(6, 'David', 'US', 200),
(7, 'Tom', 'US', 130),
(8, 'John', 'India', 540),
(9, 'John', 'UK', 120),
(10, 'David', 'UK', 220),
(11, 'John', 'UK', 420),
(12, 'David', 'US', 320),
(13, 'Tom', 'US', 340),
(14, 'Tom', 'UK', 660),
(15, 'John', 'India', 430),
(16, 'David', 'India', 230),
(17, 'David', 'India', 280),
(18, 'Tom', 'UK', 480),
(19, 'John', 'UK', 360),
(20, 'David', 'UK', 140)

--tehke uuesti pivot, aga kasutage SalesWithId tabelit
select SalesAgent, India, US, UK
from SalesWithId
PIVOT
(
	sum(SalesAmount)
	for SalesCountry in (India, US, UK)
)
as PivotTable
--põhjuseks on Id veeru olemasolu SalesWithId, mida võetakse arvesse
--pööramise ja grupeerimise järgi

select SalesAgent, India, US, UK
from
(
	select SalesAgent, SalesCountry, SalesAmount
	from SalesWithId
)
as SourceTable
PIVOT
(
	sum(SalesAmount)
	for SalesCountry in (India, US, UK)
)
as PivotTable

--transactionind 
--transaction jälgib järgmisi samme: 
--1. selle algus
--2. käivitub DB käske
--3. kontrollib vigu- Kui on viga, siis taastab algse olek´u

create table MailingAddress
(
	Id int not null primary key,
	EmployeeNumber int,
	HouseNumber nvarchar(10),
	StreetAddress nvarchar(50),
	City nvarchar(50),
	PostalCode nvarchar(20)
)

insert into MailingAddress
values (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

create table PhysicalAddress
(
	Id int not null primary key,
	EmployeeNumber int,
	HouseNumber nvarchar(10),
	StreetAddress nvarchar(50),
	City nvarchar(50),
	PostalCode nvarchar(20)
)

insert into PhysicalAddress
values (1, 101, '#10', 'King Street', 'Londoon', 'CR27DW')

create proc spUpdateAddress
as begin
	begin try
		begin transaction
			update MailingAddress set City = 'LONDON'
			where MailingAddress.Id = 1 and EmployeeNumber = 101

			update PhysicalAddress set City = 'LONDON'
			where PhysicalAddress.Id = 1 and EmployeeNumber = 101
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch
end

--käivitame spUpdateAddress stored procedure-i
spUpdateAddress

select * from MailingAddress
select * from PhysicalAddress

--kui teine uuendus ei lähe läbi, siis esimene ei lähe ka läbi
--kõik uuendused peavad läbi minema


---transaction ACID test

--edukas transaction peab läbima ACID testi:
-- A - atomic e aatomlikus
-- C - consistent e järjepidevus
-- I - isolated e isoleeritus
-- D - durable e vastupidav

--- Atomic – kõik tehingud transactionis on kas edukalt täidetud või need
--- lükatakse tagasi. Nt, mõlemad käsud peaksid alati õnnestuma. Andmebaas
--- teeb sellisel juhul: võtab viimase update tagasi ja veeretab selle algasendisse
--- e taastab algsed andmed

--- Consistent – kõik transactioni puudutavad andmed jäetakse loogiliselt
--- järjepidevasse olekusse. Nt, kui laos saadaval olevaid esemeid hulka
--- vähendatakse, siis tabelis peab olema vastav kanne. Inventuur ei saa
--- lihtsalt kaduda

-- Isolated – transaction peab andmeid mõjutama, sekkumata teistesse
-- samaaegsetesse transactionitesse. See takistab andmete muutmist, mis
-- põhinevad sidumata tabelitel. Nt, muudatused kirjas, mis hiljem tagasi
-- muudetakse. Enamik DB-d kasutab tehingute isoleerimise säilitamiseks 
-- lukustamist.

-- Durable – kui muudatus on tehtud, siis see on püsiv. Kui süsteemiviga või 
-- voolukatkestus ilmneb enne käskude komplekti valmimist, siis tühistatakse 
-- need käsud ja andmed taastatakse algsesse olekusse. Taastamine toimub peale
-- süsteemi taaskäivitamist.

--subqueries e alamkäsud
--alamkäsud on SQL-i käsud, mis on pesastatud teise SQL-i käsu sisse

create table ProductSales
(
	Id int primary key identity,
	ProductId int foreign key references Product(Id),
	UnitPrice int,
	QuantitySold int
)

truncate table Product

Insert into ProductSales values(3, 450, 5)
Insert into ProductSales values(2, 250, 7)
Insert into ProductSales values(3, 450, 4)
Insert into ProductSales values(3, 450, 9)

select * from Product
select * from ProductSales

--kirjutame päringu, mis annab infot müümata toodetest
select Id, Name, Description
from Product
where Id not in (select ProductId from ProductSales)
--sulgude sees on subquery, mis tagastab kõik ProductId-d ProductSales tabelist

--enamus juhtudel saab subquery-t asendada JOIN-iga
--teha päring join-iga, et saada müümata toodete infot (left join)
select Product.Id, Product.Name, Description
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
where ProductSales.ProductId is NULL

--teeme subquery, kus kasutatakse selecti
select Name,
(select sum(QuantitySold) from ProductSales where ProductId = Product.Id) as
[Total Quantity]
from Product
order by Name

--sama tulemus, aga join-iga
select Product.Name,  Sum(ProductSales.QuantitySold) as [TotalQuantity]
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
group by Name
order by Name

--subqueryt saab subquery sisse panna
--subquery on alati sulgudes ja neid nimetatakse sisemisteks päringuteks

--rohkete andmetega testimise tabel

truncate table Product
truncate table ProductSales

select * from Product
select * from ProductSales

create table Product
(
Id int identity primary key,
Name nvarchar(50),
Description nvarchar(250)
)

create table ProductSales
(
Id int primary key identity,
ProductId int foreign key references Product(Id),
UnitPrice int,
QuantitySold int
)

--sisestame näidisandmed Product tabelisse
declare @Id int
set @Id = 1
while(@Id <= 3000000)
begin
	insert into Product values('Product - ' + cast(@Id as nvarchar(20)),
	'Product - ' + cast(@Id as nvarchar(20)) + ' Description')

	print @Id
	set @Id = @Id + 1
end

declare @RandomProductId int
declare @RandomUnitPrice int
declare @RandomQuantitySold int

-- ProductId
declare @LowerLimitForProductId int
declare @UpperLimitForProductId int

set @LowerLimitForProductId = 1
set @UpperLimitForProductId = 100000

--UnitPrice
declare @LowerLimitForUnitPrice int
declare @UpperLimitForUnitPrice int

set @LowerLimitForUnitPrice = 1
set @UpperLimitForUnitPrice = 100

--QuantitySold
declare @LowerLimitForQuantitySold int
declare @UpperLimitForQuantitySold int

set @LowerLimitForQuantitySold = 1
set @UpperLimitForQuantitySold = 10

declare @Counter int
set @Counter = 1

while(@Counter <= 4500000)
begin
	select @RandomProductId = round(((@UpperLimitForProductId -
	@LowerLimitForProductId) * RAND() + @LowerLimitForProductId), 0)

	select @RandomUnitPrice = round(((@UpperLimitForUnitPrice -
	@LowerLimitForUnitPrice) * RAND() + @LowerLimitForUnitPrice), 0)

	select @RandomQuantitySold = round(((@UpperLimitForQuantitySold -
	@LowerLimitForQuantitySold) * RAND() + @LowerLimitForQuantitySold), 0)

	insert into ProductSales
	values(@RandomProductId, @RandomUnitPrice, @RandomQuantitySold)

	print @Counter
	set @Counter = @Counter + 1
end

select * from Product
select * from ProductSales

--võrdleme subquerit ja JOIN-i
select Id, Name, Description
from Product
where Id in
(
select Product.Id from ProductSales
)
--3 milj rida 16 sek

--teeme cache puhtaks, et uut päringut ei oleks kuskile vahemällu salvestatud
checkpoint;
go
dbcc DROPCLEANBUFFERS; --puhastab päringu cache-i
go
dbcc FREEPROCCACHE; --puhastab täitva planeeritud cache-i
go

--teeme sama tabelite peale inner join päringu
--Product ja ProductSales
select Product.Id, Name, Description
from Product
inner join ProductSales
on Product.Id = ProductSales.ProductId
--285 tuhat rida 1 sekundiga
--teeme cahce puhtaks

select Id, Name, Description
from Product
where not exists
(
select * from ProductSales where  ProductId = Product.Id
)
--2.9 miljonit rida 15 sekundiga
-- vahemälu puhtaks teha
--kasutage left join-i ProductId is null

select Product.Id, Name, Description
from Product
left join ProductSales
on Product.Id = ProductSales.ProductId
where ProductSales.ProductId is NULL
--15 sek, 2,9 miljonit rida


---CURSOR-d

-- relatsiooniliste DB-de haldussüsteemid saavad väga hästi hakkama
-- SETS-ga. SETS lubab mitut päringut kombineerida üheks tulemuseks.
-- Sinna alla käivad UNION, INTERSECT ja EXCEPT.

update ProductSales set UnitPrice = 50
where ProductSales.ProductId = 101

-- Kui on vaja rea kaupa andmeid töödelda, siis kõige parem oleks kasutada
-- kursoreid. Samas on need jõudlusele halvad ja võimalusel vältida.
-- Soovitud oleks kasutada JOIN-i.

-- Kursorid jagunevad omakorda neljaks:
-- 1. Forward-Only e edasi-ainult
-- 2. Static e staatilised
-- 3. Keyset e võtmele seadistatud
-- 4. Dynamic e dünaamiline

-- Cursori näide
if the ProductName = 'Product - 55', set UnitPrice to 55

-- nüüd algab õige cursor
-------------------------
declare @ProductId int
-- deklareerime cursori
declare ProductIdCursor cursor for
select ProductId from ProductSales
-- open avaldusega täidab select avaldust
-- ja sisestab tulemuse
open ProductIdCursor

fetch next from ProductIdCursor into @ProductId
-- kui tulemuses on veel ridu, siis @@FETCH_STATUS on 0
while(@@FETCH_STATUS = 0)
begin
	declare @ProductName nvarchar(50)
	select @ProductName = Name from Product where Id = @ProductId

	if(@ProductName = 'Product - 55')
	begin
		update ProductSales set UnitPrice = 55 where ProductId = @ProductId
	end

	else if(@ProductName = 'Product - 65')
	begin
		update ProductSales set UnitPrice = 65 where ProductId  = @ProductId
	end

	else if(@ProductName = 'Product - 1000')
	begin
		update ProductSales set UnitPrice = 1000 where ProductId  = @ProductId
	end

	fetch next from ProductIdCursor into @ProductId
end

select * from Product

--vabastab rea seadistuse e suleb cursori
close ProductIdCursor
--vabastab ressursid, mis on seotud cursoriga
deallocate ProductIdCursor
--cursori käskluse lõpp

--vaatame, kas read on uuendatud
select Name, UnitPrice
from Product join
ProductSales on Product.Id = ProductSales.ProductId
where(Name = 'Product - 55' or Name = 'Product - 65' or Name = 'Product - 1000')

--asendame cursorid JOIN-ga
update ProductSales
set UnitPrice =
	case
		when Name = 'Product - 55' then 155
		when Name = 'Product - 65' then 165
		--võib kasutada like või =
		when Name like 'Product - 1000' then 10001
	end
from ProductSales
join Product
on Product.Id = ProductSales.ProductId
where Name = 'Product - 55' or Name = 'Product - 65' or Name like 'Product - 1000'

--vaatame tulemust
select Name, UnitPrice
from Product join
ProductSales on Product.Id = ProductSales.ProductId
where(Name = 'Product - 55' or Name = 'Product - 65' or Name = 'Product - 1000')

---tabelite info
--nimekiri süsteemi objectidest
select * from sysobjects where xtype = 'S'

--tabelite nimekiri
select * from sys.tables

--nimekiri tabelitest ja view-st
select * from INFORMATION_SCHEMA.TABLES

--kui soovid erinevaid objektitüüpe vaadata, siis kasuta XTYPE süntaksit
select distinct XTYPE from sysobjects

-- IT - internal table
-- P  - stored procedure
-- PK - primary key constraint
-- S  - system table
-- SQ - service queue
-- U  - user table
-- V  - view

--annab teada, kas sellise nimega tabel on olemas
if not exists (select * from INFORMATION_SCHEMA.TABLES where TABLE_NAME = 'Employee')
begin
	create table Employee
	(
	Id int primary key,
	Name nvarchar(30),
	ManagerId int
	)
	print 'Table has been created'
end
else
begin
	print 'Table already exists'
end

--saab kasutada ka sisseehitatud funktsiooni: OBJECT_ID()
if OBJECT_ID('Employee') is null
begin
	print 'Table created'
end
else
begin
	print 'Table already exists'
end

--tahame sama nimega tabeli ära kustutada ja siis uuesti luua
if OBJECT_ID('Employee') is not null
begin
	drop table Employee
end
create table Employee
(
	Id int primary key,
	Name nvarchar(30),
	ManagerId int 
)


















