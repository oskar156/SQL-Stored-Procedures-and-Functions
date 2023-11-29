/* Stored Procedure - CNT
	
-concise way to get the count of a table
-instead of typing SELECT COUNT(*) FROM TABLE, just write CNT TABLE

-1st parameter, tablename is required
-2nd parameter, dbname is optional 
	-if left blank it will use the DB currently in use
*/

USE [TEMP_OK]
GO
/****** Object:  StoredProcedure [dbo].[CNT]    Script Date: 11/29/2023 11:03:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[CNT]
	-- Add the parameters for the stored procedure here
	@TABLENAME VARCHAR(255)
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
    SET @Sql = N' SELECT COUNT(*) as [COUNT]  FROM ' + @DBNAME + '..[' + @TABLENAME + '] '
    EXECUTE sp_executesql @Sql
END
