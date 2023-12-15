select * from exam.Exams
select * from exam.Course
select * from exam.Questions
select * from Exam.Instractor 
select * from Exam.ExamQuestion
select * from Exam.IntakeBranchTrack

--- add exams

go
create or alter proc AddEXam 
(
@Name varchar(30),
@Type varchar(10),
@StartTime time ,
@EndTime time  ,
@TotalDegree int ,
@IntakeBranchTrackId int ,
@CourseId int,
@DayOfExam date
)
as
begin
	declare @CourseMaxDegree int 
	 
	if exists(select 1 from Exam.Course as c where c.Id = @CourseId)
	begin
		select @CourseMaxDegree =MaxDegree from Exam.Course as c where c.Id = @CourseId;
		if (@DayOfExam > GETDATE())
		begin
			if(@EndTime > @StartTime)
			begin
				if(@TotalDegree =@CourseMaxDegree)
				 begin
					if(@Type in ('exam' , 'corective'))
					begin
						if exists ( select * from Exam.IntakeBranchTrack where Id = @IntakeBranchTrackId )
						begin
						 if(len(@Name)>=3)
						 begin 
							----- insertt ---
							insert into Exam.Exams ([Name] , [Type],StartTime,EndTime , TotalDegree , IntakeBranchTrackId,CourseId,DayOFExam)
							values (@Name , @Type, @StartTime ,@EndTime , @TotalDegree,@IntakeBranchTrackId , @CourseId,@DayOfExam);
						 end
						 else
						 throw 51000,'incorrect Name Must BE above 3 Char ',16;

						end
						else 
							throw 51000,'incorrect intake branch track ',16;
							
					end
					else
						throw 51000,'Type of Exame Must Be exam or corective ',16;

				 end
				 else
					throw 51000,'Invalid total degree Check Course Degree',16;

			end
			else
				throw 51000,'End Time Must Be Greater Than Start time',16;
		end
		else 
				throw 51000,'Invalid date , date must be greater than today ',16;


	end
	else 
		throw 51000,'Invalid Course Id ',16;

end


begin try
exec AddEXam @Name = 'Test Case',
@Type ='exam',
@StartTime ='06:30',
@EndTime ='07:30'  ,
@TotalDegree =100 ,
@IntakeBranchTrackId =1 ,
@CourseId =1,
@DayOfExam ='2023-09-01' 
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch
--- Update exams
go
Create  trigger UpdateExam
on [Exam].[Exams]
Instead of UPDATE
AS
BEGIN
declare @OldExamId int ,@NewCourseID int ,
@NewName varchar(30),
@NewType varchar(10),
@NewStartTime time ,
@NewEndTime time  ,
@NewTotalDegree int ,
@NewIntakeBranchTrackId int,
@NewDayOfExam date;
		select @OldExamId =deleted.Id from deleted;

		select @NewCourseID=i.CourseId , @NewName = i.[Name] , @NewType = i.[Type],@NewEndTime =i.EndTime , @NewStartTime =i.StartTime , @NewTotalDegree = i.TotalDegree , @NewIntakeBranchTrackId = i.IntakeBranchTrackId , @NewDayOfExam=i.DayOFExam

		from inserted as i;

		if exists(select 1 from Exam.Course as c where c.Id = @NewCourseID )
			begin
				if (@NewDayOfExam > GETDATE())
				begin
					if(@NewEndTime >@NewStartTime )
					begin
						if((select MaxDegree from Exam.Course where Id =@NewCourseID ) =@NewTotalDegree)
						 begin
							if( @NewType in ('exam' , 'corective'))
							begin
								if exists ( select 1 from Exam.IntakeBranchTrack where Id = @NewIntakeBranchTrackId )
								begin
								
								 if(len(@NewName)>=3)
								 begin 
									----- UpDate ---
									update Exam.Exams 
									set  CourseId = @NewCourseID,
									[Name] = @NewName,
									[Type] = @NewType,
									StartTime = @NewStartTime,
									EndTime = @NewEndTime,
									TotalDegree = @NewTotalDegree,
									DayOFExam = @NewDayOfExam,
									IntakeBranchTrackId = @NewIntakeBranchTrackId
									where Id = @OldExamId

								 end
								 else
								 throw 51000,'incorrect Name Must BE above 3 Char ',16;

								end
								else 
									throw 51000,'incorrect intake branch track ',16;
							
							end
							else
								throw 51000,'Type of Exame Must Be exam or corective ',16;

						 end
						 else
							throw 51000,'Invalid total degree Check Course Degree',16;

					end
					else
						throw 51000,'End Time Must Be Greater Than Start time',16;
				end
				else 
						throw 51000,'Invalid date , date must be greater than today ',16;


			end
			else 
				throw 51000,'Invalid Course Id ',16;


