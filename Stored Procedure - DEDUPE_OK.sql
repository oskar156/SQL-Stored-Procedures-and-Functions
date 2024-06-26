﻿/* Stored Procedure - DEDUPE_OK
	
-dedupes a table by 1 or many columns 
-creates a backup of the original table appended with _OLD
-re-creation of stored procedure from work

-1st parameter, tablename is required
-2nd parameter, COLS is required 
*/

USE [TEMP_OK]
GO
/****** Object:  StoredProcedure [dbo].[DEDUPE_OK]    Script Date: 12/6/2023 11:02:09 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[DEDUPE_OK]
	-- Add the parameters for the stored procedure here
	@TABLENAME VARCHAR(255)
	,@COLS VARCHAR(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    DECLARE @Sql NVARCHAR(4000);

	IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_NAME = N'' + @TABLENAME + '_OLD'))
	BEGIN
	    SET @Sql = N'DROP TABLE [' + @TABLENAME + '_OLD]'
		EXECUTE sp_executesql @Sql
	END

	SET @Sql = N' SELECT * INTO [' + @TABLENAME + '_OLD] FROM [' + @TABLENAME +'] '
	SET @Sql = @Sql + ' DROP TABLE [' + @TABLENAME +'] '
	SET @Sql = @Sql + ' SELECT TOP 0 * INTO [' + @TABLENAME + '] FROM [' + @TABLENAME + '_OLD] '
	SET @Sql = @Sql + ' CREATE UNIQUE INDEX UNIQUE_INDEX ON [' + @TABLENAME + '] (' + @COLS + ') WITH IGNORE_DUP_KEY ON [PRIMARY] '
	SET @Sql = @Sql + ' INSERT INTO [' + @TABLENAME + '] SELECT * FROM [' + @TABLENAME + '_OLD] '
	EXECUTE sp_executesql @Sql
END
