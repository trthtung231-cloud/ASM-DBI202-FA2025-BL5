use master
go

if not exists (
    select [name]
from sys.databases
where [name] = N'SalaryManagement'
)
create database SalaryManagement
go


if OBJECT_ID('[dbo].[Location]', 'U') is not null
drop table [dbo].[Location]
go

create table [dbo].[Location]
(
    LocationId varchar(5) primary key,
    StreetAddress nvarchar(100) not null,
    City nvarchar(20) not null,
    Country nvarchar(20) not null,
    PostalCode nvarchar(15),

)
go