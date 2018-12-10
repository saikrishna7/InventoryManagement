USE MASTER;     
-- 1) Check for the Database Exists .If the database is exist then drop and create new DB     
IF EXISTS (SELECT [name] FROM sys.databases WHERE [name] = 'TCOBInventoryDB' )     
BEGIN     
ALTER DATABASE TCOBInventoryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE     
DROP DATABASE TCOBInventoryDB ;     
END     
     
     
CREATE DATABASE TCOBInventoryDB   
GO     
     
USE TCOBInventoryDB     
GO 
/****** Object:  Table [dbo].[Inventory]    Script Date: 5/11/2016 11:15:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Inventory](
	[InventoryId] [int] IDENTITY(1,1) NOT NULL,
	[SerialNumber] [nvarchar](255) NOT NULL,
	[Type] [nvarchar](255) NOT NULL,
	[Make] [nvarchar](255) NOT NULL,
	[Model] [nvarchar](255) NOT NULL,
	[User] [nvarchar](255) NOT NULL,
	[UserStatus] [varchar](255) NULL,
	[Department] [varchar](255) NULL,
	[Location] [varchar](255) NULL,
	[OwnedBy] [varchar](255) NULL,
	[PurchaseDate] [date] NULL,
	[AuxComputerDate] [date] NULL,
 CONSTRAINT [primkey] PRIMARY KEY CLUSTERED 
(
	[InventoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO

/****** Object:  StoredProcedure [dbo].[Delete_Inventory_DeleteTempTableData]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Delete_Inventory_DeleteTempTableData]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		DELETE FROM [dbo].[tblTempInventory] 
		
	END
END




GO
/****** Object:  StoredProcedure [dbo].[Get_Recent_Inventory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Get_Recent_Inventory]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT * FROM [dbo].[ComputerInventory] ORDER BY InventoryId DESC
		
	END
END


GO
/****** Object:  StoredProcedure [dbo].[Inventory_GetInventoryData]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE PROCEDURE [dbo].[Inventory_GetInventoryData] 
(
	@SerialNum Varchar(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT SerialNumber, Make, Model, ComputerName FROM [dbo].[ComputerInventoryTest]
		WHERE SerialNumber = @SerialNum
	END
END



GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_AddUser]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM dbo.ComputerInventory WHERE InventoryId = 1953
CREATE PROCEDURE [dbo].[sp_ComputerInventory_AddUser]
(
	 @FullName as NVARCHAR(MAX)
	,@Pawprint as NVARCHAR(50)
)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO dbo.ComputerInventory_tblUserStorage(
	 FullName
	,Pawprint
	) VALUES (
     @FullName 
	,@Pawprint
	)

END



GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_Compare]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ensui Chen
-- Create date: 07/29/2008
-- Description:	Compare MWI results aginst the main table
-- =============================================
create PROCEDURE [dbo].[sp_ComputerInventory_Compare] 
	-- Add the parameters for the stored procedure here
AS
	declare
	@cName nvarchar(15),
	@PStat nvarchar(10),
	@serialNum nvarchar(25),
	@strCPU nvarchar(100),
	@intCPU int,
	@strOS nvarchar(100),
	@intOS int,
	@bigIntRAM bigint,
	@intRAM int,
	@strMake nvarchar(50),
	@intMake int,
	@strModel nvarchar(50),
	@intModel int,
	@errorMsg nvarchar(250),

	@SNTemp nvarchar(25),
	@cNameTemp nvarchar(15);

	DECLARE result_cursor CURSOR FOR 
		SELECT compname, pingstatus, sn, cpu, os, ram, make, model, errormsg
			FROM ComputerInventory_tblResults;
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	OPEN result_cursor

	FETCH NEXT FROM result_cursor
		INTO @cName,@PStat,@serialNum,@strCPU,@strOS,@bigIntRAM,@strMake,@strModel,@errorMsg;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		if (@serialNum is not null) and (len(@serialNum) > 0)
		begin
			set @cNameTemp = (select compname from main where sn = @serialNum)
			PRINT @cName + ' - ' + @cNameTemp + ' - ' + @serialNum;
		end
		else
		begin
			PRINT @cName + ' - ' + @errorMsg;
		end
		FETCH NEXT FROM result_cursor
			INTO @cName,@PStat,@serialNum,@strCPU,@strOS,@bigIntRAM,@strMake,@strModel,@errorMsg;
	END
	CLOSE result_cursor
	DEALLOCATE result_cursor
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_DeptID]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_ComputerInventory_DeptID] AS
	declare
		@intID int,
		@strUpdate varchar(255)
	declare Dept_cursor CURSOR
	FOR select ComputerInventory_tblDepartment.DeptID, ComputerInventory_tblDepartment.Dept from ComputerInventory_tblDepartment
	
	OPEN Dept_cursor
	FETCH NEXT FROM Dept_cursor INTO @intID, @strUpdate
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			begin try
				update ComputerInventory_tblMain set ComputerInventory_tblMain.Dept = str(@intID) where ComputerInventory_tblMain.Dept = @strUpdate;
			end try
			begin catch
				select @intID as ID, @strUpdate as Text,
					ERROR_NUMBER() AS ErrorNumber,ERROR_SEVERITY() AS ErrorSeverity,
					ERROR_STATE() AS ErrorState,ERROR_PROCEDURE() AS ErrorProcedure,
					ERROR_LINE() AS ErrorLine,ERROR_MESSAGE() AS ErrorMessage;
			end catch
			FETCH NEXT FROM Dept_cursor INTO @intID, @strUpdate
		END

	CLOSE Dept_cursor
	DEALLOCATE Dept_cursor

	/* SET NOCOUNT ON */ 
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_Get_Users]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Paul Stypula
-- Description:	gets full name and pawprint stored in userStorage
-- =============================================
CREATE PROCEDURE [dbo].[sp_ComputerInventory_Get_Users]

AS
BEGIN
	SET NOCOUNT ON;
	SELECT FullName, Pawprint FROM dbo.ComputerInventory_tblUserStorage
END



GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_MA]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_ComputerInventory_MA] AS
	declare
		@intID int,
		@strModel varchar(255)
