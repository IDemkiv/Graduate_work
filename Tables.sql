/*Database objects creation*/

drop table  if exists [Demkiv].[EMPLOYEES]

create table [Demkiv].[EMPLOYEES] (
  [PersonId] [bigint] IDENTITY(1,1) primary key NOT NULL,
  [Name] [nchar](30) NOT NULL,
  [Surname] [nchar](30) NOT NULL,
  [Patronymic] [nchar](30) NOT NULL,
  [Birthday] [Date] NOT NULL,
  [Gender] [nchar](1) NOT NULL,
  [MaritalStatus] [nchar](1) NOT NULL,
  )

 
/*alter table [EMPLOYEES]
add constraint  pk_id primary key (PersonId)*/