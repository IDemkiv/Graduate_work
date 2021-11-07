/**Developing all the necessary programming objects **/

/**Creating function that returns the full working years of the person **/
create function demkiv.getFullWorkingYears (@HireDate date)
	returns int
	as begin
			declare @CTRFullWorkingYears as int;
				set @CTRFullWorkingYears = datediff(year, @HireDate, getdate()) - case when 100 * month(getdate()) + day(getdate())
< 100 * month(@HireDate) + day(@HireDate)
then 1 else 0 end
			return @CTRFullWorkingYears;

       end;

select demkiv.getFullWorkingYears('1987-11-07')

/**Creating function that returns age of the most experienced employee on the selected work position **/
create function demkiv.getEmp (@JobTitle nchar(30))
	returns bigint
	as begin
			declare @CTREmp as bigint;
				set @CTREmp = (select t2.EmployeeId 
				                        from 
				                       (select top 1 max(datediff(year, e1.HireDate, getdate())) as WorkingYears ,
				                        e1.EmployeeId
										from [demkiv].[EMPLOYEES] as e1 
										where e1.JobTitle = @JobTitle 
										group by e1.EmployeeId
										order by WorkingYears desc) as t2)
			return @CTREmp

       end;
select demkiv.getEmp('Civil Engineer') 






/** Creating trigger**/
go
create trigger PROD_QTY_CHECK_TR on [demkiv].[ORDERDETAILS]
	after insert as
		begin


            declare @inappropriate_order_qty as int = ( 
														select count(distinct t1.OrderID)
														  from inserted                 as t1  
														 inner join [demkiv].[PRODUCTS] as t2 on t2.VendorID = t1.VendorId
																							 and t2.ProductId = t1.ProductId
																							 and t2.ProductAmount < t1.OrderAmount);

			if @inappropriate_order_qty > 0
				rollback transaction;
					
		end;
		


/**Creating procedure**/
go
create procedure demkiv.CREATE_NEW_ORDER
	@ORDER_ID bigint,
	@ORDER_DETAIL_ID bigint,
	@VENDOR_ID   bigint,
	@PRODUCT_ID  bigint,
	@QTY      int,
	@SUM money
	as begin
	     
		begin transaction
		begin try 
	    declare @COST as numeric(15, 2) = (select t1.ProductPrice
		                                      from [demkiv].[PRODUCTS] as t1
											  where t1.VendorID = @VENDOR_ID
											    and t1.ProductId = @PRODUCT_ID);

		declare @AMOUNT as numeric(15, 2) = (@QTY * @COST)

	    insert into [demkiv].[ORDERDETAILS] ([OrderID], [OrderDetailId], [VendorId], [ProductId], [OrderAmount], [TotalSum])
		values(@ORDER_ID, @ORDER_DETAIL_ID, @VENDOR_ID, @PRODUCT_ID, @QTY, @AMOUNT);


		update [demkiv].[PRODUCTS]
		   set ProductAmount = t1.ProductAmount - @QTY
		  from [demkiv].[PRODUCTS] as t1
		 where t1.VendorID = @VENDOR_ID
		   and t1.ProductId = @PRODUCT_ID
		   and isnull(@QTY, 0) > 0

		end try 
		begin catch
		rollback transaction;
		end catch

		   commit transaction
	   end ;


execute demkiv.CREATE_NEW_ORDER 26, 4,7,9, 1900, 154;

-- creating view ;
create view [demkiv].[vwEmployees] 
as 
 with t5 as ( select --* 
				old.JobTitle,
				demkiv.getFullWorkingYears(old.[HireDate]) as WorkYearsMostExp,
				sum(isnull(t4.TotalSum, 0)) as TotSum,
				count(t4.OrderID) as CountOrders
				from (select rank() over (partition by t1.JobTitle ORDER BY t1.HireDate asc) as rn,
					t1.JobTitle,
					t1.EmployeeId,
					t1.PersonId,
					t1.HireDate
					from [demkiv].[EMPLOYEES] as t1
					) old 
							
										    join [demkiv].[PERSONS] as t2 on t2.[PersonId] = old.[PersonId]
									left	join [demkiv].[ORDERS] as t3 on t3.PersonId = t2.PersonId
									left	join [demkiv].[ORDERDETAILS] as t4 on t4.OrderID = t3.OrderID

										where old.rn = 1
										group by old.JobTitle, old.HireDate
			),

	 t6 as (
	 select t1.[EmployeeId], 
	       t1.[JobTitle],
		   upper(concat(trim(t2.[Name]), N' ', trim(t2.[Surname]), N' ', trim(t2.[Patronymic]))) as FullName,
		   demkiv.getFullWorkingYears(t1.[HireDate]) as FullWorkingYear,
		   count(t3.[OrderID]) as OrdersCount,
		   sum(isnull(t4.[TotalSum],0)) as MoneySum
from [demkiv].[EMPLOYEES] as t1
join [demkiv].[PERSONS] as t2 on t2.[PersonId] = t1.[PersonId]
left join [demkiv].[ORDERS] as t3 on t3.PersonId = t2.PersonId
left join [demkiv].[ORDERDETAILS] as t4 on t4.OrderID = t3.OrderID
group by t1.[EmployeeId], 
	     t1.[JobTitle],
		 t2.[Name],
		 t2.[Surname],
		 t2.[Patronymic],
		 t1.[HireDate])

	select t6.EmployeeId,
	t6.JobTitle,
	t6.FullName,
	t6.FullWorkingYear,
	t5.WorkYearsMostExp,
	t5.WorkYearsMostExp - t6.FullWorkingYear as Yeardiff,
	t6.OrdersCount,
	t5.CountOrders,
	t6.OrdersCount - t5.CountOrders  as OrdersDiff,
	t6.MoneySum,
	t5.TotSum,
	t6.MoneySum - t5.TotSum as MoneyDiff

	from t6
	
join t5 on t5.JobTitle = t6.JobTitle
order by t6.FullWorkingYear desc
;