--		@strMake varchar(255),
--		@strCPU varchar(255)
--		@strHDD varchar(255)
--		@strDept varchar(255)
	declare model_cursor CURSOR
	FOR select distinct ComputerInventory_tblMain.model from ComputerInventory_tblMain where ltrim(rtrim(ComputerInventory_tblMain.model)) not in (select ltrim(rtrim(model)) from ComputerInventory_tblModel) and ltrim(rtrim(ComputerInventory_tblMain.model)) not in (select ltrim(rtrim(id)) from ComputerInventory_tblModel)
	
	OPEN model_cursor
	FETCH NEXT FROM model_cursor INTO @strModel

	set @intID = (select max(cast(id as int)) from ComputerInventory_tblModel) + 1
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			begin try
				insert into ComputerInventory_tblModel values (ltrim(rtrim(str(@intID))), @strModel)
			end try
			begin catch
				select @strModel as ComputerInventory_tblModel,
					ERROR_NUMBER() AS ErrorNumber,ERROR_SEVERITY() AS ErrorSeverity,
					ERROR_STATE() AS ErrorState,ERROR_PROCEDURE() AS ErrorProcedure,
					ERROR_LINE() AS ErrorLine,ERROR_MESSAGE() AS ErrorMessage;
			end catch
			set @intID = @intID + 1
			FETCH NEXT FROM model_cursor INTO @strModel
		END

	CLOSE model_cursor
	DEALLOCATE model_cursor

	/* SET NOCOUNT ON */ 
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_MakeID]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_ComputerInventory_MakeID] AS
	declare
		@intID int,
		@strUpdate varchar(255)
	declare Make_cursor CURSOR
	FOR select ComputerInventory_tblMake.ID, ComputerInventory_tblMake.Manuf from ComputerInventory_tblMake
	
	OPEN Make_cursor
	FETCH NEXT FROM Make_cursor INTO @intID, @strUpdate
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			begin try
				update ComputerInventory_tblMain set ComputerInventory_tblMain.Make = str(@intID) where ComputerInventory_tblMain.Make = @strUpdate;
			end try
			begin catch
				select @intID as ID, @strUpdate as CPUType,
					ERROR_NUMBER() AS ErrorNumber,ERROR_SEVERITY() AS ErrorSeverity,
					ERROR_STATE() AS ErrorState,ERROR_PROCEDURE() AS ErrorProcedure,
					ERROR_LINE() AS ErrorLine,ERROR_MESSAGE() AS ErrorMessage;
			end catch
			FETCH NEXT FROM Make_cursor INTO @intID, @strUpdate
		END

	CLOSE Make_cursor
	DEALLOCATE Make_cursor

	/* SET NOCOUNT ON */ 
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_ModelID]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_ComputerInventory_ModelID] AS
	declare
		@intID int,
		@strUpdate varchar(255)
	declare Model_cursor CURSOR
	FOR select ComputerInventory_tblModel.ID, ComputerInventory_tblModel.Model from ComputerInventory_tblModel
	
	OPEN Model_cursor
	FETCH NEXT FROM Model_cursor INTO @intID, @strUpdate
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			begin try
				update ComputerInventory_tblMain set ComputerInventory_tblMain.Model = ltrim(rtrim(str(@intID))) where ComputerInventory_tblMain.Model = @strUpdate;
			end try
			begin catch
				select @intID as ID, @strUpdate as model,
					ERROR_NUMBER() AS ErrorNumber,ERROR_SEVERITY() AS ErrorSeverity,
					ERROR_STATE() AS ErrorState,ERROR_PROCEDURE() AS ErrorProcedure,
					ERROR_LINE() AS ErrorLine,ERROR_MESSAGE() AS ErrorMessage;
			end catch
			FETCH NEXT FROM Model_cursor INTO @intID, @strUpdate
		END

	CLOSE Model_cursor
	DEALLOCATE Model_cursor

	/* SET NOCOUNT ON */ 
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_NewMake]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ensui Chen
-- Create date: 08/08/2008
-- Description:	Check for new Make(s) and update the Make table
-- =============================================
create PROCEDURE [dbo].[sp_ComputerInventory_NewMake] 
AS
DECLARE
	@intMake int, 
	@strMake nvarchar(100)
declare
	result_Make_cursor CURSOR FOR 
		SELECT distinct ComputerInventory_tblMake
			FROM results;
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	OPEN result_Make_cursor

	FETCH NEXT FROM result_Make_cursor
		INTO @strMake;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		set @intMake = (select ID from ComputerInventory_tblMakeTest where Manuf = @strMake)
		if ((@intMake is null) or (@intMake < 0)) and (len(rtrim(ltrim(@strMake))) > 0)
		begin
			set @intMake = (select max(ID)+1 from ComputerInventory_tblMakeTest)
			print CAST(@intMake AS varchar(4)) + ', ' + @strMake + ' is added to the table.'
			insert into ComputerInventory_tblMakeTest (ID, Manuf) values (@intMake, @strMake)
		end
		else
		begin
			print '******** ' + @strMake + ' is in the table, no row added.'
		end
		FETCH NEXT FROM result_Make_cursor
			INTO @strMake;
	END
	CLOSE result_Make_cursor
	DEALLOCATE result_Make_cursor
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_NewModel]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ensui Chen
-- Create date: 08/08/2008
-- Description:	Check for new Model(s) and update the Model table
-- =============================================
create PROCEDURE [dbo].[sp_ComputerInventory_NewModel]
AS
DECLARE
	@intModel int, 
	@strModel nvarchar(100)
declare
	result_Model_cursor CURSOR FOR 
		SELECT distinct ComputerInventory_tblModel
			FROM results;
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	OPEN result_Model_cursor

	FETCH NEXT FROM result_Model_cursor
		INTO @strModel;
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		set @intModel = (select ID from ComputerInventory_tblModelTest where Model = @strModel)
		if ((@intModel is null) or (@intModel < 0)) and (len(rtrim(ltrim(@strModel))) > 0)
		begin
			set @intModel = (select max(ID)+1 from ComputerInventory_tblModelTest)
			print CAST(@intModel AS varchar(4)) + ', ' + @strModel + ' is added to the table.'
			insert into ComputerInventory_tblModelTest (ID, Model) values (@intModel, @strModel)
		end
		else
		begin
			print '******** ' + @strModel + ' is in the table, no row added.'
		end
		FETCH NEXT FROM result_Model_cursor
			INTO @strModel;
	END
	CLOSE result_Model_cursor
	DEALLOCATE result_Model_cursor
END

GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_Trim]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_ComputerInventory_Trim] AS
	declare
		@strModel varchar(255)
--		@strMake varchar(255),
--		@strCPU varchar(255)
--		@strHDD varchar(255)
--		@strDept varchar(255)
	declare trim_cursor CURSOR
	FOR select distinct ComputerInventory_tblMain.model from ComputerInventory_tblMain
	
	OPEN trim_cursor
	FETCH NEXT FROM trim_cursor INTO @strModel
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			begin try
				update ComputerInventory_tblMain set ComputerInventory_tblMain.model = ltrim(rtrim(@strModel)) where ComputerInventory_tblMain.model = @strModel;
			end try
			begin catch
				select @strModel as model,
					ERROR_NUMBER() AS ErrorNumber,ERROR_SEVERITY() AS ErrorSeverity,
					ERROR_STATE() AS ErrorState,ERROR_PROCEDURE() AS ErrorProcedure,
					ERROR_LINE() AS ErrorLine,ERROR_MESSAGE() AS ErrorMessage;
			end catch
			FETCH NEXT FROM trim_cursor INTO @strModel
		END

	CLOSE trim_cursor
	DEALLOCATE trim_cursor

	/* SET NOCOUNT ON */ 
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_ComputerInventory_TypeID]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_ComputerInventory_TypeID] AS
	declare
		@intID int,
		@strUpdate varchar(255)
	declare Type_cursor CURSOR
	FOR select ComputerInventory_tblType.ID, ComputerInventory_tblType.Type from ComputerInventory_tblType
	
	OPEN Type_cursor
	FETCH NEXT FROM Type_cursor INTO @intID, @strUpdate
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			begin try
				update ComputerInventory_tblMain set ComputerInventory_tblMain.Type = ltrim(rtrim(str(@intID))) where ComputerInventory_tblMain.Type = @strUpdate;
			end try
			begin catch
				select @intID as ID, @strUpdate as what,
					ERROR_NUMBER() AS ErrorNumber,ERROR_SEVERITY() AS ErrorSeverity,
					ERROR_STATE() AS ErrorState,ERROR_PROCEDURE() AS ErrorProcedure,
					ERROR_LINE() AS ErrorLine,ERROR_MESSAGE() AS ErrorMessage;
			end catch
			FETCH NEXT FROM Type_cursor INTO @intID, @strUpdate
		END

	CLOSE Type_cursor
	DEALLOCATE Type_cursor

	/* SET NOCOUNT ON */ 
	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_Get_Departments]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ben Sammons
