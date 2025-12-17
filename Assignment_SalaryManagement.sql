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

update Employees
set Phone = '+84966244761'
where EmpId = 1

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
-- 1. 12/2025
insert into Payroll
    (EmpID, [Month], [Year], Deduction, Allowance, TotalOTHours, TotalWorkDays, NetSalary)
select
    e.EmpId, 12, 2025,
    50 as Deduction,
    100 as Allowance,
    ISNULL(SUM(a.OvertimeHours), 0),
    COUNT(distinct a.WorkDate),
    (e.BaseSalary + 100 - 50) + 
    (ISNULL(SUM(a.OvertimeHours), 0) * ((e.BaseSalary / 176) * 2))
from Employees e
    left join Attendance a on e.EmpId = a.EmpId
where MONTH(a.WorkDate) = 12 and YEAR(a.WorkDate) = 2025
group by e.EmpId, e.BaseSalary;

-- 2. 01/2026
insert into Payroll
    (EmpID, [Month], [Year], Deduction, Allowance, TotalOTHours, TotalWorkDays, NetSalary)
select
    e.EmpId, 1, 2026,
    50, 100,
    ISNULL(SUM(a.OvertimeHours), 0),
    COUNT(distinct a.WorkDate),
    (e.BaseSalary + 100 - 50) + 
    (ISNULL(SUM(a.OvertimeHours), 0) * ((e.BaseSalary / 176) * 2))
from Employees e
    left join Attendance a on e.EmpId = a.EmpId
where MONTH(a.WorkDate) = 1 and YEAR(a.WorkDate) = 2026
group by e.EmpId, e.BaseSalary;

-- 3. 02/2026 (Thưởng Tết $500)
insert into Payroll
    (EmpID, [Month], [Year], Deduction, Allowance, TotalOTHours, TotalWorkDays, NetSalary)
select
    e.EmpId, 2, 2026,
    50,
    500,
    ISNULL(SUM(a.OvertimeHours), 0),
    COUNT(distinct a.WorkDate),
    (e.BaseSalary + 500 - 50) + 
    (ISNULL(SUM(a.OvertimeHours), 0) * ((e.BaseSalary / 176) * 2))
from Employees e
    left join Attendance a on e.EmpId = a.EmpId
where MONTH(a.WorkDate) = 2 and YEAR(a.WorkDate) = 2026
group by e.EmpId, e.BaseSalary;

------------------------------------------------------------------------
-- SINGLE SELECT
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

-- 6. nhung vi tri hien co trong cong ty
select distinct Position
from Employees
order by Position

-- 7. dev, manager
select
    EmpId,
    FName,
    LName,
    Position,
    DeptId
from Employees
where Position in ('Dev', 'Senior Dev', 'Project Manager')
order by DeptId

-- 8. du tinh thu nhap ca nam cua nv
select
    EmpId,
    FName + ' ' + LName as FullName,
    BaseSalary as MonthlySalary,
    (BaseSalary * 12) as EstimatedAnnualSalary
from Employees
order by EstimatedAnnualSalary desc

-- 9. loc nv co sinh nhat trong quy 1 
select
    EmpId,
    Gender,
    Birthdate,
    Hometown
from EmpInfo
where MONTH(Birthdate) in (1, 2, 3)
order by MONTH(Birthdate) asc

-- 10. 
select
    EmpId,
    FName,
    LName,
    Email,
    Phone
from Employees
where Email like '%@gmail.com'
    or Email like '%@yahoo.com'

go

------------------------------------------------------------------------
-- MULTIPLE SELECT 
-- 1. thong tin nhan vien dang lam viec o chi nhanh Tokyo
select
    *
from Employees e
    join EmpInfo ei on e.EmpId = ei.EmpId
where e.LocationId = (select LocationId
from [Location]
where LocationName = 'Tokyo Headquarter')

