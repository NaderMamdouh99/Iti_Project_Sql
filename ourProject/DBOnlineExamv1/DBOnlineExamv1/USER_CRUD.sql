------ User_Crud Operator -----
select * from Exam.[User]
go
create or alter proc Register 
(@UserName Varchar(50) ,
@Phone Varchar(11) ,
@FirstName Varchar(50) ,
@LastName Varchar(50) ,
@City varchar(50) ,
@StreetName varchar(50) ,
@DOB date ,
@Password varchar(50))
as 
begin
if not ExISTS(Select * from Exam.[User] where Exam.[User].UserName = @UserName )
	begin
		if(len(@Phone) != 11 and @Phone not like  '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
				begin
					select 'phone must be 11 number '
					return -1;
				end
		if(@DOB >= GETDATE() )
				begin
					select 'Date of birth  must not To Day '
					return -1;

				end
		if(@Password  not like '%[0-9]%' and @Password not like '%[A-Z]%'  and len(@Password) >= 8 )
				begin
				select '@Password must be contain numbers and leters and grater than 8 digis '
				return -1;
				end

		declare @age int ;
		select @age = DATEDIFF(year, @DOB, GETDATE());
		
		insert into [ExamSystem].[Exam].[User](UserName,Password,Phone,FirstName,LastName,City,StreetName,Birthdate,Age) 
		values(@UserName,@Password,@Phone,@FirstName,@LastName,@City,@StreetName, @DOB,@age);
		return 1;
	end
else 
	begin
		print 'User Name Orady Exits'
	end
end

go
exec Register @UserName= 'test3@gmail.com' , @Phone='01142202287',@FirstName='hesham',@LastName='Galal',@City='asuit',@StreetName='elnames',@DOB='2012-07-19',@Password='12345678';

go
go


--------------------------------------------------------------
go
create or alter proc UpdateUser
(@UserName Varchar(50) ,
@NewUserName varchar(50),
@Phone Varchar(11) ,
@FirstName Varchar(50) ,
@LastName Varchar(50) ,
@City varchar(50) ,
@StreetName varchar(50) ,
@DOB date ,
@Password varchar(50))
as 
begin
	begin try
	if ExISTS(Select * from Exam.[User] where Exam.[User].UserName = @UserName )
		begin
			if (len(@NewUserName) < 10 or   @NewUserName not like '%@%' )
					begin
						select 'UserName must greater than 10 and contain @ ';
						return -1;
					end
			if(len(@Phone) != 11 or @Phone not like  '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
						begin
							select 'phone must be 11 number ';
							return -1
						end
			if(@DOB >= GETDATE() )
						begin
							select 'Date of birth  must not To Day ';
									return -1;

						end
			if(@Password  not like '%[0-9]%' or @Password not like '%[A-Z]%'  or len(@Password) <= 8 )
						begin
						select '@Password must be contain numbers and leters and grater than 8 digis ';
								return -1;

						end
		
				declare @age int ;
				select @age = DATEDIFF(year, @DOB, GETDATE());
		
				update Exam.[User] 
				set UserName = @NewUserName,Password = @Password,FirstName=@FirstName, LastName=@LastName , Birthdate=@DOB ,Age = @age,City=@City , StreetName =@StreetName , Phone =@Phone
				where UserName = @UserName;
				select 'Updated Seccufuly'
				return 1;
		
	end
else 
	begin
		select 'User Name Not Exits';
		return -1;
	end
end try
begin catch
		select ERROR_MESSAGE();
		return -1;
end catch
end



exec UpdateUser @NewUserName= 'aya1990@gmail.com',@UserName='aya1953@gmail.com' ,  @Phone='01142202287',@FirstName='hesham',@LastName='Galal',@City='asuit',@StreetName='elnames',@DOB='2012-07-19',@Password='12345678asd';

select * from Exam.[User]
-----
go
create Trigger PreventDeleteUser
on [Exam].[User]
instead of delete 
as
begin
	throw 51000,'Cant Delete User ',16;
end
go
begin try
delete  Exam.[User] 
where  Id = 1;
end try
begin catch
   select ERROR_MESSAGE();

end catch