END

begin try
update Exam.Exams
set [Name] = 'new test',
[Type] ='exam',
[StartTime] ='05:30',
EndTime ='07:30'  ,
TotalDegree =100 ,
IntakeBranchTrackId =2 ,
CourseId =2,
DayOFExam ='2023-09-20' 
where Id = 12
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch

select * from Exam.Exams
select * from exam.Exams
select * from exam.Course
select * from exam.Questions
select * from Exam.Instractor 
select * from Exam.ExamQuestion;

--- add quetion to exam 
create or alter  proc AddQuestiontToExam 
(
@InstractorId int,
@CourseId int,
@ExamId int,
@QuestionId Int,
@Degree int
)
as 
begin
	if exists(select 1 from Exam.Instractor where Id = @InstractorId)
	begin
		if exists (select 1 from Exam.Course where Id = @CourseId )
		begin
			if exists (select 1 from Exam.Course where InstractorId = @InstractorId)
				begin
					if exists( select 1 from Exam.Exams where id = @ExamId )
					begin
						if exists(select 1 from Exam.Exams where CourseId = @CourseId)
						begin
						--
						if exists (Select 1 From Exam.Questions where Id = @QuestionId)
						begin
							if exists(Select 1 From Exam.Questions where CourseId = @CourseId )
							begin
							-----
								declare @CurrentTotalDegree int;
								select @CurrentTotalDegree =sum(e.Degree)				from Exam.ExamQuestion as e
								where e.[ExamId] = @ExamId 
								group by e.[ExamId];

								if( @CurrentTotalDegree < (select TotalDegree from Exam.Exams where Id = @ExamId )) and (@CurrentTotalDegree > 0)
								begin
								-----
								insert into [Exam].[ExamQuestion]		(Degree ,QuestionsId,[ExamId])
								values (@Degree,@QuestionId,@ExamId);
								----
								end
								else
								throw 51000,'Cant not Add Question Because the current totoal degree Greater Than Exam Degree And Degree must be greater than Zero ',16;

							end
							else
								throw 51000,'this Question not belong to this course',16;
						end
						else
							throw 51000,'Invalid Question Id',16
						end
						else
							throw 51000,'this Exam not belong to this course',16;

					end
					else
					throw 51000,'Invalid Exam Id',16;

				end
				else
				Throw 51000,'Instractor dont Teach this Course ',16;

		end
		else
		Throw 51000,'Ivalid Course ID',16;
	end
	else
		throw 51000,'Invalid  Instractor ID', 16;
end

begin try
exec AddQuestiontToExam 
@InstractorId=1 ,
@CourseId=1 ,
@ExamId= 1,
@QuestionId = 3 ,
@Degree = 10 ;
end try
begin catch
	select ERROR_MESSAGE();
end catch



--- student take exam 
create or alter  proc ValidStudentAndShowExam 
(
@StudentId int ,
@CourseId int ,
@StartTime time,
@DayOfExam Date,
@Type varchar(10) ---('exam' , 'corective')
)
As
Begin 
	if exists (select 1 from Exam.Student where Id = @StudentId)
	begin
		IF exists( select 1 from Exam.StudentCourse where CourseId = @CourseId and StudentId = @StudentId)
		begin
		declare  @ExamId int ;
				 select @ExamId= e.Id from Exam.Exams as e
				 where e.DayOFExam = @DayOfExam and e.[Type] = @Type and
				 e.StartTime = @StartTime and e.CourseId =@CourseId;
			If exists( select 1 from Exam.Exams where Id = @ExamId and DayOFExam=@DayOfExam )
			begin
			If exists( select 1 from Exam.Exams where Id = @ExamId and StartTime=@StartTime )
			begin
				if exists(select 1 from Exam.Exams where Id = @ExamId and [Type]=@Type )
				begin
				----- get exam id ---- 
				 
				 declare @Questions table 
				 (
					quetionId int
				 );
				 insert into @Questions 
				 select QuestionsId from Exam.ExamQuestion where [ExamId] =@ExamId;

				 ----
					select q.Id as 'Question Id' ,q.Content AS ' Question ', a.Answer AS ' Answers '
					 from Exam.Questions as q
					join Exam.QuestionsAnswer as a
					on q.Id = a.QuestionId
					where CourseId = @CourseId and q.Id in (select quetionId from @Questions ) ;


				end
				else
				throw 51000,'Please enter the rirht type of exam ',16;

			end
			else
				throw 51000,'Please enter in the Time of exam ',16;


			end
			else
				throw 51000,'Please enter in the day of exam ',16;

		end
		else
				throw 51000,'Student Not Enroll in this course ',16;

	end
	else
		throw 51000,'Invalid Student ID',16;

