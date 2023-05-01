--Shlomi Kiko - SQL Joins Homework

--1. View the ProductName, ProductPrice and it's CategoryName for products above 32
SELECT p.ProductName, p.UnitPrice, c.CategoryName FROM Products AS p 
INNER JOIN Categories AS c
ON(p.CategoryID = c.CategoryID)
WHERE p.UnitPrice > 32

--2. View the ProductName and Category in the result
SELECT p.ProductName, c.CategoryName FROM Products AS p
INNER JOIN Categories AS c
ON(p.CategoryID = c.CategoryID)

--3. View the ProductName and it's Supplier's CompanyName
SELECT p.ProductName, s.CompanyName FROM Products AS p
INNER JOIN Suppliers AS s
ON(p.SupplierID = s.SupplierID)

--4. View the OrderNumber and the Customer's CompanyName for companies whose names begin with the letter 'c'
SELECT o.OrderId, c.CompanyName FROM Orders AS o
INNER JOIN Customers AS c
ON(o.CustomerID = c.CustomerID)
WHERE c.CompanyName LIKE 'c%'

--5. View from Region, Region Description and from the Territories table TerritoryDescription
SELECT r.RegionDescription, t.TerritoryDescription FROM Region AS r
INNER JOIN Territories AS t
ON(r.RegionID = t.RegionID)

--6. View the OrderId from the OrderDetails table, orderDate from the orders table, and ProductName
--   from Products table, only when the OrderDate is in 97, 98, sort by OrderId ASC
SELECT od.OrderId, o.OrderDate, p.ProductName FROM Products AS p
INNER JOIN [Order Details] AS od
ON(p.ProductID = od.ProductID)
INNER JOIN Orders AS o
ON(od.OrderID = o.OrderID)
WHERE YEAR(o.OrderDate) = 1997 OR YEAR(o.OrderDate) = 1998
ORDER BY od.OrderId ASC

--7. View ProductNumber, ProductPrice, SupplierNumber from Products table and its CategoryName from the Categories table
--   for products whose suppliernumber is 22
SELECT p.ProductID, p.UnitPrice, p.SupplierID, c.CategoryName FROM Products AS p
INNER JOIN Suppliers AS s
ON(p.SupplierID = s.SupplierID)
INNER JOIN Categories AS c
ON(p.CategoryID = c.CategoryID)
WHERE p.SupplierID = 22

--8. View ProductNumber, ProductPrice, SupplierNumber from the Products table and it's CategoryName from
--   the Categories table for products that have the letter 'e' in CategoryName
SELECT p.ProductId, p.UnitPrice, p.SupplierId, c.CategoryName FROM Products AS p
INNER JOIN Suppliers AS s
ON(p.SupplierID = s.SupplierID)
INNER JOIN Categories AS c
ON(p.CategoryID = c.CategoryID)
WHERE c.CategoryName LIKE '%e%'

--9. View the ProductName from the Products table, CategoryName from the Categories table and 
--   CompanyName from the Suppliers table
SELECT p.ProductName, c.CategoryName, s.CompanyName FROM Products AS p
INNER JOIN Categories AS c
ON(p.CategoryID = c.CategoryID)
INNER JOIN Suppliers AS s
ON(p.SupplierID = s.SupplierID)

--10. Show the city of the employee and city of his manager, for all employees, including those without management
SELECT e1.City AS EmpCity, e1.FirstName + ' ' + e1.LastName AS EmpName, e2.City AS ManCity, e2.FirstName + ' ' + e2.LastName AS ManName
FROM Employees AS e1
LEFT JOIN Employees AS e2
ON(e1.ReportsTo = e2.EmployeeID )

--11. From Products, ProductNumber, ProductQuantityPerUnit, UnitInStock where UnitInStock is 
--    less than products who have QuantityPerUnit = '10 - 200g glasses'
SELECT p.ProductID, p.QuantityPerUnit, p.UnitsInStock FROM Products AS p
WHERE p.UnitsInStock < (SELECT UnitsInStock FROM Products WHERE QuantityPerUnit = '10 - 200 g glasses')

--12. From Products, ProductID, from Category, CategoryDescription, from Suppliers Country, only when the 
--    first letter of the country is 'd'
SELECT p.ProductID, c.Description, s.Country FROM Products AS p
INNER JOIN Categories AS c
ON(p.CategoryID = c.CategoryID)
INNER JOIN Suppliers AS s
ON(p.SupplierID = s.SupplierID)
WHERE s.Country LIKE 'd%'

--13. From Customers, CustomerId, from Orders, Freight, for all customers, including those without orders
SELECT c.CustomerId, o.Freight FROM Customers AS c
LEFT JOIN Orders AS o
ON(c.CustomerID = o.CustomerID)

--14. From Orders, OrderId, OrderDate, ShippingAddress, from Customers, CompanyName, CustomerId, PhoneNumber, 
--    only where orders were made in 97 and for customers whose id begins with the letters 'E' or 'B'
SELECT o.OrderId, o.OrderDate, o.ShipAddress, c.CompanyName, c.CustomerId, c.Phone FROM Orders AS o
INNER JOIN Customers AS c
ON(o.CustomerID = c.CustomerID)
WHERE YEAR(o.OrderDate) = 1997 AND c.CustomerId LIKE '[E,B]%'