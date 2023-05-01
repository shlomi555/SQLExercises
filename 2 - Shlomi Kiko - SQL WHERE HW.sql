--Shlomi Kiko - WHERE Homework

--1. View Customer CompanyName and Country for CustomerCode ALFKI
SELECT c.CompanyName, c.Country FROM Customers AS c
WHERE c.CustomerId = 'ALFKI'

--2. View CustomerCode, FullAddress(Country, City, Address), SalesContact details for contacts living in Berlin
SELECT c.CustomerId, c.Country + ' ' + c.City + ' ' + c.Address AS FullAddress, c.ContactName
FROM Customers AS c
WHERE c.City = 'Berlin'

--3. View ProductName, ProductPrice of item 6 from the Products table
SELECT p.ProductName, p.UnitPrice FROM Products AS p
WHERE p.ProductID = '6'

--4. View ProductNumber, ProductName, ProductPrice from the Products table where the price is higher than 16, 
--   order according by price ASC
SELECT p.ProductID, p.ProductName, p.UnitPrice FROM Products AS p
WHERE p.UnitPrice > 16
ORDER BY p.UnitPrice ASC

--5. View from Employees table FullName, BirthDate, EmployeeID of his manager for EmployeeId 7
SELECT e.FirstName + ' ' + e.LastName AS FullName, e.BirthDate, e.ReportsTo 
FROM Employees AS e
WHERE e.EmployeeID = '7'

--6. View the OrderCode, Freight from the Orders table for orders within FreightCost range: 33.45 - 65.8, 
--   sort by Freight DESC
SELECT o.OrderID, o.Freight FROM Orders AS o
WHERE o.Freight BETWEEN 33.45 AND 65.8
ORDER BY o.Freight DESC

--7. View all details from Products table for products not within price 41 and 92
SELECT * FROM Products WHERE UnitPrice NOT BETWEEN 41 AND 92
--8. View OrderCode, Ship City, EmployeeCode for orders whose EmployeeCode is not in 3,5,8, sort by EmployeeCode ASC
SELECT o.OrderID, o.ShipCity, o.EmployeeID FROM Orders AS o
WHERE o.EmployeeID NOT IN (3, 5, 8)
ORDER BY o.EmployeeId ASC

--9. View EmployeeCode, LastName, StartDate, from Employees for workers in Seattle or Kirkland
SELECT e.EmployeeId, e.LastName, e.HireDate FROM Employees AS e
WHERE e.City IN ('Seattle', 'Kirkland')

--10. View EmployeeNumber, First and LastName, only for employeeId's 3,4,6
SELECT e.EmployeeId, e.FirstName + ' ' + e.LastName AS FullName FROM Employees AS e
WHERE e.EmployeeId IN (3, 4 ,6)

--11. View Employee's FirstName, LastName, Date of birth for employees whose id number is not in 2, 8
SELECT e.FirstName, e.LastName, e.BirthDate FROM Employees AS e
WHERE e.EmployeeID NOT IN (2, 8)

--12. View from Employees LastName, City for Employee's where LastName ends with 'w'
SELECT e.LastName, e.City FROM Employees AS e WHERE e.LastName LIKE '%w'

--13. Show Employee's FirstNames and Region where Region is NULL
SELECT e.FirstName, e.Region FROM Employees AS e WHERE e.Region IS NULL

--14. Display TOP 5 expensive products, price and name
SELECT TOP 5 p.UnitPrice, p.ProductName FROM Products AS p 
ORDER BY p.UnitPrice DESC

--15. Show from Orders, Order Numbers, Order and required date, for all orders where required date is after November 1997
SELECT o.OrderID, o.OrderDate, o.RequiredDate FROM Orders AS o 
WHERE DATEPART(YEAR, o.RequiredDate) > 1997 OR (DATEPART(YEAR, o.RequiredDate) = 1997 AND DATEPART(MONTH, o.RequiredDate) > 11)

--16. Show from Employees, EmployeeId, LastName, ReportsTo, only for those who have a manager, Sort by EmployeeId ASC
SELECT e.EmployeeId, e.LastName, e.ReportsTo FROM Employees AS e WHERE e.ReportsTo IS NOT NULL
ORDER BY e.EmployeeId ASC

--17. Show the details for each Category where category has 'e' in name
SELECT c.CategoryName, c.Description FROM Categories AS c WHERE c.CategoryName LIKE '%e%'

--18. View from Orders, OrderNumber, EmployeeNumber, OrderDate, DateOfRequirement, ShippingDate for orders that 
--    meet the following conditions:
--    ShippingName is Quick-Stop, EmployeeId in 1,2,8, difference between RequirementDate and ShippingDate > 19 days
SELECT o.OrderId, o.EmployeeID, o.OrderDate, o.RequiredDate, o.ShippedDate FROM Orders AS o
WHERE o.ShipName = 'QUICK-Stop' AND o.EmployeeID IN (1, 2, 8) AND DATEDIFF(DAY , o.ShippedDate, o.RequiredDate) > 19

--19. Display from Products, ProductName, CategoryNumber, where 'e' is the letter before the end
SELECT p.ProductName, p.CategoryId FROM Products AS p WHERE p.ProductName LIKE '%e_'

--20. Show from Orders, OrderNumber, CustomerCode and EmployeeId for orders made between May to August 1996
SELECT o.OrderId, o.CustomerId, o.EmployeeId FROM Orders AS o WHERE o.OrderDate BETWEEN '01-05-1996' AND '31-08-1996'

--21. Display from Orders, OrderNumber, CustomerCode, CompanyName, Country, PHone, Region for Customers who are 
--    in countries whose names start with A, B, H and Region is NULL
SELECT o.OrderId, o.CustomerId, c.CompanyName, c.Country, c.Phone, c.Region FROM Orders AS o
INNER JOIN Customers AS c
ON(o.CustomerID = c.CustomerID)
WHERE c.Country LIKE '[A, B, H]%' AND c.Region IS NULL

--22. Display from Employees, EmployeeId, FullName, Date of birth, Country for employees whose lastName
--    has 't' or 'b' in it and were born in 1967
SELECT e.EmployeeId, e.FirstName + ' ' + e.LastName AS FullName, e.BirthDate, e.Country FROM Employees AS e
WHERE e.LastName LIKE '%[t, b]%' AND DATEPART(YEAR, BirthDate) = 1967

--23. Display from Products, ProductNumber, ProductTitle for products:
--    UnitInStock not between 19 - 89, SupplierNumber in 6, 7, UnitPrice > 15
SELECT p.ProductId, p.ProductName, p.UnitsInStock, p.SupplierID, p.UnitPrice FROM Products AS p
WHERE p.UnitPrice > 15 AND (p.UnitsInStock NOT BETWEEN 19 AND 89) AND p.SupplierID IN (6, 7)
