USE [TEMP_OK]
GO
/****** Object:  StoredProcedure [dbo].[SMRY]    Script Date: 7/21/2025 8:58:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].BREAKDOWN
	-- Add the parameters for the stored procedure here
	@TABLENAME VARCHAR(255)
	,@COL VARCHAR(255)
	,@COL2 VARCHAR(255)
	,@DBNAME VARCHAR(255)=''
	,@COUNT VARCHAR(255)='count'
AS


BEGIN

    IF @DBNAME IS NULL OR @DBNAME = '' BEGIN
        SET @DBNAME = DB_NAME()
    END

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
    DECLARE @Sql NVARCHAR(4000);

	IF @COL='' BEGIN-- THEN SUMMARIZE THE TABLE 
		--Get count
		IF lower(@COUNT) = 'count' BEGIN
			SET @Sql = N' SELECT COUNT(*) as [COUNT]  FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
			EXECUTE sp_executesql @Sql
		END

		--Get top 10
		SET @Sql = N' SELECT TOP 10 * FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
		EXECUTE sp_executesql @Sql

		--Get all Column Names in a Table and surround them with ,[] (original order)
		SET @Sql = N' SELECT CONCAT(''['',COLUMN_NAME,'']'') as [COLUMN_NAMES]'
		SET @Sql = @Sql + ' FROM [' + @DBNAME + '].information_schema.columns '
		SET @Sql = @Sql + ' WHERE table_name = ''' + @TABLENAME + ''' '
		EXECUTE sp_executesql @Sql
	END

	--create the "case when then" part of the query
	CREATE TABLE #TempTable
	(
		ColumnName VARCHAR(255)
	)

	insert into #TempTable(ColumnName)
	select value
	from string_split(@COL2, ',')
	
	DECLARE @RowCount INT = (SELECT COUNT(*) FROM #TempTable)
	DECLARE @i INT = @RowCount
	DECLARE @CurrentColumnName VARCHAR(255)
	DECLARE @ColumnNameQuery NVARCHAR(4000) = N''
	
	WHILE @i > 0 BEGIN  
		SELECT @CurrentColumnName=ColumnName
 		FROM #TempTable   
 		ORDER BY ColumnName DESC OFFSET @RowCount - @i ROWS FETCH NEXT 1 ROWS ONLY
		
		SET @ColumnNameQuery = N'' + @ColumnNameQuery + N', COUNT(CASE WHEN ' + @CurrentColumnName + ' IS NOT NULL AND ' + @CurrentColumnName + '<>'''' THEN 1 ELSE NULL END) AS [' + @CurrentColumnName + '_COUNT]'
		SET @i -= 1
	END  

	IF @COL<>'' AND LEFT(@COL, 1) <> '$' BEGIN-- THEN SUMMARIZE THE COLUMN 
	
		SET @Sql = N' SELECT COUNT(CASE WHEN ' + REPLACE(@COL,',','+') + ' IS NULL THEN 1 ELSE 1 END) AS [COUNT]'
		SET @Sql = @Sql + ' , COUNT(CASE WHEN ' + REPLACE(@COL,',','+') + ' IS NOT NULL AND ' + REPLACE(@COL,',','+') + ' <>'''' THEN 1 END) AS [NOT BLANK AND NOT NULL COUNT] '
		SET @Sql = @Sql + ' , COUNT(DISTINCT ' + REPLACE(@COL,',','+') + ' ) AS [DISTINCT COUNT] '
		SET @Sql = @Sql + ' FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
		EXECUTE sp_executesql @Sql
		
		SET @Sql = N' SELECT ' + @COL + ', COUNT(*) AS [COUNT] ' + @ColumnNameQuery
		SET @Sql = @Sql + ' FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
		SET @Sql = @Sql + ' GROUP BY ' + @COL + ' '
		SET @Sql = @Sql + ' ORDER BY    COUNT(*) DESC ,  ' + @COL 
		EXECUTE sp_executesql @Sql

	END


	IF @COL<>'' AND LEFT(@COL, 1) = '$' BEGIN-- THEN SUMMARIZE THE COLUMN 

		SET @Sql = N' SELECT COUNT(CASE WHEN ' + RIGHT(@COL, LEN(@COL) - 1) + ' IS NULL THEN 1 ELSE 1 END) AS [COUNT]'
		SET @Sql = @Sql + ' , COUNT(CASE WHEN ' + RIGHT(@COL, LEN(@COL) - 1) + ' IS NOT NULL AND ' + RIGHT(@COL, LEN(@COL) - 1) + ' <>'''' THEN 1 END) AS [NOT BLANK AND NOT NULL COUNT] '
		SET @Sql = @Sql + ' , COUNT(DISTINCT ' + RIGHT(@COL, LEN(@COL) - 1) + ' ) AS [DISTINCT COUNT] '
		SET @Sql = @Sql + ' FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
		EXECUTE sp_executesql @Sql
		
		SET @Sql = N' SELECT ' + RIGHT(@COL, LEN(@COL) - 1) + ', COUNT(*) AS [COUNT] ' + @ColumnNameQuery
		SET @Sql = @Sql + ' FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
		SET @Sql = @Sql + ' GROUP BY ' + RIGHT(@COL, LEN(@COL) - 1) + ' '
		SET @Sql = @Sql + ' ORDER BY    COUNT(*) DESC ,  ' + RIGHT(@COL, LEN(@COL) - 1)
		EXECUTE sp_executesql @Sql
	END
END
