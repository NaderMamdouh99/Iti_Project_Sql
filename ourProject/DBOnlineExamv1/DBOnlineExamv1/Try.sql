---- uere Register ------
exec Register @UserName= 'NewUser1@Yahoo.com' , @Phone='01142202287',
@FirstName='Sherif',@LastName='Atef',
@City='asuit',@StreetName='elnames',@DOB='2012-07-19',@Password='12345678Cr7';
exec Register @UserName= 'NewUser2@Yahoo.com' , @Phone='01142202288',
@FirstName='Sherif',@LastName='Atef',@City='asuit',
@StreetName='elnames',@DOB='2012-07-19',@Password='12345678Cr7';
exec Register @UserName= 'NewUser3@Yahoo.com' , @Phone='01142202289',
@FirstName='Sherif',@LastName='Atef',@City='asuit',
@StreetName='elnames',@DOB='2012-07-19',@Password='12345678Cr7';
exec Register @UserName= 'NewUser4@Yahoo.com' , @Phone='01142202205',
@FirstName='Sherif',@LastName='Atef',@City='asuit',
@StreetName='elnames',@DOB='2012-07-19',@Password='12345678Cr7';
select * from [Exam].[User]
---- update user data----
exec UpdateUser @UserName='NewUser@Yahoo.com' , 
@NewUserName= 'NewUser@Gmail.com', 
@Phone='01142202287',
@FirstName='hesham',
@LastName='Galal',
@City='asuit',@StreetName='elnames',@DOB='2012-07-19',@Password='12345678asd';
select * from [Exam].[User]
----------- user is prevent deleted --------
begin try
delete  Exam.[User] 
where  Id = 1;
end try
begin catch
   select ERROR_MESSAGE();
end catch
select * from [Exam].[User]
--------------------------- Add Instractor  ---------------------------------------
begin try
exec ADD_Instractor @UserID=9,@MangerID=1,@BranchId=1,@DepartementId=1
end try
begin catch
	select ERROR_MESSAGE()
end catch
select * from Exam.Instractor;
------------------  Add Branch  -------------------------
Exec InsToBranch 'El Mansoura', 4;
select * from Exam.Branch;
----------------- Add Departement --------------------
exec InsToDeprtment 'Internet Of Things IOS' , 4;
select * from Exam.Departmant;

----------------- update instractor ------------------------
begin try
	update Exam.Instractor
	set 
	UserId = 10,
	DepartmantId=2,
	BranchId = 6,
	MangerId =2
	where Id=4
end try
begin catch
	select ERROR_MESSAGE();
end catch
------------------ add Student ----------------
begin try
exec ADD_Student @UserID=11,@IntakeBranchId=1,@DepartementId=1
end try
begin catch
	select ERROR_MESSAGE()
end catch

select * from Exam.Student;
-------------------update student ---------------------
begin try
	update Exam.Student
	set UserId = 11,
	DepartmantId=2
	where Id=6
end try
begin catch
	select ERROR_MESSAGE();
end catch
------------------------ Add Exam----------------------------------
begin try
exec
AddEXam @Name = 'Test Case',
@Type ='exam',
@StartTime ='06:30',
@EndTime ='07:30'  ,
@TotalDegree =100 ,
@IntakeBranchTrackId =1 ,
@CourseId =1,
@DayOfExam ='2023-10-01' 
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch
select * from Exam.Exams
-----------update exam -------------
begin try
update Exam.Exams
set [Name] = 'new test 1',
[Type] ='exam',
[StartTime] ='05:30',
EndTime ='07:30'  ,
TotalDegree =100 ,
IntakeBranchTrackId =2 ,
CourseId =2,
DayOFExam ='2023-09-20' 
where Id = 13
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch
select * from Exam.Exams
-------------------add question to Exam-----------------------------
begin try
exec AddQuestiontToExam 
@InstractorId=1 ,
@CourseId= 1 ,
@ExamId= 2,
@QuestionId = 4 ,
@Degree = 10 ;
end try
begin catch
	select ERROR_MESSAGE();
end catch

select * from Exam.Course;
select * from Exam.Exams;
select * from Exam.ExamQuestion;
---------------- valid student show him exam---------------------------------

begin try
exec ValidStudentAndShowExam 
@StudentId =2 ,
@CourseId =1 ,
@StartTime ='11:30',
@DayOfExam ='2023-11-03',
@Type = 'exam'---('exam' , 'corective')
end try
begin catch
	select ERROR_MESSAGE();
end catch

------------ then answer the exame -------------------

