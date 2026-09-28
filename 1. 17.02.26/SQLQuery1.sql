-- 1. Loo uus andmebaas
CREATE DATABASE HarjutusDB;
GO

-- Võtame loodud andmebaasi kasutusele
USE HarjutusDB;
GO

-- 2. Loo tabel Tootajad
CREATE TABLE Tootajad (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Nimi VARCHAR(100) NOT NULL,
    Amet VARCHAR(100),
    Palk DECIMAL(10, 2)
);
GO

-- 3. Loo järgmised login’id ja kasutajad:
-- Arendaja login ja kasutaja
CREATE LOGIN ArendajaLogin WITH PASSWORD = 'TurvalineParool123!';
CREATE USER ArendajaUser FOR LOGIN ArendajaLogin;
GO

-- Raamatupidaja login ja kasutaja
CREATE LOGIN RaamatupidajaLogin WITH PASSWORD = 'TurvalineParool456!';
CREATE USER RaamatupidajaUser FOR LOGIN RaamatupidajaLogin;
GO

-- Admini login ja kasutaja
CREATE LOGIN AdminLogin WITH PASSWORD = 'TurvalineParool789!';
CREATE USER AdminUser FOR LOGIN AdminLogin;
GO

--7. 
GRANT SELECT ON Tootajad TO ArendajaUser;
GO

--8.
GRANT SELECT, UPDATE ON Tootajad TO RaamatupidajaUser;
GO
--9.
ALTER ROLE db_owner ADD MEMBER AdminUser;
GO

--10.
-- Rolli loomine
CREATE ROLE Vaatajad;
GO

-- Rollile õiguse andmine
GRANT SELECT ON Tootajad TO Vaatajad;
GO

-- Kasutaja lisamine rolli
ALTER ROLE Vaatajad ADD MEMBER ArendajaUser;
GO

--11.
-- DENY tühistab igasuguse võimaluse andmeid kustutada, isegi kui see õigus tuleks kuskilt rollist
DENY DELETE ON Tootajad TO RaamatupidajaUser;
GO

--12.

-- 12.1 Luba SQL Serveri tasemel contained andmebaasid (seda peab tegema sysadmin õigustes)
EXEC sp_configure 'contained database authentication', 1;
RECONFIGURE;
GO

-- 12.3 Lülitame andmebaasi ühekordse kasutaja režiimi ja katkestame muud ühendused kohe (ROLLBACK IMMEDIATE)
ALTER DATABASE HarjutusDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- 12.4 Nüüd teeme muudatuse ära (see õnnestub, sest lukk on maas)
ALTER DATABASE HarjutusDB SET CONTAINMENT = PARTIAL;
GO

-- 12.5. Paneme andmebaasi tavarežiimi tagasi, et teised kasutajad saaksid ligi
ALTER DATABASE HarjutusDB SET MULTI_USER;
GO

-- Contained user luuakse otse andmebaasi sisse ilma serveritaseme LOGIN-ita
CREATE USER TestUser WITH PASSWORD = 'TestParool123!';
GRANT SELECT ON Tootajad TO TestUser;
GO

--13.
-- ArendajaUser test (Peab lubama ainult SELECTi)
EXECUTE AS USER = 'ArendajaUser';
SELECT * FROM Tootajad; -- ÕNNESTUB
UPDATE Tootajad SET Palk = 3000 WHERE ID = 1; -- VIGA (Keelatud)
REVERT; -- Naaseb administraatori õigustesse

-- RaamatupidajaUser test (Peab lubama SELECT ja UPDATE, aga DELETE on DENY)
EXECUTE AS USER = 'RaamatupidajaUser';
SELECT * FROM Tootajad; -- ÕNNESTUB
UPDATE Tootajad SET Palk = 3500 WHERE ID = 1; -- ÕNNESTUB
DELETE FROM Tootajad WHERE ID = 1; -- VIGA (Rangelt keelatud)
REVERT;

-- AdminUser test (Kuna on db_owner, siis õnnestub kõik)
EXECUTE AS USER = 'AdminUser';
SELECT * FROM Tootajad; -- ÕNNESTUB
DELETE FROM Tootajad WHERE ID = 1; -- ÕNNESTUB
REVERT;

-- TestUser test (Peab lubama ainult SELECTi)
EXECUTE AS USER = 'TestUser';
SELECT * FROM Tootajad; -- ÕNNESTUB
UPDATE Tootajad SET Palk = 2000 WHERE ID = 1; -- VIGA (Keelatud)
REVERT;