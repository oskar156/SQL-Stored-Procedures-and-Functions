/* Stored Procedure - SLCT
	
-concise way of grouping a table
-instead of typing SELECT TOP(5000) FROM TABLE ORDER BY NEWID() just write SLCT TABLE,'5000','NEWID()'

-1st parameter, tablename is required
-2nd parameter, distinct is optional
	-SELECT DISTINCT
-3rd parameter, top is optional
	-SELECT TOP (@TOP)
-4th parameter, order is optional
	-these are the columns to order by
	-if left blank, it will be ignored
-5th parameter, dbname is optional 
	-if left blank it will use the DB currently in use
*/

USE [TEMP_OK]
GO
/****** Object:  StoredProcedure [dbo].[SLCT]    Script Date: 11/29/2023 11:04:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SLCT]
	-- Add the parameters for the stored procedure here
	@TABLENAME VARCHAR(255)
	,@DISTINCT VARCHAR(255)=''
	,@TOP VARCHAR(255)=''
	,@ORDER VARCHAR(255)=''
	,@DBNAME VARCHAR(255)=''
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
    SET @Sql = N' SELECT ' 
	--* FROM ' + @DBNAME + '..[' + @TABLENAME + '] '

     IF @TOP <> '' BEGIN
          SET @Sql = @Sql + ' DISTINCT ' 
     END

     IF @TOP <> '' BEGIN
          SET @Sql = @Sql + ' TOP (' + @TOP + ') ' 
     END

	 SET @Sql = @Sql + ' * FROM ' + @DBNAME + '..[' + @TABLENAME + '] '


	 IF @ORDER <> '' BEGIN
          SET @Sql = @Sql + ' ORDER BY ' + @ORDER + ''
     END

    EXECUTE sp_executesql @Sql
END
