--Shlomi Kiko - SQL UDF Homework

--1. Create a function that will receive a CategoryName and display the number of products that were sold with that category
--   Use the function in a select statement
CREATE FUNCTION fn_SoldPerCat(@catName varchar(20))
RETURNS INT AS
BEGIN
	RETURN 
	(
		SELECT SUM(p.UnitsOnOrder) AS UnitsSold 
		FROM Products AS p
		INNER JOIN Categories AS c
		ON(p.CategoryID = c.CategoryID)
		WHERE c.CategoryName = @catName
	)
END

SELECT dbo.fn_SoldPerCat('Beverages')

--2. Create a function called fn_timePassed that will accept a date value as a parameter, 
--   then calculates the time passed in years from the current date.
--   The function should return an integer value.
--   Use the function with the HireDate column in the Employees table and calculate the seniority for all employees 
--   (use the function in a select statement)
CREATE FUNCTION fn_timePassed(@dates date)
RETURNS INT
AS
BEGIN
	RETURN
	(
		SELECT DATEDIFF(YEAR, @dates, GETDATE())
	)
END

SELECT e.EmployeeID, e.FirstName + ' ' + e.LastName AS FullName, CAST(e.HireDate AS date) AS HireDate,
dbo.fn_timePassed(e.HireDate) AS Seniority
FROM Employees AS e

--3. Create a function that checks if a customer has a region, return the string "Has Region" if yes, else return "No Region"
--   Use the function in a select statement with the Customers table
CREATE FUNCTION fn_hasRegion(@customerId nchar(10))
RETURNS varchar(20)
AS
BEGIN
		DECLARE @res varchar(20)
		if (SELECT c.Region FROM Customers AS c WHERE c.CustomerId = @customerId) IS NULL
			SET @res = 'No Region'
		ELSE
			SET @res = 'Has Region'
		RETURN @res
END

SELECT dbo.fn_hasRegion('BOTTM') AS hasRegion

--4. Write a function that receives Employees FirstName as a parameter and returns a table with the following details:
/*
     OrderId, OrderDate, OrderAge, EmployeeName, Customer's CompanyName
     Use the function fn_timePassed to calculate the column OrderAge
     Use the function in a select statement with the employee Steven	   
*/
CREATE FUNCTION fn_orderDetails(@empFirstName nvarchar(20))
RETURNS table
AS
RETURN
	(
		SELECT o.OrderID, o.OrderDate, e.FirstName + ' ' + e.LastName AS EmployeeName, c.CompanyName,
		dbo.fn_timePassed(o.OrderDate) AS OrderAge FROM Employees AS e
		INNER JOIN Orders AS o
		ON(e.EmployeeID = o.EmployeeID)
		INNER JOIN Customers AS c
		ON(o.CustomerID = c.CustomerID)
		WHERE e.FirstName = @empFirstName
	)

SELECT * FROM dbo.fn_orderDetails('Steven')

--5. Write a function that receives 2 parameters from type float, 
--   the function returns a table only with employees whose revenue is between the range of the 2 float parameters
--   In the Feedback column, the top 2 employees will receive a feedback as Great job, the others will receive Ok job
--   For example, for param1 = 10000 and param2 = 50000
--   We can get:
--   EmployeeId		Rev		Feedback
--   8			35789.98	Great job
--   4			31007.76	Great job
--   2			28970.87	Ok job
CREATE FUNCTION fn_empRating(@param1 money, @param2 money)
RETURNS @empRating table (EmployeeId nchar(10), Revenue float, Feedback varchar(50))
AS
BEGIN
	DECLARE @numEmps int = 
	(
		SELECT COUNT(DISTINCT o.employeeId) FROM Orders AS o 
		INNER JOIN [Order Details] AS od ON(o.OrderId = od.OrderId) 
		WHERE o.EmployeeID IN 
		(
			SELECT o.EmployeeID FROM Orders AS o 
			INNER JOIN [Order Details] AS od 
			ON(o.OrderID = od.OrderID)
			GROUP BY o.EmployeeID
			HAVING SUM(od.UnitPrice *  od.Quantity * (1 - od.Discount)) BETWEEN @param1 AND @param2
		)
	)

	INSERT INTO @empRating
	SELECT TOP 2 e.EmployeeID, ROUND(SUM(od.UnitPrice *  od.Quantity * (1 - od.Discount)), 2) AS Revenue, 'Great Job' AS rating
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON(e.EmployeeID = o.EmployeeID)
	INNER JOIN [Order Details] AS od
	ON(o.OrderID = od.OrderID)
	GROUP BY e.EmployeeID
	HAVING SUM(od.UnitPrice *  od.Quantity * (1 - od.Discount)) BETWEEN @param1 AND @param2
	ORDER BY Revenue DESC
	
	if(@numEmps = 0)
		SET @numEmps = 2

	INSERT INTO @empRating
	SELECT TOP (ABS(@numEmps - 2)) e.EmployeeID, ROUND(SUM(od.UnitPrice *  od.Quantity * (1 - od.Discount)), 2) AS Revenue,
	'Ok Job' AS rating
	FROM Employees AS e
	INNER JOIN Orders AS o
	ON(e.EmployeeID = o.EmployeeID)
	INNER JOIN [Order Details] AS od
	ON(o.OrderID = od.OrderID)
	WHERE e.EmployeeID NOT IN (SELECT EmployeeId FROM @empRating)
	GROUP BY e.EmployeeID
	HAVING SUM(od.UnitPrice *  od.Quantity * (1 - od.Discount)) BETWEEN @param1 AND @param2
	ORDER BY Revenue ASC

	RETURN
END

SELECT * FROM fn_empRating(2000, 200000)

/*With Row_num
CREATE FUNCTION fn_empResults(@param1 money, @param2 money)
RETURNS @emptable table (EmployeeId nchar(10), Revenue float, Feedback nvarchar(20))
AS
BEGIN
	
	INSERT INTO @emptable
	SELECT EmployeeID, Revenue, CASE WHEN RowNum BETWEEN 1 AND 2 THEN 'Great job' ELSE 'Ok job' END AS Feedback FROM
	(
		SELECT ROW_NUMBER() OVER(ORDER BY Revenue DESC) AS RowNum, EmployeeID, ROUND(Revenue, 2) AS Revenue 
		FROM
		(
			SELECT e.EmployeeID, SUM(od.UnitPrice *  od.Quantity * (1 - od.Discount)) AS Revenue FROM Employees AS e
			INNER JOIN Orders AS o
			ON(e.EmployeeID = o.EmployeeID)
			INNER JOIN [Order Details] AS od
			ON(o.OrderID = od.OrderID)
			GROUP BY e.EmployeeID
			HAVING SUM(od.UnitPrice *  od.Quantity * (1 - od.Discount)) BETWEEN @param1 AND @param2
		) AS t
	) AS b

	RETURN
END


SELECT * FROM dbo.fn_empResults(30000, 80000)
*/