begin try
exec AnswerQuestion 
@StudentId =2 ,
@QuetionId =1,
@Answer ='::',
@examId =1;
end try
begin catch
	select ERROR_MESSAGE();
end catch


----------- get degree -----

begin try
exec GetDegreeOfStudent
	@ExamId = 1,
	@StudentId =2;
end try
begin catch
		select ERROR_MESSAGE();
end catch

select * from Exam.ExamsResult;
--------------------- add text Question  ------------------------
begin try
exec Add_Question_Text
 @QuestionContent ='New Question test pro max 13',@CourseId = 7,@QuestionTypeId = 1, @AnserText = 'this is the right anser';
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch
select * from Exam.Questions;
select * from Exam.QuestionsAnswer;
-------------- add choice q--------
begin try
exec  Add_Question_Choice 
@QuestionContent ='new question choice 306070',
@CourseId =7,
@QuestionTypeId =2 ,
@ch1 ='CH1',
@ch2 = 'CH2',
@ch3 = 'Ch13' , 
@CorrectAnser = 'CH correct 1';
end try
begin catch
		select ERROR_MESSAGE() as 'Error';
end catch
select * from Exam.Questions;
select * from Exam.QuestionsAnswer;
----------------add question t & f

begin try
 exec Add_Question_TAndF 
@QuestionContent = 'this New Question True And False 2',
@CourseId = 7,
@QuestionTypeId = 3,
@CorrectAnser = 'false';
end try
begin catch
		select ERROR_MESSAGE() as 'Error';
end catch
select * from Exam.Questions;
select * from Exam.QuestionsAnswer;
-------------------- update question ------------------
begin try
	update Exam.Questions 
	set Content = 'new content from update pro max 13',
	CourseId = 7,
	TypeId =3
	where
	Id =42;
end try
begin catch
		select ERROR_MESSAGE() as 'Error';
end catch

select * from Exam.Questions;
select * from Exam.QuestionsAnswer;

--------------------- Add Course -----------------
exec Add_Coursee @Crs_Name = 'New Course2',
@Crs_MaxDegree = 100,@Crs_MinDegree = 30,
@Crs_Discraption='this is new Course2 ',@Crs_InstractorId=2
select * from [Exam].[Course]
--------------------- Update Course ---------------------
exec Update_Coursee @Crs_Id=8,@Crs_Name='php',@Crs_MaxDegree=100,@Crs_MinDegree=30,
@Crs_Discraption='Introduction to Php',@Crs_InstractorId=1

select * from Exam.[Course]
------------------------ prevent delete course -------------
begin try
delete  Exam.Course where Id = 8;
end try
begin catch
   select ERROR_MESSAGE()

end catch
----------------------- Add Intake --------------------------
exec  Add_Intake @In_Id = 49 , @In_Name = 'Intake 49',@In_Year = '2023-10-01'
select * from [Exam].[Intake]
----------------------- Update Intake --------------------------
exec Update_Intake @In_Id=44,@In_Name='Intake 54',@In_Year='2024-07-01'
select * from [Exam].[Intake]
---------------------  prevention update and delete intake ----------
begin try
   delete  [Exam].[Intake]
   where Id=42
end try
begin catch
   select ERROR_MESSAGE();
end catch
----------------- Update Departement -------------------
begin try 
update Exam.Departmant
set 
Name = 'new name',
ManagerId = 3
where Id =5
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch
select * from Exam.Departmant;
------------------ Delete Departement -------------------
begin try 
delete from  Exam.Departmant
where Id =5
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch

-------------------Add Track----------------------
begin try
exec Add_Track '. Development',7
end try
begin catch
select ERROR_MESSAGE()
end catch
---------------------Update Track-----------------
begin try

update Exam.Track
 SET [NameTrack]='AYMAN'
 WHERE ID=55
end try
begin catch
select ERROR_MESSAGE()
end catch
------------------ Updata Branch --------------------
SELECT * FROM [Exam].[Branch]
exec UpdatInBranch 'nnnn',1000	
-----------------------------------------------------------------------
-------------------View Student Fullname and Department----------
select * from StudentInDepartmant
-------------------View Instractor Fullname and Department----------
select * from InstractorInDepartmant
------------------- View Student Fullname and Courses-------------
select * from StudentNameInCourse;
------------------- View Instractor Fullname and Courses and Max and Min Degrees ------------
select * from InstractorNameInCourse
------------------View Instractor with Course Name and Discraption and The Track------
select * from In_Course_Discraption_Track
------------------ View Manger Name For Instractor (Self Join)-------------
select * from MangerforInstractor