-- 2. nhan vien moi nhan viec
select
    e.EmpId,
    CONCAT(e.FName, ' ', e.LName) as Fullname,
    ei.Gender,
    e.[Position],
    e.Phone,
    e.Email
from Employees e
    join EmpInfo ei on e.EmpId = ei.EmpId
where MONTH(ei.HireDate) = 12

-- 3. top 5 nhan vien OT nhieu nhat 
select top 5
    e.EmpId,
    CONCAT(e.FName, ' ', e.LName) as Fullname,
    e.[Position],
    e.DeptId,
    l.LocationName,
    p.TotalOTHours
from Employees e
    join Payroll p on e.EmpId = p.EmpID
    join [Location] l on e.LocationId = l.LocationId
order by TotalOTHours desc

-- 4. thong ke so nhan vien / phong ban
select
    d.DeptId,
    d.DeptName,
    COUNT(e.EmpId) as NumberOfEmployees
from Department d
    join Employees e on d.DeptId = e.DeptId
group by d.DeptId, d.DeptName

-- 5. tong quy luong tren phong ban trong thang 1/2026
select
    d.DeptId,
    d.DeptName,
    CONCAT(ISNULL(SUM(p.NetSalary), 0), ' $') as TotalPayrollFund
from Department d
    join Employees e on d.DeptId = e.DeptId
    join Payroll p on e.EmpId = p.EmpID
where p.[Month] = 2 and p.[Year] = 2026
group by d.DeptId, d.DeptName
order by ISNULL(SUM(p.NetSalary), 0) desc

-- 6. ho so nhan vien
select
    e.EmpId,
    e.FName + ' ' + e.LName as FullName,
    e.Position,
    d.DeptName,
    l.LocationName,
    l.City
from Employees e
    inner join Department d on e.DeptId = d.DeptId
    inner join [Location] l on e.LocationId = l.LocationId

-- 7. bang luong chi tiet theo phong ban
select
    d.DeptName,
    e.EmpId,
    e.FName + ' ' + e.LName as FullName,
    p.TotalWorkDays,
    p.TotalOTHours,
    p.NetSalary
from Payroll p
    join Employees e on p.EmpID = e.EmpId
    join Department d on e.DeptId = d.DeptId
where p.[Month] = 12
    and p.[Year] = 2025
order by d.DeptName, p.NetSalary desc

-- 8. thong tin nhung nhan vien di muon trong thang kem thong tin lien lac
select
    a.WorkDate,
    e.FName + ' ' + e.LName as OffenderName,
    e.Phone,
    e.Email,
    d.DeptName,
    a.CheckinTime
from Attendance a
    join Employees e on a.EmpId = e.EmpId
    join Department d on e.DeptId = d.DeptId
where a.[Status] = 'Late'
    and MONTH(a.WorkDate) = 12
    and YEAR(a.WorkDate) = 2025
order by a.WorkDate desc

-- 9. thong ke ngay cong va luong thuc nhan cua nv
select
    e.EmpId,
    e.FName + ' ' + e.LName as FullName,
    d.DeptName,
    p.TotalWorkDays,
    p.NetSalary
from Employees e
    join Payroll p on e.EmpId = p.EmpID
    join Department d on e.DeptId = d.DeptId
where d.DeptId = 'IT'
    and p.[Month] = 2
    and p.[Year] = 2026
order by p.TotalWorkDays desc

-- 10. ho so ly lich, vv...
select
    e.EmpId,
    e.FName + ' ' + e.LName as FullName,
    i.Gender,
    i.Nationality,
    e.Position,
    d.DeptName,
    l.City as WorkCity
from Employees e
    inner join EmpInfo i on e.EmpId = i.EmpId
    inner join Department d on e.DeptId = d.DeptId
    inner join [Location] l on e.LocationId = l.LocationId
order by l.City, e.Position

