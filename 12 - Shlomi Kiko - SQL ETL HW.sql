--Shlomi Kiko - SQL ETL Homework

IF EXISTS(SELECT SPECIFIC_NAME FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'fn_isProdExpensive')
	DROP FUNCTION fn_isProdExpensive
	
GO

--If UnitPrice lower than average then 'Cheap', else expensive
CREATE FUNCTION fn_isProdExpensive(@unitPrice money)
RETURNS nvarchar(20)
AS
BEGIN
	DECLARE @avgUnitPriceAllPrd money = 0
	SET @avgUnitPriceAllPrd = (SELECT AVG(p.UnitPrice) FROM NORTHWND.dbo.Products AS p)
	DECLARE @result nvarchar(20)

	IF(@unitPrice < @avgUnitPriceAllPrd)
		SET @result = 'Cheap'
	ELSE
		SET @result = 'Expensive'

	RETURN @result
END

GO

IF EXISTS(SELECT [name] FROM sys.procedures WHERE name = 'ETL_Load')
	DROP PROCEDURE ETL_Load

GO

CREATE PROCEDURE ETL_Load
AS
BEGIN
	SET NOCOUNT ON

	--Clean tables before load
	TRUNCATE TABLE Northwind_DW.dbo.Dim_Date
	TRUNCATE TABLE Northwind_DW.dbo.Dim_Customers
	TRUNCATE TABLE Northwind_DW.dbo.Dim_Employees
	TRUNCATE TABLE Northwind_DW.dbo.Dim_Orders
	TRUNCATE TABLE Northwind_DW.dbo.Dim_Products
	TRUNCATE TABLE Northwind_DW.dbo.Fact_Sales

	--Create a DimDate table to be used as Calendar
	IF EXISTS(SELECT name FROM Northwind_DW.sys.tables WHERE name = 'Dim_Date')
		DROP TABLE Dim_Date
	
	CREATE TABLE Northwind_DW.dbo.Dim_Date
	(
		DateKey int,
		[Date] Date,
		Year int,
		Quarter int,
		Month int,
		MonthName nvarchar(20)
	)

	DECLARE @endDate Date = '1999-12-31'
	DECLARE @startDate Date = '1990-01-01'

	DECLARE @totalNumOfRowsInserted int = 0

	DECLARE @year int = DATEPART(YEAR, @startDate)
	DECLARE @month int = DATEPART(MONTH, @startDate)
	DECLARE @quarter int = DATEPART(QUARTER, @startDate)
	DECLARE @monthName nvarchar(10) = DATENAME(MONTH, @startDate)
	DECLARE @dateKey int = LEFT(@startDate, 4) + SUBSTRING(CAST(@startDate AS nvarchar(10)), 6, 2) + RIGHT(@startDate, 2)

	WHILE(@startDate <= @endDate)
	BEGIN

		INSERT INTO Northwind_DW.dbo.Dim_Date
		(DateKey, Date, [Year], [Quarter], [Month], [MonthName]) 
		VALUES 
		(@dateKey, @startDate, @year, @quarter, @month, @monthName)

		--Move to the next day for the following iteration
		SET @startDate = DATEADD(DAY, 1, @startDate)

		--Derive the date parts from the next day
		SET @year = DATEPART(YEAR, @startDate)
		SET @month = DATEPART(MONTH, @startDate)
		SET @quarter = DATEPART(QUARTER, @startDate)
		SET @monthName = DATENAME(MONTH, @startDate)
		SET @dateKey = LEFT(@startDate, 4) + SUBSTRING(CAST(@startDate AS nvarchar(10)), 6, 2) + RIGHT(@startDate, 2)

		SET @totalNumOfRowsInserted = @totalNumOfRowsInserted + 1
	END

	--PRINT @TotalNumOfRowsInserted 

	--DimCustomers from Northwind Customers
	INSERT INTO Northwind_DW.dbo.Dim_Customers
	(CustomerBK, CustomerName, City, Region, Country)
	SELECT c.CustomerId, c.CompanyName, c.City, c.Region, c.Country FROM NORTHWND.dbo.Customers AS c

	--DimEmployees from Northwind Employees
	INSERT INTO Northwind_DW.dbo.Dim_Employees
	SELECT e.EmployeeId, e.LastName, e.FirstName, e.LastName + ' ' + e.FirstName, e.Title, e.BirthDate, 
	DATEDIFF(YEAR, e.BirthDate , GETDATE()), e.HireDate, DATEDIFF(YEAR, e.HireDate, GETDATE()), e.City, e.Country,
	e.Photo, e.ReportsTo
	FROM NORTHWND.dbo.Employees AS e

	--DimOrders from Northwind Orders
	INSERT INTO Northwind_DW.dbo.Dim_Orders
	(OrderBK, ShipCity, ShipRegion, ShipCountry)
	SELECT o.OrderID, o.ShipCity, o.ShipRegion, o.ShipCountry 
	FROM NORTHWND.dbo.Orders AS o

	--DimProducts from Northwind Products, Categories and Suppliers
	INSERT INTO Northwind_DW.dbo.Dim_Products
	(ProductBK, ProductName, ProductUnitPrice, ProductType, CategoryName, SupplierName, Discontinued)
	SELECT p.ProductID, p.ProductName, p.UnitPrice, dbo.fn_isProdExpensive(p.UnitPrice),
	c.CategoryName, s.CompanyName, p.Discontinued 
	FROM NORTHWND.dbo.Products AS p 
	INNER JOIN NORTHWND.dbo.Categories AS c
	ON(p.CategoryID = c.CategoryId)
	INNER JOIN NORTHWND.dbo.Suppliers AS s
	ON(p.SupplierID = s.SupplierId)

	--Create the format for the finalFactTable without data
	SELECT * INTO #stgFactSales
	FROM Northwind_DW.dbo.Fact_Sales
	WHERE 1 = 0

	--Insert from both the original Northwind tables joined with the DimTables for the SurrogateKeys
	INSERT INTO #stgFactSales
	(OrderSK, ProductSK, DateKey, CustomerSK, EmployeeSK, UnitPrice, Quantity, Discount)
	SELECT ISNULL(do.OrderSK, 0), ISNULL(dp.ProductSK, 0), ISNULL(dm.DateKey, 0), ISNULL(dc.CustomerSK, 0),
	ISNULL(de.EmployeeSK, 0), ISNULL(od.UnitPrice, 0), ISNULL(od.Quantity, 0), ISNULL(od.Discount, 0)
	FROM  NORTHWND.dbo.Orders AS o
	INNER JOIN NORTHWND.dbo.[Order Details] AS od
	ON(o.OrderId = od.OrderId)
	INNER JOIN NORTHWND.dbo.Products AS p
	ON(od.ProductID = p.ProductID)
	LEFT JOIN Dim_Customers AS dc
	ON(o.CustomerID = dc.CustomerBK)
	LEFT JOIN Dim_Employees AS de
	ON(o.EmployeeID = de.EmployeeBK)
	LEFT JOIN Dim_Orders AS do
	ON(od.OrderID = do.OrderBK)
	LEFT JOIN Dim_Products AS dp
	ON(p.ProductID = dp.ProductBK)
	LEFT JOIN Dim_Date AS dm
	ON(o.OrderDate = dm.Date)

	--Insert from the staging table to the FactSales table
	INSERT INTO Northwind_DW.dbo.Fact_Sales
	(OrderSK, ProductSK, DateKey, CustomerSK, EmployeeSK, UnitPrice, Quantity, Discount)
	SELECT stg.OrderSK, stg.ProductSK, stg.DateKey, stg.CustomerSK, stg.EmployeeSK, stg.UnitPrice,
	stg.Quantity, stg.Discount
	FROM #stgFactSales AS stg

	DROP TABLE #stgFactSales

	SET NOCOUNT OFF
END

SELECT * FROM Dim_Customers
SELECT * FROM Dim_Date
SELECT * FROM Dim_Orders
SELECT * FROM Dim_Products
SELECT * FROM Fact_Sales

EXECUTE ETL_Load