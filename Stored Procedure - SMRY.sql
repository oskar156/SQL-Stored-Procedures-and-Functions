/* Stored Procedure - SMRY
	
-shows the count, top 10 rows, and list of columns in the table
-columns displayed in a way that is easy to copy and paste
	-first column is just bracketed []
	-all following columns are bracketed and preceded by a comma ,[]

-1st parameter, tablename is required
-2nd parameter, col is optional
	-if left blank it will summarize the table
	-if filled in, then it will summarize the column instead
-3rd parameter, dbname is optional 
	-if left blank it will use the DB currently in use
-4th parameter, count is optional 
	-if left blank it will default to showing the count
	-if passed any value other than 'count', then it will not show the count
	-SMRY is all about convenience and speed, some tables are very large and will take a long time to get their count, that's why it's optional
*/

USE [TEMP_OK]
GO
/****** Object:  StoredProcedure [dbo].[SMRY]    Script Date: 4/30/2024 3:40:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SMRY]
	-- Add the parameters for the stored procedure here
	@TABLENAME VARCHAR(255)
	,@COL VARCHAR(255)=''
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

	IF @COL<>'' BEGIN-- THEN SUMMARIZE THE COLUMN 

		SET @Sql = N' SELECT COUNT(CASE WHEN ' + REPLACE(@COL,',','+') + ' IS NULL THEN 1 ELSE 1 END) AS [COUNT]'
		SET @Sql = @Sql + ' , COUNT(CASE WHEN ' + REPLACE(@COL,',','+') + ' IS NOT NULL AND ' + REPLACE(@COL,',','+') + ' <>'''' THEN 1 END) AS [NOT BLANK AND NOT NULL COUNT] '
		SET @Sql = @Sql + ' , COUNT(DISTINCT ' + REPLACE(@COL,',','+') + ' ) AS [DISTINCT COUNT] '
		SET @Sql = @Sql + ' FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
		EXECUTE sp_executesql @Sql
		
		SET @Sql = N' SELECT ' + @COL + ', COUNT(*) AS [COUNT] '
		SET @Sql = @Sql + ' FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
		SET @Sql = @Sql + ' GROUP BY ' + @COL + ' '
		SET @Sql = @Sql + ' ORDER BY    COUNT(*) DESC ,  ' + @COL 
		EXECUTE sp_executesql @Sql
	END
END