go
------------------------------------------------------------------------
-- SUB-QUERY
-- 1. nhan vien co luong thuc nhan cao hon muc trung binh
select
    e.EmpId,
    CONCAT(e.FName, ' ', e.LName) as Fullname,
    CONCAT(p.NetSalary, ' $'),
    CONCAT( (select AVG(NetSalary)
    from Payroll
    where [Month] = 12 and [Year] = 2025), ' $') as AverageNetSalary
from Employees e
    join Payroll p on e.EmpId = p.EmpID
where p.[Month] = 12
    and p.[Year] = 2025
    and p.NetSalary > (
        select AVG(NetSalary)
    from Payroll
    where p.[Month] = 12
        and p.[Year] = 2025
    )
group by     e.EmpId,
    CONCAT(e.FName, ' ', e.LName),
    p.NetSalary

-- 2. nhan vien chua tung di lam muon
select
    *
from Employees e
where e.EmpId not in (
select distinct
    EmpId
from Attendance
where [Status] = 'Late'
)

-- 3. nhan vien co luong cung cao nhat nv
select
    *
from Employees
where BaseSalary = (
    select MAX(BaseSalary)
from Employees
)

-- 4. tong so gio OT cua cac phong ban
select
    d.DeptId,
    d.DeptName,
    (
    select
        ISNULL(SUM(p.TotalOTHours), 0)
    from Employees e
        join Payroll p on e.EmpId = p.EmpID
    where e.DeptId = d.DeptId
        and p.[Month] = 2
        and p.[Year] = 2026
    ) as TotalDeptOT
from Department d

-- 5. nhan vien co luong cung cao hon so voi muc trung binh trong phong ban
select
    e.EmpId,
    CONCAT(e.FName, ' ', e.LName) as Fullname,
    e.BaseSalary,
    e.DeptId,
    (select AVG(BaseSalary)
    from Employees
    where DeptId = e.DeptId) as AverageBaseSalaryOnDept
from Employees e
where e.BaseSalary > (
    select
    AVG(e1.BaseSalary)
from Employees e1
where e1.DeptId = e.DeptId
)
order by e.BaseSalary desc

-- 6. nhan vien tre nhat
select
    e.EmpId,
    e.FName + ' ' + e.LName as FullName,
    i.Birthdate
from Employees e
    join EmpInfo i on e.EmpId = i.EmpId
where i.Birthdate = (
    select MAX(Birthdate)
from EmpInfo
)

-- 7. 3 nv luong cao nhat
select
    T.EmpId,
    T.FullName,
    T.BaseSalary
from (
    select top 3
        EmpId,
        FName + ' ' + LName as FullName,
        BaseSalary
    from Employees
    order by BaseSalary desc
) as T

-- 8. phong ban co luong trung binh cao hon phong khac
select
    d.DeptName,
    AVG(e.BaseSalary) as AvgDeptSalary
from Department d
    join Employees e on d.DeptId = e.DeptId
group by d.DeptName
having AVG(e.BaseSalary) > (
    select AVG(BaseSalary)
from Employees
)

-- 9. nhan vien IT co luong > tat ca nv CS
select EmpId, FName, LName, BaseSalary
from Employees
where DeptId = 'IT'
    and BaseSalary > all (
      select BaseSalary
    from Employees
    where DeptId = 'CS'
  )

-- 10. tim nv co luong cao thu 2
select top 1 with ties
    EmpId,
    FName + ' ' + LName as FullName,
    Position,
    BaseSalary
from Employees
where BaseSalary < (
    select MAX(BaseSalary)
from Employees
)
order by BaseSalary desc

go
------------------------------------------------------------------------
-- FUNCTION
-- SCALAR RETURN FUNCTION
-- 1. tinh tham nien lam viec
create or alter function fn_GetWorkDurationMonths (@EmpId int)
RETURNS int
as
begin
    declare @Month int;
    declare @HireDate date;

    select @HireDate = HireDate
    from EmpInfo
    where EmpId = @EmpId;
    if @HireDate is null return 0;

    set @Month = DATEDIFF(MONTH, @HireDate, GETDATE());

    return @Month;
