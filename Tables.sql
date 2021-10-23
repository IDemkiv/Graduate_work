/*Database objects creation*/

drop table  if exists [Demkiv].[PERSONS]

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
  [NumberId] [bigint] IDENTITY(1,1) primary key NOT NULL,
  [PhoneNumber] [nchar](30) NOT NULL,
  [NumberType] [nchar](30) NOT NULL,
  [PersonId] [bigint] NOT NULL
 )
 
drop table  if exists [Demkiv].[EMAILS]

create table [Demkiv].[EMAILS] (
  [EmailId] [bigint] IDENTITY(1,1) primary key NOT NULL,
  [Email] [nchar](30) NOT NULL,
  [EmailType] [nchar](30) NOT NULL,
  [PersonId] [bigint] NOT NULL
 )

drop table  if exists [Demkiv].[EMPLOYEES]

create table [Demkiv].[EMPLOYEES] (
  [EmployeeId] [bigint] IDENTITY(1,1) primary key NOT NULL,
  [JobTitle] [nchar](30) NOT NULL,
  [HireDate] [date] NOT NULL,
  [StationId] [int] NOT NULL,
  [LeadId] [bigint] NULL,
  [SaleTarget] [money] NOT NULL,
  [Status] [tinyint] NOT NULL,
  [StatusChangeDate] [datetime] NOT NULL,
  [TaxNumber] [nchar] (50) NULL,
  [PersonId] [bigint] NOT NULL
 )


drop table  if exists [Demkiv].[CUSTOMERS]

create table [Demkiv].[CUSTOMERS] (
  [CustomerId] [bigint] IDENTITY(1,1) primary key  NOT NULL,
  [ServiceType] [nchar](30) NOT NULL,
  [ServiceStartDate] [date] NOT NULL,
  [EmployeeId] [bigint] NOT NULL,
  [Status] [tinyint] NOT NULL,
  [StatusChangeDate] [date] NOT NULL,
  [PersonId] [bigint] NOT NULL
 )

drop table  if exists [Demkiv].[CARDS]

create table [Demkiv].[CARDS] (
  [CardNumber] [bigint] primary key NOT NULL, 
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
  [ProductName] [nchar] (50) NOT NULL,
  [ProductPrice] [money] NOT NULL,
  [ProductAmount] [bigint] NULL,
 )

 alter table [Demkiv].[PRODUCTS] 
 add constraint pk_products primary key ([VendorID],[ProductId])


drop table  if exists [Demkiv].[ORDERS]

create table [Demkiv].[ORDERS] (
  [OrderID] [bigint] primary key NOT NULL, 
  [CardId] [bigint]  NOT NULL,
  [StationId] [int]  NOT NULL,
  [PersonId] [bigint]  NOT NULL,
  [OrderDate] [date] NOT NULL
 )

drop table  if exists [Demkiv].[ORDERDETAILS]

create table [Demkiv].[ORDERDETAILS] (
  [OrderID] [bigint]  NOT NULL, 
  [OrderDetailId] [bigint] primary key NOT NULL,
  [VendorId] [bigint]  NOT NULL,
  [ProductId] [bigint]  NOT NULL,
  [OrderAmount] [int] NOT NULL,
  [TotalSum] [int] NOT NULL
 )

drop table  if exists [Demkiv].[STATIONS]

create table [Demkiv].[STATIONS] (
  [StationId] [int] IDENTITY(1,1) primary key NOT NULL,
  [District] [nchar](30) NOT NULL,
  [Address] [nchar](50) NOT NULL,
  [LeadId] [bigint] NOT NULL
 )

 --Creation all the foreign keys
 GO

alter table [Demkiv].[PHONES]
add constraint  fk_PHONES_PERSONS foreign key (PersonId) references [Demkiv].[PERSONS] (PersonId)

alter table [Demkiv].[EMAILS]
add constraint  fk_EMAILS_PERSONS foreign key (PersonId) references [Demkiv].[PERSONS] (PersonId)

alter table [Demkiv].[EMPLOYEES]
add constraint  fk_EMPLOYEES_PERSONS foreign key (PersonId) references [Demkiv].[PERSONS] (PersonId)
alter table [Demkiv].[EMPLOYEES]
add constraint  fk_EMPLOYEES_STATIONS foreign key (StationId) references [Demkiv].[STATIONS] (StationId)

alter table [Demkiv].[CUSTOMERS]
add constraint  fk_CUSTOMERS_PERSONS foreign key (PersonId) references [Demkiv].[PERSONS] (PersonId)
alter table [Demkiv].[CUSTOMERS]
add constraint  fk_CUSTOMERS_EMPLOYEES foreign key (EmployeeId) references [Demkiv].[EMPLOYEES] ([EmployeeId])

alter table [Demkiv].[CARDS]
add constraint  fk_CARDS_CUSTOMERS foreign key (CustomerId) references [Demkiv].[CUSTOMERS] (CustomerId)


