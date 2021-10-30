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

/**Updated script for database**/


USE [SQL21_1_Demkiv]
GO

CREATE TABLE [Demkiv].[PERSONS](
	[PersonId] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nchar](30) NOT NULL,
	[Surname] [nchar](30) NOT NULL,
	[Patronymic] [nchar](30) NOT NULL,
	[Birthday] [date] NOT NULL,
	[Gender] [nchar](1) NOT NULL,
	[MaritalStatus] [nchar](1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [demkiv].[PHONES](
	[NumberId] [bigint] IDENTITY(1,1) NOT NULL,
	[PhoneNumber] [nchar](30) NOT NULL,
	[NumberType] [nchar](30) NOT NULL,
	[PersonId] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[NumberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [demkiv].[PHONES]  WITH CHECK ADD  CONSTRAINT [fk_PHONES_PERSONS] FOREIGN KEY([PersonId])
REFERENCES [demkiv].[PERSONS] ([PersonId])
GO

ALTER TABLE [demkiv].[PHONES] CHECK CONSTRAINT [fk_PHONES_PERSONS]
GO


CREATE TABLE [demkiv].[EMAILS](
	[EmailId] [bigint] IDENTITY(1,1) NOT NULL,
	[Email] [nchar](30) NOT NULL,
	[EmailType] [nchar](30) NOT NULL,
	[PersonId] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [demkiv].[EMAILS]  WITH CHECK ADD  CONSTRAINT [fk_EMAILS_PERSONS] FOREIGN KEY([PersonId])
REFERENCES [demkiv].[PERSONS] ([PersonId])
GO

ALTER TABLE [demkiv].[EMAILS] CHECK CONSTRAINT [fk_EMAILS_PERSONS]
GO

CREATE TABLE [demkiv].[EMPLOYEES](
	[EmployeeId] [bigint] IDENTITY(1,1) NOT NULL,
	[JobTitle] [nchar](30) NOT NULL,
	[HireDate] [date] NOT NULL,
	[StationId] [int] NOT NULL,
	[LeadId] [bigint] NULL,
	[SaleTarget] [money] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[StatusChangeDate] [datetime] NOT NULL,
	[TaxNumber] [nchar](50) NULL,
	[PersonId] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [demkiv].[EMPLOYEES]  WITH CHECK ADD  CONSTRAINT [fk_EMPLOYEES_PERSONS] FOREIGN KEY([PersonId])
REFERENCES [demkiv].[PERSONS] ([PersonId])
GO

ALTER TABLE [demkiv].[EMPLOYEES] CHECK CONSTRAINT [fk_EMPLOYEES_PERSONS]
GO


CREATE TABLE [demkiv].[CUSTOMERS](
	[CustomerId] [bigint] IDENTITY(1,1) NOT NULL,
	[ServiceType] [nchar](30) NOT NULL,
	[ServiceStartDate] [date] NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[StatusChangeDate] [date] NOT NULL,
	[PersonId] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [demkiv].[CUSTOMERS]  WITH CHECK ADD  CONSTRAINT [fk_CUSTOMERS_EMPLOYEES] FOREIGN KEY([EmployeeId])
REFERENCES [demkiv].[EMPLOYEES] ([EmployeeId])
GO

ALTER TABLE [demkiv].[CUSTOMERS] CHECK CONSTRAINT [fk_CUSTOMERS_EMPLOYEES]
GO

ALTER TABLE [demkiv].[CUSTOMERS]  WITH CHECK ADD  CONSTRAINT [fk_CUSTOMERS_PERSONS] FOREIGN KEY([PersonId])
REFERENCES [demkiv].[PERSONS] ([PersonId])
GO

ALTER TABLE [demkiv].[CUSTOMERS] CHECK CONSTRAINT [fk_CUSTOMERS_PERSONS]
GO


CREATE TABLE [demkiv].[CARDS](
	[CardNumber] [bigint] NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[Status] [tinyint] NOT NULL,
	[StatusChangeDate] [date] NOT NULL,
	[Balance] [money] NOT NULL,
	[Discount] [numeric](5, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[CardNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [demkiv].[CARDS]  WITH CHECK ADD  CONSTRAINT [fk_CARDS_CUSTOMERS] FOREIGN KEY([CustomerId])
REFERENCES [demkiv].[CUSTOMERS] ([CustomerId])
GO

ALTER TABLE [demkiv].[CARDS] CHECK CONSTRAINT [fk_CARDS_CUSTOMERS]
GO



CREATE TABLE [demkiv].[PRODUCTS](
	[VendorID] [bigint] NOT NULL,
	[ProductId] [bigint] NOT NULL,
	[ProductName] [nchar](50) NOT NULL,
	[ProductPrice] [money] NOT NULL,
	[ProductAmount] [bigint] NULL,
 CONSTRAINT [pk_products] PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC,
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



CREATE TABLE [demkiv].[ORDERS](
	[OrderID] [bigint] IDENTITY(1,1) NOT NULL,
	[CardId] [bigint] NULL,
	[StationId] [int] NOT NULL,
	[PersonId] [bigint] NOT NULL,
	[OrderDate] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [demkiv].[ORDERS]  WITH CHECK ADD  CONSTRAINT [fk_ORDERS_PERSONS] FOREIGN KEY([PersonId])
REFERENCES [demkiv].[PERSONS] ([PersonId])
GO

ALTER TABLE [demkiv].[ORDERS] CHECK CONSTRAINT [fk_ORDERS_PERSONS]
GO

ALTER TABLE [demkiv].[ORDERS]  WITH CHECK ADD  CONSTRAINT [fk_ORDERS_STATIONS] FOREIGN KEY([StationId])
REFERENCES [demkiv].[STATIONS] ([StationId])
GO

ALTER TABLE [demkiv].[ORDERS] CHECK CONSTRAINT [fk_ORDERS_STATIONS]
GO



CREATE TABLE [demkiv].[ORDERDETAILS](
	[OrderID] [bigint] NOT NULL,
	[OrderDetailId] [bigint] NOT NULL,
	[VendorId] [bigint] NOT NULL,
	[ProductId] [bigint] NOT NULL,
	[OrderAmount] [int] NOT NULL,
	[TotalSum] [money] NOT NULL,
 CONSTRAINT [PK_Order_OrderDetail_ID] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[OrderDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [demkiv].[ORDERDETAILS]  WITH CHECK ADD  CONSTRAINT [fk_ORDERSDETAILS_ORDERS] FOREIGN KEY([OrderID])
REFERENCES [demkiv].[ORDERS] ([OrderID])
GO

ALTER TABLE [demkiv].[ORDERDETAILS] CHECK CONSTRAINT [fk_ORDERSDETAILS_ORDERS]
GO

ALTER TABLE [demkiv].[ORDERDETAILS]  WITH CHECK ADD  CONSTRAINT [fk_ORDERSDETAILS_PRODUCTS] FOREIGN KEY([VendorId], [ProductId])
REFERENCES [demkiv].[PRODUCTS] ([VendorID], [ProductId])
GO

ALTER TABLE [demkiv].[ORDERDETAILS] CHECK CONSTRAINT [fk_ORDERSDETAILS_PRODUCTS]
GO


CREATE TABLE [demkiv].[STATIONS](
	[StationId] [int] IDENTITY(1,1) NOT NULL,
	[District] [nchar](30) NOT NULL,
	[Address] [nchar](50) NOT NULL,
	[LeadId] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[StationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [demkiv].[STATIONS]  WITH CHECK ADD  CONSTRAINT [fk_STATIONS_EMPLOYEES] FOREIGN KEY([LeadId])
REFERENCES [demkiv].[EMPLOYEES] ([EmployeeId])
GO

ALTER TABLE [demkiv].[STATIONS] CHECK CONSTRAINT [fk_STATIONS_EMPLOYEES]
GO


/**Inserting the data for the following tables **/


insert into [demkiv].[PERSONS] ([Name], [Surname], [Patronymic],[Birthday],[Gender],[MaritalStatus]) values
('Blinnie','Izkovicz','Rennick','1966-01-30','F','M'),
('Krystalle','Carwardine','Bonwick','1956-12-10','F','S'),
('Isis','Espadate','Quirk','1971-12-29','F','M'),
('Cosette','Minigo','Trendle','1988-11-20','F','S'),
('Juliette','Queen','Hair','1978-12-04','F','M'),
('Lauryn','Rapp','Farrance','1975-07-22','F','S'),
('Anica','Clemson','Paszek','1975-12-15','F','S'),
('Lothaire','Burrows','Warstall','1989-04-27','M','M'),
('Ody','Firks','Grim','1956-01-28','M','M'),
('Clyde','Tofful','Hanhart','1992-05-04','M','S'),
('Florette','Roze','Heindle','1992-05-23','F','S'),
('Seth','Prendeville','Booley','1977-08-19','M','S'),
('Bell','Darrach','Patience','1995-11-23','F','S'),
('Deck','Lye','Loutheane','1952-05-12','M','S'),
('Georgi','Hodinton','Becke','1970-10-30','M','M'),
('Brittani','Le Friec','Hammerson','1951-05-14','F','M'),
('Brock','Oxton','Forryan','1972-06-27','M','M'),
('Norbie','Crofts','Sichardt','1978-04-26','M','M'),
('Clarice','Alcido','Skipworth','1981-08-31','F','S'),
('Binky','Heatly','Sennett','1990-10-18','M','M') ;


insert into [demkiv].[PHONES] ([PhoneNumber], [NumberType], [PersonId]) values 
('7774340822',  'work',  '1'),
('5534945940',  'work',  '2'),
('6743828908',  'work',  '3'),
('9816989589',  'home',  '4'),
('1133805910',  'work',  '5'),
('2146327011',  'home',  '6'),
('5119829785',  'home',  '7'),
('1399281087',  'home',  '8'),
('6677699336',  'home',  '9'),
('4485406555',  'work',  '10'),
('7497335915',  'home',  '11'),
('7367083538',  'home',  '12'),
('8674936900',  'work',  '13'),
('6876417116',  'home',  '14'),
('5769136337',  'work',  '15'),
('8297360342',  'home',  '16'),
('7116962630',  'work',  '17'),
('2537270180',  'work',  '18'),
('9148331142',  'home',  '19'),
('3673187069',  'work',  '20')

insert into [demkiv].[PRODUCTS] ([ProductId],[VendorID],[ProductName], [ProductPrice], [ProductAmount]) values 
('1','3','petrol 95','89.3','96'),
('2','1','diesel','101.29','28'),
('3','5','lpg','181.51','137'),
('4','1','petrol 95','110.97','96'),
('5','9','petrol 95','199.13','238'),
('6','9','petrol euro','67.75','146'),
('7','7','petrol euro','99.9','180'),
('8','8','diesel','162.23','15'),
('9','7','petrol 95','114.31','100'),
('10','2','diesel','68.88','53'),
('11','8','diesel','196.85','68'),
('12','6','petrol 95','21.64','159'),
('13','4','petrol 95','99.18','45'),
('14','8','diesel','30.03','122'),
('15','7','diesel','187.97','47'),
('16','7','petrol euro','20.55','122'),
('17','1','petrol 95','142.4','107'),
('18','2','petrol 95','60.05','205'),
('19','2','diesel','98.79','211'),
('20','10','lpg','159.06','54')


insert into [demkiv].[EMPLOYEES] ([JobTitle],[HireDate],[StationId],[LeadId],[SaleTarget],[Status],[StatusChangeDate],[TaxNumber],[PersonId]) values 
('Compensation Analyst','2019-10-10','7','10','4355.38','13','2021-05-19','1016426796','17'),
('Professor','2019-08-01','13','9','13297.79','10','2020-03-27','7382259339','5'),
('Civil Engineer','2020-07-30','7','2','2261.19','6','2019-12-23','9829779371','4'),
('Project Manager','2020-11-10','9','3','15049.05','9','2020-12-29','4785125505','5'),
('Geologist II','2020-09-24','20','8','14721.02','10','2019-09-23','5961144708','8'),
('Environmental Tech','2020-07-18','6','14','6313.33','19','2021-09-07','2295040869','12'),
('Database Administrator I','2019-08-04','7','13','9991.38','12','2020-08-26','5534348779','1'),
('Senior Developer','2021-10-14','18','9','8243.35','18','2019-10-05','5151987047','18'),
('Actuary','2021-06-14','12','13','1034.35','19','2019-11-16','7724913809','13'),
('Assistant Manager','2020-06-27','13','2','13681.87','6','2021-07-05','9492433577','5'),
('VP Sales','2021-09-22','14','11','16789.47','11','2021-07-24','8384716608','9'),
('Civil Engineer','2020-08-19','8','1','17383.29','12','2020-12-04','6162427601','11'),
('Community Outreach Specialist','2019-07-14','4','13','13113.68','9','2020-06-06','4134001516','4'),
('Marketing Manager','2019-04-04','14','7','11200.06','13','2019-05-17','2222118105','4'),
('Automation Specialist IV','2019-06-26','10','13','6774.72','8','2021-03-22','7456902899','10'),
('Structural Analysis Engineer','2020-11-04','18','13','4675.85','10','2019-10-25','8988652315','20'),
('Quality Control Specialist','2019-11-09','12','19','5650.73','15','2020-02-28','6067063686','1'),
('Product Engineer','2021-02-08','18','5','3119.27','16','2021-03-29','2318700695','16'),
('Environmental Specialist','2020-03-05','1','14','17030.64','19','2021-02-15','8656139324','4'),
('Assistant Media Planner','2020-08-13','11','7','16943.47','10','2020-09-29','3267249253','7')



insert into [demkiv].[STATIONS] ([District],[Address],[LeadId]) values 
('Sobral','66120 Mitchell Drive','10'),
('Suru','3 Haas Plaza','19'),
('Sukoanyar','068 Oakridge Court','16'),
('Bilhó','638 Delaware Pass','2'),
('Yingzhou','4114 8th Parkway','2'),
('Mingyihe','310 Nobel Parkway','14'),
('Tipo-Tipo','7728 Knutson Road','17'),
('Kendalngupuk','6657 Ruskin Terrace','2'),
('Donskoy','4 Kedzie Drive','4'),
('Kirovgrad','60752 Rieder Park','11'),
('Матејче','1939 Ridgeway Lane','9'),
('Quartier Morin','3239 Roth Road','11'),
('Linhu','9 Schlimgen Junction','16'),
('Cipanggung','42864 Dawn Hill','9'),
('Linköping','3 Huxley Lane','12'),
('Sete Lagoas','14 Lotheville Way','9'),
('Chavães','27854 Chive Hill','12'),
('Artur Nogueira','36146 Roxbury Terrace','5'),
('Wilczyce','03 Thierer Crossing','15'),
('General Villegas','684 Fulton Hill','20')

insert into [demkiv].[CUSTOMERS] ([ServiceType],[ServiceStartDate],[EmployeeId],[Status],[StatusChangeDate],[PersonId]) values 
('basic','2021-08-05','4','1','2021-02-19','20'),
('bronze','2019-12-23','20','1','2019-11-22','5'),
('bronze','2019-09-19','20','0','2021-07-10','3'),
('gold','2020-08-31','8','1','2019-05-07','8'),
('gold','2019-06-22','11','1','2020-06-18','2'),
('basic','2019-07-09','2','0','2021-03-20','17'),
('gold','2019-03-05','10','0','2019-03-25','14'),
('gold','2020-01-16','8','0','2019-08-24','2'),
('bronze','2020-01-07','12','0','2019-07-29','7'),
('silver','2019-03-26','11','1','2019-07-19','1'),
('silver','2019-03-22','20','0','2020-01-08','20'),
('bronze','2021-08-18','11','1','2019-03-09','5'),
('silver','2020-12-09','5','1','2021-08-21','18'),
('basic','2020-08-21','2','0','2021-05-06','2'),
('basic','2020-12-25','15','0','2020-11-18','17'),
('silver','2021-07-07','16','0','2020-08-29','2'),
('gold','2020-10-26','2','1','2021-06-08','11'),
('basic','2020-08-09','7','1','2020-05-26','8'),
('bronze','2019-08-24','11','1','2020-03-01','14'),
('gold','2019-12-10','17','1','2021-07-19','15')


insert into [demkiv].[CARDS] ([CardNumber],[CustomerId],[Status],[StatusChangeDate],[Balance],[Discount]) values 
('20956','30','1','2021-02-14','7597.77',21.00),
('40715','32','1','2021-06-27','9246.07',20.00),
('22095','40','1','2021-01-18','7168.26',11.00),
('11108','37','1','2021-04-13','3508.42',7.00),
('46328','36','1','2021-04-20','12651.24',23.00),
('15995','42','2','2019-03-17','13794.49',4.00),
('22429','35','1','2019-04-17','3856.74',23.00),
('7386','38','2','2019-04-15','3837.4',25.00),
('47576','36','2','2019-11-24','8212.25',23.00),
('78560','39','1','2021-05-02','13785.26',11.00),
('91276','37','1','2020-02-14','13210.12',24.00),
('34815','41','1','2020-01-24','7890.68',18.00),
('5894','37','2','2021-09-30','11533.01',14.00),
('42017','39','1','2021-07-19','1558.41',13.00),
('43383','33','2','2020-12-17','3587.45',9.00),
('35835','41','1','2019-11-14','2201.73',16.00),
('89112','36','1','2020-09-25','14951.18',6.00),
('11144','43','1','2020-04-03','5926.21',6.00),
('69891','42','1','2021-07-05','10166.81',24.00)

insert into [demkiv].[EMAILS] ([Email],[EmailType],[PersonId]) values 
('dgoodwell0@blogtalkradio.com','work','6'),
('sperago1@telegraph.co.uk','work','3'),
('mneal2@goodreads.com','work','9'),
('fgascoyne3@tripod.com','private','19'),
('efilasov4@people.com.cn','work','8'),
('dbadder5@icq.com','private','5'),
('ldessant6@is.gd','work','15'),
('ccavill7@acquirethisname.com','private','15'),
('mrive8@tmall.com','private','18'),
('lcrock9@google.pl','private','12'),
('lflintuffa@drupal.org','work','6'),
('kmacgillb@skyrock.com','private','20'),
('sbowichc@wordpress.com','private','2'),
('mshorttd@cisco.com','private','13'),
('fsteckingse@cdbaby.com','work','20'),
('pjeffersf@amazonaws.com','work','1'),
('malbing@archive.org','work','3'),
('rwilcinskish@bloomberg.com','private','12'),
('khawkswoodi@dell.com','work','16'),
('adudeneyj@examiner.com','private','1')

insert into [demkiv].[ORDERS] ([CardId],[StationId],[PersonId],[OrderDate]) values 
('','8','1','2020-07-07'),
('','14','17','2021-04-17'),
('','8','14','2021-10-10'),
('','9','16','2021-07-04'),
('','11','19','2020-11-11'),
('','10','16','2020-01-18'),
('20956','7','6','2020-10-09'),
('40715','22','3','2020-10-12'),
('22095','12','18','2021-05-22'),
('11108','20','7','2021-10-02'),
('46328','16','4','2020-08-06'),
('15995','9','5','2020-02-28'),
('','8','20','2020-09-28'),
('','17','5','2020-11-17'),
('','11','4','2020-06-01'),
('','10','6','2021-08-26'),
('','17','2','2021-01-07'),
('','9','5','2021-08-25'),
('','14','3','2019-12-26'),
('','12','10','2020-11-16')

insert into [demkiv].[ORDERDETAILS] ([OrderID],[OrderDetailId],[VendorId],[ProductId],[OrderAmount],[TotalSum]) values 
('15', '1', '1', '2 '  ,'343','33768.91'),
('14', '2', '1', '4 '  ,'95','10025.07'),
('19', '3', '1', '17'  ,'152','11387.71'),
('17', '4', '2', '10'  ,'55','17535.46'),
('11', '5', '2', '18'  ,'132','21306.28'),
('11', '6', '2', '19'  ,'74','6547.83'),
('13', '7', '3', '1 '  ,'131','33830.13'),
('13', '8', '4', '13'  ,'311','21098.15'),
('18', '1', '5', '3 '  ,'207','24065.74'),
('17', '1', '6', '12'  ,'193','28185.25'),
('8', '1', '7', '7 '  ,'337','8862.04'),
('26', '1', '7', '9 '  ,'116','21482.99'),
('23', '1', '7', '15'  ,'292','25649.25'),
('9', '1', '7', '16'  ,'354','34108.51'),
('14', '1', '8', '8 '  ,'51','31575.31'),
('10', '1', '8', '11'  ,'336','21477.5'),
('14', '3', '8', '14'  ,'260','38652.54'),
('12', '1', '9', '5 '  ,'155','29522.04'),
('9', '2', '9', '6 '  ,'115','26302.99'),
('14', '4', '10','20'  ,'79','17975.55')