--Shlomi Kiko - SQL Group By Homework

--1. From Customers, display the largest alphabetic CustomerId
SELECT MAX(CustomerId) AS LargestAbcCustId FROM Customers

--2. From Customers, display the smallest alphabetical CustomerId
SELECT MIN(CustomerId) AS SmallestAbcCustId FROM Customers

--3. From Customers, display the number of rows in the table
SELECT COUNT(*) AS NumOfRows FROM Customers

--4. From Products, display the smallest UnitInStock, Average UnitInStock
SELECT MIN(UnitsInStock) AS SmallestUnitInStock, AVG(UnitsInStock) AS AVGUnitInStock FROM Products AS P

--5. From Employees, display the number of records in Region, excluding NULL
SELECT COUNT(Region) AS NumOfRecordsRegion FROM Employees AS e WHERE Region IS NOT NULL

--6. From Products, display the average PriceUnit
SELECT ROUND(AVG(UnitPrice), 2) AS AvgPriceUnit FROM Products

--7. From Orders, display the Max, Min and Avg Freight for each ShipVia
SELECT o.ShipVia, MAX(Freight) AS MaxFreight, MIN(Freight) AS MinFreight, ROUND(AVG(Freight), 2) AS AvgFreight FROM Orders AS o
GROUP BY o.ShipVia

--8. From Employees, show the smallest HireDate, largest HireDate, dates should be displayed in format 114
SELECT CONVERT(DATE, MIN(e.HireDate), 114) AS SmallestHireDate, CONVERT(DATE, MAX(e.HireDate), 114) AS LargestHireDate FROM Employees AS e

--9. From Customers, show the number of different Customers
SELECT DISTINCT CustomerId FROM Customers

--10. From Orders, show the number of different Customers
SELECT DISTINCT CustomerId FROM Orders

--11. From Products, display the max UnitOfStocks of products by SupplierId, only for products with UnitsInStock 
--    smaller than 34
SELECT p.SupplierID, MAX(p.UnitsInStock) AS MaxUnitInStock FROM Products AS p
GROUP BY p.SupplierID

--12. From Products, for each SupplierId show the most expensive product, sort Desc by Price
SELECT * FROM
(
	SELECT p.SupplierId, MAX(p.UnitPrice) AS MostExpensiveProduct FROM Products AS p
	GROUP BY p.SupplierID
) AS t
ORDER BY MostExpensiveProduct DESC

--13. From Products, display the average UnitsInStock according to each SupplierId, sort by AVgUnits ASC
SELECT p.SupplierID, AVG(p.UnitsInStock) AS AvgUnitsInStock FROM Products AS p
GROUP BY p.SupplierID
ORDER BY AVG(p.UnitsInStock) ASC

--14. From Customers, show the number of Customers by country and city
SELECT Country, City, COUNT(CustomerId) AS NumOfCustomers FROM Customers
GROUP BY Country, City

--15. From Orders, show for each CustomerId the amount of Orders, only for customers who ordered more than 4 orders
--    In addition, only for orders since 98 and after
--    The result should be: 2 columns: CustomerId, OrderAmt, sort in alphabetical order ASC
SELECT o.CustomerId, COUNT(o.OrderId) AS OrderAmt FROM Orders AS o
WHERE YEAR(o.OrderDate) >= '1998'
GROUP BY o.CustomerId
HAVING COUNT(o.OrderId) > 4
ORDER BY o.CustomerID ASC

--16. From Customers, show the number of customers by city, only for customers who live in Tacoma
SELECT City, COUNT(CustomerId) AS NumberOfCustomerInTacoma FROM Customers AS c
WHERE c.City = 'Tacoma'
GROUP BY c.City 

--17. From Products, display the highest price, lowest price, average price, quantity of products, 
--    group by CategoryId, SupplierId
SELECT p.CategoryID, p.SupplierID, MAX(p.UnitPrice) AS HighestPrice, MIN(p.UnitPrice) AS LowestPrice,
AVG(p.UnitPrice) AS AvgPrice, 
COUNT(p.QuantityPerUnit) AS QuantityPerUnit
FROM Products AS p
GROUP BY p.CategoryID, p.SupplierID

--18. From Products, show the max price group by Category, for products whose price is greater than 26
SELECT p.CategoryID, MAX(p.UnitPrice) AS MaxPriceGroup FROM Products AS P 
WHERE p.Unitprice > 26
GROUP BY p.CategoryID

--19. From Products, show the average price by SupplierId, for products whose price is bigger than 33
SELECT p.SupplierId, AVG(p.UnitPrice) AS AvgUnitPrice FROM Products AS p
WHERE p.UnitPrice > 33
GROUP BY p.SupplierID

--20. From Products, display the total items that were ordered from UnitsOnOrder, and the 
--    total UnitsInStock for each CategoryName from the Categories table
--    Display only Categories that contain the letter b and only products with total units ordered greater than 97
--    Sort by CategoryName DESC
SELECT c.CategoryName, SUM(p.UnitsOnOrder) AS TotalUnitsOnOrder, SUM(p.UnitsInStock) AS TotalUnitsInStock
FROM Products AS p
INNER JOIN Categories AS c
ON(p.CategoryID = c.CategoryID)
WHERE c.CategoryName LIKE '%b%'
GROUP BY c.CategoryName
HAVING SUM(p.UnitsOnOrder) > 97
ORDER BY c.CategoryName DESC

--21. From Customers, display the number of Customers in the same region and city, only for customers 
--    that have the letters n or d in CityName and where Region is not null
--    Display only for regions and cities with more than 3 customers
SELECT c.Region, c.City, COUNT(c.CustomerId) AS TotalCustomersInSameRegionCity FROM Customers AS c
WHERE c.City LIKE '%[n, d]%' AND c.Region IS NOT NULL
GROUP BY c.Region, c.City
HAVING COUNT(c.CustomerID) > 3

--22. From Employees, LastName, from Order Details, OrderAmount for each employee and LastOrderDate the employee made
--    Display only employees who placed over 54 orders
SELECT e.LastName, COUNT(o.OrderID) AS OrderAmount, MAX(o.OrderDate) LastOrderDate
FROM Employees AS e
INNER JOIN Orders AS o
ON(e.EmployeeID = o.EmployeeID)
GROUP BY e.LastName
HAVING COUNT(o.OrderId) > 54
