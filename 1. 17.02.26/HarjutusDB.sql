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