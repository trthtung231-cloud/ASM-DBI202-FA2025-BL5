create database SalaryManagement
go

drop table [Location]
drop table Department
drop table Dept_Loc
drop table Employees
drop table EmpInfo
drop table Attendance
drop table Payroll

create table [Location]
(
    LocationId varchar(5) primary key,
    StreetAddress nvarchar(100) not null,
    City nvarchar(20) not null,
    Country nvarchar(20) not null,
    PostalCode nvarchar(15) not null,
    LocPhone varchar(15) not null
)
go

alter table [Location]
add LocEmail varchar(50) default 'N/A'

alter table [Location]
alter column LocPhone varchar(20) not null
go

create table [Department]
(
    DeptId varchar(5) primary key,
    DeptName nvarchar(30) not null,
)

create table Dept_Loc
(
    LocationId varchar(5),
    DeptId varchar(5),
    constraint PK_Dept_Loc primary key (LocationId, DeptId),
    constraint FK_Dept_Loc_Location foreign key (LocationId) references [Location](LocationId),
    constraint FK_Dept_Loc_Department foreign key (DeptId) references Department(DeptId)
)
go

create table Employees
(
    EmpId int identity(1,1) primary key,
    FName nvarchar(20) not null,
    LName nvarchar(20) not null,
    Position nvarchar(20) not null,
    Email varchar(50) not null,
    Phone varchar(15) not null,
    BaseSalary decimal(18,2) not null,
    DeptId varchar(5) not null,
    constraint FK_Employees_Department foreign key (DeptId) references Department(DeptId)
)
go

create table EmpInfo
(
    EmpId int identity(1,1) primary key,
    Gender char(1) check (Gender in ('M', 'F')),
    Birthdate date check (Birthdate < GETDATE()),
    HomeAddress nvarchar(100),
    Hometown nvarchar(50),
    Nationality nvarchar(50),
    HireDate date,
    constraint FK_EmpInfo_Employees foreign key (EmpId) references Employees(EmpId)
)
go

create table Attendance
(
    AttendanceId int identity(1,1) primary key,
    EmpId int,
    WorkDate date,
    CheckinTime time,
    CheckoutTime time,
    [Status] nvarchar(50),
    OvertimeHours decimal(5, 2),
    constraint FK_Attendance_Employees foreign key (EmpID) references Employees(EmpId)
)

create table Payroll
(
    PayrollId int identity(1,1) primary key,
    EmpID int,
    Month int,
    Year int,
    Deduction decimal(18, 2),
    Allowance decimal(18, 2),
    TotalOTHours decimal(5, 2),
    TotalWorkDays decimal(5, 2),
    NetSalary decimal(18, 2),
    constraint FK_Payroll_Employees foreign key (EmpID) references Employees(EmpId)
)
go
---------------------------------------------
-- insert data Location

insert into [Location]
    (LocationId, StreetAddress, City, Country, PostalCode, LocPhone, LocEmail)
values
    ('VN1', N'FPT Tower, số 10 Phố Phạm Văn Bạch, Phường Cầu Giấy',
        N'Hà Nội', N'Vietnam', '101010', '+84-24-7300-7300', null),
    ('VN2', N'FPT Tân Thuận Building, Lô L29B -31B - 33B, đường Tân Thuận, phường Tân Thuận',
        N'Tp. Hồ Chí Minh', N'Vietnam', '100100', '+84-28-7300-7300', null),
    ('JP1', N'Tokyo Headquarter, 33F, Sumitomo Fudosan Tokyo Mita Garden Tower, 3-5-19 Mita, Minatoku',
        N'Tokyo', N'Japan', '010101', '+81-(3)-6634-6868', 'fjp.contact@fpt.com')
go

select *
from [Location]

---------------------------------------------
-- insert data Department
insert into Department
    (DeptId,DeptName)
values
    ('IT', 'Information Technology'),
    ('CS', 'Customer Service'),
    ('HR', 'Human Resourses')
go

select *
from Department
---------------------------------------------
-- insert data Dept_Loc
insert into Dept_Loc
    (LocationId, DeptId)
values
    ('VN1', 'IT'),
    ('VN1', 'CS'),
    ('VN1', 'HR'),
    ('VN2', 'IT'),
    ('VN2', 'CS'),
    ('JP1', 'IT'),
    ('JP1', 'HR')
go

select *
from Dept_Loc

---------------------------------------------
-- insert data Employees and EmpInfo
select *
from Employees

select *
from EmpInfo

-- xoa va reseed de tranh du lieu ban
delete from Employees
dbcc CHECKIDENT ('Employees', RESEED, 0)
delete from EmpInfo
dbcc CHECKIDENT ('EmpInfo', RESEED, 0)

-- test
select
    e.*,
    eInfo.*
from Employees e
    join EmpInfo eInfo on e.EmpID = eInfo.EmpId
    
-- insert
insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId)
values
    (N'Thanh Tùng', N'Trần', 'Dev', 'trthtung231@gmail.com', '0966244761', '1500', 'IT')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '2006-01-23', 'Shinjuku', 'Vietnam', 'Vietnamese', '2026-01-01')    
