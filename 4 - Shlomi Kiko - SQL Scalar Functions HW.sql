--Shlomi Kiko - SQL Scalar Functions Homework

--1. From Customer, CompanyName, location of letter t in CompanyName,
--   Filter the query and display only customers who do not have the letter t in CompanyName
SELECT c.CompanyName, CHARINDEX('t', c.CompanyName) AS LocTInCompName FROM Customers AS c
WHERE CHARINDEX('t', c.CompanyName) = 0

--2. From Employees, LastName in lowercase, FirstName in capital letters, only for employees with id between 2 - 4
SELECT LOWER(e.LastName) AS LowCaseLastName, UPPER(e.FirstName) AS UpperCaseFirstName FROM Employees AS e
WHERE e.EmployeeID BETWEEN 2 AND 4 

--3. From Orders, OrderId, How old is the order (difference in years between current date and the OrderDate)
SELECT o.OrderId, DATEDIFF(YEAR, o.OrderDate, GETDATE()) AS DiffInYearsOrderAndNow FROM Orders AS o

--4. From Orders, OrderId, Day the order took place, OrderYear from OrderDate
SELECT o.OrderId, DATENAME(WEEKDAY, o.OrderDate) AS DayOrderTookPlace, YEAR(o.OrderDate) AS YearOfOrder FROM Orders AS o

--5. From Categories, CategoryName, CategoryDescription, location of letter 'e' in CategoryDescription, 
--   3 digits of the beginning of the word
SELECT c.CategoryName, c.Description, CHARINDEX('e', c.Description) AS Loc_E_InCatDesc, 
LEFT(CAST(c.Description AS VARCHAR(50)), 3) AS First3InDesc
FROM Categories AS c

--6. From Employees, First, last and username, userName will consist of the first 2 letters of his firstName 
--   together with the first 2 letters of his LastName
SELECT e.FirstName, e.LastName, LEFT(e.FirstName, 2) + LEFT(e.LastName, 2) AS UserName FROM Employees AS e

--7. From Products, ProductId, ProductName, ProductName when character '/' is replaced with '-'
SELECT p.ProductId, p.ProductName, REPLACE(p.ProductName, '/', '-') AS CharReplacedInProdName FROM Products AS p

--8. Today's date
SELECT CAST(GETDATE() AS DATE) AS Today

--9. From Orders, CustomerId, OrderId, OrderDate, OrderDate + 60
SELECT o.CustomerID, o.OrderId, o.OrderDate, DATEADD(DAY, 60, o.OrderDate) AS OrderDatePlus60 FROM Orders AS o

--10. From Customers, CompanyName concatenated with len CompanyName, City concatenated with len City
SELECT c.CompanyName + CAST(LEN(c.CompanyName) AS VARCHAR(30)) AS CompanyNameWithLen, 
c.City + CONVERT(VARCHAR(30), LEN(c.City)) AS CityWithLen 
FROM Customers AS c

--11. From Products, ProductId, UnitPrice * 1.14 (Round to int)
SELECT p.ProductId, CAST(ROUND((p.UnitPrice * 1.14), 0) AS INT) AS PriceRoundedToInt FROM Products AS p

--12. From Employees, concatenate EmployeeId and LastName, DateOfBirth
SELECT CONVERT(VARCHAR(50), e.EmployeeID) + ' - ' + e.LastName AS EmpIdAndLastName, 
CAST(e.BirthDate AS DATE) AS BirthDate FROM Employees AS e

--13. From Employees, LastName in capital letters, DateOfBirth format DD/MM/YY, 
--    only for employees whose firstName starts with the letter 'a' or 'b'
SELECT e.FirstName, UPPER(e.LastName) AS UpperCaseLastName, FORMAT(e.BirthDate, 'dd/MM/yyyy') AS BirthDate FROM Employees AS e
WHERE e.FirstName LIKE '[a, b]%'

--14. From Products, ProductId and SupplierId in the same column with '-' between them.
--    UnitPrice plus 10.54, round result to the bigger number
--    Show only the products whose new price is bigger than 30
SELECT * FROM
(
	SELECT CONVERT(VARCHAR(10), p.ProductID) + ' - ' + CONVERT(VARCHAR(10), p.SupplierID) AS ProdAndSuppId, 
	CEILING(p.UnitPrice + 10.54) AS UnitPrice 
	FROM Products AS p
)AS t
WHERE UnitPrice > 30

--15. From Employees, ReportsTo if a value equals NULL display 'CEO'
--    Birthdate in format 110, LastName concatenated with HireDate
--    Display only for employees whose LastName is longer than their FirstName
SELECT ISNULL(CAST(e.ReportsTo AS VARCHAR(10)), 'CEO') AS ReportsTo, CONVERT(date, e.BirthDate, 110) AS BirthDate, 
e.LastName + ' - ' + CAST(CAST(e.HireDate AS DATE) AS VARCHAR(20)) AS LastNameAndDateHired
FROM Employees AS e
WHERE LEN(e.LastName) > LEN(e.FirstName)

--16. From Employees, LastName, First 3 letters of LastName, only for employees whose LastName contains the letter 'n'
SELECT e.LastName, LEFT(e.LastName, 3) AS First3LastName FROM Employees AS e
WHERE CHARINDEX('n', e.LastName) != 0

--17. From Employees, LastName, LastName reversed, only for employees that have a manager above them
SELECT e.LastName, REVERSE(e.LastName) AS ReversedLastName FROM Employees AS e
WHERE e.ReportsTo IS NOT NULL

--18. From Orders, OrderId, OrderDate, RequirementDate, for all orders whose number of months between OrderDate and 
--    RequirementDate equals 3
SELECT o.OrderID, o.OrderDate, o.RequiredDate FROM Orders AS o
WHERE DATEDIFF(MONTH, o.OrderDate, o.RequiredDate) = 3

