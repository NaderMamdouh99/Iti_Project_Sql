------ User_Crud Operator -----
select * from Exam.[User]
go
create or alter proc Register 
(@UserName Varchar(50),
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
--create or alter proc Update_User 
--(@UserName Varchar(50) ,
--@Phone Varchar(11) ,
--@FirstName Varchar(50),
--@LastName Varchar(50),
--@City varchar(50),
--@StreetName varchar(50),
--@DOB date,
--@Password varchar(50))
--as 
--begin
--if  ExISTS(Select * from Exam.[User] where Exam.[User].UserName = @UserName )
--	begin
--		if(len(@Phone) != 11 and @Phone not like  '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
--				begin
--					select 'phone must be 11 number '
--					return -1;
--				end
--		if(@DOB >= GETDATE() )
--				begin
--					select 'Date of birth  must not To Day '
--					return -1;

--				end
--		if(@Password  not like '%[0-9]%' and @Password not like '%[A-Z]%'  and len(@Password) >= 8 )
--				begin
--				select '@Password must be contain numbers and leters and grater than 8 digis '
--				return -1;
--				end
--		declare @age int ;
--		select @age = DATEDIFF(year, @DOB, GETDATE());
--		insert into [ExamSystem].[Exam].[User](UserName,Password,Phone,FirstName,LastName,City,StreetName,Birthdate,Age) 
--		values(@UserName,@Password,@Phone,@FirstName,@LastName,@City,@StreetName, @DOB,@age);
--		return 1;
--	end
--else 
--	begin
--		print 'User Name Orady Exits'
--	end
--end

go


create TRIGGER UpdateUser
ON [Exam].[User]
Instead of UPDATE
AS
begin
begin try
	declare @UserNameOld varchar(50),@DeletedID int ;

	select  @UserNameOld =UserName , @DeletedID= deleted.Id from deleted
	if ExISTS(Select * from Exam.[User] where Exam.[User].UserName = @UserNameOld )
		begin
			declare @Phone Varchar(11) ,
					@FirstName Varchar(50),
					@LastName Varchar(50),
					@City varchar(50),
					@StreetName varchar(50),
					@DOB date,
					@Password varchar(50),
					@UserNameNew varchar(50);
			select @UserNameNew = inserted.UserName, @Phone = Phone , @FirstName = FirstName ,@LastName = LastName,@City = City , @StreetName=StreetName ,@DOB = inserted.Birthdate,@Password = inserted.Password from inserted	;
			if (len(@UserNameNew) < 10 and CHARINDEX('@',@UserNameNew) = 0 )
					begin
						throw 51000,'UserName must greater than 10 and contain @ ',16
					end
			if(len(@Phone) != 11 and @Phone not like  '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
						begin
							throw 51000,'phone must be 11 number ',16;
						end
			if(@DOB >= GETDATE() )
						begin
							throw 51000,'Date of birth  must not To Day ',16;
						end
			if(@Password  not like '%[0-9]%' and @Password not like '%[A-Z]%'  and len(@Password) <= 8 )
						begin
						
						throw 51000,'@Password must be contain numbers and leters and grater than 8 digis ',16;
						end
		
				declare @age int ;
				select @age = DATEDIFF(year, @DOB, GETDATE());
		
				update Exam.[User] 
				set UserName = @UserNameNew,Password = @Password,FirstName=@FirstName, LastName=@LastName , Birthdate=@DOB ,Age = @age,City=@City , StreetName =@StreetName , Phone =@Phone
				where Id = @DeletedID

				select 'Updated Seccufuly'
		
	end
else 
	begin
		throw 51000,'User Name Not Exits',16;
	end
	end try
	begin catch
		select ERROR_MESSAGE();
	end catch

end

update Exam.[User] 
set UserName='Heshammohamedgamil.com'
where Id = 1;