end
go

select dbo.fn_GetWorkDurationMonths(1) as WorkedMonth
go

-- 2. tinh thue
create or alter function fn_TaxCalculate (@Salary decimal(18,2))
returns decimal(18,2)
as 
begin
    declare @Tax decimal(18,2);

    if @Salary < 1750
        set @Tax = 0;
    else 
        set @Tax = (@Salary - 1750) * 0.1;

    return @Tax;
end
go

select dbo.fn_TaxCalculate (
    (select NetSalary
    from Payroll
    where EmpID = 1 and [Month] = 12 and [Year] = 2025)
    ) as Tax
go

-- 3. tinh so lan di muon trong thang
create or alter function fn_LateArrivalsCount (@EmpId int, @Month int, @Year  int)
returns int
as
begin
    declare @LateCount int;

    select @LateCount = count(*)
    from Attendance
    where EmpId = @EmpId
        and MONTH(WorkDate) = @Month
        and YEAR(WorkDate) = @Year
        and [Status] = 'Late'

    return @LateCount;
end
go

select dbo.fn_LateArrivalsCount(1, 12, 2025) as LateArrivalsCount
go

-- 4. tinh tuoi nv
create or alter function fn_CalculateAge (@EmpId int)
returns int
as
begin
    declare @Birthdate date
    declare @Age int

    select @Birthdate = Birthdate
    from EmpInfo
    where EmpId = @EmpId

    if @Birthdate is null return null

    set @Age = DATEDIFF(YEAR, @Birthdate, GETDATE()) - 
               case 
                   when DATEADD(YEAR, DATEDIFF(YEAR, @Birthdate, GETDATE()), @Birthdate) > GETDATE() 
                   then 1 
                   else 0 
               end

    return @Age
end
go

select dbo.fn_CalculateAge(1)

select EmpId, FName, dbo.fn_CalculateAge(EmpId) as Tuoi
from Employees
where dbo.fn_CalculateAge(EmpId) < 30
go

-- 5. tinh luong 1 ngay cong
create or alter function fn_GetDailyRate (@BaseSalary decimal(18, 2))
RETURNS decimal(18, 2)
as
begin
    return ISNULL(@BaseSalary, 0) / 22.0
end
go

select
    EmpId,
    FName,
    BaseSalary,
    dbo.fn_GetDailyRate(BaseSalary) as SalaryPerDay
from Employees
go

-- TABLE RETURN FUNCTION
-- 1. lay danh sach nv theo dept
create or alter function fn_GetEmployeesByDept (@DeptId varchar(5))
returns table
as 
return
(
select
    e.DeptId,
    e.EmpID,
    CONCAT(FName, ' ', LName) as Fullname,
    e.[Position],
    l.LocationName,
    e.Email,
    e.Phone,
    e.BaseSalary
from Employees e
    join [Location] l on e.LocationId = e.LocationId
where e.DeptId = @DeptId
)
go

select *
from dbo.fn_GetEmployeesByDept('IT')
go

-- 2. xem lich su luong cua nv
create or alter function fn_GetPayrollHistory (@EmpId int)
returns table
as
return
(
select
    e.EmpID,
    CONCAT(FName, ' ', LName) as Fullname,
    e.DeptId,
    e.[Position],
    p.[Month],
    p.[Year],
    e.BaseSalary,
    p.NetSalary
from Employees e
    join Payroll p on e.EmpId = p.EmpID
where e.EmpId = @EmpId
)
go

select *
from dbo.fn_GetPayrollHistory(1) as Payroll
go

-- 3. tim nhan vien theo khoang luong
create or alter function fn_FindEmpBySalaryRange (@Min decimal(18,2), @Max decimal(18,2))
returns table
as
return
(
select
    e.EmpID,
    CONCAT(FName, ' ', LName) as Fullname,
    e.[Position],
    e.DeptId,
    e.BaseSalary
from Employees e
where e.BaseSalary between @Min and @Max
)
go

