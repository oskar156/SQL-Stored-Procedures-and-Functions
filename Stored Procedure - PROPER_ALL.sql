/* Stored Procedure - PROPER_ALL
	
-makes all columns in a a table proper case (Hello World)

-1st parameter, tablename is required
-2nd parameter, dbname is optional 
	-if left blank it will use the DB currently in use
*/

USE [TEMP_OK]
GO
/****** Object:  StoredProcedure [dbo].[PROPER_ALL]    Script Date: 7/18/2024 2:13:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[PROPER_ALL]
	-- Add the parameters for the stored procedure here
	@TABLENAME VARCHAR(255)
	,@DBNAME VARCHAR(255)=''
AS

BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
    DECLARE @Sql NVARCHAR(4000)

    IF @DBNAME IS NULL OR @DBNAME = '' BEGIN
        SET @DBNAME = DB_NAME()
    END

	--DB
    SET @Sql = N'  '
    SET @Sql = @Sql + ' USE [' + @DBNAME + '];  '
	EXECUTE sp_executesql @Sql;
	
	--CREATE TEMP TABLE FOR COLUMN NAMES
	DECLARE @TEMP_TABLE TABLE (COLUMN_NAMES VARCHAR(255));

	--GET COLUMN NAMES
    INSERT INTO @TEMP_TABLE
	SELECT CONCAT('[',COLUMN_NAME,']') as [COLUMN_NAMES]  
	FROM information_schema.columns  
	WHERE table_name = @TABLENAME;  
	
	--FOR EACH COLUMN...
	DECLARE @CURRENT_COLUMN VARCHAR(255);  
	DECLARE COL_CURSOR CURSOR LOCAL FOR SELECT COLUMN_NAMES FROM @TEMP_TABLE;  

	OPEN COL_CURSOR   
	FETCH NEXT FROM COL_CURSOR  
	INTO @CURRENT_COLUMN  
	WHILE @@FETCH_STATUS = 0  
	BEGIN     

	    SET @Sql = N'  '
	    SET @Sql = @Sql + ' UPDATE [' + @TABLENAME + ']  '
	    SET @Sql = @Sql + ' SET ' + @CURRENT_COLUMN + ' = DBO.PROPER(' + @CURRENT_COLUMN + ') '
		---SELECT @Sql
	    EXECUTE sp_executesql @Sql;

	FETCH NEXT FROM COL_CURSOR  
	INTO @CURRENT_COLUMN  
	END  
   
	CLOSE COL_CURSOR;  
END
