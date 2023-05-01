--Shlomi Kiko - SQL SubQueries Homework

--1. View CustomerCode and City for Customers from the same City as Customer 'FISSA'
SELECT c.CustomerId, c.City FROM Customers AS c
WHERE City = (SELECT City FROM Customers WHERE CustomerId = 'FISSA')

--2. From Products, display ProductName for products that are less expensive than product 67
SELECT p.ProductName FROM Products AS p
WHERE p.UnitPrice < (SELECT UnitPrice FROM Products WHERE ProductId = 67)

--3. From Products, display the product's names and prices for products that are more expensive than the 
--   price of product Chang
SELECT p.ProductName, p.UnitPrice FROM Products AS p
WHERE p.UnitPrice > (SELECT UnitPrice FROM Products WHERE ProductName = 'Chang')

--4. View all orders that are at the same date or later than order 10533.
--   Don't show order 10533 in the final result
 SELECT o.OrderId, o.OrderDate FROM Orders AS o
 WHERE o.OrderDate >= (SELECT OrderDate FROM Orders WHERE OrderId = 10533) AND o.OrderId != 10533

--5. From Products, display ProductId, ProductName, UnitPrice for products whose prices are higher than the 
--   average price of all products
SELECT p.ProductId, p.ProductName, p.UnitPrice FROM Products AS p
WHERE p.UnitPrice > (SELECT AVG(UnitPrice) FROM Products AS p)

--6. From Products, view ProductNames, QuantityInStock for products whose UnitInStock is less than the minimum 
--   quantity in category 7
SELECT p.ProductName, p.UnitsInStock FROM Products AS p
WHERE p.UnitsInStock < (SELECT MIN(UnitsInStock) FROM Products WHERE CategoryID = 7)

--7. From Orders, view OrderId, Freight, only for orders whose Freight is bigger than all Freights of orders 
--   that were shipped with ShipVia2
SELECT o.OrderId, o.Freight FROM Orders AS o
WHERE o.Freight > ALL (SELECT Freight FROM Orders WHERE ShipVia = 2)

--8. From Products, view ProductName, Price, CategoryId for products whose price is equal to the products in category 7
SELECT p.ProductName, p.UnitPrice, p.CategoryId FROM Products AS p 
WHERE p.UnitPrice IN (SELECT UnitPrice FROM Products WHERE CategoryID = 7)

--9. From Products, show ProductName, Price for products that are more expensive from at least one of the products 
--   in category 3
SELECT p.ProductName, p.UnitPrice FROM Products AS p
WHERE p.UnitPrice > ANY (SELECT UnitPrice FROM Products WHERE CategoryId = 3)

--10. From Orders, show OrderID, ShipCountry, only for orders whose Freight is bigger than the average Freight of 
--    orders whose OrderYear is 97 or after
SELECT o.OrderId, o.ShipCountry FROM Orders AS o
WHERE o.Freight > (SELECT AVG(Freight) FROM Orders WHERE YEAR(OrderDate) >= 1997)

--11. From Orders, view OrderId, OrderDate for all orders whose Suppliers are from Spain, Germany or US and whose 
--    OrderMonth is July

SELECT o.OrderID, o.OrderDate FROM Orders AS o
WHERE EXISTS
	(
		SELECT s.SupplierId FROM Suppliers AS s
		INNER JOIN Products AS p
		ON(s.SupplierID = p.SupplierID)
		INNER JOIN [Order Details] AS od
		ON(p.ProductID = od.ProductID)
		WHERE od.OrderID = o.OrderID AND s.Country IN ('Spain', 'Germany', 'US') AND MONTH(o.OrderDate) = 07
	)

--12. From Employees, show for each employee the last order he made and the order date
--    Required columns: EmployeeId, OrderId, OrderDate, only the last order made, use correlated subqueries for 
--    this exercise
SELECT e.EmployeeId, o.OrderId, o.OrderDate FROM Employees AS e
INNER JOIN Orders AS o
ON(e.EmployeeID = o.EmployeeID)
WHERE o.OrderDate = 
(
	SELECT MAX(OrderDate) FROM Orders AS o1
	WHERE o.EmployeeID = o1.EmployeeID
)

--13. Show SupplierId, CompanyName only for those that have products with UnitPrice less than 20
--    Use corellated subqueries for this exercise
SELECT s.SupplierID, s.CompanyName FROM Suppliers AS s
WHERE EXISTS
(
	SELECT s.SupplierID FROM Products AS p
	WHERE (s.SupplierID = p.SupplierID) AND p.UnitPrice < 20
)

--14. From Products, view the ProductNames for products whose CategoryName is 'SeaFood' and the Region of the customer 
--    is NULL
SELECT p.ProductName FROM Products AS p
WHERE p.CategoryID IN 
(
	SELECT cat.CategoryId FROM Customers AS c
	INNER JOIN Orders AS o
	ON(c.CustomerID = o.CustomerID)
	INNER JOIN [Order Details] AS od
	ON(o.OrderID = od.OrderID)
	INNER JOIN Categories AS cat
	ON(p.CategoryID = cat.CategoryID AND p.ProductID = od.ProductID)
	WHERE cat.CategoryName = 'Seafood' AND c.Region IS NULL
)

--15. From Suppliers, show CompanyName only for suppliers who have products in the 'Condiments' category
SELECT s.CompanyName FROM Suppliers AS s
WHERE EXISTS
(
	SELECT s.SupplierID FROM Products AS p
	WHERE s.SupplierID = p.SupplierID 
	AND 
	p.CategoryID = (SELECT c.CategoryId FROM Categories AS c WHERE c.CategoryName = 'Condiments')
)