select *
from dbo.fn_FindEmpBySalaryRange(2000, 3000) 
go

-- 4. lich su cham cong
create or alter function fn_GetAttendanceHistory 
(
    @EmpId int, 
    @FromDate date, 
    @ToDate date
)
returns table
as
return 
(
    select
    a.WorkDate,
    a.CheckinTime,
    a.CheckoutTime,
    a.[Status],
    DATEDIFF(MINUTE, a.CheckinTime, a.CheckoutTime) / 60.0 as HoursWorked
from Attendance a
where a.EmpId = @EmpId
    and a.WorkDate between @FromDate and @ToDate
)
go

select *
from dbo.fn_GetAttendanceHistory(1, '2025-12-01', '2025-12-31')
order by WorkDate desc
go

-- 5. ham tinh luong thang cua tat ca nv
create or alter function fn_GetPayrollReport 
(
    @Month int, 
    @Year int
)
returns table
as
return 
(
    select
    e.EmpId,
    e.FName + ' ' + e.LName as FullName,
    d.DeptName,
    e.BaseSalary,
    p.TotalOTHours,
    p.TotalWorkDays,
    p.NetSalary
from Payroll p
    join Employees e on p.EmpID = e.EmpId
    join Department d on e.DeptId = d.DeptId
where p.[Month] = @Month
    and p.[Year] = @Year
)
go

select *
from dbo.fn_GetPayrollReport(12, 2025)
order by NetSalary desc

go

------------------------------------------------------------------------
-- PROCEDURE
-- Input Parameter Proc
-- 1. update luong 
create or alter proc p_UpdateSalary
    @EmpId int,
    @NewSalary decimal(18,2)
as
begin
    if not exists(select 1
    from Employees
    where EmpId = @EmpId)
    begin
        print 'Employee not found!'
    end
    
    else
    begin
        update Employees
    set BaseSalary = @NewSalary
    where EmpId = @EmpId
        print 'Update employee with Id ' + CAST(@EmpId as NVARCHAR(10)) + ' successfully !'
    end
end
go

exec p_UpdateSalary 1, 2800
go

exec p_UpdateSalary 21, 2800
go

select *
from Employees
where EmpId = 1
go

-- 2. add Location
create or alter proc p_AddLocation
    @LocationId varchar(5),
    @LocationName nvarchar(50),
    @StreetAddress nvarchar(100),
    @City nvarchar(20),
    @Country nvarchar(20),
    @PostalCode nvarchar(20),
    @LocPhone varchar(20),
    @LocEmail varchar(50)
as
begin
    if exists (select 1
    from [Location]
    where LocationName = @LocationName)
    begin
        print 'Location already existed !'
    end

    else
    begin
        insert into [Location]
            (LocationId, LocationName, StreetAddress, City, Country, PostalCode, LocPhone, LocEmail)
        values
            (@LocationId, @LocationName, @StreetAddress, @City, @Country, @PostalCode, @LocPhone, @LocEmail)

        print 'Location added successfully : ' + @LocationName
    end
end
go

-- insert new location
exec p_AddLocation 
'JP2', 'FPT Japan Training Center', 'Shibadaimon Building No. 2 7F, Shibadaimon 1-12-16, Minato-ku',
 'Tokyo', 'Japan', '123123', '+81 3-6634-6868', ''
go

-- insert existed location
exec p_AddLocation 
'JP2', 'FPT Japan Training Center', 'Shibadaimon Building No. 2 7F, Shibadaimon 1-12-16, Minato-ku',
 'Tokyo', 'Japan', '123123', '+81 3-6634-6868', ''
go


-- 3. chuyen phong ban
create or alter proc p_TransferDepartment
    @EmpId int,
    @NewDeptId varchar(5)
