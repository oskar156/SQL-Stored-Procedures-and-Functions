/* Stored Procedure - SMRY
	
-shows the count, top 10 rows, and list of columns in the table
-columns displayed in a way that is easy to copy and paste
	-first column is just bracketed []
	-all following columns are bracketed and preceded by a comma ,[]

-1st parameter, tablename is required
-2nd parameter, dbname is optional 
	-if left blank it will use the DB currently in use
-3rd parameter, count is optional 
	-if left blank it will default to showing the count
	-if passed any value other than 'count', then it will not show the count
	-SMRY is all about convenience and speed, some tables are very large and will take a long time to get their count, that's why it's optional
*/

USE [TEMP_OK]
GO
/****** Object:  StoredProcedure [dbo].[SMRY_OLD]    Script Date: 4/30/2024 3:42:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SMRY_OLD]
	-- Add the parameters for the stored procedure here
	@TABLENAME VARCHAR(255)
	--,@COL VARCHAR(255)=''
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

    --Get count
     IF lower(@COUNT) = 'count' BEGIN
          SET @Sql = N' SELECT COUNT(*) as [COUNT]  FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
          EXECUTE sp_executesql @Sql
     END

    --Get top 10
	SET @Sql = N' SELECT TOP 10 * FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
	EXECUTE sp_executesql @Sql

    --Get all Column Names in a Table and surround them with ,[] (original order)
	SET @Sql = N' SELECT CONCAT(CASE WHEN ROW_NUMBER() OVER(order by (SELECT NULL)) <> 1 THEN '',''END,''['',COLUMN_NAME,'']'') as [COLUMN_NAMES]'
	SET @Sql = @Sql + ' FROM [' + @DBNAME + '].information_schema.columns '
	SET @Sql = @Sql + ' WHERE table_name = ''' + @TABLENAME + ''' '
	EXECUTE sp_executesql @Sql




END

