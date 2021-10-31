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