as
begin
    if not exists (select 1
    from Department
    where DeptId = @NewDeptId)
    begin
        print 'Department not existed !'
        return
    end

    else
    begin
        update Employees
    set DeptId = @NewDeptId
    where EmpId = @EmpId
    end

    print 'Moved employee ' + CAST(@EmpId as NVARCHAR(10)) + ' to ' + @NewDeptId + ' successfully !'
end
go

select
    e.EmpId,
    e.DeptId
from Employees e

exec p_TransferDepartment 1, 'MKT'

exec p_TransferDepartment 2, 'IT'
go

-- 4. xoa 1 nhan vien va tat ca thong tin lien quan
create or alter procedure p_DeleteEmployee
    @EmpId int
as
begin
    begin transaction
    begin try
        delete from EmpInfo where EmpId = @EmpId
        delete from Attendance where EmpId = @EmpId
        delete from Payroll where EmpID = @EmpId
        delete from Employees where EmpId = @EmpId
        commit transaction
        print 'Employee deleted completely !'
    end try
    begin catch
        rollback transaction
        print 'Error ! Can not delete this employee'
    end CATCH
end
go

exec p_DeleteEmployee 1003
go

-- 5. chuyen dia diem lam viec cho nv
create or alter procedure p_TransferWorkLocation
    @EmpId int,
    @NewLocationId varchar(10)
as
begin
    declare @OldLocationId varchar(10)
    declare @LocationName nvarchar(100)

    select @OldLocationId = LocationId
    from Employees
    where EmpId = @EmpId

    if @OldLocationId is null
    begin
        print 'Employee with Id ' + CAST(@EmpId as VARCHAR) + ' not found !'
        return
    end

    select @LocationName = LocationName
    from [Location]
    where LocationId = @NewLocationId

    if @LocationName is null
    begin
        print 'LocationId not valid !'
        return
    end

    if @OldLocationId = @NewLocationId
    begin
        print 'Employee already worked at ' + @LocationName + ' !'
        return
    end

    begin try
        update Employees
        set LocationId = @NewLocationId
        where EmpId = @EmpId

        print 'Employee moved to ' + @LocationName + ' successfully !'
    end TRY
    begin catch
        print 'Error !'
        print ERROR_MESSAGE()
    end catch
end
go

select *
from Employees

exec p_TransferWorkLocation 1, 'VN1'
exec p_TransferWorkLocation 1, 'JP1'

go

-- Output Parameter Proc
-- 1. lay ho va ten day du cua nv
create or alter proc p_GetFullNameById
    @EmpId int,
    @FullName nvarchar(50) OUTPUT
as
begin
    select @FullName = LName + ' ' + FName
    from Employees
    where EmpId = @EmpId

    if @FullName is null
        set @FullName = 'Not found !'
end
go

declare @Fullname nvarchar(50)
exec p_GetFullNameById 1, @Fullname output
-- cach 1
select @Fullname as Fullname
-- cach 2
print @FullName
go

-- 2. dem nv theo postion
create or alter proc p_CountStaffsByPosition
    @Pos nvarchar(20),
    @Count int output
as
begin
    select @Count = COUNT(EmpId)
    from Employees
    where [Position] = @Pos
end
go

declare @Count int
exec p_CountStaffsByPosition BrSE, @Count output
-- cach 1
select @Count as NoOfStaffs
-- cach 2
print @Count
go

-- 3. lay luong cao nhat va thap nhat cua phong ban
create or alter proc p_GetDeptSalaryRange
    @DeptId varchar(5),
    @MinSalary decimal(18,2) output,
    @MaxSalary decimal(18,2) output
as
begin
    select
        @MinSalary = MIN(BaseSalary),
        @MaxSalary = MAX(BaseSalary)
    from Employees
    where DeptId = @DeptId

    set @MinSalary = ISNULL(@MinSalary, 0)
    set @MaxSalary = ISNULL(@MaxSalary, 0)
end
go

declare @Min decimal(18,2)
declare @Max decimal(18,2)
exec p_GetDeptSalaryRange 'IT', @Min output, @Max output
-- cach 1 
select
    @Min as [Min],
    @Max as [Max]