-- Description:	grabs feedback survey data for a particular ticket if it exists
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_Departments]

AS
BEGIN
	SET NOCOUNT ON;
	SELECT Department_Name FROM dbo.TS_Departments_Serviced
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_AddNewTempTable]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Name
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[sp_Inventory_AddNewTempTable]
(
	@SerialNumber VARCHAR(255) = NULL,
	@Make VARCHAR(255) = NULL,
	@Model VARCHAR(255) = NULL,
	@ComputerName VARCHAR(255) = NULL,
	@Type VARCHAR(255) = NULL,
	@Category VARCHAR(255) = NULL,
	@User VARCHAR(255) = NULL,
	@UserPawprint VARCHAR(255) = NULL,
	@Department VARCHAR(255) = NULL,
	@Location VARCHAR(255) = NULL,
	@Letter VARCHAR(2) = NULL,
	@Building VARCHAR(255) = NULL,
	@Note VARCHAR(255) = NULL,	
	@OwnedBy VARCHAR(255) = NULL,
	@PurchaseDate VARCHAR(255) = NULL,
	@AuxComputerDate VARCHAR(255) = NULL,
	@RecordStatus VARCHAR(255) = NULL,
	@DateCreated VARCHAR(255) = NULL,
	@LastUpdate VARCHAR(255) = NULL,
	@LastVerified VARCHAR(255) = NULL
	
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN
		--INSERT INTO [dbo].[tblTestTemp]
		--VALUES (@SerialNum,@Type,@Make,@Model,@User,@Department,@Location,@OwnedBy,@PurchaseDate,@AuxComputerDate)
		INSERT INTO [dbo].[tblTempNewInventory]
		(SerialNumber,Make,Model,ComputerName,[Type],Category,[User],UserPawprint,Department,Location,RoomLetter,Building,note,OwnedBy,PurchaseDate,AuxComputerDate,RecordStatus)
		VALUES (@SerialNumber,@Make,@Model,@ComputerName,@Type,@Category,@User,@UserPawprint,@Department,@Location,@Letter,@Building,@Note,@OwnedBy,@PurchaseDate,@AuxComputerDate,@RecordStatus)
	END

	
	--BEGIN
	--SELECT MAX(Author_Id) as newid FROM authors
 --END
    --RETURN 1
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_AddRecord]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_Inventory_AddRecord]
(
	 @SerialNumber as NVARCHAR(255)
	,@Type as NVARCHAR(255)
	,@Make as NVARCHAR(255)
	,@Model as NVARCHAR(255)
	,@ComputerName as NVARCHAR(255)
	,@User as NVARCHAR(255) = NULL
	,@UserPawprint as NVARCHAR(64) = NULL
	,@Category as NVARCHAR(255)
	,@Department as NVARCHAR(255)
	,@Room as NVarchar(255) = NULL
	,@Building as NVARCHAR(255) = NULL
	,@Note as NVARCHAR(512) = NULL
	,@RoomLetter as VARCHAR(2) = NULL
	,@OwnedBy as NVARCHAR(255)
	,@PurchaseDate as NVARCHAR(255) = NULL
	,@AuxComputerDate as NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION
	INSERT INTO dbo.ComputerInventory(
	 SerialNumber
	,[Type]
	,Make
	,Model
	,[User]
	,UserPawprint
	,Category
	,Department
	,Room
	,Letter
	,Building
	,OwnedBy
	,PurchaseDate
	,AuxComputerDate
	,DateCreated
	,LastUpdate
	,Note
	,ComputerName
	) VALUES (
     @SerialNumber 
	,@Type 
	,@Make 
	,@Model 
	,@User
	,@UserPawprint
	,@Category 
	,@Department 
	,@Room
	,@RoomLetter
	,@Building 
	,@OwnedBy 
	,@PurchaseDate
	,@AuxComputerDate
	,CURRENT_TIMESTAMP
	,CURRENT_TIMESTAMP
	,@Note
	,@ComputerName
	)
	
	COMMIT TRANSACTION
END





GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_AddTempTable]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[sp_Inventory_AddTempTable] 
(
	@SerialNumber VARCHAR(255) = NULL,
	@Make VARCHAR(255) = NULL,
	@Model VARCHAR(255) = NULL,
	@ComputerName VARCHAR(255) = NULL,
	@RecordStatus VARCHAR(255) = NULL,
	@Type VARCHAR(255) = NULL,
	@Category VARCHAR(255) = NULL,
	@User VARCHAR(255) = NULL,
	@UserPawprint VARCHAR(255) = NULL,	
	@Department VARCHAR(255) = NULL,			
	@Room VARCHAR(64) = NULL,
	@Letter VARCHAR(2) = NULL,
	@Building VARCHAR(255) = NULL,	
	@Note [Text] = NULL,
	@OwnedBy VARCHAR(255) = NULL,
	@PurchaseDate VARCHAR(255) = NULL,
	@AuxComputerDate VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN
		--INSERT INTO [dbo].[tblTestTemp]
		--VALUES (@SerialNum,@Type,@Make,@Model,@User,@Department,@Location,@OwnedBy,@PurchaseDate,@AuxComputerDate)
		INSERT INTO [dbo].[tblTempInventory]
		(SerialNumber,Make,Model,ComputerName,RecordStatus,[Type],Category,[User],UserPawprint,Department, Building, OwnedBy, PurchaseDate, AuxComputerDate, Room, Letter, Note)
		VALUES (@SerialNumber, @Make, @Model, @ComputerName, @RecordStatus, @Type, @Category, @User, @UserPawprint, @Department, @Building, @OwnedBy, @PurchaseDate, @AuxComputerDate, @Room, @Letter, @Note )
	END

	
	--BEGIN
	--SELECT MAX(Author_Id) as newid FROM authors
 --END
    --RETURN 1
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_AddUsers]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SELECT * FROM dbo.ComputerInventory WHERE InventoryId = 1953
CREATE PROCEDURE [dbo].[sp_Inventory_AddUsers]
(
	@FullName as NVARCHAR(MAX),
	@Pawprint as NVARCHAR(50)
	
)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[ComputerInventory_tblUserStorage]
	(
		FullName,
		Pawprint
	
	)
	VALUES(
		@FullName,
		@Pawprint
	)

END





GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_CreateRecord]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM dbo.ComputerInventory WHERE InventoryId = 1953
CREATE PROCEDURE [dbo].[sp_Inventory_CreateRecord]
(
	 @SerialNumber as NVARCHAR(255)
	,@Type as NVARCHAR(255)
	,@Make as NVARCHAR(255)
	,@Model as NVARCHAR(255)
	,@User as NVARCHAR(255) = NULL
	,@UserPawprint as NVARCHAR(64) = NULL
	,@Category as NVARCHAR(255)
	,@Department as NVARCHAR(255)
	,@Room as NVarchar(255) = NULL
	,@Building as NVARCHAR(255) = NULL
	,@Note as NVARCHAR(512) = NULL
	,@RoomLetter as VARCHAR(2) = NULL
	,@OwnedBy as NVARCHAR(255)
	,@PurchaseDate as NVARCHAR(255) = NULL
	,@AuxComputerDate as NVARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION
	INSERT INTO dbo.ComputerInventory(
	 SerialNumber
	,[Type]
	,Make
	,Model
	,[User]
	,UserPawprint
	,Category
	,Department
	,Room
	,Letter
	,Building
	,OwnedBy
	,PurchaseDate
	,AuxComputerDate
	,DateCreated
	,LastUpdate
	,Note
	) VALUES (
     @SerialNumber 
	,@Type 
	,@Make 
	,@Model 
	,@User
	,@UserPawprint
	,@Category 
	,@Department 
	,@Room
	,@RoomLetter
	,@Building 
	,@OwnedBy 
	,@PurchaseDate
	,@AuxComputerDate
	,CURRENT_TIMESTAMP
	,CURRENT_TIMESTAMP
	,@Note
	)
	SELECT MAX(InventoryId) FROM dbo.ComputerInventory
	COMMIT TRANSACTION
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_DeleteRecord]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM dbo.ComputerInventory WHERE InventoryId = 1953
CREATE PROCEDURE [dbo].[sp_Inventory_DeleteRecord]
(
	 @InventoryId as integer
)
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM dbo.ComputerInventory WHERE InventoryId = @InventoryId
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_DeleteRecordTemp]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [dbo].[sp_Inventory_DeleteRecordTemp]
(
	@SerialNumber VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		DELETE FROM [dbo].[tblTempNewInventory]
		WHERE SerialNumber = @SerialNumber
	END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_DeleteTempTableData]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[sp_Inventory_DeleteTempTableData]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		DELETE FROM [dbo].[tblTempNewInventory] 
		
	END
END




GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetCategories]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ben Sammons
-- =============================================
CREATE PROCEDURE [dbo].[sp_Inventory_GetCategories]

AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM dbo.ComputerInventory_tblCategory
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetCategory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_Inventory_GetCategory]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Category_Name FROM [dbo].[ComputerInventory_tblCategory]
	END
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetDepartmentNames]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_Inventory_GetDepartmentNames]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Dept FROM [dbo].[ComputerInventory_tblDepartment]
	END
END




GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetInventoryData]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE PROCEDURE [dbo].[sp_Inventory_GetInventoryData] 
(
	@SerialNum Varchar(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT SerialNumber, Make, Model, ComputerName FROM [dbo].[ComputerInventory]
		WHERE SerialNumber = @SerialNum
	END
END




GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetInventoryDataFromActual]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE PROCEDURE [dbo].[sp_Inventory_GetInventoryDataFromActual] 
(
	@SerialNum Varchar(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT [SerialNumber]
      ,[Type]
      ,[Make]
      ,[Model]
	  ,[ComputerName]
      ,[User]
      ,[UserPawprint]
      ,[Category]
      ,[Department]
      ,[Location]
      ,[Room]
      ,[Letter]
      ,[Building]
      ,[OwnedBy]
      ,[PurchaseDate]
      ,[AuxComputerDate]
	  ,[Note]
	   FROM [dbo].[ComputerInventory]
		WHERE SerialNumber = @SerialNum
	END
END





GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetInventoryMake]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[sp_Inventory_GetInventoryMake]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Manuf FROM [dbo].[ComputerInventory_tblMake]
	END
END






GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetInventoryModel]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[sp_Inventory_GetInventoryModel]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Model FROM [dbo].[ComputerInventory_tblModel]
	END
END






GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetInventoryOwnedBy]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[sp_Inventory_GetInventoryOwnedBy]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Dept FROM [dbo].[ComputerInventory_tblOwnedBy]
	END
END





GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetInventoryType]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_Inventory_GetInventoryType]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Type FROM [dbo].[ComputerInventory_tblType]
	END
END




GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetMakes]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ben Sammons
-- =============================================
CREATE PROCEDURE [dbo].[sp_Inventory_GetMakes]

AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM dbo.ComputerInventory_tblMake
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetModels]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ben Sammons
-- Description:	grabs feedback survey data for a particular ticket if it exists
-- =============================================
CREATE PROCEDURE [dbo].[sp_Inventory_GetModels]

AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM dbo.ComputerInventory_tblModel
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetRecord]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Inventory_GetRecord]
@id as Integer
AS
BEGIN
	SET NOCOUNT ON
	SELECT * FROM dbo.ComputerInventory c WHERE c.InventoryId = @id
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetRecordInventoryDB]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO












CREATE PROCEDURE [dbo].[sp_Inventory_GetRecordInventoryDB]
(
	@SerialNum Varchar(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT
		[SerialNumber]
		,[Make]
		,[Model]
		,[ComputerName]
		,[Type]
		,[User]
		,[UserPawprint]
		,[Category]
		,[Department]
		,[Room]
		,[Letter]
		,[Building]
		,[Note]
		,[OwnedBy]
		,[PurchaseDate]
		,[AuxComputerDate]
		FROM [dbo].[ComputerInventory]
		WHERE SerialNumber = @SerialNum
	END
END



GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetRecords]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_Inventory_GetRecords]
AS
BEGIN
	SET NOCOUNT ON
	SELECT [InventoryId]
	,[SerialNumber]
	,[Type]
	,[Make]
	,[Model]
	,[ComputerName]
	,[User]
	,[UserPawprint]
	,[Category]
	,[Department]
	,[Room]
	,[Letter]
	,[Building]
	,[OwnedBy]
	,[PurchaseDate] 
	,[AuxComputerDate]
	,[LastVerified]
	 FROM dbo.ComputerInventory ORDER BY InventoryId DESC
END



GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetRecordTemp]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE PROCEDURE [dbo].[sp_Inventory_GetRecordTemp]
(
	@SerialNum Varchar(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT 
		[SerialNumber]
		,[Make]
		,[Model]
		,[ComputerName]
		,[Type]
		,[Category]
		,[user]
		,[UserPawprint]
		,[Department]
		,[Location]
		,[RoomLetter]
		,[Building]
		,[Note]
		,[OwnedBy]
		,[PurchaseDate]
		,[AuxComputerDate]
		,[RecordStatus]
		FROM [dbo].[tblTempNewInventory]
		WHERE SerialNumber = @SerialNum
	END
END



GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_GetTypes]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Ben Sammons
-- Description:	grabs feedback survey data for a particular ticket if it exists
-- =============================================
CREATE PROCEDURE [dbo].[sp_Inventory_GetTypes]

AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM dbo.ComputerInventory_tblType
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_UpdateInventoryDB]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE PROCEDURE [dbo].[sp_Inventory_UpdateInventoryDB]
(
	@SerialNumber VARCHAR(255) = NULL,
	@Make VARCHAR(255) = NULL,
	@Model VARCHAR(255) = NULL,
	@ComputerName VARCHAR(255) = NULL,
	@Type VARCHAR(255) = NULL,
	@User VARCHAR(255) = NULL,
	@UserPawprint VARCHAR(255) = NULL,
	@Category VARCHAR(255) = NULL,
	@Department VARCHAR(255) = NULL,
	@Location VARCHAR(64) = NULL,
	@Letter VARCHAR(2) = NULL,
	@Building VARCHAR(255) = NULL,
	@Note [Text] = NULL,
	@OwnedBy VARCHAR(255) = NULL,
	@PurchaseDate VARCHAR(255) = NULL,
	@AuxComputerDate VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN
		
		UPDATE [dbo].[ComputerInventory]
		SET 
			Make = @Make
			,Model = @Model
			,ComputerName = @ComputerName
			,[Type] = @Type
			,[User] = @User
			,[UserPawprint] = @UserPawprint
			,[Category] = @Category
			,[Department] = @Department
			,[Room] = @Location
			,[Letter] = @Letter
			,[Building] = @Building
			,[Note] = @Note
			,[OwnedBy] = @OwnedBy
			,[PurchaseDate] = @PurchaseDate
			,[AuxComputerDate] = @AuxComputerDate
			,LastUpdate = CURRENT_TIMESTAMP
		WHERE SerialNumber = @SerialNumber
	END

	
	
END




GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_UpdateInventoryDBActual]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











