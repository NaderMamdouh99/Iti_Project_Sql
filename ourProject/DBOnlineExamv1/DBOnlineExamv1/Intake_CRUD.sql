
-- Add Intake 
create or alter proc Add_Intake(@In_Id int, @In_Name varchar(15),@In_Year date)
as
begin
	IF NOT EXISTS(select 1 from  [Exam].[Intake] where [Name]=@In_Name )
		begin
			if (@In_Id >= (SELECT MAX([Id]) FROM [Exam].[Intake]))
				begin
					iF ( @In_Year > GETDATE())
						begin
							insert into [Exam].[Intake]([Id],[Name],[year])
							values (@In_Id,@In_Name,@In_Year)
						end
					else
						begin
							select 'The Year Is Small Than of This Year'
						end
				end
			else 
				begin
					select 'The Id intake is not Valid '
				end
		end
	else
	begin
		select 'Intake is exist';
	end
end
go
exec  Add_Intake @In_Id = 51 , @In_Name = 'Intake 51',@In_Year = '2024-10-01'
select * from [Exam].[Intake]
-----------------------------------------
--Update Intake
go
create or alter  proc Update_Intake(@In_Id int, @In_Name varchar(15),@In_Year date)
as 
begin 
	IF EXISTS(select 1 from [Exam].[Intake]  where [Id]= @In_Id)
		begin
		IF Not EXISTS(select 1 from [Exam].[Intake]  where [Name]=@In_Name)
			begin
				if (@In_Name='')
					begin
						select 'The Name Is Not Valid'
					end
				else
					begin
						update [Exam].[Intake]
						set [Id]=@In_Id,[Name]=@In_Name ,[year]=@In_Year
						where [Id]=@In_Id;
					end
		end
		else
			select 'Intake repeated'
		end
	else
	begin
		select 'Intake Does not is exist';
	end
end

exec Update_Intake @In_Id=44,@In_Name='Intake 54',@In_Year='2024-07-01'
select * from [Exam].[Intake]
----===========prevention delete intake  ================-----------
----===========prevention update and delete  intake  ================-----------
go
create or alter trigger Prevent_Intake_Update
on [Exam].[Intake]
instead of  delete
as
begin
    
       throw 51000,'Cannot delete in Intake',16;
      
end  
begin try
   delete  [Exam].[Intake]
   where Id=42
end try
begin catch
   select ERROR_MESSAGE();
end catch