-- cach 2 
print 'Min Salary ' + CAST(@Min as nvarchar(10))
print 'Max Salary ' + CAST(@Max as nvarchar(10))
go

-- 4. tong so nhan vien va tong ngan sach luong
create or alter procedure p_GetDeptStats
    @DeptId varchar(10),
    @EmployeeCount int OUTPUT,
    @TotalBudget decimal(18, 2) OUTPUT
as
begin
    select
        @EmployeeCount = COUNT(EmpId),
        @TotalBudget = ISNULL(SUM(BaseSalary), 0)
    from Employees
    where DeptId = @DeptId
end

declare @NoOfEmp int
declare @TotalSalaryBudget decimal(18, 2)

exec p_GetDeptStats 
    'IT', 
    @NoOfEmp output, 
    @TotalBudget output
select @NoOfEmp as NumberOfEmployees, @TotalSalaryBudget as TotalBaseSalaryBudget
go

-- 5. nv va tham nien lam viec
create or alter procedure p_GetEmpLatestInfo
    @EmpId int,
    @FullName nvarchar(100) OUTPUT,
    @YearsOfService int OUTPUT
as
begin
    declare @HireDate date

    select
        @FullName = e.FName + ' ' + e.LName,
        @HireDate = i.HireDate
    from Employees e
        join EmpInfo i on e.EmpId = i.EmpId
    where e.EmpId = @EmpId

    if @FullName is null
    begin
        set @YearsOfService = 0
        return
    end

    set @YearsOfService = DATEDIFF(YEAR, @HireDate, GETDATE())
end
go

declare @FullName nvarchar(100)
declare @YearsOfService int

exec p_GetEmpLatestInfo 
    1, 
    @FullName output, 
    @YearsOfService output

select
    @FullName as [Employee],
    @YearsOfService as YearsOfService


print 'Employee: ' + @FullName
print 'Worked ' + CAST(@YearsOfService as VARCHAR) + ' year'

go

------------------------------------------------------------------------
-- TRIGGER
-- 1. trigger ngan chan khi insert Attendance k hop le
create or alter trigger tg_CheckTimeValid
on Attendance
AFTER insert, update
as
begin
    if exists (
    select 1
    from inserted
    where CheckoutTime is not null
        and CheckoutTime <= CheckinTime
    )
    begin
        print 'Error ! Check out time must bigger than check in time !'
        rollback transaction
    end
end
go

-- test
insert into Attendance
    (EmpId, WorkDate, CheckinTime, CheckoutTime, [Status], OvertimeHours)
values
    (1, '2025-12-10', '07:55:00', '07:00:00', 'Present', 0)
go

enable trigger tg_CheckTimeValid on Attendance
go
disable trigger tg_CheckTimeValid on Attendance
go

-- 2. trigger khong cho phep giam luong
create or alter trigger tg_PreventSalaryDecrease
on Employees
AFTER update
as
begin
    if exists (
        select 1
    from inserted i
        join deleted d on i.EmpId = d.EmpId
    where i.BaseSalary < d.BaseSalary
    )
    begin
        print 'Can not decrease employee Salary !'
        rollback transaction
    end
end
go

-- test 
update Employees 
set BaseSalary = 1 
where EmpId = 1
go

-- 3. trigger khi them nhan vien. nv phai > 18 tuoi moi du tuoi lao dong
create or alter trigger tg_CheckWorkingAge
on EmpInfo
AFTER insert, update
as
begin
    if exists (
        select 1
    from inserted
    where DATEDIFF(YEAR, Birthdate, GETDATE()) < 18
    )
    begin
        print 'Employee is not 18 years old yet !'
        rollback transaction
    end
end
go

-- test 
set
identity_insert "EmpInfo" on

