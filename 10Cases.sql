USE RoCALink

-- 1
SELECT c.ID, c.Name, CONCAT(COUNT(DISTINCT bt.ID), ' Types') AS [Total Item Variety]
FROM TransactionHeader th JOIN Customer c ON th.CustomerID = c.ID JOIN TransactionDetail td ON th.ID = td.ID JOIN Bike b ON td.BikeID = b.ID JOIN BikeType bt ON b.TypeID = bt.ID
WHERE c.Name LIKE 'A%' AND c.Gender = 'Male'
GROUP BY c.ID, c.Name


-- 2
SELECT DISTINCT bt.Name, bt.ID, COUNT(bgs.ID) AS [Bike Count]
FROM Bike b JOIN BikeType bt ON b.TypeID = bt.ID JOIN BikeGroupSet bgs ON b.GroupSetID = bgs.ID
WHERE bgs.Name LIKE 'Shimano %' AND bgs.GearNumber BETWEEN 7 AND 12
GROUP BY bt.Name, bt.ID


-- 3
SELECT s.ID, s.Name, COUNT(DISTINCT td.BikeID) AS [Number Of Transaction], CONCAT(SUM(td.Quantity), ' Bikes') AS [Number of Bikes Sold]
FROM TransactionHeader th JOIN Staff s ON th.StaffID = s.ID JOIN TransactionDetail td ON th.ID = td.ID
WHERE s.Gender = 'Female' AND LEN(s.Name) BETWEEN 5 AND 10
GROUP BY s.ID, s.Name


-- 4
SELECT DISTINCT bgs.ID, bgs.Name, COUNT(b.ID) AS [Bike Count], FORMAT(AVG(CAST(b.Price AS bigint)), 'C', 'id-ID') AS [Average Price]
FROM BikeGroupSet bgs JOIN Bike b ON bgs.ID = b.GroupSetID JOIN BikeBrand bb ON bb.ID = b.BrandID
WHERE bb.Name LIKE 'C%'
GROUP BY bgs.ID, bgs.Name
HAVING AVG(CAST(b.Price AS BIGINT)) > 150000000 


-- 5
SELECT th.ID, c.Name, DATENAME(WEEKDAY, th.Date) AS [Transaction Day]
FROM TransactionHeader th JOIN Customer c ON th.CustomerID = c.ID JOIN Staff s ON s.ID = th.StaffID,
(
	SELECT AVG(s.Salary) AS [AVGSALARY]
	FROM Staff s
)x
WHERE s.Salary > x.AVGSALARY AND DATENAME(MONTH, th.Date) ='February'


-- 6
SELECT DISTINCT s.Name, b.Name, th.ID, DATENAME(MONTH, th.Date) AS [Transaction Month]
FROM TransactionHeader th JOIN Staff s ON th.StaffID = s.ID JOIN TransactionDetail td ON td.ID = th.ID JOIN Bike b ON td.BikeID = b.ID,
(
	SELECT MAX(y.SumQty)  AS [Max Transaction]
	FROM
	(
		SELECT SUM(td.Quantity) 'SumQty'
		FROM TransactionDetail td JOIN TransactionHeader th ON th.ID = td.ID
		WHERE DAY(th.Date) = 12
		GROUP BY td.ID
	)y
)x
GROUP BY x.[Max Transaction], s.Name, b.Name, th.ID,  DATENAME(MONTH, th.Date)
HAVING SUM(td.Quantity) > x.[Max Transaction]


-- 7
SELECT CONCAT(x.Average, ' Bikes') AS [Average Bikes Sold]
FROM (
	SELECT AVG(td2.Quantity) AS [Average]
	FROM TransactionDetail td2 JOIN Bike b2 ON td2.BikeID = b2.ID JOIN TransactionHeader th2 ON td2.ID = th2.ID
	WHERE  DATEDIFF(YEAR, th2.Date, GETDATE()) > 1  AND b2.Price BETWEEN 100000000 AND 150000000
	)x


-- 8
SELECT CONCAT(MAX(x.Sum), ' Bikes') AS [Max Bikes Purchased]
FROM TransactionHeader th JOIN TransactionDetail td ON th.ID = td.ID JOIN Bike b ON td.BikeID = b.ID,
	(
	SELECT DISTINCT th2.ID, SUM(td2.Quantity) AS [Sum]
	FROM TransactionDetail td2 JOIN TransactionHeader th2 ON th2.ID = td2.ID JOIN Bike b2 ON td2.BikeID = b2.ID
	WHERE b2.Name LIKE 'S%' AND MONTH(th2.Date) BETWEEN 7 AND 12
	GROUP BY th2.ID
	)x


-- 9
CREATE VIEW CustomerView
AS
SELECT  c.Name, COUNT(DISTINCT td.BikeID) AS [Total Transactions], SUM(td.Quantity) AS [Total Bikes Bought], STUFF(c.Phone, 1, 1, '+62') AS [Customer Phone]
FROM Customer c JOIN TransactionHeader th ON th.CustomerID = c.ID JOIN TransactionDetail td ON th.ID = td.ID
GROUP BY c.Name, c.Phone
HAVING COUNT(th.ID) BETWEEN 2 AND 5 AND SUM(td.Quantity) > 5


-- 10
CREATE VIEW TransactionView
AS 
SELECT th.ID, MAX(td.Quantity) AS [Max Quantity], MIN(td.Quantity) AS [Min Quantity], DATEDIFF(DAY, th.Date, GETDATE()) AS [Day Elapsed]
FROM TransactionHeader th JOIN TransactionDetail td ON th.ID = td.ID JOIN Staff s ON s.ID = th.StaffID
WHERE s.Gender = 'Male'
GROUP BY th.ID, th.Date
HAVING MAX(td.Quantity) != MIN(td.Quantity)
