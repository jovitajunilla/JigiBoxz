USE ProjectAkhirGroup1
GO

--Question 1
SELECT CONCAT(Title, CustomerName) AS 'Customer Name',
       CONCAT(MsStaff.StaffID, ' - ', StaffName) AS 'Staff Name',
       COUNT(*) AS 'Total Transactions'
FROM SaleHeader
INNER JOIN MsStaff ON SaleHeader.StaffID = MsStaff.StaffID
INNER JOIN (
	SELECT CustomerID, CustomerName,
		CASE WHEN CustomerGender = 'Male' THEN 'Mr. ' ELSE 'Mrs. ' END AS Title
	FROM MsCustomer
	WHERE YEAR(CustomerDOB) = 1999
) AS FilteredCustomers
ON SaleHeader.CustomerID = FilteredCustomers.CustomerID
WHERE YEAR(TransactionDate) = 2023
GROUP BY FilteredCustomers.Title, FilteredCustomers.CustomerName, MsStaff.StaffID, MsStaff.StaffName

--Question 2
SELECT CONCAT('SalesID ', RIGHT(SaleID, 3)) AS 'Sales ID',
       ProductName,
	   SUM(Quantity) AS 'Total Product Sold'
FROM SaleDetail
INNER JOIN MsProduct ON SaleDetail.ProductID = MsProduct.ProductID
WHERE CAST(RIGHT(SaleID, 3) AS INT) % 2 = 0 AND Quantity BETWEEN 1 AND 5
GROUP BY SaleDetail.SaleID, MsProduct.ProductName

--Question 3
SELECT PurchaseHeader.PurchaseID,
       REPLACE(StaffEmail, SUBSTRING(StaffEmail, CHARINDEX('@', StaffEmail), LEN(StaffEmail)), '@DigiBoxZ.com') AS 'Staff Email',
       VendorName,
       COUNT(*) AS 'Total Purchases Made',
       SUM(PurchaseDetail.Quantity) AS 'Total Quantity'
FROM PurchaseHeader
INNER JOIN MsStaff ON PurchaseHeader.StaffID = MsStaff.StaffID
INNER JOIN MsVendor ON PurchaseHeader.VendorID = MsVendor.VendorID
INNER JOIN PurchaseDetail ON PurchaseHeader.PurchaseID = PurchaseDetail.PurchaseID
WHERE LEN(StaffName) > 5 AND Quantity BETWEEN 1 AND 5
GROUP BY PurchaseHeader.PurchaseID, MsStaff.StaffEmail, MsVendor.VendorName

--Question 4
SELECT CONCAT('SalesID ', RIGHT(SaleHeader.SaleID, 3)) AS 'Sales ID',
       CustomerName,
       CONVERT(VARCHAR(20), TransactionDate, 107) AS 'Sales Date',
       DATEPART(QUARTER, TransactionDate) AS 'Sales Date Quarter',
       SUM(Quantity) AS 'Total Product Sold',
       COUNT(*) AS 'Total Sales Transactions Made'
FROM SaleHeader
INNER JOIN SaleDetail ON SaleHeader.SaleID = SaleDetail.SaleID
INNER JOIN MsCustomer ON SaleHeader.CustomerID = MsCustomer.CustomerID
WHERE YEAR(TransactionDate) = 2024 AND DATEPART(QUARTER, TransactionDate) IN (1, 2)
GROUP BY SaleHeader.SaleID, MsCustomer.CustomerName, SaleHeader.TransactionDate

--Question 5
SELECT RIGHT(MsProduct.ProductID, 3) AS 'Product ID',
	   CONCAT('Staff', RIGHT(PurchaseHeader.StaffID, 3), ' - ', StaffName) AS 'Staff Name',
	   CONCAT('Product', RIGHT(MsProduct.ProductID, 3), ' - ', ProductName) AS 'Product Name',
	   MsProduct.ProductPrice,
	   AvgPrice.AvgProductPrice
FROM PurchaseDetail
INNER JOIN MsProduct ON PurchaseDetail.ProductID = MsProduct.ProductID
INNER JOIN PurchaseHeader ON PurchaseDetail.PurchaseID = PurchaseHeader.PurchaseID
INNER JOIN MsStaff ON PurchaseHeader.StaffID = MsStaff.StaffID
INNER JOIN (
	SELECT PurchaseHeader.PurchaseID, SUM(MsProduct.ProductPrice * PurchaseDetail.Quantity) / SUM(PurchaseDetail.Quantity) AS AvgProductPrice
	FROM PurchaseHeader
	INNER JOIN PurchaseDetail ON PurchaseHeader.PurchaseID = PurchaseDetail.PurchaseID
	INNER JOIN MsProduct ON PurchaseDetail.ProductID = MsProduct.ProductID
	GROUP BY PurchaseHeader.PurchaseID
) AS AvgPrice
ON PurchaseDetail.PurchaseID = AvgPrice.PurchaseID
WHERE CAST(RIGHT(PurchaseHeader.PurchaseID, 3) AS INT) % 2 != 0 AND MsProduct.ProductPrice > AvgPrice.AvgProductPrice


