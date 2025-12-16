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
    LocationName nvarchar(50) not null,
    StreetAddress nvarchar(100) not null,
    City nvarchar(20) not null,
    Country nvarchar(20) not null,
    PostalCode nvarchar(15) not null,
    LocPhone varchar(15) not null
)
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
    LocationId varchar(5) not null,
    constraint FK_Employees_Department foreign key (DeptId) references Department(DeptId),
    constraint FK_Employees_Location foreign key (LocationId) references [Location](LocationId)
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

--------------------------------------------
-- ALTER

alter table [Location]
add LocEmail varchar(50) default 'N/A'

alter table [Location]
alter column LocPhone varchar(20) not null
go

alter table Attendance
alter column [Status] varchar(20) not null
go

alter table Attendance
add constraint CK_Status_Valid 
check ([Status] in ('Present', 'Absent', 'Late', 'LeaveEarly', 'Holiday', 'OnLeave'))
go

---------------------------------------------
-- insert data Location

insert into [Location]
    (LocationId, LocationName, StreetAddress, City, Country, PostalCode, LocPhone, LocEmail)
values
    ('VN1', 'FPT Ha Noi', 'FPT Tower, 10 Pham Van Bach Street, Cau Giay',
        'Ha Noi', 'Vietnam', '101010', '+84-24-7300-7300', null),
    ('VN2', 'FPT HCM', 'L29B -31B - 33B, Tan Thuan Street, Tan Thuan',
        'Ho Chi Minh City', 'Vietnam', '100100', '+84-28-7300-7300', null),
    ('JP1', 'Tokyo Headquarter', '33F, Sumitomo Fudosan Tokyo Mita Garden Tower, 3-5-19 Mita, Minatoku',
        'Tokyo', 'Japan', '010101', '+81-(3)-6634-6868', 'fjp.contact@fpt.com')
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
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Thanh Tùng', N'Trần', 'BrSE', 'trthtung231@gmail.com', '0966244761', 2500, 'IT', 'JP1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '2006-01-23', 'Shinjuku', N'Thái Bình', 'Vietnamese', '2026-01-01')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Tanaka', N'Kenji', N'Project Manager', 'kenji.t@fpt.com', '+8190111122', 4000, 'IT', 'JP1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '1985-05-05', N'Shibuya, Tokyo', N'Osaka', 'Japanese', '2019-01-10')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Nguyễn Văn', N'Hùng', N'BrSE', 'hungnv@fpt.com', '+8180333344', 3200, 'IT', 'JP1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '1995-08-20', N'Minato-ku, Tokyo', N'Hà Nội', 'Vietnamese', '2022-03-15')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Suzuki', N'Yuki', N'HR Manager', 'yuki.s@fpt.com', '+8170555566', 2800, 'HR', 'JP1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('F', '1990-12-12', N'Chuo-ku, Tokyo', N'Kyoto', 'Japanese', '2020-06-01')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Lê Thị', N'Lan', N'Comtor', 'lanlt@fpt.com', '+8190777788', 2500, 'IT', 'JP1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('F', '1998-02-14', N'Shinjuku, Tokyo', N'Đà Nẵng', 'Vietnamese', '2023-09-01')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Yamamoto', N'Takeshi', N'Senior Dev', 'takeshi.y@fpt.com', '+8180999900', 3500, 'IT', 'JP1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '1992-07-07', N'Koto-ku, Tokyo', N'Nagoya', 'Japanese', '2021-04-01')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Trần Đức', N'Minh', N'Dev', 'minhtd@fpt.com', '+8170123456', 2200, 'IT', 'JP1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '2000-10-10', N'Saitama', N'Hải Phòng', 'Vietnamese', '2024-01-10')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Phạm Thu', N'Hương', N'HR Executive', 'huongpt@fpt.com', '0912345678', 1000, 'HR', 'VN1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('F', '2001-03-08', N'Cầu Giấy, Hà Nội', N'Nam Định', 'Vietnamese', '2023-05-05')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Hoàng Văn', N'Nam', N'Senior Dev', 'namhv@fpt.com', '0988777666', 2000, 'IT', 'VN1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '1996-09-02', N'Thanh Xuân, Hà Nội', N'Thái Bình', 'Vietnamese', '2020-08-15')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Nguyễn Thị', N'Bích', N'CS Agent', 'bichnt@fpt.com', '0905555444', 800, 'CS', 'VN1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('F', '2002-11-20', N'Đống Đa, Hà Nội', N'Hưng Yên', 'Vietnamese', '2024-02-01')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Vũ Quốc', N'Đạt', N'IT Manager', 'datvq@fpt.com', '0911222333', 3500, 'IT', 'VN1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '1988-01-01', N'Ba Đình, Hà Nội', N'Hà Nội', 'Vietnamese', '2015-10-10')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Đỗ Thị', N'Trang', N'Tester', 'trangdt@fpt.com', '0944555666', 1100, 'IT', 'VN1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('F', '2000-06-15', N'Hoàng Mai, Hà Nội', N'Vĩnh Phúc', 'Vietnamese', '2022-12-01')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Lại Văn', N'Sâm', N'CS Lead', 'samlv@fpt.com', '0966888999', 1500, 'CS', 'VN1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '1994-04-30', N'Long Biên, Hà Nội', N'Phú Thọ', 'Vietnamese', '2019-07-20')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Bùi Tiến', N'Dũng', N'Intern', 'dungbt@fpt.com', '0977111222', 400, 'IT', 'VN1')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '2003-12-25', N'Gia Lâm, Hà Nội', N'Thanh Hóa', 'Vietnamese', '2024-11-01')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Trần Quang', N'Khải', N'Frontend Dev', 'khaitq@fpt.com', '0933123123', 1400, 'IT', 'VN2')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '1999-05-19', N'Quận 1, TP.HCM', N'Cần Thơ', 'Vietnamese', '2023-02-14')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Lý Nhã', N'Kỳ', N'CS Staff', 'kyln@fpt.com', '0909090909', 850, 'CS', 'VN2')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('F', '2001-08-08', N'Quận 7, TP.HCM', N'Vũng Tàu', 'Vietnamese', '2023-11-11')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Nguyễn Tấn', N'Tài', N'DevOps', 'taint@fpt.com', '0988666555', 1800, 'IT', 'VN2')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '1997-02-02', N'Bình Thạnh, TP.HCM', N'Đồng Nai', 'Vietnamese', '2022-09-09')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Huỳnh Như', N'Thảo', N'BA', 'thaohn@fpt.com', '0912345999', 1600, 'IT', 'VN2')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('F', '1998-11-11', N'Gò Vấp, TP.HCM', N'Bến Tre', 'Vietnamese', '2023-01-01')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Võ Tấn', N'Phát', N'Solution Architect', 'phatvt@fpt.com', '0977888222', 3800, 'IT', 'VN2')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '1990-09-09', N'Thủ Đức, TP.HCM', N'Long An', 'Vietnamese', '2018-05-20')

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Dương Lâm', N'Đồng', N'CS Manager', 'dongdl@fpt.com', '0933777111', 1700, 'CS', 'VN2')
insert into EmpInfo
    (Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    ('M', '1993-06-01', N'Quận 10, TP.HCM', N'Tiền Giang', 'Vietnamese', '2020-12-12')

---------------------------------------------------------------------------------------------------
-- insert Attendance
-- 2025-12-01
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-01', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2025-12-01', '08:00:00', '17:35:00', 'Present', 0),
    (3, '2025-12-01', '07:45:00', '17:30:00', 'Present', 0),
    (4, '2025-12-01', '08:10:00', '17:45:00', 'Present', 0),
    (5, '2025-12-01', '07:50:00', '17:30:00', 'Present', 0),
    (6, '2025-12-01', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-01', '07:58:00', '18:30:00', 'Present', 1.0),
    (8, '2025-12-01', '08:05:00', '17:30:00', 'Present', 0),
    (9, '2025-12-01', '07:30:00', '17:30:00', 'Present', 0),
    (10, '2025-12-01', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-01', '08:15:00', '17:30:00', 'Present', 0),
    (12, '2025-12-01', '07:55:00', '17:30:00', 'Present', 0),
    (13, '2025-12-01', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-01', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-01', '07:50:00', '17:30:00', 'Present', 0),
    (16, '2025-12-01', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-01', '08:02:00', '17:30:00', 'Present', 0),
    (18, '2025-12-01', '07:55:00', '17:30:00', 'Present', 0),
    (19, '2025-12-01', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-01', '08:00:00', '19:00:00', 'Present', 1.5)

-- 2025-12-02
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-02', '08:00:00', '19:30:00', 'Present', 2.0),
    (2, '2025-12-02', '07:55:00', '17:30:00', 'Present', 0),
    (3, '2025-12-02', '08:35:00', '17:30:00', 'Late', 0),
    (4, '2025-12-02', '08:00:00', '17:30:00', 'Present', 0),
    (5, '2025-12-02', '08:40:00', '17:45:00', 'Late', 0),
    (6, '2025-12-02', '07:50:00', '17:30:00', 'Present', 0),
    (7, '2025-12-02', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-02', '07:55:00', '17:30:00', 'Present', 0),
    (9, '2025-12-02', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-02', '08:00:00', '20:00:00', 'Present', 2.5),
    (11, '2025-12-02', '08:05:00', '17:30:00', 'Present', 0),
    (12, '2025-12-02', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-02', '07:45:00', '17:30:00', 'Present', 0),
    (14, '2025-12-02', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-02', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (16, '2025-12-02', '07:55:00', '17:30:00', 'Present', 0),
    (17, '2025-12-02', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-02', '08:00:00', '18:30:00', 'Present', 1.0),
    (19, '2025-12-02', '08:10:00', '17:30:00', 'Present', 0),
    (20, '2025-12-02', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-03
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-03', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2025-12-03', '07:50:00', '17:30:00', 'Present', 0),
    (3, '2025-12-03', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2025-12-03', '08:00:00', '21:00:00', 'Present', 3.5),
    (5, '2025-12-03', '08:10:00', '19:30:00', 'Present', 2.0),
    (6, '2025-12-03', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-03', '07:55:00', '17:30:00', 'Present', 0),
    (9, '2025-12-03', '07:45:00', '17:30:00', 'Present', 0),
    (10, '2025-12-03', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-03', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-03', '08:50:00', '17:30:00', 'Late', 0),
    (13, '2025-12-03', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-03', '08:05:00', '17:30:00', 'Present', 0),
    (15, '2025-12-03', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-03', '07:55:00', '18:30:00', 'Present', 1.0),
    (17, '2025-12-03', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-03', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-03', '08:15:00', '17:30:00', 'Present', 0),
    (20, '2025-12-03', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-04
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-04', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2025-12-04', '08:45:00', '17:45:00', 'Late', 0),
    (3, '2025-12-04', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2025-12-04', '08:00:00', '19:45:00', 'Present', 2.25),
    (5, '2025-12-04', '08:05:00', '19:00:00', 'Present', 1.5),
    (6, '2025-12-04', '07:58:00', '17:30:00', 'Present', 0),
    (7, '2025-12-04', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-04', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-04', '07:45:00', '17:30:00', 'Present', 0),
    (10, '2025-12-04', '08:10:00', '17:30:00', 'Present', 0),
    (11, '2025-12-04', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-04', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-04', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-04', '07:55:00', '17:30:00', 'Present', 0),
    (15, '2025-12-04', null, null, 'OnLeave', 0),
    (16, '2025-12-04', '08:00:00', '18:00:00', 'Present', 0.5),
    (17, '2025-12-04', '08:02:00', '17:30:00', 'Present', 0),
    (18, '2025-12-04', '09:00:00', '18:00:00', 'Late', 0.5),
    (19, '2025-12-04', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-04', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-05
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-05', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2025-12-05', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-05', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (4, '2025-12-05', '08:00:00', '19:00:00', 'Present', 1.5),
    (5, '2025-12-05', '08:10:00', '18:00:00', 'Present', 0.5),
    (6, '2025-12-05', '07:50:00', '17:30:00', 'Present', 0),
    (7, '2025-12-05', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-05', '07:55:00', '17:30:00', 'Present', 0),
    (9, '2025-12-05', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-05', '08:05:00', '17:30:00', 'Present', 0),
    (11, '2025-12-05', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-05', '07:45:00', '17:30:00', 'Present', 0),
    (13, '2025-12-05', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-05', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-05', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-05', '07:55:00', '17:30:00', 'Present', 0),
    (17, '2025-12-05', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-05', '08:30:00', '17:30:00', 'Late', 0),
    (19, '2025-12-05', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-05', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-08
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-08', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2025-12-08', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-08', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2025-12-08', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2025-12-08', '08:05:00', '18:30:00', 'Present', 1.0),
    (6, '2025-12-08', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-08', '07:45:00', '17:30:00', 'Present', 0),
    (8, '2025-12-08', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-08', '08:10:00', '17:30:00', 'Present', 0),
    (10, '2025-12-08', '08:00:00', '18:00:00', 'Present', 0.5),
    (11, '2025-12-08', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-08', '08:20:00', '17:30:00', 'Late', 0),
    (13, '2025-12-08', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-08', '07:55:00', '17:30:00', 'Present', 0),
    (15, '2025-12-08', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-08', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-08', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-08', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-08', '07:50:00', '17:30:00', 'Present', 0),
    (20, '2025-12-08', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-09
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-09', '08:00:00', '19:00:00', 'Present', 1.5),
    (2, '2025-12-09', '07:55:00', '17:30:00', 'Present', 0),
    (3, '2025-12-09', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2025-12-09', '08:00:00', '17:30:00', 'Present', 0),
    (5, '2025-12-09', '08:10:00', '17:45:00', 'Present', 0),
    (6, '2025-12-09', '07:50:00', '17:30:00', 'Present', 0),
    (7, '2025-12-09', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-09', '08:30:00', '17:30:00', 'Late', 0),
    (9, '2025-12-09', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-09', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-09', '08:05:00', '17:30:00', 'Present', 0),
    (12, '2025-12-09', '07:45:00', '17:30:00', 'Present', 0),
    (13, '2025-12-09', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-09', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-09', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (16, '2025-12-09', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-09', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-09', '07:55:00', '17:30:00', 'Present', 0),
    (19, '2025-12-09', '08:00:00', '18:30:00', 'Present', 1.0),
    (20, '2025-12-09', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-10
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-10', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-10', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2025-12-10', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2025-12-10', '08:20:00', '17:30:00', 'Late', 0),
    (6, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-10', '07:55:00', '17:30:00', 'Present', 0),
    (9, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-10', '08:05:00', '17:30:00', 'Present', 0),
    (14, '2025-12-10', '07:45:00', '17:30:00', 'Present', 0),
    (15, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-10', '07:55:00', '17:30:00', 'Present', 0),
    (19, '2025-12-10', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-10', '08:00:00', '18:30:00', 'Present', 1.0)

-- 2025-12-11
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-11', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2025-12-11', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-11', '08:05:00', '17:30:00', 'Present', 0),
    (4, '2025-12-11', '08:00:00', '20:30:00', 'Present', 3.0),
    (5, '2025-12-11', null, null, 'OnLeave', 0),
    (6, '2025-12-11', '07:55:00', '17:30:00', 'Present', 0),
    (7, '2025-12-11', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-11', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-11', '07:45:00', '17:30:00', 'Present', 0),
    (10, '2025-12-11', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-11', '08:45:00', '17:45:00', 'Late', 0),
    (12, '2025-12-11', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-11', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-11', '08:00:00', '19:00:00', 'Present', 1.5),
    (15, '2025-12-11', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-11', '07:50:00', '17:30:00', 'Present', 0),
    (17, '2025-12-11', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-11', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-11', '08:10:00', '17:30:00', 'Present', 0),
    (20, '2025-12-11', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-12
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-12', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2025-12-12', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-12', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (4, '2025-12-12', '08:00:00', '21:00:00', 'Present', 3.5),
    (5, '2025-12-12', '08:05:00', '17:30:00', 'Present', 0),
    (6, '2025-12-12', '07:50:00', '17:30:00', 'Present', 0),
    (7, '2025-12-12', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-12', '07:55:00', '17:30:00', 'Present', 0),
    (9, '2025-12-12', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-12', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-12', '08:15:00', '17:30:00', 'Present', 0),
    (12, '2025-12-12', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-12', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-12', '08:00:00', '18:30:00', 'Present', 1.0),
    (15, '2025-12-12', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-12', '09:00:00', '17:30:00', 'Late', 0),
    (17, '2025-12-12', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-12', '07:55:00', '17:30:00', 'Present', 0),
    (19, '2025-12-12', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-12', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-15
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-15', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2025-12-15', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-15', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2025-12-15', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2025-12-15', '08:10:00', '17:30:00', 'Present', 0),
    (6, '2025-12-15', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-15', '08:40:00', '17:45:00', 'Late', 0),
    (8, '2025-12-15', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-15', '07:45:00', '17:30:00', 'Present', 0),
    (10, '2025-12-15', '08:00:00', '18:00:00', 'Present', 0.5),
    (11, '2025-12-15', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-15', '08:05:00', '17:30:00', 'Present', 0),
    (13, '2025-12-15', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (14, '2025-12-15', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-15', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-15', '07:55:00', '17:30:00', 'Present', 0),
    (17, '2025-12-15', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-15', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-15', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-15', '08:15:00', '17:30:00', 'Present', 0)

-- 2025-12-16
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-16', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2025-12-16', '07:50:00', '17:30:00', 'Present', 0),
    (3, '2025-12-16', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2025-12-16', '08:00:00', '20:15:00', 'Present', 2.75),
    (5, '2025-12-16', '08:00:00', '19:00:00', 'Present', 1.5),
    (6, '2025-12-16', '08:35:00', '17:30:00', 'Late', 0),
    (7, '2025-12-16', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-16', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (9, '2025-12-16', '07:55:00', '17:30:00', 'Present', 0),
    (10, '2025-12-16', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-16', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-16', '07:45:00', '17:30:00', 'Present', 0),
    (13, '2025-12-16', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-16', '08:05:00', '17:30:00', 'Present', 0),
    (15, '2025-12-16', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-16', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-16', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-16', '08:00:00', '18:00:00', 'Present', 0.5),
    (19, '2025-12-16', null, null, 'OnLeave', 0),
    (20, '2025-12-16', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-17
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-17', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2025-12-17', '08:40:00', '17:45:00', 'Late', 0),
    (3, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2025-12-17', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2025-12-17', '08:05:00', '19:30:00', 'Present', 2.0),
    (6, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-17', '07:50:00', '17:30:00', 'Present', 0),
    (8, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-17', '08:15:00', '17:30:00', 'Present', 0),
    (11, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-17', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (13, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-17', '07:55:00', '17:30:00', 'Present', 0),
    (16, '2025-12-17', '08:00:00', '18:30:00', 'Present', 1.0),
    (17, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-17', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-18
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-18', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-18', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2025-12-18', '08:00:00', '20:30:00', 'Present', 3.0),
    (5, '2025-12-18', '08:00:00', '19:00:00', 'Present', 1.5),
    (6, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-18', '08:10:00', '17:30:00', 'Present', 0),
    (10, '2025-12-18', null, null, 'OnLeave', 0),
    (11, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-18', '08:45:00', '17:45:00', 'Late', 0),
    (14, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-18', '07:45:00', '17:30:00', 'Present', 0),
    (16, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-18', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-18', '08:05:00', '17:30:00', 'Present', 0)

-- 2025-12-19
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-19', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-19', '08:40:00', '17:45:00', 'Late', 0),
    (4, '2025-12-19', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2025-12-19', '08:00:00', '19:00:00', 'Present', 1.5),
    (6, '2025-12-19', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (7, '2025-12-19', '07:50:00', '17:30:00', 'Present', 0),
    (8, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-19', '08:10:00', '17:30:00', 'Present', 0),
    (12, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-19', '07:55:00', '17:30:00', 'Present', 0),
    (15, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-19', '08:00:00', '18:00:00', 'Present', 0.5),
    (17, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-19', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-22
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-22', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2025-12-22', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2025-12-22', '08:00:00', '18:30:00', 'Present', 1.0),
    (6, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-22', '07:55:00', '17:30:00', 'Present', 0),
    (8, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-22', '08:05:00', '17:30:00', 'Present', 0),
    (12, '2025-12-22', '08:30:00', '17:30:00', 'Late', 0),
    (13, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-22', '07:45:00', '17:30:00', 'Present', 0),
    (15, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-22', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-23
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-23', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2025-12-23', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2025-12-23', '08:15:00', '17:45:00', 'Late', 0),
    (6, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-23', '08:00:00', '18:00:00', 'Present', 0.5),
    (11, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-23', '07:50:00', '17:30:00', 'Present', 0),
    (13, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-23', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (16, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-23', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-24
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-24', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2025-12-24', '08:00:00', '19:00:00', 'Present', 1.5),
    (5, '2025-12-24', '08:00:00', '18:00:00', 'Present', 0.5),
    (6, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-24', null, null, 'OnLeave', 0),
    (9, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-24', '07:45:00', '17:30:00', 'Present', 0),
    (14, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-24', '08:10:00', '17:30:00', 'Present', 0),
    (16, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-24', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-25
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2025-12-25', '08:00:00', '18:00:00', 'Present', 0.5),
    (5, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-25', '08:35:00', '17:30:00', 'Late', 0),
    (10, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-25', '07:55:00', '17:30:00', 'Present', 0),
    (18, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-25', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-26
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-26', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2025-12-26', '08:00:00', '21:00:00', 'Present', 3.5),
    (5, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-26', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (14, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-26', '09:00:00', '18:00:00', 'Late', 0.5),
    (19, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-26', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-29
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-29', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2025-12-29', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2025-12-29', '08:10:00', '18:00:00', 'Present', 0.5),
    (6, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-29', '07:55:00', '17:30:00', 'Present', 0),
    (8, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-29', '08:45:00', '17:45:00', 'Late', 0),
    (13, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-29', '07:55:00', '17:30:00', 'Present', 0),
    (17, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-29', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-30
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-30', '08:00:00', '18:30:00', 'Present', 1.0),
    (2, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2025-12-30', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2025-12-30', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-30', null, null, 'OnLeave', 0),
    (9, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-30', '07:50:00', '17:30:00', 'Present', 0),
    (18, '2025-12-30', '08:35:00', '17:35:00', 'Late', 0),
    (19, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-30', '08:00:00', '17:30:00', 'Present', 0)

-- 2025-12-31
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-31', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (2, '2025-12-31', '08:00:00', '17:00:00', 'LeaveEarly', 0),
    (3, '2025-12-31', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2025-12-31', '08:00:00', '18:00:00', 'Present', 0.5),
    (5, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2025-12-31', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (7, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2025-12-31', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (11, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2025-12-31', '08:00:00', '15:30:00', 'LeaveEarly', 0),
    (16, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2025-12-31', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2025-12-31', '08:00:00', '16:00:00', 'LeaveEarly', 0)

-- 2026-01-05
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-05', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-05', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-01-05', '08:00:00', '18:30:00', 'Present', 1.0),
    (5, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-05', '08:05:00', '17:30:00', 'Present', 0),
    (9, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-05', '08:45:00', '17:45:00', 'Late', 0),
    (13, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-05', '07:50:00', '17:30:00', 'Present', 0),
    (17, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-05', '08:10:00', '17:30:00', 'Present', 0),
    (20, '2026-01-05', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-06
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2026-01-06', '07:55:00', '17:30:00', 'Present', 0),
    (3, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2026-01-06', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2026-01-06', '08:15:00', '17:30:00', 'Late', 0),
    (6, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-06', '07:50:00', '17:30:00', 'Present', 0),
    (13, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-06', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (16, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-06', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-07
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-07', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-07', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-01-07', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2026-01-07', '08:00:00', '18:00:00', 'Present', 0.5),
    (6, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-07', '08:30:00', '17:45:00', 'Late', 0),
    (10, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-07', '07:45:00', '17:30:00', 'Present', 0),
    (15, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-07', null, null, 'OnLeave', 0),
    (20, '2026-01-07', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-08
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2026-01-08', '08:00:00', '20:30:00', 'Present', 3.0),
    (5, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-08', '08:05:00', '17:30:00', 'Present', 0),
    (12, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-08', '09:00:00', '18:00:00', 'Late', 0.5),
    (19, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-08', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-09
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-09', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-09', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (4, '2026-01-09', '08:00:00', '19:00:00', 'Present', 1.5),
    (5, '2026-01-09', '08:00:00', '18:00:00', 'Present', 0.5),
    (6, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-09', '07:50:00', '17:30:00', 'Present', 0),
    (9, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-09', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-12
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-12', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-12', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2026-01-12', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2026-01-12', '08:10:00', '18:00:00', 'Present', 0.5),
    (6, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-12', '08:05:00', '17:30:00', 'Present', 0),
    (12, '2026-01-12', '08:30:00', '17:30:00', 'Late', 0),
    (13, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-12', '07:45:00', '17:30:00', 'Present', 0),
    (15, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-12', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-13
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-13', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-01-13', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-13', '08:00:00', '18:00:00', 'Present', 0.5),
    (11, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-13', '07:50:00', '17:30:00', 'Present', 0),
    (13, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-13', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (16, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-13', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-14
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-14', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2026-01-14', '08:00:00', '19:00:00', 'Present', 1.5),
    (5, '2026-01-14', '08:00:00', '18:00:00', 'Present', 0.5),
    (6, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-14', null, null, 'OnLeave', 0),
    (9, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-14', '07:45:00', '17:30:00', 'Present', 0),
    (14, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-14', '08:10:00', '17:30:00', 'Present', 0),
    (16, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-14', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-15
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2026-01-15', '08:00:00', '18:00:00', 'Present', 0.5),
    (5, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-15', '08:35:00', '17:30:00', 'Late', 0),
    (10, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-15', '07:55:00', '17:30:00', 'Present', 0),
    (18, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-15', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-16
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-16', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2026-01-16', '08:00:00', '21:00:00', 'Present', 3.5),
    (5, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-16', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (14, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-16', '09:00:00', '18:00:00', 'Late', 0.5),
    (19, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-16', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-19
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-19', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2026-01-19', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2026-01-19', '08:05:00', '18:00:00', 'Present', 0.5),
    (6, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-19', '07:55:00', '17:30:00', 'Present', 0),
    (8, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-19', '08:40:00', '17:40:00', 'Late', 0),
    (13, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-19', '07:50:00', '17:30:00', 'Present', 0),
    (17, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-19', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-20
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-20', '08:00:00', '18:00:00', 'Present', 0.5),
    (2, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-20', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-01-20', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-20', null, null, 'OnLeave', 0),
    (9, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-20', '07:50:00', '17:30:00', 'Present', 0),
    (18, '2026-01-20', '08:35:00', '17:35:00', 'Late', 0),
    (19, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-20', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-21
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-21', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (2, '2026-01-21', '08:00:00', '17:00:00', 'LeaveEarly', 0),
    (3, '2026-01-21', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2026-01-21', '08:00:00', '18:00:00', 'Present', 0.5),
    (5, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-01-21', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (7, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-21', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-22
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-22', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-01-22', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-22', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2026-01-22', '08:00:00', '20:15:00', 'Present', 2.75),
    (5, '2026-01-22', '08:00:00', '19:00:00', 'Present', 1.5),
    (6, '2026-01-22', '08:35:00', '17:30:00', 'Late', 0),
    (7, '2026-01-22', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-22', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (9, '2026-01-22', '07:55:00', '17:30:00', 'Present', 0),
    (10, '2026-01-22', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-22', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-22', '07:45:00', '17:30:00', 'Present', 0),
    (13, '2026-01-22', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-22', '08:05:00', '17:30:00', 'Present', 0),
    (15, '2026-01-22', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-22', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-22', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-22', '08:00:00', '18:00:00', 'Present', 0.5),
    (19, '2026-01-22', null, null, 'OnLeave', 0),
    (20, '2026-01-22', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-23
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-23', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-01-23', '08:40:00', '17:45:00', 'Late', 0),
    (3, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2026-01-23', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2026-01-23', '08:05:00', '19:30:00', 'Present', 2.0),
    (6, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-23', '07:50:00', '17:30:00', 'Present', 0),
    (8, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-23', '08:15:00', '17:30:00', 'Present', 0),
    (11, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-23', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (13, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-23', '07:55:00', '17:30:00', 'Present', 0),
    (16, '2026-01-23', '08:00:00', '18:30:00', 'Present', 1.0),
    (17, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-23', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-26
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-26', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-26', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-01-26', '08:00:00', '20:30:00', 'Present', 3.0),
    (5, '2026-01-26', '08:00:00', '19:00:00', 'Present', 1.5),
    (6, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-26', '08:10:00', '17:30:00', 'Present', 0),
    (10, '2026-01-26', null, null, 'OnLeave', 0),
    (11, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-26', '08:45:00', '17:45:00', 'Late', 0),
    (14, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-26', '07:45:00', '17:30:00', 'Present', 0),
    (16, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-26', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-26', '08:05:00', '17:30:00', 'Present', 0)

-- 2026-01-27
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-27', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-27', '08:40:00', '17:45:00', 'Late', 0),
    (4, '2026-01-27', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2026-01-27', '08:00:00', '19:00:00', 'Present', 1.5),
    (6, '2026-01-27', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (7, '2026-01-27', '07:50:00', '17:30:00', 'Present', 0),
    (8, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-27', '08:10:00', '17:30:00', 'Present', 0),
    (12, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-27', '07:55:00', '17:30:00', 'Present', 0),
    (15, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-27', '08:00:00', '18:00:00', 'Present', 0.5),
    (17, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-27', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-28
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-28', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2026-01-28', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-28', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-01-28', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2026-01-28', '08:05:00', '18:30:00', 'Present', 1.0),
    (6, '2026-01-28', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-28', '07:45:00', '17:30:00', 'Present', 0),
    (8, '2026-01-28', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-01-28', '08:10:00', '17:30:00', 'Present', 0),
    (10, '2026-01-28', '08:00:00', '18:00:00', 'Present', 0.5),
    (11, '2026-01-28', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-28', '08:20:00', '17:30:00', 'Late', 0),
    (13, '2026-01-28', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-28', '07:55:00', '17:30:00', 'Present', 0),
    (15, '2026-01-28', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-28', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-28', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-28', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-01-28', '07:50:00', '17:30:00', 'Present', 0),
    (20, '2026-01-28', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-29
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-29', '08:00:00', '19:00:00', 'Present', 1.5),
    (2, '2026-01-29', '07:55:00', '17:30:00', 'Present', 0),
    (3, '2026-01-29', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2026-01-29', '08:00:00', '17:30:00', 'Present', 0),
    (5, '2026-01-29', '08:10:00', '17:45:00', 'Present', 0),
    (6, '2026-01-29', '07:50:00', '17:30:00', 'Present', 0),
    (7, '2026-01-29', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-29', '08:30:00', '17:30:00', 'Late', 0),
    (9, '2026-01-29', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-29', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-29', '08:05:00', '17:30:00', 'Present', 0),
    (12, '2026-01-29', '07:45:00', '17:30:00', 'Present', 0),
    (13, '2026-01-29', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-01-29', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-01-29', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (16, '2026-01-29', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-29', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-29', '07:55:00', '17:30:00', 'Present', 0),
    (19, '2026-01-29', '08:00:00', '18:30:00', 'Present', 1.0),
    (20, '2026-01-29', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-01-30
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-01-30', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-01-30', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2026-01-30', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2026-01-30', '08:20:00', '17:30:00', 'Late', 0),
    (6, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-01-30', '07:55:00', '17:30:00', 'Present', 0),
    (9, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-01-30', '08:05:00', '17:30:00', 'Present', 0),
    (14, '2026-01-30', '07:45:00', '17:30:00', 'Present', 0),
    (15, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-01-30', '07:55:00', '17:30:00', 'Present', 0),
    (19, '2026-01-30', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-01-30', '08:00:00', '18:30:00', 'Present', 1.0)

-- 2026-02-02
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-02', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-02', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-02-02', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2026-02-02', '08:10:00', '18:00:00', 'Present', 0.5),
    (6, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-02-02', '07:55:00', '17:30:00', 'Present', 0),
    (8, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-02-02', '08:45:00', '17:45:00', 'Late', 0),
    (13, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-02', '07:55:00', '17:30:00', 'Present', 0),
    (17, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-02', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-02-03
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-03', '08:00:00', '18:30:00', 'Present', 1.0),
    (2, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-03', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-02-03', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-02-03', null, null, 'OnLeave', 0),
    (9, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-02-03', '07:50:00', '17:30:00', 'Present', 0),
    (18, '2026-02-03', '08:35:00', '17:35:00', 'Late', 0),
    (19, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-03', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-02-04
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-04', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (2, '2026-02-04', '08:00:00', '17:00:00', 'LeaveEarly', 0),
    (3, '2026-02-04', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2026-02-04', '08:00:00', '18:00:00', 'Present', 0.5),
    (5, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-02-04', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (7, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-02-04', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (11, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-02-04', '08:00:00', '15:30:00', 'LeaveEarly', 0),
    (16, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-02-04', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-04', '08:00:00', '16:00:00', 'LeaveEarly', 0)

-- 2026-02-05
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-05', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-05', '08:05:00', '17:30:00', 'Present', 0),
    (4, '2026-02-05', '08:00:00', '20:30:00', 'Present', 3.0),
    (5, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-02-05', '07:55:00', '17:30:00', 'Present', 0),
    (7, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-02-05', '07:45:00', '17:30:00', 'Present', 0),
    (10, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-02-05', '08:45:00', '17:45:00', 'Late', 0),
    (12, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-05', '08:00:00', '19:00:00', 'Present', 1.5),
    (15, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-05', '07:50:00', '17:30:00', 'Present', 0),
    (17, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-02-05', '08:10:00', '17:30:00', 'Present', 0),
    (20, '2026-02-05', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-02-06
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-06', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-02-06', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-06', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (4, '2026-02-06', '08:00:00', '21:00:00', 'Present', 3.5),
    (5, '2026-02-06', '08:05:00', '17:30:00', 'Present', 0),
    (6, '2026-02-06', '07:50:00', '17:30:00', 'Present', 0),
    (7, '2026-02-06', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-02-06', '07:55:00', '17:30:00', 'Present', 0),
    (9, '2026-02-06', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-02-06', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-02-06', '08:15:00', '17:30:00', 'Present', 0),
    (12, '2026-02-06', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-02-06', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-06', '08:00:00', '18:30:00', 'Present', 1.0),
    (15, '2026-02-06', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-06', '09:00:00', '17:30:00', 'Late', 0),
    (17, '2026-02-06', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-06', '07:55:00', '17:30:00', 'Present', 0),
    (19, '2026-02-06', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-06', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-02-09
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-09', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2026-02-09', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-09', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-02-09', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2026-02-09', '08:10:00', '17:30:00', 'Present', 0),
    (6, '2026-02-09', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-02-09', '08:40:00', '17:45:00', 'Late', 0),
    (8, '2026-02-09', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-02-09', '07:45:00', '17:30:00', 'Present', 0),
    (10, '2026-02-09', '08:00:00', '18:00:00', 'Present', 0.5),
    (11, '2026-02-09', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-02-09', '08:05:00', '17:30:00', 'Present', 0),
    (13, '2026-02-09', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (14, '2026-02-09', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-02-09', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-09', '07:55:00', '17:30:00', 'Present', 0),
    (17, '2026-02-09', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-09', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-02-09', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-09', '08:15:00', '17:30:00', 'Present', 0)

-- 2026-02-10
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-10', '08:00:00', '17:30:00', 'Present', 0),
    (2, '2026-02-10', '07:50:00', '17:30:00', 'Present', 0),
    (3, '2026-02-10', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2026-02-10', '08:00:00', '20:15:00', 'Present', 2.75),
    (5, '2026-02-10', '08:00:00', '19:00:00', 'Present', 1.5),
    (6, '2026-02-10', '08:35:00', '17:30:00', 'Late', 0),
    (7, '2026-02-10', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-02-10', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (9, '2026-02-10', '07:55:00', '17:30:00', 'Present', 0),
    (10, '2026-02-10', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-02-10', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-02-10', '07:45:00', '17:30:00', 'Present', 0),
    (13, '2026-02-10', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-10', '08:05:00', '17:30:00', 'Present', 0),
    (15, '2026-02-10', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-10', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-02-10', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-10', '08:00:00', '18:00:00', 'Present', 0.5),
    (19, '2026-02-10', null, null, 'OnLeave', 0),
    (20, '2026-02-10', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-02-11
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-11', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-02-11', '08:40:00', '17:45:00', 'Late', 0),
    (3, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0),
    (4, '2026-02-11', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2026-02-11', '08:05:00', '19:30:00', 'Present', 2.0),
    (6, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-02-11', '07:50:00', '17:30:00', 'Present', 0),
    (8, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-02-11', '08:15:00', '17:30:00', 'Present', 0),
    (11, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-02-11', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (13, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-02-11', '07:55:00', '17:30:00', 'Present', 0),
    (16, '2026-02-11', '08:00:00', '18:30:00', 'Present', 1.0),
    (17, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-11', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-02-12
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-12', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-12', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-02-12', '08:00:00', '20:30:00', 'Present', 3.0),
    (5, '2026-02-12', '08:00:00', '19:00:00', 'Present', 1.5),
    (6, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-02-12', '08:10:00', '17:30:00', 'Present', 0),
    (10, '2026-02-12', null, null, 'OnLeave', 0),
    (11, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-02-12', '08:45:00', '17:45:00', 'Late', 0),
    (14, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-02-12', '07:45:00', '17:30:00', 'Present', 0),
    (16, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-02-12', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-12', '08:05:00', '17:30:00', 'Present', 0)

-- 2026-02-13
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-13', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-13', '08:40:00', '17:45:00', 'Late', 0),
    (4, '2026-02-13', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2026-02-13', '08:00:00', '19:00:00', 'Present', 1.5),
    (6, '2026-02-13', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (7, '2026-02-13', '07:50:00', '17:30:00', 'Present', 0),
    (8, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-02-13', '08:10:00', '17:30:00', 'Present', 0),
    (12, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-13', '07:55:00', '17:30:00', 'Present', 0),
    (15, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-13', '08:00:00', '18:00:00', 'Present', 0.5),
    (17, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-13', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-02-16
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-16', null, null, 'Holiday', 0),
    (2, '2026-02-16', null, null, 'Holiday', 0),
    (3, '2026-02-16', null, null, 'Holiday', 0),
    (4, '2026-02-16', null, null, 'Holiday', 0),
    (5, '2026-02-16', null, null, 'Holiday', 0),
    (6, '2026-02-16', null, null, 'Holiday', 0),
    (7, '2026-02-16', null, null, 'Holiday', 0),
    (8, '2026-02-16', null, null, 'Holiday', 0),
    (9, '2026-02-16', null, null, 'Holiday', 0),
    (10, '2026-02-16', null, null, 'Holiday', 0),
    (11, '2026-02-16', null, null, 'Holiday', 0),
    (12, '2026-02-16', null, null, 'Holiday', 0),
    (13, '2026-02-16', null, null, 'Holiday', 0),
    (14, '2026-02-16', null, null, 'Holiday', 0),
    (15, '2026-02-16', null, null, 'Holiday', 0),
    (16, '2026-02-16', null, null, 'Holiday', 0),
    (17, '2026-02-16', null, null, 'Holiday', 0),
    (18, '2026-02-16', null, null, 'Holiday', 0),
    (19, '2026-02-16', null, null, 'Holiday', 0),
    (20, '2026-02-16', null, null, 'Holiday', 0)

-- 2026-02-17
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-17', null, null, 'Holiday', 0),
    (2, '2026-02-17', null, null, 'Holiday', 0),
    (3, '2026-02-17', null, null, 'Holiday', 0),
    (4, '2026-02-17', null, null, 'Holiday', 0),
    (5, '2026-02-17', null, null, 'Holiday', 0),
    (6, '2026-02-17', null, null, 'Holiday', 0),
    (7, '2026-02-17', null, null, 'Holiday', 0),
    (8, '2026-02-17', null, null, 'Holiday', 0),
    (9, '2026-02-17', null, null, 'Holiday', 0),
    (10, '2026-02-17', null, null, 'Holiday', 0),
    (11, '2026-02-17', null, null, 'Holiday', 0),
    (12, '2026-02-17', null, null, 'Holiday', 0),
    (13, '2026-02-17', null, null, 'Holiday', 0),
    (14, '2026-02-17', null, null, 'Holiday', 0),
    (15, '2026-02-17', null, null, 'Holiday', 0),
    (16, '2026-02-17', null, null, 'Holiday', 0),
    (17, '2026-02-17', null, null, 'Holiday', 0),
    (18, '2026-02-17', null, null, 'Holiday', 0),
    (19, '2026-02-17', null, null, 'Holiday', 0),
    (20, '2026-02-17', null, null, 'Holiday', 0)

-- 2026-02-18
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-18', null, null, 'Holiday', 0),
    (2, '2026-02-18', null, null, 'Holiday', 0),
    (3, '2026-02-18', null, null, 'Holiday', 0),
    (4, '2026-02-18', null, null, 'Holiday', 0),
    (5, '2026-02-18', null, null, 'Holiday', 0),
    (6, '2026-02-18', null, null, 'Holiday', 0),
    (7, '2026-02-18', null, null, 'Holiday', 0),
    (8, '2026-02-18', null, null, 'Holiday', 0),
    (9, '2026-02-18', null, null, 'Holiday', 0),
    (10, '2026-02-18', null, null, 'Holiday', 0),
    (11, '2026-02-18', null, null, 'Holiday', 0),
    (12, '2026-02-18', null, null, 'Holiday', 0),
    (13, '2026-02-18', null, null, 'Holiday', 0),
    (14, '2026-02-18', null, null, 'Holiday', 0),
    (15, '2026-02-18', null, null, 'Holiday', 0),
    (16, '2026-02-18', null, null, 'Holiday', 0),
    (17, '2026-02-18', null, null, 'Holiday', 0),
    (18, '2026-02-18', null, null, 'Holiday', 0),
    (19, '2026-02-18', null, null, 'Holiday', 0),
    (20, '2026-02-18', null, null, 'Holiday', 0)

-- 2026-02-19
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-19', null, null, 'Holiday', 0),
    (2, '2026-02-19', null, null, 'Holiday', 0),
    (3, '2026-02-19', null, null, 'Holiday', 0),
    (4, '2026-02-19', null, null, 'Holiday', 0),
    (5, '2026-02-19', null, null, 'Holiday', 0),
    (6, '2026-02-19', null, null, 'Holiday', 0),
    (7, '2026-02-19', null, null, 'Holiday', 0),
    (8, '2026-02-19', null, null, 'Holiday', 0),
    (9, '2026-02-19', null, null, 'Holiday', 0),
    (10, '2026-02-19', null, null, 'Holiday', 0),
    (11, '2026-02-19', null, null, 'Holiday', 0),
    (12, '2026-02-19', null, null, 'Holiday', 0),
    (13, '2026-02-19', null, null, 'Holiday', 0),
    (14, '2026-02-19', null, null, 'Holiday', 0),
    (15, '2026-02-19', null, null, 'Holiday', 0),
    (16, '2026-02-19', null, null, 'Holiday', 0),
    (17, '2026-02-19', null, null, 'Holiday', 0),
    (18, '2026-02-19', null, null, 'Holiday', 0),
    (19, '2026-02-19', null, null, 'Holiday', 0),
    (20, '2026-02-19', null, null, 'Holiday', 0)

-- 2026-02-20
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-20', null, null, 'Holiday', 0),
    (2, '2026-02-20', null, null, 'Holiday', 0),
    (3, '2026-02-20', null, null, 'Holiday', 0),
    (4, '2026-02-20', null, null, 'Holiday', 0),
    (5, '2026-02-20', null, null, 'Holiday', 0),
    (6, '2026-02-20', null, null, 'Holiday', 0),
    (7, '2026-02-20', null, null, 'Holiday', 0),
    (8, '2026-02-20', null, null, 'Holiday', 0),
    (9, '2026-02-20', null, null, 'Holiday', 0),
    (10, '2026-02-20', null, null, 'Holiday', 0),
    (11, '2026-02-20', null, null, 'Holiday', 0),
    (12, '2026-02-20', null, null, 'Holiday', 0),
    (13, '2026-02-20', null, null, 'Holiday', 0),
    (14, '2026-02-20', null, null, 'Holiday', 0),
    (15, '2026-02-20', null, null, 'Holiday', 0),
    (16, '2026-02-20', null, null, 'Holiday', 0),
    (17, '2026-02-20', null, null, 'Holiday', 0),
    (18, '2026-02-20', null, null, 'Holiday', 0),
    (19, '2026-02-20', null, null, 'Holiday', 0),
    (20, '2026-02-20', null, null, 'Holiday', 0)

-- 2026-02-23
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-23', '07:50:00', '17:30:00', 'Present', 0),
    (2, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-23', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-02-23', '08:00:00', '19:30:00', 'Present', 2.0),
    (5, '2026-02-23', '08:10:00', '18:00:00', 'Present', 0.5),
    (6, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-02-23', '07:55:00', '17:30:00', 'Present', 0),
    (8, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-02-23', '08:45:00', '17:45:00', 'Late', 0),
    (13, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-23', '07:55:00', '17:30:00', 'Present', 0),
    (17, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-23', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-02-24
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-24', '08:00:00', '18:30:00', 'Present', 1.0),
    (2, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-24', '07:55:00', '17:30:00', 'Present', 0),
    (4, '2026-02-24', '08:00:00', '20:00:00', 'Present', 2.5),
    (5, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (7, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-02-24', null, null, 'OnLeave', 0),
    (9, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-02-24', '07:50:00', '17:30:00', 'Present', 0),
    (18, '2026-02-24', '08:35:00', '17:35:00', 'Late', 0),
    (19, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-24', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-02-25
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-25', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (2, '2026-02-25', '08:00:00', '17:00:00', 'LeaveEarly', 0),
    (3, '2026-02-25', '07:50:00', '17:30:00', 'Present', 0),
    (4, '2026-02-25', '08:00:00', '18:00:00', 'Present', 0.5),
    (5, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-02-25', '08:00:00', '16:30:00', 'LeaveEarly', 0),
    (7, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-02-25', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (11, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (12, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (15, '2026-02-25', '08:00:00', '15:30:00', 'LeaveEarly', 0),
    (16, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (17, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-02-25', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-25', '08:00:00', '16:00:00', 'LeaveEarly', 0)

-- 2026-02-26
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-26', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-26', '08:05:00', '17:30:00', 'Present', 0),
    (4, '2026-02-26', '08:00:00', '20:30:00', 'Present', 3.0),
    (5, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0),
    (6, '2026-02-26', '07:55:00', '17:30:00', 'Present', 0),
    (7, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0),
    (9, '2026-02-26', '07:45:00', '17:30:00', 'Present', 0),
    (10, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-02-26', '08:45:00', '17:45:00', 'Late', 0),
    (12, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-26', '08:00:00', '19:00:00', 'Present', 1.5),
    (15, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-26', '07:50:00', '17:30:00', 'Present', 0),
    (17, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0),
    (19, '2026-02-26', '08:10:00', '17:30:00', 'Present', 0),
    (20, '2026-02-26', '08:00:00', '17:30:00', 'Present', 0)

-- 2026-02-27
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2026-02-27', '07:55:00', '17:30:00', 'Present', 0),
    (2, '2026-02-27', '08:00:00', '17:30:00', 'Present', 0),
    (3, '2026-02-27', '08:00:00', '16:00:00', 'LeaveEarly', 0),
    (4, '2026-02-27', '08:00:00', '21:00:00', 'Present', 3.5),
    (5, '2026-02-27', '08:05:00', '17:30:00', 'Present', 0),
    (6, '2026-02-27', '07:50:00', '17:30:00', 'Present', 0),
    (7, '2026-02-27', '08:00:00', '17:30:00', 'Present', 0),
    (8, '2026-02-27', '07:55:00', '17:30:00', 'Present', 0),
    (9, '2026-02-27', '08:00:00', '17:30:00', 'Present', 0),
    (10, '2026-02-27', '08:00:00', '17:30:00', 'Present', 0),
    (11, '2026-02-27', '08:15:00', '17:30:00', 'Present', 0),
    (12, '2026-02-27', '08:00:00', '17:30:00', 'Present', 0),
    (13, '2026-02-27', '08:00:00', '17:30:00', 'Present', 0),
    (14, '2026-02-27', '08:00:00', '18:30:00', 'Present', 1.0),
    (15, '2026-02-27', '08:00:00', '17:30:00', 'Present', 0),
    (16, '2026-02-27', '09:00:00', '17:30:00', 'Late', 0),
    (17, '2026-02-27', '08:00:00', '17:30:00', 'Present', 0),
    (18, '2026-02-27', '07:55:00', '17:30:00', 'Present', 0),
    (19, '2026-02-27', '08:00:00', '17:30:00', 'Present', 0),
    (20, '2026-02-27', '08:00:00', '17:30:00', 'Present', 0)


-- insert payroll


------------------------------------------------------------------------
-- select don
-- 1. danh sach tat ca nhan vien
select *
from Employees
-- 2. danh sach tat ca cac phong ban
select *
from Department
-- 3. danh sach tat ca ban ghi cham cong
select *
from Attendance
-- 4. danh sach tat ca cac chi nhanh
select *
from [Location]
-- 5. danh sach tat ca ban ghi luong 
select *
from Payroll