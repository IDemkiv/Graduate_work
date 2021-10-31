/**Developing all the necessary programming objects **/

/**Creating function that returns the full age of person **/
create function dbo.getFullAge (@BirthDate date)
	returns int
	as begin
			declare @CTRFullAge as int;
				set @CTRFullAge = datediff(year, @BirthDate, getdate()) - case when 100 * month(getdate()) + day(getdate())
< 100 * month(@BirthDate) + day(@BirthDate)
then 1 else 0 end
			return @CTRFullAge;

       end;

select dbo.getFullAge('1987-11-07')

/**Creating function that returns age of the most experienced employee on the selected work position **/
create function dbo.getEmp (@JobTitle nchar(30))
	returns int
	as begin
			declare @CTREmp as int;
				set @CTREmp = (select top 1 max(datediff(year, e1.HireDate, getdate())) as WorkingYears 
										from [demkiv].[EMPLOYEES] as e1 
										where e1.JobTitle = @JobTitle)
			return @CTREmp;

       end;
select dbo.getEmp('Civil Engineer') 






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




	