--Question 6
SELECT 
	SaleHeader.SaleID, 
	CONVERT(DATE, TransactionDate, 106) AS 'Sales Date', 
	MsProduct.ProductName, 
	MsProductCategory.ProductCategoryName AS 'CategoryName',
	CONCAT(SaleDetail.Quantity, ' PCS') AS Quantity, 
	CONCAT('$ ', MsProduct.ProductPrice) AS 'Product Price'
FROM 
SaleHeader
INNER JOIN SaleDetail ON SaleHeader.SaleID = SaleDetail.SaleID
INNER JOIN MsProduct ON SaleDetail.ProductID = MsProduct.ProductID
INNER JOIN MsProductCategory ON MsProduct.ProductCategoryID = MsProductCategory.ProductCategoryID
INNER JOIN (
	SELECT SaleDetail.SaleID, SUM(ProductPrice * Quantity) AS TotalPrice
    FROM SaleDetail
	INNER JOIN MsProduct ON SaleDetail.ProductID = MsProduct.ProductID
	GROUP BY SaleDetail.SaleID
) AS TotalPrice 
ON SaleDetail.SaleID = TotalPrice.SaleID
WHERE YEAR(TransactionDate) = 2023 AND (TotalPrice - MsProduct.ProductPrice) > 14000
 
 --Question 7
 SELECT SaleHeader.SaleID, STUFF(CustomerEmail, CHARINDEX('@', CustomerEmail), LEN(CustomerEmail), '@DigiBoxZ.com') AS 'Customer Email',
 CONVERT(DATE, TransactionDate, 113) AS SalesDate,
 ProductName,
 ProductPrice,
 SaleDetail.Quantity
 FROM MsCustomer
  INNER JOIN SaleHeader ON SaleHeader.CustomerID = MsCustomer.CustomerID
  INNER JOIN SaleDetail ON SaleHeader.SaleID = SaleDetail.SaleID
  INNER JOIN MsProduct ON SaleDetail.ProductID = MsProduct.ProductID
  INNER JOIN (
    SELECT 
      SaleDetail.SaleID,
      (MAX(ProductPrice) - MIN(ProductPrice)) AS MaxPriceMinPrice
    FROM 
      SaleDetail
      INNER JOIN MsProduct ON SaleDetail.ProductID = MsProduct.ProductID
    GROUP BY 
     SaleDetail.SaleID
  ) AS MaxPriceMinPrice
  ON SaleDetail.SaleID = MaxPriceMinPrice.SaleID

   WHERE SaleDetail.Quantity > 4 AND ProductPrice <= MaxPriceMinPrice

  --Question 8
SELECT SaleHeader.SaleID AS SalesID,
       CONCAT('VIP CUSTOMER', ' - ', UPPER(CustomerName)) AS 'VIP Customer',
	   MONTH(TransactionDate) AS 'Month',
	   CONCAT('$ ', TotalExpense) AS 'Total Expenses'
FROM SaleHeader
INNER JOIN MsCustomer ON SaleHeader.CustomerID = MsCustomer.CustomerID
INNER JOIN SaleDetail ON SaleHeader.SaleID = SaleDetail.SaleID
INNER JOIN (
	SELECT SaleID,
		   SUM(ProductPrice * Quantity) AS TotalExpense
	FROM MsProduct
	INNER JOIN SaleDetail ON SaleDetail.ProductID = MsProduct.ProductID
	GROUP BY SaleDetail.SaleID
) AS Expense
ON SaleDetail.SaleID = Expense.SaleID
WHERE MONTH(TransactionDate) IN(2, 4, 7)
GROUP BY SaleHeader.SaleID, MsCustomer.CustomerName, SaleHeader.TransactionDate, Expense.TotalExpense
HAVING SUM(TotalExpense) > AVG(TotalExpense)

  --Question 9
  GO
  CREATE VIEW MostAndLessBoughtProductPerCustomer AS
  SELECT STUFF(SaleHeader.SaleID,1,2,'Sales ID ') AS 'Sales ID',
		 STUFF(MsProduct.ProductID,1,2,'Product ID ') AS 'Product ID',
		 CONVERT(DATE, TransactionDate, 113) AS SalesDate,
		 MAX(Quantity) AS 'Most Bought Product',
		 MIN(Quantity) AS 'Less Bought Product'

  FROM SaleHeader
  INNER JOIN SaleDetail ON SaleHeader.SaleID = SaleDetail.SaleID
  INNER JOIN MsProduct ON SaleDetail.ProductID = MsProduct.ProductID

  WHERE ProductWeight > 180 AND ProductPrice > 1500

  GROUP BY SaleHeader.SaleID, MsProduct.ProductID, TransactionDate;


  --Question 10
  GO
  CREATE VIEW SpentAboveMaximumTotalSalesCustomerIn2023 AS
  SELECT UPPER(CustomerName) AS 'Customer Name',
  SUM(ProductPrice * Quantity) AS 'Total Transaction',
  MAX(ProductPrice * Quantity) AS 'Max Total Transaction'

 FROM MsCustomer
  INNER JOIN SaleHeader ON SaleHeader.CustomerID = MsCustomer.CustomerID
  INNER JOIN SaleDetail ON SaleHeader.SaleID = SaleDetail.SaleID
  INNER JOIN MsProduct ON SaleDetail.ProductID = MsProduct.ProductID

  WHERE YEAR(TransactionDate) = 2023 AND 'Total Transaction' > 'Max Total Transaction'

  GROUP BY MsCustomer.CustomerName


 


