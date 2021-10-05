/*Database objects creation*/

drop table  if exists [Demkiv].[EMPLOYEES]

create table [Demkiv].[PERSONS] (
  [PersonId] [bigint] IDENTITY(1,1) primary key NOT NULL,
  [Name] [nchar](30) NOT NULL,
  [Surname] [nchar](30) NOT NULL,
  [Patronymic] [nchar](30) NOT NULL,
  [Birthday] [Date] NOT NULL,
  [Gender] [nchar](1) NOT NULL,
  [MaritalStatus] [nchar](1) NOT NULL
  )

drop table  if exists [Demkiv].[PHONES]

create table [Demkiv].[PHONES] (
  [NumberId] [bigint] IDENTITY(1,1) NOT NULL,
  [PhoneNumber] [nchar](30) NOT NULL,
  [NumberType] [nchar](30) NOT NULL,
  [PersonId] [bigint] NOT NULL
 )
 
drop table  if exists [Demkiv].[EMAILS]

create table [Demkiv].[EMAILS] (
  [NumberId] [bigint] IDENTITY(1,1) NOT NULL,
  [Email] [nchar](30) NOT NULL,
  [EmailType] [nchar](30) NOT NULL,
  [PersonId] [bigint] NOT NULL
 )

drop table  if exists [Demkiv].[EMPLOYEES]

create table [Demkiv].[EMPLOYEES] (
  [EmployeeId] [bigint] IDENTITY(1,1) NOT NULL,
  [JobTitle] [nchar](30) NOT NULL,
  [HireDate] [date] NOT NULL,
  [StationId] [int] NOT NULL,
  [LeadId] [bigint] NOT NULL,
  [SaleTarget] [money] NOT NULL,
  [Status] [tinyint] NOT NULL,
  [StatusChangeDate] [date] NOT NULL,
  [TaxNumber] [nchar] (50) NULL,
  [PersonId] [bigint] NOT NULL
 )

drop table  if exists [Demkiv].[CUSTOMERS]

create table [Demkiv].[CUSTOMERS] (
  [CustomerId] [bigint] IDENTITY(1,1) NOT NULL,
  [ServiceType] [nchar](30) NOT NULL,
  [ServiceStartDate] [date] NOT NULL,
  [EmployeeId] [bigint] NOT NULL,
  [Status] [tinyint] NOT NULL,
  [StatusChangeDate] [date] NOT NULL,
  [PersonId] [bigint] NOT NULL
 )

drop table  if exists [Demkiv].[CARDS]

create table [Demkiv].[CARDS] (
  [CardNumber] [bigint]  NOT NULL, 
  [CustomerId] [bigint]  NOT NULL,
  [Status] [tinyint] NOT NULL,
  [StatusChangeDate] [date] NOT NULL,
  [Balance] [money] NOT NULL,
  [Discount] [numeric] (3,2) NOT NULL
 )

drop table  if exists [Demkiv].[PRODUCTS]

create table [Demkiv].[PRODUCTS] (
  [VendorID] [bigint]  NOT NULL, 
  [ProductId] [bigint]  NOT NULL,
  [ProductName] [nchar](50) NOT NULL,
  [ProductPrice] [money] NOT NULL,
  [ProductAmount] [bigint] NULL,
 )

drop table  if exists [Demkiv].[Orders]

create table [Demkiv].[ORDERS] (
  [OrderID] [bigint]  NOT NULL, 
  [CardId] [bigint]  NOT NULL,
  [StationId] [bigint]  NOT NULL,
  [PersonId] [bigint]  NOT NULL,
  [OrderDate] [date] NOT NULL
 )

drop table  if exists [Demkiv].[OrderDetails]

create table [Demkiv].[ORDERDETAILS] (
  [OrderID] [bigint]  NOT NULL, 
  [OrderDetailId] [bigint]  NOT NULL,
  [VendorId] [bigint]  NOT NULL,
  [ProductId] [bigint]  NOT NULL,
  [OrderAmount] [int] NOT NULL,
  [TotalSum] [int] NOT NULL
 )

drop table  if exists [Demkiv].[Stations]

create table [Demkiv].[STATIONS] (
  [StationId] [bigint] IDENTITY(1,1) NOT NULL,
  [District] [nchar](30) NOT NULL,
  [Address] [nchar](50) NOT NULL,
  [LeadId] [bigint] NOT NULL
 )

/*alter table [EMPLOYEES]
add constraint  pk_id primary key (PersonId)









*/