alter table [Demkiv].[ORDERS]
add constraint  fk_ORDERS_CARDS foreign key (CardId) references [Demkiv].[CARDS] (CardNumber)
alter table [Demkiv].[ORDERS]
add constraint  fk_ORDERS_STATIONS foreign key (StationId) references [Demkiv].[STATIONS] (StationId)
alter table [Demkiv].[ORDERS]
add constraint  fk_ORDERS_PERSONS foreign key (PersonId) references [Demkiv].[PERSONS] (PersonId)

alter table [Demkiv].[ORDERDETAILS]
add constraint  fk_ORDERSDETAILS_ORDERS foreign key (OrderID) references [Demkiv].[ORDERS] (OrderID)
alter table [Demkiv].[ORDERDETAILS]
add constraint  fk_ORDERSDETAILS_PRODUCTS foreign key ([VendorID],[ProductId]) references [Demkiv].[PRODUCTS] ([VendorID],[ProductId])


alter table [Demkiv].[STATIONS]
add constraint  fk_STATIONS_EMPLOYEES foreign key (LeadId) references [Demkiv].[EMPLOYEES] ([EmployeeId]) 

--Drop all the forign keys

 ALTER TABLE [Demkiv].[PHONES] DROP CONSTRAINT [fk_PHONES_PERSONS]
 ALTER TABLE [demkiv].[ORDERS] DROP CONSTRAINT [fk_ORDERS_CARDS]
 ALTER TABLE [demkiv].[ORDERS] DROP CONSTRAINT [fk_ORDERS_PERSONS]
 ALTER TABLE [demkiv].[ORDERS] DROP CONSTRAINT [fk_ORDERS_STATIONS]
 ALTER TABLE [demkiv].[ORDERDETAILS] DROP CONSTRAINT [fk_ORDERSDETAILS_ORDERS]
 ALTER TABLE [demkiv].[ORDERDETAILS] DROP CONSTRAINT [fk_ORDERSDETAILS_PRODUCTS]
 ALTER TABLE [demkiv].[EMPLOYEES] DROP CONSTRAINT [fk_EMPLOYEES_PERSONS]
 ALTER TABLE [demkiv].[EMPLOYEES] DROP CONSTRAINT [fk_EMPLOYEES_STATIONS]
 ALTER TABLE [demkiv].[EMAILS] DROP CONSTRAINT [fk_EMAILS_PERSONS]
 ALTER TABLE [demkiv].[CUSTOMERS] DROP CONSTRAINT [fk_CUSTOMERS_EMPLOYEES]
 ALTER TABLE [demkiv].[CUSTOMERS] DROP CONSTRAINT [fk_CUSTOMERS_PERSONS]
 ALTER TABLE [demkiv].[CARDS] DROP CONSTRAINT [fk_CARDS_CUSTOMERS]

 --create non-clustered indexes 
 CREATE NONCLUSTERED INDEX IX_PHONES 
    ON [Demkiv].[PHONES] (PersonId)

CREATE NONCLUSTERED INDEX IX_EMAILS 
    ON [Demkiv].[EMAILS] (PersonId)

CREATE NONCLUSTERED INDEX IX_EMPLOYEES_PERSONID
    ON [Demkiv].[EMPLOYEES] (PersonId)
CREATE NONCLUSTERED INDEX IX_EMPLOYEES_STATIONID
    ON [Demkiv].[EMPLOYEES] (StationId)

CREATE NONCLUSTERED INDEX IX_CUSTOMERS_PERSONID
    ON [Demkiv].[CUSTOMERS] (PersonId)
CREATE NONCLUSTERED INDEX IX_CUSTOMERS_EMPLOYEESID
    ON [Demkiv].[CUSTOMERS] (EmployeeId)

CREATE NONCLUSTERED INDEX IX_CARDS
    ON [Demkiv].[CARDS] (CustomerId)

CREATE NONCLUSTERED INDEX IX_ORDERS_CARDS
    ON [Demkiv].[ORDERS] (CardId)
CREATE NONCLUSTERED INDEX IX_ORDERS_STATIONS
    ON [Demkiv].[ORDERS] (StationId)
CREATE NONCLUSTERED INDEX IX_ORDERS_PERSONS
    ON [Demkiv].[ORDERS] (PersonId)

CREATE NONCLUSTERED INDEX IX_ORDERSDETAILS_ORDERS
    ON [Demkiv].[ORDERDETAILS] (OrderID)
CREATE NONCLUSTERED INDEX IX_ORDERSDETAILS_PRODUCTS
    ON [Demkiv].[ORDERDETAILS] ([VendorID],[ProductId])

CREATE NONCLUSTERED INDEX IX_STATIONS
    ON [Demkiv].[STATIONS] (LeadId)
