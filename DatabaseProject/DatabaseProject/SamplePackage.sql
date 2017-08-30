
/****** Object:  UserDefinedFunction [dbo].[ufnGetAllCategories]    Script Date: 8/28/2017 12:40:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[ufnGetAllCategories]()
RETURNS @retCategoryInformation TABLE
(
    -- Columns returned by the function
    [ParentProductCategoryName] nvarchar(50) NULL,
    [ProductCategoryName] nvarchar(50) NOT NULL,
    [ProductCategoryID] int NOT NULL
)
AS
-- Returns the CustomerID, first name, and last name for the specified customer - test by ccu adp 1.
BEGIN
    WITH CategoryCTE([ParentProductCategoryID], [ProductCategoryID], [Name]) AS
    (
        SELECT [ParentProductCategoryID], [ProductCategoryID], [Name]
        FROM SalesLT.ProductCategory
        WHERE ParentProductCategoryID IS NULL

    UNION ALL

        SELECT C.[ParentProductCategoryID], C.[ProductCategoryID], C.[Name]
        FROM SalesLT.ProductCategory AS C
        INNER JOIN CategoryCTE AS BC ON BC.ProductCategoryID = C.ParentProductCategoryID
    )

    INSERT INTO @retCategoryInformation
    SELECT PC.[Name] AS [ParentProductCategoryName], CCTE.[Name] as [ProductCategoryName], CCTE.[ProductCategoryID]
    FROM CategoryCTE AS CCTE
    JOIN SalesLT.ProductCategory AS PC
    ON PC.[ProductCategoryID] = CCTE.[ParentProductCategoryID];
    RETURN;
END;
