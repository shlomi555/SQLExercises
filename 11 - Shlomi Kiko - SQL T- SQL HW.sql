--Shlomi Kiko - SQL T-SQL Homework

--1. Set a variable with the current time, set another variable with the following message:
/*
If the time is before noon print "Wow, it's really early"
If the time is after noon print "Oh no, it's really late"
Concatenate the 2 variables and print them together
*/
DECLARE @currTime datetime = GETDATE()
DECLARE @message  varchar(100)

IF(DATEPART(HOUR, @currTime) < '12')
	SET @message = 'wow, it''s really early'
ELSE
	SET @message = 'oh no, it''s really late'

DECLARE @res varchar(100) = 'The hour is: ' + CONVERT(varchar(50), DATEPART(HOUR, @currTime)) + ', ' + @message

print @res

--2. Create 3 variables, 2 of them should be string, one should be int
/*
Assign the value "Let's print" to the first variable
The value 3 to the second variable
The value "variables" to the third variable
Print all 3 variables with spaces in between in the message tab
*/
DECLARE @printMessage varchar(50) = 'Let''s print'
DECLARE @val varchar(20) = 'variables' 
DECLARE @num int = 3

print @printMessage + ' ' + CAST(@num AS varchar(10)) + ' ' + @val

--3. Create a script, set a variable with a random OrderId, set another variable with the OrderId Freight cost
--If the FreightCost is less or equal to the average freight, print an appropriate message
DECLARE @randOrderId int 
DECLARE @maxOrderIds int, @minOrderIds int
DECLARE @orderIdFreightCost float
DECLARE @avgFreightCost float 

SET @maxOrderIds = (SELECT MAX(OrderId) FROM Orders)
SET @minOrderIds = (SELECT MIN(OrderId) FROM Orders)
SET @randOrderId = (SELECT CAST(RAND() * (@maxOrderIds - @minOrderIds + 1) + @minOrderIds AS int))
SET @orderIdFreightCost = (SELECT Freight FROM Orders WHERE OrderId = @randOrderId)
SET @avgFreightCost = (SELECT AVG(Freight) FROM Orders)

IF(@orderIdFreightCost <= @avgFreightCost)
	print 'The freight cost is lower or equal than the average.'
ELSE
	print 'The freight cost is higher than the average.'

--4. Set 2 variables, the first one with the company name, the second with the Country, 
--   both from the Customers table for CustomerId "ALFKI", print them both
	DECLARE @companyName nvarchar(50), @country nvarchar(50)
	SET @companyName = (SELECT CompanyName FROM Customers WHERE CustomerId = 'ALFKI')
	SET @country = (SELECT Country FROM Customers WHERE CustomerId = 'ALFKI')

	print 'CompanyName: ' + @companyName + ', Country: ' + @country

--5. Use the appropriate Loop to print a year and it's revenue, for example "1998 rev is: 1597..."
--   The last year with sales should be printed first regardless of the revenue, 
--   the next years should be printed only if their revenues are over 300000

DECLARE @yearOfSale int = (SELECT MAX(YEAR(o.OrderDate)) FROM Orders AS o)
DECLARE @minYearOfSale int = (SELECT MIN(YEAR(o.OrderDate)) FROM Orders AS o)
DECLARE @yearOfSalesGrouped int =
(
	SELECT YEAR(o.OrderDate) 
	FROM [Order Details] AS od
	INNER JOIN Orders AS o
	ON(od.OrderID = o.OrderID)
	WHERE YEAR(o.OrderDate) = @yearOfSale
	GROUP BY YEAR(o.OrderDate)
)

DECLARE @revenuePerYear float = 
(
	SELECT ROUND(SUM(od.UnitPrice * od.Quantity * od.Discount - 1), 2) 
	FROM [Order Details] AS od
	INNER JOIN Orders AS o
	ON(od.OrderId = o.OrderId) 
	WHERE YEAR(o.OrderDate) = @yearOfSale
	GROUP BY YEAR(o.OrderDate)
)

LABEL:
	SELECT @yearOfSalesGrouped AS YearOfSales, @revenuePerYear AS YearlyRevenue 
	
	SET @yearOfSale = @yearOfSale - 1

	SET @revenuePerYear = 	
	(
		SELECT ROUND(SUM(od.UnitPrice * od.Quantity * od.Discount - 1), 2) 
		FROM [Order Details] AS od
		INNER JOIN Orders AS o
		ON(od.OrderId = o.OrderId) 
		WHERE YEAR(o.OrderDate) = @yearOfSale
		GROUP BY YEAR(o.OrderDate)
	)

	SET @yearOfSalesGrouped = 
	(
		SELECT YEAR(o.OrderDate) 
		FROM [Order Details] AS od
		INNER JOIN Orders AS o
		ON(od.OrderID = o.OrderID)
		WHERE YEAR(o.OrderDate) = @yearOfSale
		GROUP BY YEAR(o.OrderDate)
	)

	IF(@yearOfSale >= @minYearOfSale AND @revenuePerYear > 30000) 
	GOTO LABEL

--6. Set a variable with the units in stock of product named "Chang"
--   If the units in stock is greater than 27 print, "Lots of units"
--   If the units in stock of the product is less or equal to 27 print, "Not many units"
DECLARE @changUnitsInStock nvarchar(20) = (SELECT UnitsInStock FROM Products WHERE ProductName = 'Chang') 

IF(@changUnitsInStock > 27)
	print 'Lots of units'
ELSE
	print 'Not many units'

GO

--7. Use the WHILE LOOP to go over all the customers's company name
--   If it has the the letter 'a' or 'n', print the name, else, print the company name with the text "Doesn't contain the letters 'a' or 'n'"
DECLARE @countCompanies int = (SELECT COUNT(CompanyName) FROM Customers)
DECLARE @companyName nvarchar(20) = 
(
	SELECT CompanyName 
	FROM
	(
		SELECT ROW_NUMBER() OVER(ORDER BY CompanyName) AS Id, CompanyName FROM Customers AS c
	)AS t
	WHERE id = @countCompanies
)

WHILE(@countCompanies > 0)
BEGIN
	
	SET @companyName =
	(
		SELECT CompanyName 
		FROM
		(
			SELECT ROW_NUMBER() OVER(ORDER BY CompanyName) AS Id, CompanyName FROM Customers AS c
		)AS t
		WHERE id = @countCompanies
	)

	IF(@companyName LIKE '%[a, n]%')
		PRINT(@companyName)
	ELSE
		PRINT(@companyName + ' ' + 'does not contain the letters a or n.')

	SET @countCompanies = @countCompanies - 1
END