End


begin try
exec ValidStudentAndShowExam 
@StudentId =1 ,
@CourseId =1 ,
@StartTime ='11:30',
@DayOfExam ='2023-11-03',
@Type = 'exam'---('exam' , 'corective')

end try
begin catch
	select ERROR_MESSAGE();
end catch


----next proc
create or alter proc AnswerQuestion 
(
@StudentId int ,
@QuetionId int,
@Answer varchar(30),
@examId int
)
as
begin 
	if not exists (select 1 from Exam.ExamAnswer where StudentId = @StudentId and QuestionsId = @QuetionId and ExamId = @examId )
	begin
				if exists(select 1 from Exam.Questions where Id = @QuetionId)
		begin
			declare @CorrectAns varchar(30) ,@Falg int, @Degree int ;

			select @CorrectAns =a.Answer from Exam.QuestionsAnswer as a
			where QuestionId = @QuetionId  and Flag = 1 ;


			if(@CorrectAns = @Answer and len(@Answer) > 0 )
			begin
				select @Degree =eq.Degree from Exam.ExamQuestion as eq
				where eq.QuestionsId = @QuetionId and eq.[ExamId] =@examId;
				set @Falg = 1;
			end
			else if(@CorrectAns != @Answer and len(@Answer) > 0)
			begin
				set @Degree = 0;
				set @Falg = 0;
			end
			else
				throw 51000,'Select answer from Choice plz ',16
			
			-----
			insert into Exam.ExamAnswer (AnswerText , Flag , Degree ,StudentId,QuestionsId ,[ExamId] )
			values (@Answer , @Falg ,@Degree,@StudentId ,@QuetionId ,@examId);
			-----

		end
		else
			throw 51000,'invalid questuion ID',16;

	end
	else
	throw 51000,'You Answered This Question Before',16;
end
begin try
exec AnswerQuestion 
@StudentId =1 ,
@QuetionId =2,
@Answer ='::',
@examId =1;
end try
begin catch
	select ERROR_MESSAGE();
end catch
---------------------------------------
create or alter proc GetDegreeOfStudent
(
	@ExamId int ,
	@StudentId int
)
as
Begin
	if exists (select 1 from Exam.Exams where Id = @ExamId  )
	and exists (select 1 from Exam.ExamAnswer where ExamId = @ExamId and StudentId = @StudentId )
	begin
		declare @TotalDegree int , @CourseId int, @type varchar(10),
		@StartTime time ,@EndTime time,@ExamDegree int ;
		select @CourseId = CourseId , @type = [Type] ,@StartTime = StartTime ,@EndTime = EndTime,@ExamDegree = TotalDegree  from Exam.Exams where Id = @ExamId;
		if exists (select 1 from Exam.StudentCourse where StudentId = @StudentId and CourseId = @CourseId)
		begin
		if not exists (select 1 from Exam.ExamsResult where StudentId = @StudentId and [ExamId] = @ExamId)
		begin
					select @TotalDegree = sum(Degree) from Exam.ExamAnswer 
		where ExamId = @ExamId and StudentId = @StudentId and Flag = 1;
		-----
		insert into [Exam].[ExamsResult]([Type],StartTime,EndTime,TotalDegreeStudent,TotalDegreeExam , StudentId ,CourseId,[ExamId])
		values 
		(@type , @StartTime ,@EndTime , @TotalDegree , @ExamDegree,@StudentId,@CourseId,@ExamId);


		end
		else
			throw 51000,'this result  Exists ',16
		end
		else
			throw 51000 , 'Invalid Student ID',16
		
	end
	else
		throw 51000,'Student Not Attend This Exame ',16
end

begin try
exec GetDegreeOfStudent
	@ExamId = 1,
	@StudentId =1;
end try
begin catch
		select ERROR_MESSAGE();
end catch

--- prevent delete exam

select * from Exam.QuestionsAnswer 
select * from Exam.ExamAnswer;
select * from Exam.Exams;
select * from exam.Course;
select * from Exam.Student;
select * from Exam.StudentCourse
select * from Exam.QuestionsAnswer
select * from exam.ExamQuestion;
select * from Exam.ExamsResult;
select * from exam.Questions;



