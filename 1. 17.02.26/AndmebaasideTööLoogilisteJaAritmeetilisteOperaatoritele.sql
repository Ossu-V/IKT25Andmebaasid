--1. AND operaator
--Leia kõik tooted, mille hind on suurem kui 500 eurot ja kaal suurem kui 500 grammi
--Väljasta: ProductID, Name, ListPrice, Weight

Select ProductID, Name, ListPrice, Weight
from SalesLT.Product
where ListPrice > 500 AND Weight > 500

--2. OR ja NOT operaator
--Leia kõik tooted, mis kuuluvad kategooriasse „Mountain Bikes“ või „Road Bikes“, kuid mille nimi ei sisalda sõna „Women“.
--Väljasta: ProductID, Name
Select ProductID, SalesLT.Product.Name
from SalesLT.Product
where (Name = 'Mountain Bikes' or Name = 'Road Bikes' and name not like 'Women')

--3. Allahindlus
--Kuva kõik tooted koos 15% soodushinnaga.
--Väljasta: Name, LastPrice, DiscountPrice
Select Name,
(ListPrice * 0.15) as DiscountPrice
from SalesLT.Product

--4. Käibemaksu arvutamine
--Arvuta toodete hinnad koos 22% käibemaksuga.
--Väljasta; Name, ListPrice, PriceWithVAT
Select Name,
(ListPrice * 0.22) as PriceWithVAT
from SalesLT.Product

--5. Toote otsimine ID järgi
--Loo stored procedure, mis tagastab ühe toote andmed ProductID alusel. 
Create procedure spGetProductWithID
@ID int
as begin
	Select * from SalesLT.Product
	where ProductID = @ID
end 

execute spGetProductWithID @ID = 712

--6. Kategooria toodete nimekiri
--Loo stored procedure, mis kuvab kõik tooted etteantud kategooriast.
Create Procedure spGetProductByCategory
@CategoryID int
as begin
	Select * from SalesLT.Product
	where ProductCategoryID = @CategoryID
end

execute spGetProductByCategory @CategoryID = 20
