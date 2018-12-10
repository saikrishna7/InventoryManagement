USE MASTER;     
-- 1) Check for the Database Exists .If the database is exist then drop and create new DB     
IF EXISTS (SELECT [name] FROM sys.databases WHERE [name] = 'InventoryDB' )     
BEGIN     
ALTER DATABASE InventoryDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE     
DROP DATABASE InventoryDB ;     
END     
     
     
CREATE DATABASE InventoryDB   
GO     
     
USE InventoryDB     
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
/****** Object:  Table [dbo].[tblTempInventory]    Script Date: 5/11/2016 11:15:03 AM ******/
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
/****** Object:  Table [dbo].[tblTempNewInventory]    Script Date: 5/11/2016 11:15:03 AM ******/
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

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTest]    Script Date: 5/11/2016 11:15:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTest](
	[TestId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NULL,
	[Age] [int] NULL,
 CONSTRAINT [PK_tblTest] PRIMARY KEY CLUSTERED 
(
	[TestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTestInventory]    Script Date: 5/11/2016 11:15:03 AM ******/
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
/****** Object:  Table [dbo].[tblTestTemp]    Script Date: 5/11/2016 11:15:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTestTemp](
	[TestId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NULL,
	[Age] [int] NULL,
 CONSTRAINT [PK_tblTestTemp] PRIMARY KEY CLUSTERED 
(
	[TestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTestTemp1]    Script Date: 5/11/2016 11:15:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTestTemp1](
	[DifferenceItemId] [int] IDENTITY(1,1) NOT NULL,
	[TestId] [int] NULL,
	[Name] [varchar](255) NULL,
	[Age] [int] NULL,
 CONSTRAINT [PK_tblTestTemp1] PRIMARY KEY CLUSTERED 
(
	[DifferenceItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTestTemp1Inventory]    Script Date: 5/11/2016 11:15:03 AM ******/
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
/****** Object:  Table [dbo].[tblTestTempInventory]    Script Date: 5/11/2016 11:15:03 AM ******/
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

GO
SET ANSI_PADDING OFF
GO