insert into EmpInfo
    (EmpId, Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    (1002, 'M', '2010-01-01', 'Shinjuku', N'Thái Bình', 'Vietnamese', '2026-01-01')

insert into EmpInfo
    (EmpId, Gender, Birthdate, HomeAddress, Hometown, Nationality, HireDate)
values
    (1003, 'M', '2005-01-01', 'Shinjuku', N'Thái Bình', 'Vietnamese', '2026-01-01')

select *
from Employees e
    full join EmpInfo ei on e.EmpId = ei.EmpId

insert into Employees
    (FName, LName, Position, Email, Phone, BaseSalary, DeptId, LocationId)
values
    (N'Đỗ Thị', N'Trang', N'Tester', 'trangdt@fpt.com', '0944555666', 1100, 'IT', 'VN1')
go

------------------------------------------------------------------------
-- VIEW
-- 1. view tong hop thong tin nv, phong ban, dia diem
create or alter view v_EmployeeData
as
    select
        e.EmpId,
        e.FName + ' ' + e.LName as FullName,
        e.Position,
        e.Email,
        d.DeptName,
        l.LocationName,
        l.City
    from Employees e
        join Department d on e.DeptId = d.DeptId
        join [Location] l on e.LocationId = l.LocationId
go

select *
from v_EmployeeData
go

-- xoa tu view

delete v_EmployeeData
where EmpId = 1002

go
create trigger tg_DeleteEmployeeViaView
on v_EmployeeData
INSTEAD of delete 
as
begin

    declare @EmpIdToDelete int
    select @EmpIdToDelete = EmpId
    from deleted
    delete from Employees where EmpId = @EmpIdToDelete

    print 'Deleted Employee successfully !'
end
go

-- 2. bao cao luong
create or alter view v_PayrollConfidential
as
    select
        p.[Month],
        p.[Year],
        e.EmpId,
        e.FName + ' ' + e.LName as FullName,
        d.DeptName,
        p.TotalWorkDays,
        p.TotalOTHours,
        p.NetSalary
    from Payroll p
        join Employees e on p.EmpID = e.EmpId
        join Department d on e.DeptId = d.DeptId
go

select *
from v_PayrollConfidential
where [Month] = 12
go

-- 3. xem danh ba cong ty, de nv tra cuu sdt, email de lien he 
create or alter view v_CompanyDirectory
as
    select
        EmpId,
        FName,
        LName,
        Position,
        DeptId,
        Email,
        Phone
    from Employees
go

select *
from v_CompanyDirectory
order by FName
go

-- 4. thong ke di lam muon
create or alter view v_LateHistory
as
    select
        a.WorkDate,
        e.FName + ' ' + e.LName as EmployeeName,
        d.DeptName,
        a.CheckinTime,
        a.[Status]
    from Attendance a
        join Employees e on a.EmpId = e.EmpId
        join Department d on e.DeptId = d.DeptId
    where a.[Status] = 'Late'
go

select *
from v_LateHistory
where WorkDate > '2025-12-01'
go

-- 5. thong ke nhan su, luong theo phong ban
create or alter view v_DeptStats
as
    select
        d.DeptId,
        d.DeptName,
        COUNT(e.EmpId) as TotalEmployees,
        ISNULL(SUM(e.BaseSalary), 0) as TotalBaseSalaryBudget,
        ISNULL(AVG(e.BaseSalary), 0) as AvgBaseSalary
    from Department d
        left join Employees e on d.DeptId = e.DeptId
    group by d.DeptId, d.DeptName
go

select *
from v_DeptStats
order by TotalEmployees desc
go

------------------------------------------------------------------------
-- INDEX
create nonclustered index index_Employees_SearchName 
on Employees(FName, LName)

create nonclustered index index_Employees_Position 
on Employees(Position)

create nonclustered index index_Location_LocationName 
on [Location](LocationName)

create nonclustered index index_Department_DeptName 
on Department(DeptName)

create nonclustered index index_Attendance_WorkDate 
on Attendance(WorkDate)