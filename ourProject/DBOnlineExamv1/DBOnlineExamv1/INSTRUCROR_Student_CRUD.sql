------------INSTRACOR-----
----ADD INSTRACTOR--------
go
create function [Exam].CkeckHowManyInstractorUserID
(@UserId int )
returns int
as
begin
	declare @Flag int;
	select  @Flag=count(*) from Exam.Instractor
	where UserId= @UserID
	group by Exam.Instractor.UserId
	having COUNT(*) >= 1
	return @flag
end

-----------------------------------------------

create function [Exam].CkeckIfStudentTakeInstractorUserID
(@UserId int )
returns int
as
begin
	declare @Flag int;
	select  @Flag=count(*) from Exam.Student
	where UserId=@UserID
	group by Exam.Student.UserId
	having COUNT(*) >= 1;
	return @flag
end




go
Create or alter proc ADD_Instractor 
(
@UserID int,
@MangerID int,
@BranchId int,
@DepartementId int
)
as
begin
	declare @FalgForCountUserId int;
	set  @FalgForCountUserId = [Exam].CkeckHowManyInstractorUserID(@UserID);

	declare @FalgForCheckStudentTakeUserID int;
	set  @FalgForCheckStudentTakeUserID =[Exam].CkeckIfStudentTakeInstractorUserID(@UserID);

	if  EXISTS(select * from Exam.[User] where Id = @UserID)
		if  (@FalgForCountUserId  is  null)
			if exists (select * from Exam.Departmant where Id != @DepartementId)
				if exists (select * from Exam.Branch where Id != @BranchId)
					if exists (select * from Exam.Instractor where Id = @MangerID or @MangerID is null)
						if(@FalgForCheckStudentTakeUserID is null)
							begin
									insert into Exam.Instractor												(UserId,MangerId,BranchId,DepartmantId)
							values				(@UserID,@MangerID,@BranchId,@DepartementId);
							return 1
							end
	begin
		throw  51000,'Invalid Instractor plz check FK Ids ' ,16;
	end
		return -1
end


--------------
begin try
exec ADD_Instractor @UserID=8,@MangerID=1,@BranchId=1,@DepartementId=2
end try
begin catch
	select ERROR_MESSAGE()
end catch

select * from Exam.Instractor 
select * from Exam.Student;
select * from Exam.[User];
-------------------------------------------------------------------------
-- ADD Student 

create function [Exam].CkeckHowManyStudentUserID
(@UserId int )
returns int
as
begin
	declare @Flag int;
	select  @Flag=count(*) from Exam.Student
	where UserId= @UserID
	group by Exam.Student.UserId
	having COUNT(*) >= 1
	return @flag
end

create function [Exam].CkeckIfInstractorTakeUserID
(@UserId int )
returns int
as
begin
	declare @Flag int;
	select  @Flag=count(*) from Exam.Instractor
	where UserId=@UserID
	group by Exam.Instractor.UserId
	having COUNT(*) >= 1;
	return @flag
end




go

Create or alter proc ADD_Student 
(
@UserID int,
@IntakeBranchId int,
@DepartementId int
)
as
begin
	declare @FalgForCountUserId int;
	set  @FalgForCountUserId=[Exam].CkeckHowManyStudentUserID(@UserID);

	declare @FalgForCheckInstractorTakeUserID int;
	set  @FalgForCheckInstractorTakeUserID=[Exam].CkeckIfInstractorTakeUserID(@UserID);

	if  EXISTS(select * from Exam.[User] where Id = @UserID)
		if  (@FalgForCountUserId  is  null)
			if exists (select * from Exam.Departmant where Id = @DepartementId)
				if exists (select * from Exam.IntakeBranchTrack where Id = @IntakeBranchId)
						if(@FalgForCheckInstractorTakeUserID is null)
							begin
									insert into Exam.Student(UserId,IntakeBranchTrackID,DepartmantId)
							values				(@UserID,@IntakeBranchId,@DepartementId);
							return 1
							end
	begin
		throw  51000,'Invalid Instractor plz check FK Ids ' ,16;
	end
		return -1
end

begin try
exec ADD_Student @UserID=1,@IntakeBranchId=1,@DepartementId=1
end try
begin catch
	select ERROR_MESSAGE()
end catch
---------------------------------------------
----------------UpDate instructor------------
---------------------------------------------
go
create or alter TRIGGER [Update_Instractor]
ON exam.Instractor
Instead of UPDATE
AS
begin 
	declare @NewUserId int ,@NewManger int,@NewDepartement int,@NewBranch int;
	select @NewUserId = inserted.UserId,@NewManger=inserted.MangerId,@NewDepartement=inserted.DepartmantId,@NewBranch=inserted.BranchId from inserted;
	---- check IF theier is ins Take The Same UserID
	declare @FalgForCountUserId int;
	set  @FalgForCountUserId=[Exam].CkeckHowManyInstractorUserID(@NewUserId);

	--ckeck std take the same user id
	declare @FalgForCheckStudentTakeUserID int;
	set  @FalgForCheckStudentTakeUserID=[Exam].CkeckIfStudentTakeInstractorUserID(@NewUserId);

	declare @MangerID int 
	select @MangerID =inserted.MangerId from inserted;
		if  EXISTS(select * from Exam.[User] where Id = (select inserted.UserId from inserted ))
			and exists (select * from Exam.Departmant where Id =(select inserted.DepartmantId from inserted))
			and exists (select * from Exam.Branch where Id = (select inserted.BranchId from inserted) )
				and exists (select * from Exam.Instractor where Id =@MangerID or @MangerID is null)
					begin
					if(@FalgForCheckStudentTakeUserID is null and @FalgForCountUserId is null )
					begin
								declare @Id int ;
								select @Id =deleted.Id from deleted ;
									update Exam.Instractor
									set UserId=@NewUserId
									, DepartmantId =@NewDepartement
									, BranchId =@NewBranch
									, MangerId =@NewManger
									where Id =@Id;
					end
					else 
					begin 
						throw 51000,'Ivalid FK Please Check Foregin Key',16;
					end

					

		end -- end lareg if 
		else
		begin 
			throw 51000,'Ivalid FK Please Check Foregin Key',16;
		end

end

------
go




---------------------------------------------
----------------------------------------------
---update student
-- logically no one can update student Data Once Student Data is Assign
go
create  TRIGGER [Update_Student]
ON [Exam].[Student]
Instead of UPDATE
AS
begin 
		throw 51000,' Student Cant Updated After Register in ITI and Accepted in Intake  ',16;
end

-----
go
begin try
	update Exam.Student
	set UserId = 4,DepartmantId=2
	where Id=1
end try
begin catch
	select ERROR_MESSAGE();
end catch


---------------- prevent delete of instructor and Student---------
create Trigger PreventDeleteStudent
on [Exam].[Student]
instead of delete 
as
begin
	throw 51000,'Cant Delete Student ',16;
end
go
begin try
delete  Exam.Student 
where  Id = 1;
end try
begin catch
   select ERROR_MESSAGE();

end catch

------ 
create Trigger PreventDeleteInstractor
on [Exam].[Instractor]
instead of delete 
as
begin
	throw 51000,'Cant Delete Instractor ',16;
end
go
begin try
delete  Exam.Instractor 
where  Id = 1;
end try
begin catch
   select ERROR_MESSAGE();

end catch