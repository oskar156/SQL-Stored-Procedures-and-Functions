/* Stored Procedure - GRP
	
-concise way of checking how many blanks/nulls there are in a column
-instead of typing SELECT COUNT(*) FROM TABLE WHERE COLUMN IS NULL OR COLUMN='' just write ISBLANK TABLE,COLUMN

-1st parameter, tablename is required
-2nd parameter, col is required
-3rd parameter, dbname is optional 
	-if left blank it will use the DB currently in use
*/

USE [TEMP_OK]
GO
/****** Object:  StoredProcedure [dbo].[GRP]    Script Date: 4/2/2024 11:17:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[ISBLANK]
	-- Add the parameters for the stored procedure here
	@TABLENAME VARCHAR(255)
	,@COL VARCHAR(255)
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

    --Get count OF BLANKS
    SET @Sql = N' SELECT COUNT(*) AS [COUNT] FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
    SET @Sql = @Sql + ' WHERE ' + @COL + ' IS NULL OR ' + @COL + '='''' '
	EXECUTE sp_executesql @Sql

    --SEE BLANKS
    SET @Sql = N' SELECT * FROM [' + @DBNAME + ']..[' + @TABLENAME + '] '
    SET @Sql = @Sql + ' WHERE ' + @COL + ' IS NULL OR ' + @COL + '='''' '
	EXECUTE sp_executesql @Sql

END
