-- Add Questions 
Create or alter proc Add_Question_Text 
(
@QuestionContent varchar(Max),
@CourseId int,
@QuestionTypeId int ,
@AnserText Varchar(max)
)
as
begin
	IF Not EXISTS(select 1 from [Exam].[Questions] where [Content]= @QuestionContent)
	begin
		if (@QuestionContent !='' and @QuestionContent is not null )
		begin
			if(@QuestionTypeId=1)
			begin
				if exists (select 1 from Exam.Course where Id = @CourseId)
				begin
					insert into [Exam].[Questions]([Content],[CourseId],[TypeId])
						values (@QuestionContent,@CourseId,@QuestionTypeId) 
					if(@AnserText is not null and LEN(@AnserText) > 5)
					begin
						insert into Exam.QuestionsAnswer(Flag,Answer,QuestionId)
						values (1,@AnserText,@@IDENTITY);
					end
					else
						throw 51000,'Question Answer Must Be Greater Than 5 And Not NUll',16 ;


				end
				else
					throw 51000,'Invalid Course Name',16;
			end
			else
				throw 51000,' Question type of text must be 1 ',16; 

		end
		else
			throw 51000,'Question Cant Be Empty Or Null',16 ;

	end
	else
		throw 51000,'Question Oready Exists',16; 


end

begin try
exec Add_Question_Text
 @QuestionContent ='New Question test1234555',@CourseId = 7,@QuestionTypeId = 1, @AnserText = null;
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch

--- add question of type Choices
go

Create or alter proc Add_Question_Choice 
(
@QuestionContent varchar(Max),
@CourseId int,
@QuestionTypeId int,
@ch1 Varchar(max),
@ch2 Varchar(max),
@ch3 Varchar(max), 
@CorrectAnser varchar(max)
)
as
begin
	IF Not EXISTS(select 1 from [Exam].[Questions] where [Content]= @QuestionContent)
	begin
		if (@QuestionContent !='' and @QuestionContent is not null )
		begin
			if(@QuestionTypeId=2)
			begin
				if exists (select 1 from Exam.Course where Id = @CourseId)
				begin
					
						if((@ch1 is not null and LEN(@ch1) >= 1) and(@ch2 is not null and LEN(@ch2) >= 1) and(@ch3 is not null and LEN(@ch3) >= 1) and @CorrectAnser is not null and LEN(@CorrectAnser) >= 1 )
						begin

							if(@ch1 !=@ch2 and @ch1 !=@ch3 and @ch1 !=@CorrectAnser and @ch2 !=@ch3 and @ch2 !=@CorrectAnser and @Ch3 != @CorrectAnser )
							begin
							begin TRANSACTION  T1
							insert into [Exam].[Questions]([Content],[CourseId],		[TypeId])
							values (@QuestionContent,@CourseId,@QuestionTypeId) 
							declare @QuestionId int ;
							set @QuestionId = @@IDENTITY;
							insert into Exam.QuestionsAnswer(Flag,Answer,QuestionId)
							values (0,@ch1,@QuestionId);
							insert into Exam.QuestionsAnswer(Flag,Answer,QuestionId)
							values (0,@ch2,@QuestionId);
							insert into Exam.QuestionsAnswer(Flag,Answer,QuestionId)
							values (0,@ch3,@QuestionId);
							insert into Exam.QuestionsAnswer(Flag,Answer,QuestionId)
							values (1,@CorrectAnser,@QuestionId);
							commit transaction T1;
							
							
							end
							else
								throw 51000,'Answers Must Be Not Same ',16;
						end
						else
							Throw  51000,'Invalid Answers',16;
				end
				else
					throw 51000,'Invalid Course Name',16;
			end
			else
				throw 51000,' Question type of text must be 2 ',16; 

		end
		else
			throw 51000,'Question Cant Be Empty Or Null',16 ;

	end
	else
		throw 51000,'Question Oready Exists',16; 


end

begin try
exec  Add_Question_Choice 
@QuestionContent ='new question choice   19',
@CourseId =7,
@QuestionTypeId =2 ,
@ch1 ='CH',
@ch2 = 'CH',
@ch3 = 'Ch1' , 
@CorrectAnser = 'CH correct';
end try
begin catch
		select ERROR_MESSAGE() as 'Error';
