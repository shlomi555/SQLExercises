--Shlomi Kiko - SQL DML Homework

--1. Insert a new customer to the Customers table, assign all of the values to each of the columns without 
--   specifying the list of columns
INSERT INTO Customers VALUES('TEST', 'TestComp.Co', 'Mr Clean', 'CEO', 'Mitte strasse 32', 
'Berlin', NULL, '12209', 'Germany', '030-0074322', NULL)

--2. There was a mistake with the HireDate of employee number 4, his HireDate should be April 7, same year
UPDATE Employees
SET HireDate = '19930407'
WHERE EmployeeID = 4

--3. Change Product 58's name to your favorite drink and change the category to beverages
UPDATE p
SET p.ProductName = 'La Chouffe'
FROM Products AS p
WHERE p.ProductId = 58

UPDATE c
SET c.CategoryName = 'Beverages', c.Description = 'Alcoholic drinks'
FROM Categories AS c
INNER JOIN Products AS p
ON(c.CategoryID = p.CategoryID)
WHERE p.ProductID = 58

--4. Insert a new customer to the Customers table, assign all of the values to each of the columns, 
--   specify the list of columns
INSERT INTO Customers(CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country
, Phone, Fax)
VALUES
('Test2', 'Test2 Incorporated', 'Mr T', 'CFO', 'La ramblas 56', 'Barcelona', NULL, '08021', 'Spain', '(93) 203 4561', NULL)

--5. Insert a new customer to the Customers table, assign all of the values to each of the columns
--   For the Region column use NULL
INSERT INTO Customers(CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country
, Phone, Fax)
VALUES
('Test3', 'Test3 Incorporated', 'Mr H', 'COO', 'Grotehondstraat 12', 'Rotterdam', NULL, '08021', 'Netherlands', '(03) 203 4565', NULL)

--6. The company decided to stop working with supplier "Tokyo Traders", change all the related products 
--   to supplier "Mayumi's"
UPDATE p
SET p.SupplierId = (SELECT SupplierID FROM Suppliers WHERE CompanyName = 'Mayumi''s')
FROM Products AS p
WHERE p.SupplierID = (SELECT SupplierID FROM Suppliers WHERE CompanyName = 'Tokyo Traders')

--7. The customer "Fissa" decided to stop working with us, Remove his record from the table
DELETE FROM Customers
WHERE CustomerID = 'FISSA'

--8. A new employee joined the company, "Avi Coolness", Add a new record with the 
--   employeeId, FirstName, LastName, rest should be NULL
INSERT INTO Employees (FirstName, LastName) VALUES ('Avi', 'Coolness')

--9. Use the code below to create the NewSuplliers table:
--   CREATE TABLE NewSuppliers
--   (
--	Id INT,
--	SuppName NVARCHAR(30),
--	City NVARCHAR(30),
--	Rating NVARCHAR(30)
--   )
-- Insert to the new table only the suppliers with products in Categories 1, 3, 6
-- Ensure the Rating column in the new table consist of only NULL values
CREATE TABLE NewSuppliers
(
	Id INT,
	SuppName NVARCHAR(30),
	City NVARCHAR(30),
	Rating NVARCHAR(30)
)

INSERT INTO NewSuppliers (Id, SuppName, City)
(
	SELECT s.SupplierId, LEFT(s.CompanyName, 30), City FROM Suppliers AS s
	INNER JOIN Products AS p
	ON(s.SupplierID = p.SupplierID)
	WHERE p.CategoryID IN (1, 3, 6)
)

--10. Restore the database from the .bak file
--Done