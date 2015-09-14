create database DBFarmadati_WEB
go

create table TDF (
	FDI_T218 varchar(9),
	FDI_T227 varchar(12),
	FDI_T483 varchar(2)	
)
go

insert into TDF (FDI_T218, FDI_T227, FDI_T483) values ('000000001', 'F0019070.pdf', 'it')
go
insert into TDF (FDI_T218, FDI_T227, FDI_T483) values ('000000001', 'F0019071.pdf', 'de')
go
insert into TDF (FDI_T218, FDI_T227, FDI_T483) values ('000000001', 'F0019072.pdf', 'en')
go