end catch

select * from [Exam].[Questions];
select * from [Exam].[QuestionsAnswer];
select * from [Exam].[QuestionsType];
 
 --------------------------------Add Question TRUE OR FALSE----------------------
 go
 Create or alter proc Add_Question_TAndF 
(
@QuestionContent varchar(Max),
@CourseId int,
@QuestionTypeId int,
@CorrectAnser varchar(max)
)
as
begin
	IF Not EXISTS(select 1 from [Exam].[Questions] where [Content]= @QuestionContent)
	begin
		if (@QuestionContent !='' and @QuestionContent is not null )
		begin
			if(@QuestionTypeId=3)
			begin
				if exists (select 1 from Exam.Course where Id = @CourseId)
				begin
						if(LOWER( @CorrectAnser )= 'true'  )
							begin
							begin TRANSACTION  T1
							insert into [Exam].[Questions]([Content],[CourseId],		[TypeId])
							values (@QuestionContent,@CourseId,@QuestionTypeId) 
							declare @QuestionId int ;
							set @QuestionId = @@IDENTITY;
							insert into Exam.QuestionsAnswer(Flag,Answer,QuestionId)
							values (0,'False',@QuestionId);
							insert into Exam.QuestionsAnswer(Flag,Answer,QuestionId)
							values (1,'True',@QuestionId);
							commit transaction T1;
							
							
							end
							else if(LOWER( @CorrectAnser )= 'false' )
							begin
								begin TRANSACTION  TF
							insert into [Exam].[Questions]([Content],[CourseId],		[TypeId])
							values (@QuestionContent,@CourseId,@QuestionTypeId) 
							declare @QId int ;
							set @QId = @@IDENTITY;
							insert into Exam.QuestionsAnswer(Flag,Answer,QuestionId)
							values (1,'False',@QId);
							insert into Exam.QuestionsAnswer(Flag,Answer,QuestionId)
							values (0,'True',@QId);
							commit transaction Tf;
							end
							else
								throw 51000,'Answers Must Be Not Same ',16;
				end
				else
					throw 51000,'Invalid Course Name',16;
			end
			else
				throw 51000,' Question type of text must be 2 ',16; 

		end
		else
			throw 51000,'Question Cant Be Empty Or Null',16 ;

	end
	else
		throw 51000,'Question Oready Exists',16; 


end


begin try
 exec Add_Question_TAndF 
@QuestionContent = 'this New Question True And False',
@CourseId = 7,
@QuestionTypeId = 3,
@CorrectAnser = 'True';
end try
begin catch
		select ERROR_MESSAGE() as 'Error';
end catch




select * from Exam.Questions;
select * from Exam.QuestionsAnswer;

-------------------------- update ---------------
--Update Questions
go
create trigger Update_Question
on [Exam].[Questions]
instead of update 
as
begin
declare @NewContent varchar(max) , @NewCourseId INT ,@NewTypeID int ,@OldTypeID int,@QuestionId int ;
select @NewContent = inserted.Content,@NewCourseId = inserted.CourseId , @NewTypeID = inserted.TypeId , @QuestionId = inserted.Id from inserted;

select @OldTypeID=deleted.TypeId from deleted;
if exists (select 1 from Exam.Questions where Id = @QuestionId)
begin
	IF	not EXISTS(select 1 from Exam.Questions where Content =@NewContent)
	begin
		if exists (select 1 from Exam.Questions where CourseId =@NewCourseId )
		begin
			if(@NewTypeID = @OldTypeID)
			begin
				update Exam.Questions 
				set Content = @NewContent,
				CourseId = @NewCourseId
				where Id = @QuestionId
			end
			else
			throw 51000,'You Cant NOT Change Question Type ',16;
		end
		else
			throw 51000,'Invalid Course Id',16;
	end
	else
		throw 51000,'Reapeated Question ',16;
end
else
	throw 51000,'Invalid Question ID ',16

end

begin try
	update Exam.Questions 
	set Content = 'new content from updaete000',
	CourseId = 7,
	TypeId =3
	where
	Id =42;
end try
begin catch
		select ERROR_MESSAGE() as 'Error';
end catch
select * from [Exam].[Questions];

------------------------------ ------------------------------