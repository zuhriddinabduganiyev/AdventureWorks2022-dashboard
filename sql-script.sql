-- CREATE NEW TABLE FROM DATABASE

SELECT s1.[SalesOrderID],s1.[RevisionNumber] ,s1.[OrderDate],s1.[DueDate] ,s1.[ShipDate],s1.[Status],
s1.[OnlineOrderFlag],s1.[SalesOrderNumber],s1.[CustomerID],s1.[SalesPersonID],s1.[TerritoryID],
s1.[SubTotal],s1.[TaxAmt],s1.[Freight],s1.[TotalDue],
s2.[SalesOrderDetailID],s2.[OrderQty],s2.[ProductID],s2.[SpecialOfferID],
s2.[UnitPrice],s2.[UnitPriceDiscount],s2.[LineTotal],
s3.[MakeFlag] AS ProductMakeFlag,s3.[FinishedGoodsFlag] AS ProductFinishedGoodsFlag,
s3.[Color] AS ProductColor,s3.[SafetyStockLevel] AS ProductSafetyStockLevel,
s3.[ReorderPoint] AS ProductReorderPoint,s3.[StandardCost] AS ProductStandardCost,
s3.[ListPrice] AS ProductListPrice,s3.[Size] AS ProductSize,
s3.[Weight] AS ProductWeight,s3.[DaysToManufacture] AS ProductDaysToManufacture,
s3.[ProductLine],s3.[Class] AS ProductClass,s3.[Style] AS ProductStyle,
s3.[ProductSubcategoryID],s3.[ProductModelID],
s4.[ProductCategoryID],s4.[Name] AS ProductSubcategoryName,
s5.Name AS ProductCategoryName,
s6.[Name] AS TerritoryName,s6.[CountryRegionCode] AS TerritoryCountryRegionCode,
s6.[Group] AS TerritoryGroup,s6.[SalesYTD] AS TerritorySalesYTD,s6.[SalesLastYear] AS TerritorySalesLastYear,
s6.[CostYTD] AS TerritoryCostYTD,s6.[CostLastYear] AS TerritoryCostLastYear
INTO ImtihonJadvali
  FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] AS s1
  INNER JOIN [AdventureWorks2022].[Sales].[SalesOrderDetail] AS s2
    ON s1.SalesOrderID = s2.SalesOrderID
  INNER JOIN [AdventureWorks2022].[Production].[Product] AS s3
    ON s2.ProductID = s3.ProductID
  INNER JOIN [AdventureWorks2022].[Production].[ProductSubcategory] AS s4
    ON s3.ProductSubcategoryID = s4.ProductSubcategoryID
  INNER JOIN [AdventureWorks2022].[Production].[ProductCategory] AS s5
    ON s4.ProductCategoryID = s5.ProductCategoryID
  INNER JOIN [AdventureWorks2022].[Sales].[SalesTerritory] AS s6 
    ON s1.TerritoryID = s6.TerritoryID
;




--ADD column TotalRevenue
ALTER TABLE ImtihonJadvali
ADD TotalRevenue DECIMAL(18, 2);




-- TotalOrders
SELECT COUNT(DISTINCT SalesOrderID) AS TotalOrders
FROM Sales.SalesOrderHeader;



--- Monthly Revenue
SELECT YEAR(OrderDate) AS Year, 
        MONTH(OrderDate) AS Month, 
        SUM(LineTotal) AS MonthlyRevenue
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY YEAR(OrderDate), MONTH(OrderDate);



-- Revenue Per Customer
SELECT (SUM(LineTotal) / COUNT(DISTINCT CustomerID)) AS RevenuePerCustomer
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID;



--- Calculate Total cost and TotalRevenue 
SELECT SUM(sod.LineTotal) AS TotalRevenue, 
       SUM(pch.StandardCost * sod.OrderQty) AS TotalCost, 
       (SUM(sod.LineTotal) - SUM(pch.StandardCost * sod.OrderQty)) AS GrossProfit
FROM Sales.SalesOrderDetail sod
JOIN Production.ProductCostHistory pch ON sod.ProductID = pch.ProductID;



---Calculate SHipment Count
SELECT cr.Name AS Country, COUNT(soh.SalesOrderID) AS ShipmentCount
FROM Sales.SalesOrderHeader AS soh
JOIN Person.Address AS a ON soh.ShipToAddressID = a.AddressID
JOIN Person.StateProvince AS sp ON a.StateProvinceID = sp.StateProvinceID
JOIN Person.CountryRegion AS cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name;



-- Top 5 Products more sale
SELECT TOP 5 p.Name AS ProductName, SUM(sod.OrderQty) AS TotalQuantitySold
FROM Sales.SalesOrderDetail AS sod
JOIN Production.Product AS p ON sod.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalQuantitySold DESC;