CREATE PROCEDURE [dbo].[sp_Inventory_UpdateInventoryDBActual]
(
	@SerialNumber VARCHAR(255) = NULL,
	@Make VARCHAR(255) = NULL,
	@Model VARCHAR(255) = NULL,
	@ComputerName VARCHAR(255) = NULL,
	@Type VARCHAR(255) = NULL,
	@User VARCHAR(255) = NULL,
	@UserPawprint VARCHAR(255) = NULL,
	@Category VARCHAR(255) = NULL,
	@Department VARCHAR(255) = NULL,
	@Room VARCHAR(64) = NULL,
	@Letter VARCHAR(2) = NULL,
	@Building VARCHAR(255) = NULL,
	@Note [Text] = NULL,
	@OwnedBy VARCHAR(255) = NULL,
	@PurchaseDate VARCHAR(255) = NULL,
	@AuxComputerDate VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN
		
		UPDATE [dbo].[ComputerInventory]
		SET 
			Make = @Make
			,Model = @Model
			,ComputerName = @ComputerName
			,LastUpdate = CURRENT_TIMESTAMP
			,[Type] = @Type
			,[User] = @User
			,[UserPawprint] = @UserPawprint
			,[Category] = @Category
			,[Department] = @Department
			,[Room] = @Room
			,[Letter] = @Letter
			,[Building] = @Building
			,[Note] = @Note
			,[OwnedBy] = @OwnedBy
			,[PurchaseDate] = @PurchaseDate
			,[AuxComputerDate] = @AuxComputerDate 
		WHERE SerialNumber = @SerialNumber
	END

	
	
END




GO
/****** Object:  StoredProcedure [dbo].[sp_Inventory_UpdateRecord]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM dbo.ComputerInventory WHERE InventoryId = 1953
CREATE PROCEDURE [dbo].[sp_Inventory_UpdateRecord]
(
	@inventoryId as Int
	,@SerialNumber as NVARCHAR(255)
	,@Type as NVARCHAR(255)
	,@Make as NVARCHAR(255)
	,@Model as NVARCHAR(255)
	,@User as NVARCHAR(255) = NULL
	,@UserPawprint as NVARCHAR(64) = NULL
	,@Category as NVARCHAR(255)
	,@Department as NVARCHAR(255)
	,@Room as NVarchar(255) = null
	,@Building as NVARCHAR(255) = null
	,@Note as NVARCHAR(512)
	,@RoomLetter as VARCHAR(2) = null
	,@OwnedBy as NVARCHAR(255)
	,@PurchaseDate as NVARCHAR(255) = null
	,@AuxComputerDate as NVARCHAR(255) = null
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN 
	UPDATE dbo.ComputerInventory
	SET 
	SerialNumber = @SerialNumber
	,[Type] = @Type
	,Make = @Make
	,Model = @Model
	,[User] = @User
	,UserPawprint = @UserPawprint
	,Category = @Category
	,Department = @Department
	,Location = NULL
	,Room = @Room
	,Building = @Building
	,Letter = @RoomLetter
	,OwnedBy = @OwnedBy
	,PurchaseDate = @PurchaseDate
	,AuxComputerDate = @AuxComputerDate
	,LastUpdate = CURRENT_TIMESTAMP
	,Note = @Note 
	WHERE InventoryId = @inventoryId
	END
END



GO
/****** Object:  StoredProcedure [dbo].[sp_TempInventory_GetRecords]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_TempInventory_GetRecords]
AS
BEGIN
	SET NOCOUNT ON
	SELECT * FROM [dbo].[tblTestTemp1Inventory]
END



GO
/****** Object:  StoredProcedure [dbo].[sp_TempTable_GetRecords]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_TempTable_GetRecords]
AS
BEGIN
	SET NOCOUNT ON
	SELECT * FROM [dbo].[tblNewTempInventory]
END




GO
/****** Object:  StoredProcedure [dbo].[sp_TempTable_GetRecords_Mismatch]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_TempTable_GetRecords_Mismatch]
AS
BEGIN
	SET NOCOUNT ON
	SELECT * FROM [dbo].[tblTempNewInventory]
	WHERE RecordStatus = 'Mismatch found'
END




GO
/****** Object:  StoredProcedure [dbo].[sp_TempTable_GetRecords_New]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_TempTable_GetRecords_New]
AS
BEGIN
	SET NOCOUNT ON
	SELECT * FROM [dbo].[tblTempNewInventory]
	WHERE RecordStatus = 'New Record'
END


GO
/****** Object:  StoredProcedure [dbo].[Add_Inventory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Add_Inventory]
(
	--@Author_ID INT, 
	@SerialNum	VARCHAR(255) = NULL,
	@Type VARCHAR(255) = NULL,
	@Make VARCHAR(255) = NULL,
	@Model VARCHAR(255) = NULL,
    @User VARCHAR(255) = NULL,
	@Category VARCHAR(255) = NULL,
	@Department VARCHAR(255) = NULL,
	@Location VARCHAR(255) = NULL,
	@OwnedBy VARCHAR(255) = NULL,
	@PurchaseDate DATE = NULL,
    @AuxComputerDate DATE = NULL
	
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN
		--INSERT INTO [dbo].[ComputerInventory]
		--VALUES (@SerialNum,@Type,@Make,@Model,@User,@Department,@Location,@OwnedBy,@PurchaseDate,@AuxComputerDate)
		INSERT INTO [dbo].[ComputerInventory]
		VALUES (@SerialNum,@Type,@Make,@Model,@User,@Category,@Department,@Location,@OwnedBy,@PurchaseDate,@AuxComputerDate)
	END

	
	--BEGIN
	--SELECT MAX(Author_Id) as newid FROM authors
 --END
    --RETURN 1
END
GO
/****** Object:  StoredProcedure [dbo].[Add_TempTable]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[Add_TempTable] 
(
	@SerialNumber VARCHAR(255) = NULL,
	@Make VARCHAR(255) = NULL,
	@Model VARCHAR(255) = NULL,
	@ComputerName VARCHAR(255) = NULL,
	@RecordStatus VARCHAR(255) = NULL,
	@Type VARCHAR(255) = NULL,
	@Category VARCHAR(255) = NULL,
	@User VARCHAR(255) = NULL,
	@UserPawprint VARCHAR(255) = NULL,	
	@Department VARCHAR(255) = NULL,			
	@Location VARCHAR(255) = NULL,
	@Building VARCHAR(255) = NULL,	
	@OwnedBy VARCHAR(255) = NULL,
	@PurchaseDate VARCHAR(255) = NULL,
	@AuxComputerDate VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN
		--INSERT INTO [dbo].[tblTestTemp]
		--VALUES (@SerialNum,@Type,@Make,@Model,@User,@Department,@Location,@OwnedBy,@PurchaseDate,@AuxComputerDate)
		INSERT INTO [dbo].[tblTempInventory]
		VALUES (@SerialNumber, @Make, @Model, @ComputerName, @RecordStatus, @Type, @Category, @User, @UserPawprint, @Department, @Location, @Building, @OwnedBy, @PurchaseDate, @AuxComputerDate )
	END

	
	--BEGIN
	--SELECT MAX(Author_Id) as newid FROM authors
 --END
    --RETURN 1
END


GO
/****** Object:  StoredProcedure [dbo].[Add_TestTemp]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Add_TestTemp]
(
	@TestId INT,
	@SerialNum VARCHAR(255) = NULL,
	@Type VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN
		--INSERT INTO [dbo].[tblTestTemp]
		--VALUES (@SerialNum,@Type,@Make,@Model,@User,@Department,@Location,@OwnedBy,@PurchaseDate,@AuxComputerDate)
		INSERT INTO [dbo].[tblTestTemp1Inventory]
		VALUES (@TestId, @SerialNum, @Type)
	END

	
	--BEGIN
	--SELECT MAX(Author_Id) as newid FROM authors
 --END
    --RETURN 1
END


GO
/****** Object:  StoredProcedure [dbo].[Delete_Author]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Delete_Author]
(
	--@Author_ID INT, 
	@Author_Name		VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN
		DELETE FROM authors
		WHERE Author_Name = @Author_Name
		
	END
	
	--BEGIN
	--SELECT MAX(Author_Id) as newid FROM authors
 --END
    --RETURN 1
END
GO
/****** Object:  StoredProcedure [dbo].[Delete_Record_Temp]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[Delete_Record_Temp]
(
	@SerialNumber VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		DELETE FROM [dbo].[tblTempInventory]
		WHERE SerialNumber = @SerialNumber
	END
END








GO
/****** Object:  StoredProcedure [dbo].[Delete_TempTableData]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[Delete_TempTableData]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		DELETE FROM [dbo].[tblTempInventory] 
		
	END
END







GO
/****** Object:  StoredProcedure [dbo].[Delete_TempTestData]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[Delete_TempTestData]
(
	@SerialNum VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		DELETE FROM [dbo].[tblTestTemp1Inventory]
		WHERE SerialNum = @SerialNum
	END
END







GO
/****** Object:  StoredProcedure [dbo].[Delete_TestData]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[Delete_TestData]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		DELETE FROM [dbo].[tblTestTemp1Inventory]
		
	END
END






GO
/****** Object:  StoredProcedure [dbo].[Get_Author_Details]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_Author_Details]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Author_Name FROM authors 
	END
END
GO
/****** Object:  StoredProcedure [dbo].[Get_Author_Id]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_Author_Id]
(
	@Author_Name VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Author_Id FROM authors 
		WHERE Author_Name = @Author_Name
	END
END

GO
/****** Object:  StoredProcedure [dbo].[Get_Category]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Get_Category]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Category_Name FROM [dbo].[ComputerInventory_tblCategory]
	END
END

GO
/****** Object:  StoredProcedure [dbo].[Get_DepartmentNames]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Get_DepartmentNames]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Dept FROM [dbo].[ComputerInventory_tblDepartment]
	END
END



GO
/****** Object:  StoredProcedure [dbo].[Get_InventoryData]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [dbo].[Get_InventoryData] 
(
	@SerialNum Varchar(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT SerialNumber, Make, Model, ComputerName FROM [dbo].[ComputerInventoryTest]
		WHERE SerialNumber = @SerialNum
	END
END


GO
/****** Object:  StoredProcedure [dbo].[Get_InventoryMake]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Get_InventoryMake]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Manuf FROM [dbo].[ComputerInventory_tblMake]
	END
END




GO
/****** Object:  StoredProcedure [dbo].[Get_InventoryModel]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Get_InventoryModel]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Model FROM [dbo].[ComputerInventory_tblModel]
	END
END




GO
/****** Object:  StoredProcedure [dbo].[Get_InventoryOwnedBy]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Get_InventoryOwnedBy]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Dept FROM [dbo].[ComputerInventory_tblOwnedBy]
	END
END




GO
/****** Object:  StoredProcedure [dbo].[Get_InventoryType]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Get_InventoryType]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Type FROM [dbo].[ComputerInventory_tblType]
	END
END



GO
/****** Object:  StoredProcedure [dbo].[Get_New_Author_Id]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Get_New_Author_Id]
AS
BEGIN
	SELECT MAX(Author_ID) AS max_id from authors
END



GO
/****** Object:  StoredProcedure [dbo].[Get_Record_InventoryDB]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [dbo].[Get_Record_InventoryDB]
(
	@SerialNum Varchar(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT
		[SerialNumber]
		,[Make]
		,[Model]
		,[ComputerName]
		,[Type]
		,[User]
		,[UserPawprint]
		,[Category]
		,[Department]
		,[Location]
		,[Building]
		,[OwnedBy]
		,[PurchaseDate]
		,[AuxComputerDate]
		FROM [dbo].[ComputerInventoryTest]
		WHERE SerialNumber = @SerialNum
	END
END



GO
/****** Object:  StoredProcedure [dbo].[Get_Record_Temp]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE PROCEDURE [dbo].[Get_Record_Temp]
(
	@SerialNum Varchar(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT 
		[SerialNumber]
		,[Make]
		,[Model]
		,[ComputerName]
		,[Type]
      ,[Category]
      ,[User]
      ,[UserPawprint]
      ,[Department]
      ,[Location]
      ,[Building]
      ,[OwnedBy]
      ,[PurchaseDate]
      ,[AuxComputerDate]
		FROM [dbo].[tblTempInventory]
		WHERE SerialNumber = @SerialNum
	END
END

GO
/****** Object:  StoredProcedure [dbo].[Get_TestData]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[Get_TestData]
(
	@SerialNum Varchar(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT * FROM [dbo].[tblTestInventory]
		WHERE SerialNum = @SerialNum
	END
END






GO
/****** Object:  StoredProcedure [dbo].[Get_TestTempData]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[Get_TestTempData]
(
	@SerialNum Varchar(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT * FROM [dbo].[tblTestTemp1Inventory]
		WHERE SerialNum = @SerialNum
	END
END







GO
/****** Object:  StoredProcedure [dbo].[Get_Top_Row_Num]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[Get_Top_Row_Num]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT Top 1 * FROM [dbo].[tblTestTemp1Inventory]
		
	END
END

GO
/****** Object:  StoredProcedure [dbo].[Get_TopRowId]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Get_TopRowId]

AS
BEGIN
	SET NOCOUNT ON

	BEGIN
		SELECT TOP 1 [DifferenceItemId] 
		FROM [dbo].[tblTestTemp1]
	END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Add_New_Data]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_Add_New_Data]
(
	@studentNum varchar(50), 
	@lastName	VARCHAR(255) = NULL,
	@firstName			VARCHAR(255) = NULL,
	@pawPrint VARCHAR(255)
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN
	INSERT INTO dbo.ULA_Student (studentNum,lastName,firstName,pawPrint)
	VALUES (@studentNum,@lastName,@firstName,@pawPrint)
		
	END
	
	BEGIN
	SELECT count(UserLogin) as count FROM dbo.ULA_Student
 END
    --RETURN 1
END

GO
/****** Object:  StoredProcedure [dbo].[Update_InventoryDB]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE PROCEDURE [dbo].[Update_InventoryDB]
(
	@SerialNumber VARCHAR(255) = NULL,
	@Make VARCHAR(255) = NULL,
	@Model VARCHAR(255) = NULL,
	@ComputerName VARCHAR(255) = NULL,
	@Type VARCHAR(255) = NULL,
	@User VARCHAR(255) = NULL,
	@UserPawprint VARCHAR(255) = NULL,
	@Category VARCHAR(255) = NULL,
	@Department VARCHAR(255) = NULL,
	@Location VARCHAR(255) = NULL,
	@Building VARCHAR(255) = NULL,
	@OwnedBy VARCHAR(255) = NULL,
	@PurchaseDate VARCHAR(255) = NULL,
	@AuxComputerDate VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN
		
		UPDATE [dbo].[ComputerInventoryTest]
		SET 
			Make = @Make
			,Model = @Model
			,ComputerName = @ComputerName
			,LastUpdate = CURRENT_TIMESTAMP
			,[Type] = @Type
			,[User] = @User
			,[UserPawprint] = @UserPawprint
			,[Category] = @Category
			,[Department] = @Department
			,[Location] = @Location
			,[Building] = @Building
			,[OwnedBy] = @OwnedBy
			,[PurchaseDate] = @PurchaseDate
			,[AuxComputerDate] = @AuxComputerDate 
		WHERE SerialNumber = @SerialNumber
	END

	
	
END

GO
/****** Object:  StoredProcedure [dbo].[Update_Test_Temp]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[Update_Test_Temp]
(
	@TestId INT,
	@SerialNum VARCHAR(255) = NULL,
	@Type VARCHAR(255) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	BEGIN
		--INSERT INTO [dbo].[tblTestTemp]
		--VALUES (@SerialNum,@Type,@Make,@Model,@User,@Department,@Location,@OwnedBy,@PurchaseDate,@AuxComputerDate)
		UPDATE [dbo].[tblTestInventory]
		SET Type = @Type, LastModified = CURRENT_TIMESTAMP
		WHERE SerialNum = @SerialNum
	END

	
	
END




-- ******************************************



GO
/****** Object:  Table [dbo].[ComputerInventory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComputerInventory](
	[InventoryId] [int] IDENTITY(1,1) NOT NULL,
	[SerialNumber] [nvarchar](255) NOT NULL,
	[Type] [nvarchar](255) NOT NULL,
	[Make] [nvarchar](255) NOT NULL,
	[Model] [nvarchar](255) NOT NULL,
	[User] [nvarchar](255) NULL,
	[UserPawprint] [varchar](64) NULL,
	[Category] [varchar](255) NULL,
	[Department] [varchar](255) NULL,
	[Location] [varchar](255) NULL,
	[Room] [varchar](64) NULL,
	[Letter] [varchar](2) NULL,
	[Building] [varchar](64) NULL,
	[OwnedBy] [varchar](255) NULL,
	[PurchaseDate] [date] NULL,
	[AuxComputerDate] [date] NULL,
	[DateCreated] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
	[Note] [text] NULL,
	[ComputerName] [nvarchar](255) NULL,
	[LastVerified] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComputerInventory_tblCategory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblCategory](
	[Category_Id] [int] IDENTITY(1,1) NOT NULL,
	[Category_Name] [varchar](255) NULL,
 CONSTRAINT [PK_ComputerInventory_tblCategory] PRIMARY KEY CLUSTERED 
(
	[Category_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComputerInventory_tblDepartment]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblDepartment](
	[DeptID] [int] NOT NULL,
	[Dept] [nvarchar](50) NULL,
	[Valid] [nvarchar](10) NULL,
 CONSTRAINT [PK_ComputerInventory_tblDepartment] PRIMARY KEY CLUSTERED 
(
	[DeptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblfpd-doctoral-students]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblfpd-doctoral-students](
	[academic-unit] [char](10) NULL,
	[flat-panels] [int] NULL,
	[purchase-date] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComputerInventory_tblLogRecords]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblLogRecords](
	[Trigger] [nvarchar](255) NULL,
	[Timestamp] [nvarchar](255) NULL,
	[ComputerName] [nvarchar](255) NULL,
	[UserName] [nvarchar](255) NULL,
	[SerialNumber] [nvarchar](255) NULL,
	[Manufacturer] [nvarchar](255) NULL,
	[Model] [nvarchar](255) NULL,
	[Memory] [nvarchar](255) NULL,
	[OS] [nvarchar](255) NULL,
	[NetworkAdapter] [nvarchar](255) NULL,
	[MACAddress] [nvarchar](255) NULL,
	[IPAddress] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblLogRecords_TEST]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblLogRecords_TEST](
	[Count] [int] IDENTITY(1,1) NOT NULL,
	[Trigger] [nvarchar](255) NULL,
	[Timestamp] [nvarchar](255) NULL,
	[ComputerName] [nvarchar](255) NULL,
	[UserName] [nvarchar](255) NULL,
	[SerialNumber] [nvarchar](255) NULL,
	[Manufacturer] [nvarchar](255) NULL,
	[Model] [nvarchar](255) NULL,
	[Memory] [nvarchar](255) NULL,
	[OS] [nvarchar](255) NULL,
	[NetworkAdapter] [nvarchar](255) NULL,
	[MACAddress] [nvarchar](255) NULL,
	[IPAddress] [nvarchar](255) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblMain]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblMain](
	[CompName] [nvarchar](15) NULL,
	[Type] [int] NULL,
	[Make] [int] NULL,
	[Model] [int] NULL,
	[SN] [nvarchar](25) NOT NULL,
	[User] [nvarchar](50) NULL,
	[UserStatus] [int] NULL,
	[Location] [nvarchar](20) NULL,
	[Dept] [int] NULL,
	[Transferred] [ntext] NULL,
	[Purchase] [datetime] NULL,
	[AuxComputerDate] [datetime] NULL,
	[writeConflict] [timestamp] NULL,
	[OwnedBy] [int] NULL,
	[Status] [nchar](20) NULL,
 CONSTRAINT [PK_ComputerInventory_tblMain_1] PRIMARY KEY CLUSTERED 
(
	[SN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblMake]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblMake](
	[ID] [int] NOT NULL,
	[Manuf] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ComputerInventory_tblMake] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblModel]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblModel](
	[ID] [int] NOT NULL,
	[Model] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ComputerInventory_tblModel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblOptions]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblOptions](
	[Version] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblOwnedBy]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblOwnedBy](
	[DeptID] [int] NOT NULL,
	[Dept] [nvarchar](50) NULL,
	[Valid] [nvarchar](10) NULL,
 CONSTRAINT [PK_ComputerInventory_tblOwnedBy] PRIMARY KEY CLUSTERED 
(
	[DeptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblParse]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblParse](
	[Activity] [nvarchar](50) NULL,
	[Timestamp] [nvarchar](25) NULL,
	[ComputerName] [nvarchar](25) NULL,
	[UserName] [nvarchar](25) NULL,
	[ServiceTag] [nvarchar](50) NOT NULL,
	[Manufacturer] [nvarchar](50) NULL,
	[Model] [nvarchar](50) NULL,
	[Memory] [nvarchar](50) NULL,
	[OS] [nvarchar](50) NULL,
	[OSSP] [nvarchar](50) NULL,
	[OSVersion] [nvarchar](50) NULL,
	[ProcessorDesc] [nvarchar](50) NULL,
	[Processor] [nvarchar](50) NULL,
	[Level] [nvarchar](50) NULL,
	[ClockSpeed] [nvarchar](50) NULL,
	[PRocessorID] [nvarchar](50) NULL,
	[Network] [nvarchar](50) NULL,
	[MAC] [nvarchar](50) NULL,
	[IP] [nvarchar](50) NULL,
 CONSTRAINT [PK_ComputerInventory_tblParse] PRIMARY KEY CLUSTERED 
(
	[ServiceTag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblResults]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblResults](
	[compName] [nvarchar](50) NULL,
	[PingStatus] [nvarchar](50) NULL,
	[SN] [nvarchar](50) NULL,
	[OS] [nvarchar](100) NULL,
	[CPU] [nvarchar](100) NULL,
	[RAM] [nvarchar](50) NULL,
	[Make] [nvarchar](50) NULL,
	[Model] [nvarchar](50) NULL,
	[errorMsg] [nvarchar](250) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblType]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblType](
	[ID] [int] NOT NULL,
	[Type] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_ComputerInventory_tblType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblUpdateRecords]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblUpdateRecords](
	[SerialNumber] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblUser]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblUser](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[UserStatus] [int] NULL,
	[Department] [int] NULL,
	[Location] [nvarchar](25) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblUserStatus]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblUserStatus](
	[USID] [int] NOT NULL,
	[UserStatus] [nvarchar](50) NULL,
 CONSTRAINT [PK_ComputerInventory_tblUserStatus] PRIMARY KEY CLUSTERED 
(
	[USID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory_tblUserStorage]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ComputerInventory_tblUserStorage](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](max) NOT NULL,
	[Pawprint] [nvarchar](50) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ComputerInventory3]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComputerInventory3](
	[InventoryId] [int] IDENTITY(1,1) NOT NULL,
	[SerialNumber] [nvarchar](255) NOT NULL,
	[Type] [nvarchar](255) NOT NULL,
	[Make] [nvarchar](255) NOT NULL,
	[Model] [nvarchar](255) NOT NULL,
	[User] [nvarchar](255) NULL,
	[UserPawprint] [varchar](64) NULL,
	[Category] [varchar](255) NULL,
	[Department] [varchar](255) NULL,
	[Location] [varchar](255) NULL,
	[OwnedBy] [varchar](255) NULL,
	[PurchaseDate] [date] NULL,
	[AuxComputerDate] [date] NULL,
	[DateCreated] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
	[Note] [text] NULL,
 CONSTRAINT [primkey1] PRIMARY KEY CLUSTERED 
(
	[InventoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ComputerInventoryTest]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComputerInventoryTest](
	[InventoryId] [int] IDENTITY(1,1) NOT NULL,
	[SerialNumber] [nvarchar](255) NOT NULL,
	[Type] [nvarchar](255) NOT NULL,
	[Make] [nvarchar](255) NOT NULL,
	[Model] [nvarchar](255) NOT NULL,
	[User] [nvarchar](255) NULL,
	[UserPawprint] [varchar](64) NULL,
	[Category] [varchar](255) NULL,
	[Department] [varchar](255) NULL,
	[Location] [varchar](255) NULL,
	[Room] [varchar](64) NULL,
	[Letter] [varchar](2) NULL,
	[Building] [varchar](64) NULL,
	[OwnedBy] [varchar](255) NULL,
	[PurchaseDate] [date] NULL,
	[AuxComputerDate] [date] NULL,
	[DateCreated] [datetime] NULL,
	[LastUpdate] [datetime] NULL,
	[Note] [text] NULL,
	[ComputerName] [nvarchar](255) NULL,
	[LastVerified] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


IF OBJECT_ID('dbo.Inventory', 'U') IS NOT NULL 
  DROP TABLE dbo.Inventory; 

IF OBJECT_ID('tempdb.dbo.Inventory', 'U') IS NOT NULL
DROP TABLE Inventory; 
  
GO
/****** Object:  Table [dbo].[Inventory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Inventory](
	[InventoryId] [int] IDENTITY(1,1) NOT NULL,
	[SerialNumber] [nvarchar](255) NOT NULL,
	[Type] [nvarchar](255) NOT NULL,
	[Make] [nvarchar](255) NOT NULL,
	[Model] [nvarchar](255) NOT NULL,
	[User] [nvarchar](255) NOT NULL,
	[UserStatus] [varchar](255) NULL,
	[Department] [varchar](255) NULL,
	[Location] [varchar](255) NULL,
	[OwnedBy] [varchar](255) NULL,
	[PurchaseDate] [date] NULL,
	[AuxComputerDate] [date] NULL,
 CONSTRAINT [primkey] PRIMARY KEY CLUSTERED 
(
	[InventoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]




GO
/****** Object:  Table [dbo].[tblTempInventory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTempInventory](
	[DifferenceItemId] [int] IDENTITY(1,1) NOT NULL,
	[SerialNumber] [varchar](255) NULL,
	[Make] [varchar](255) NULL,
	[Model] [varchar](255) NULL,
	[ComputerName] [varchar](255) NULL
) ON [PRIMARY] 
SET ANSI_PADDING OFF
ALTER TABLE [dbo].[tblTempInventory] ADD [RecordStatus] [varchar](255) NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [Type] [nvarchar](255) NULL
SET ANSI_PADDING ON
ALTER TABLE [dbo].[tblTempInventory] ADD [Category] [varchar](255) NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [User] [nvarchar](255) NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [UserPawprint] [varchar](64) NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [Department] [varchar](255) NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [Location] [varchar](255) NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [Building] [varchar](64) NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [OwnedBy] [varchar](255) NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [PurchaseDate] [date] NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [AuxComputerDate] [date] NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [Room] [varchar](64) NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [Letter] [varchar](2) NULL
ALTER TABLE [dbo].[tblTempInventory] ADD [Note] [text] NULL
 CONSTRAINT [PK_tblTempInventory] PRIMARY KEY CLUSTERED 
(
	[DifferenceItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTempNewInventory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTempNewInventory](
	[SerialNumber] [varchar](255) NULL,
	[Make] [varchar](255) NULL,
	[Model] [varchar](255) NULL,
	[ComputerName] [varchar](255) NULL,
	[Type] [varchar](255) NULL,
	[category] [varchar](255) NULL,
	[User] [varchar](255) NULL,
	[UserPawprint] [varchar](255) NULL,
	[Department] [varchar](255) NULL,
	[Location] [varchar](255) NULL,
	[RoomLetter] [varchar](2) NULL,
	[Building] [varchar](255) NULL,
	[Note] [varchar](255) NULL,
	[OwnedBy] [varchar](255) NULL,
	[PurchaseDate] [varchar](255) NULL,
	[AuxComputerDate] [varchar](255) NULL,
	[RecordStatus] [varchar](255) NULL
) ON [PRIMARY]



/****** Object:  Table [dbo].[TS_Departments_Serviced]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[TS_Departments_Serviced](
	[Department_ID] [int] IDENTITY(1,1) NOT NULL,
	[Department_Name] [varchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Department_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]




/****** Object:  Table [dbo].[tblTestInventory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTestInventory](
	[TestId] [int] IDENTITY(1,1) NOT NULL,
	[SerialNum] [varchar](255) NULL,
	[Type] [varchar](255) NULL,
	[LastModified] [date] NULL,
 CONSTRAINT [PK_tblTestInventory] PRIMARY KEY CLUSTERED 
(
	[TestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]




GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTestTemp1Inventory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTestTemp1Inventory](
	[DifferenceItemId] [int] IDENTITY(1,1) NOT NULL,
	[TestId] [int] NULL,
	[SerialNum] [varchar](255) NULL,
	[Type] [varchar](255) NULL,
 CONSTRAINT [PK_tblTestTemp1Inventory] PRIMARY KEY CLUSTERED 
(
	[DifferenceItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTestTempInventory]    Script Date: 5/11/2016 11:15:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTestTempInventory](
	[TestId] [int] IDENTITY(1,1) NOT NULL,
	[SerialNum] [varchar](255) NULL,
	[Type] [varchar](255) NULL,
 CONSTRAINT [PK_tblTestTempInventory] PRIMARY KEY CLUSTERED
(
	[TestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



