--Shlomi Kiko - SQL VIEW Homework

--1. Create a view that shows the average units in stock for 
--   SupplierId 21, 22, 23, name the view vv_SupplierStock
CREATE VIEW vv_SupplierStock
AS
(
	SELECT p.SupplierID, AVG(p.UnitsInStock) AS AvgUnitsInStock 
	FROM Products AS p
	WHERE p.SupplierID BETWEEN 21 AND 23
	GROUP BY p.SupplierID
)

--2. Create a view that shows the amount of sold items in the years 
--   1997 - 1998, name the view vv_YearlySoldItems
CREATE VIEW vv_YearlySoldItems
AS
(
	SELECT YEAR(o.OrderDate) AS YearOfSale, SUM(od.Quantity) AS AmountOfSoldItems 
	FROM [Order Details] AS od
	INNER JOIN Orders AS o
	ON(od.OrderID = o.OrderID)
	WHERE YEAR(o.OrderDate) BETWEEN 1997 AND 1998
	GROUP BY YEAR(o.OrderDate)
)

--3. Change the view you created vv_SupplierStock so that the Suppliers companyName will be displayed 
--   and only for suppliers with an average UnitsInStock higher than 30
ALTER VIEW vv_SupplierStock
AS 
(
	SELECT p.SupplierID, s.CompanyName, AVG(p.UnitsInStock) AS AvgUnitsInStock 
	FROM Products AS p
	INNER JOIN Suppliers AS s
	ON(p.SupplierID = s.SupplierID)
	WHERE p.SupplierID BETWEEN 21 AND 23
	GROUP BY p.SupplierID, s.CompanyName
	HAVING AVG(p.UnitsInStock) > 30
)

--4. Use the view vv_YearlySoldItems in a query and add a column for the percentage items sold
SELECT *, ROUND(CAST(AmountOfSoldItems AS float) / (SELECT CAST(SUM(AmountOfSoldItems) AS float) FROM vv_YearlySoldItems), 2) AS SalesPercentage
FROM vv_YearlySoldItems

--5. Create a view with columns: EmployeeId, FirstName and LastName only for employees in USA or UK
CREATE VIEW EmployeesUK_US
AS
(
	SELECT e.EmployeeID, e.FirstName, e.LastName FROM Employees AS e
	WHERE e.Country IN ('UK', 'USA')
)

--6.Create a view with CHECK OPTION vv_OrdersFreight with columns: OrderId, ShipCountry, Freight, 
--  only orders whose FreightCost is less than 33 should be included
CREATE VIEW vv_OrdersFreight
AS 
(
	SELECT o.OrderID, o.ShipCountry, o.Freight 
	FROM Orders AS o
	WHERE o.Freight < 33
	
)WITH CHECK OPTION  

--7. Create a view vv_PrdStock with columns ProductId, ProductName, UnitPrice, 
--   and the difference between UnitsInStock and UnitsOnOrder.
--   Only products that cost less than 47 should be included
CREATE VIEW vv_PrdStock
AS 
(
	SELECT p.ProductID, p.ProductName, p.UnitPrice, ABS(p.UnitsInStock - p.UnitsOnOrder) AS DiffInstockAndOnOrder
	FROM Products AS p
	WHERE p.UnitPrice < 47
)

--8. Use the view you created before vv_OrdersFreight and try to update order 10248 freight to 42
UPDATE vv_OrdersFreight
SET Freight = 42
WHERE OrderID = 10248

--Failed because of With Check Option Constraint


--9. Use the view you created before vv_PrdStock and update product 29's name to test, update it's price to 55
--   After finishing try and use the view to display product 29
UPDATE vv_PrdStock
SET ProductName = 'test', UnitPrice = 55
WHERE ProductId = 29

SELECT * FROM vv_PrdStock
WHERE ProductID = 29


--10. Create a view that shows the FreightCost for the years 1997 - 1998
CREATE VIEW FreightCost1997_1998
AS
(
	SELECT YEAR(o.OrderDate) AS YearOfCost, SUM(Freight) AS FreightCostPerYear FROM Orders AS o
	WHERE YEAR(o.OrderDate) BETWEEN 1997 AND 1998
	GROUP BY YEAR(o.OrderDate)
)