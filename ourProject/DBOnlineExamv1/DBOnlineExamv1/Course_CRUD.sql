-- Add Course 
go
create or alter proc Add_Coursee(@Crs_Name varchar(30),@Crs_MaxDegree int,
@Crs_MinDegree	int,@Crs_Discraption nvarchar(MAX),@Crs_InstractorId int)
as
begin
	IF NOT EXISTS(select 1 from [Exam].[Course] where [Name]=@Crs_Name )
		begin
			if (@Crs_Name = '')
				begin
					select 'The Name Of Course Is Not Valid'
				end
			else
				begin
					if(@Crs_MaxDegree<=100 and @Crs_MaxDegree>@Crs_MinDegree and @Crs_MinDegree>=0)
						begin
							if(@Crs_Discraption = '')
								begin
									select 'The Discraption of Course is Not Valid'
								end
							else
								begin
									if exists(select 1 from Exam.Instractor where id = @Crs_InstractorId)
										begin
											insert into Exam.Course([Name],[MaxDegree],[MinDegree],[Discraption],[InstractorId])
											values (@Crs_Name,@Crs_MaxDegree,@Crs_MinDegree,@Crs_Discraption,@Crs_InstractorId)
										end
									else
										begin
											select 'The Instractor id is not Valid'
										end
								end
						end
					else
						begin 
							select 'The Max Degree and Min Degree is not Valid'
						end
				end
		end
	else
	begin
		select 'Courses is exist';
	end
end


exec Add_Coursee @Crs_Name = 'New Qurse ',@Crs_MaxDegree = 100,@Crs_MinDegree = 30,@Crs_Discraption='this is new Course ',@Crs_InstractorId=2
select * from [Exam].[Course]

-----------------------------------------
--Update Cource
go
create or alter proc Update_Coursee(@Crs_Id int,@Crs_Name varchar(30),@Crs_MaxDegree int,
@Crs_MinDegree	int,@Crs_Discraption nvarchar(MAX),@Crs_InstractorId int )
as 
begin 
	IF EXISTS(select 1 from [Exam].[Course]  where [Id]= @Crs_Id)
		begin
		IF Not EXISTS(select 1 from [Exam].[Course]  where [Name]=@Crs_Name AND [Id] != @Crs_Id)
			begin
				if (@Crs_Name='')
					begin
						select 'The Course Name is Not Valid'
					end
				else
					begin
						if (@Crs_MaxDegree<=100 and @Crs_MaxDegree>@Crs_MinDegree and @Crs_MinDegree>=0)
							begin
								if (@Crs_Discraption= '')
									begin
										Select 'The Discraption is Not Valid to Update Data'
									end
								else
									begin
										if (@Crs_InstractorId=1 or @Crs_InstractorId=2)
											begin
												update [Exam].[Course]
												set [Name]=@Crs_Name,[MaxDegree]=@Crs_MaxDegree,[MinDegree]=@Crs_MinDegree,
													[Discraption]=@Crs_Discraption,[InstractorId]=@Crs_InstractorId
												where [Id]=@Crs_Id;
											end
									else
										begin
											Select 'The Instractor Id is Not Valid to Update Data'
										end
									end
							end
						else
							begin
								select 'The Max Degree and Min Degree are Not Valid To Update Data'
							end
					end
		end
		else
			select 'Cource repeated'
		end
	else
	begin
		select 'Course Does not is exist';
	end
end


exec Update_Coursee @Crs_Id=180,@Crs_Name='php',@Crs_MaxDegree=100,@Crs_MinDegree=30,
@Crs_Discraption='Introduction to Csharpp',@Crs_InstractorId=1

select * from Exam.Course;

------------------------- prevent delete course ----------------------------
create trigger Prevent_Course_Deletion
on[Exam].[Course]
instead of delete
as
begin
  
      throw 51000,'Cannot delete the Course',16;
	  
End

go
begin try
delete  Exam.Course where Id = 8;
end try
begin catch
   select ERROR_MESSAGE()

end catch