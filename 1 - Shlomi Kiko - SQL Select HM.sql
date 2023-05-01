--Shlomi Kiko - SELECT Homework

--1. Show columns CustomerId, CompanyName, City from the Customers table
SELECT CustomerId, CompanyName, City FROM Customers

--2. Display the Order Details table
SELECT * FROM [Order Details]

--3. Display the Customers table
SELECT * FROM Customers

--4. Display the following columns from the employees table:
--   Region, HireDate, FirstName, Country
SELECT Region, HireDate, FirstName, Country FROM Employees

--5. Display only two columns from the Employees table: EmployeeId and City + Address, name it FullAddress
SELECT EmployeeId, City +  ' ' + Address AS FullAdress FROM Employees

--6. Display 3 columns from the Employees table:
--a) LastName + FirstName, named FullName
--b) HireDate + 6 as HireDate_6
--c) City as EmployeeCity
SELECT LastName + ' ' + FirstName AS FullName, HireDate + 6 AS HireDate_6, City AS EmployeeCity FROM Employees

--7. Display the following columns from the Products table:
--   ProductId (Alias PrdId), ProductName (Alias PrdName), UnitPrice (UP)
SELECT ProductId AS PrdId, ProductName AS PrdName, UnitPrice AS UP FROM Products

--8. Display the following columns from the Employees table: Address, City, Region
SELECT Address, City, Region FROM Employees

--9. Display the unique combination of Country and City from the Employees table
SELECT DISTINCT Country, City FROM Employees

--10. View from the Employees table the countries of which employees come in a unique list
SELECT Country FROM Employees
GROUP BY Country
HAVING COUNT(EmployeeID) = 1
ORDER BY Country

--11. View the employees's job description in a unique way from the Employees table
SELECT DISTINCT FirstName + ' ' + LastName AS EmployeeFullName, Title FROM Employees

--12. View the following columns from the Products table:
--    Product Number, Product Name, Cost of Products in the inventory that weren't ordered
--    (Calculate the difference between Products in stock and the number of products ordered, 
--    then multiply the price per unit)
SELECT p.ProductID, p.ProductName, (p.UnitsInStock - p.UnitsOnOrder) * p.UnitPrice AS CostOfProductsNotOrdered 
FROM Products AS P
--13. View the employee's First Name, Date of Birth from the Employees table, plus birthday + 7 days
SELECT e.FirstName, e.BirthDate, e.BirthDate + 7 AS BDayPlus7 FROM Employees AS e

--14. Display the Product Name, Price Per Unit, Price Per Unit + 9 from the Products table
SELECT p.ProductName, p.UnitPrice, p.UnitPrice + 9 AS PricePerUnitPlus9 FROM Products AS p

--15. Display the following columns from the Products table:
--    Product ID, Product Name, Price Per Unit, Price after a 20 % increase,
--    number of products in stock, number of products ordered
--    difference between the number of products in stock and number of products ordered
SELECT p.ProductID, p.ProductName, p.UnitPrice, CONVERT(decimal(10,2), p.UnitPrice * 1.20) AS UnitPricePlus20Percent,
p.UnitsInStock, p.UnitsOnOrder, p.UnitsInStock - p.UnitsOnOrder AS DiffBetweenStockAndOrdered
FROM Products AS P