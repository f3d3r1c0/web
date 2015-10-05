CREATE DATABASE [DBFarmadati_WEB]
GO

USE [DBFarmadati_WEB]
GO

CREATE TABLE [dbo].[FS_MOBI](
	[FDI_T485] [nvarchar](9) NULL
) 

CREATE TABLE [dbo].[TDF](
	[FDI_T218] [varchar](9) NULL,
	[FDI_T227] [varchar](12) NULL,
	[FDI_T483] [varchar](2) NULL
) 

CREATE TABLE [dbo].[TR001](
	[FDI_0001] [nvarchar](9) NULL
) 

INSERT INTO TDF (FDI_T218, FDI_T227, FDI_T483) values ('000000001', 'F0019070.pdf', 'it')
go
INSERT INTO TDF (FDI_T218, FDI_T227, FDI_T483) values ('000000001', 'F0019071.pdf', 'de')
go
INSERT INTO TDF (FDI_T218, FDI_T227, FDI_T483) values ('000000001', 'F0019072.pdf', 'en')
go

