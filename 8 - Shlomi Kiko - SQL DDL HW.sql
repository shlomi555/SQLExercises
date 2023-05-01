--Shlomi Kiko - SQL DDL Homework

--1. Create a database by script name TEST
USE master
CREATE DATABASE TEST

--2. Create 3 tables: Products, Categories and Suppliers, use the table definitions and constraints as follows:
/*
Products:
a. PrdId int - with PK and identity that starts from 200 and adds 20 each time a new row gets inserted
b. PrdName nvarchar(40) NOT NULL
c. CreateDate Date - Default value is the current date
d. Price Money NOT NULL
e. SupId int - NOT NULL and FK referencing Suppliers table
f. CatId int NOT NULL and FK referencing Categories table

Categories:
a. CatId int - with PK and identity that starts from 1 and adds 1 each time a new row gets inserted
b. CatName nvarchar(40) NOT NULL and UNIQUE

Suppliers:
a. SupId int - with PK and identity that starts from 1 and adds 1 each time a new row gets inserted
b. SupName nvarchar(40) NOT NULL and UNIQUE
*/
USE TEST

CREATE TABLE Categories
(
	CatId int IDENTITY(1, 1) PRIMARY KEY,
	CatName nvarchar(40) NOT NULL UNIQUE
)

CREATE TABLE Suppliers
(
	SupId int IDENTITY(1, 1) PRIMARY KEY,
	SupName nvarchar(40) NOT NULL UNIQUE
)

CREATE TABLE Products
(
	PrdId int IDENTITY(200, 20) PRIMARY KEY,
	PrdName nvarchar(40) NOT NULL,
	CreateDate date DEFAULT(GETDATE()),
	Price money NOT NULL,
	SupId int NOT NULL FOREIGN KEY REFERENCES Suppliers(SupId),
	CatId int NOT NULL FOREIGN KEY REFERENCES Categories(CatId)
)

--3. Add a Unique constraint with a nickname to the column PrdName in the Products table
ALTER TABLE Products
ADD CONSTRAINT UQ_Products_PrdName UNIQUE (PrdName)

--4. Insert all:
/* 
a. Categories from Northwind DB, Categories table to TEST db Categories table
b. Suppliers from Northwind db, Suppliers table to TEST db Suppliers table
c. Products from Northwind db, Products table to TEST db Products table
*/
SET IDENTITY_INSERT TEST.dbo.Categories ON

INSERT INTO Categories (CatId, CatName)
SELECT CategoryId, CategoryName FROM NORTHWND.dbo.Categories

SET IDENTITY_INSERT TEST.dbo.Categories OFF

--5. Delete in one command all rows from the Products table
TRUNCATE TABLE Products

--6. Remove all tables from TEST db
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT all'

DECLARE @SQL nvarchar(MAX) = ''
SELECT @SQL += 'DROP TABLE ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'

EXEC SP_executeSQL @SQL

--7. Remove TEST db
USE MASTER

ALTER DATABASE TEST
SET single_user WITH ROLLBACK IMMEDIATE

DROP DATABASE TEST