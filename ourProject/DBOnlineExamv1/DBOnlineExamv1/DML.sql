use [ExamSystem];
insert into [ExamSystem].[Exam].[User](UserName,Password,Phone,FirstName,LastName,City,StreetName,Birthdate,Age) 
values('hesham.m7md99@gmail.com','Asd123456@','01142202287','hesham','mohamed','asuit','el Gomhrya' , '1999-07-19', 24);

insert into [ExamSystem].[Exam].[User](UserName,Password,Phone,FirstName,LastName,City,StreetName,Birthdate,Age) 
values ('ayman0106210@gmail.com','Asd987654','01062103267','AYMAN','mohamed','CAIRO','NASR CITY' , GETDATE() , 25),('AHMED ALI@gmail.com','Asd988554','01162103267','AHMED','ALI','ASWAN','NOBA' , GETDATE() , 27);

insert into [ExamSystem].[Exam].[User](UserName,Password,Phone,FirstName,LastName,City,StreetName,Birthdate,Age) 
values ('Nader@gmail.com','Asd987654','01062103267','Nader','mohamed','CAIRO','NASR CITY' , GETDATE() , 30),
('Sayed@gmail.com','Asd549870','01023236319','Mohamed','ataf','ASWAN','NOBA' , GETDATE() , 27) 
,
('aya1953@gmail.com','Aya@556090','01062103267','Aya','Gmal','CAIRO','NASR CITY' , GETDATE() , 25),
('GalalTawfiq@gmail.com','Asdrf124589','01061624589','Galal','ALI','ASWAN','NOBA' , GETDATE() , 27);



select * from [ExamSystem].[Exam].[User];



------------------test -------------------

insert into Exam.Instractor(UserId ,DepartmantId,BranchId )
values (1,null ,null),
		(2,null,null);




insert into Exam.Branch(NameBranch,MangerId) 
values ('asuit' , 1),('minya',2)

insert into Exam.Departmant(Name,ManageRId) 
values ('SoftWare Development' , 1),('Web Development',2)


update Exam.Instractor 
set BranchId = 1 ,  DepartmantId = 1
where Id = 1;
update Exam.Instractor 
set BranchId = 2 ,  DepartmantId = 2
where Id = 2;
update Exam.Instractor 
set [MangerId] = 1
where Id = 2;

insert into Exam.Track (NameTrack,SupervisiorId)
values ('.Net Development' , 1),('Python' , 2);

-----------------------intake------------------------------
insert into Exam.Intake (Id,Name , year)
values(40,'Intake 40','2020-7-01'),
(41,'Intake 41','2021-7-01'),
(42,'Intake 42','2022-7-01'),
(43,'Intake 43','2023-7-01');

select * from Exam.Intake
--------course ---
insert into Exam.Course (Name,Discraption,MaxDegree,MinDegree,InstractorId)
values ('C Sharp', 'Introduction to C Sharp',100,50,1), --3 ---> Instructor id
('JAVA', 'Introduction to Java',100,30,1),
('JavaScript', 'Introduction to JS',100,30,1),
('Pyton', 'Introduction to C Python',100,50,2), ---4 ---> Instructor id
('HTML', 'Hyper Text MarkUp Language',100,30,2),
('CSS', 'Cascading Style Sheet',100,30,2);


select * from Exam.Course
----- intake pranch track ----
insert into Exam.IntakeBranchTrack (IntakeId,BranchId,TrackId)
values (40,1,1) ,(40,1,2),(40,2,1),(40,2,2),(41,1,1);
select * from Exam.Intake;
select * from Exam.Branch;
select * from Exam.Track;
select * from Exam.IntakeBranchTrack;

----------track instractor ------------
insert into Exam.TrackInstactor
values (1,1),(1,2),(2,2);

select * from [Exam].[Instractor];
select * from [Exam].[Track];
select * from Exam.TrackInstactor
----------- exam ----

select * from Exam.Course
select * from [Exam].[IntakeBranchTrack]
insert into Exam.Exams([Name],[Type],TotalDegree,StartTime,EndTime,IntakeBranchTrackId,CourseId)
values ('c sharp','exam',100,'11:30','12:30',1,1),
('c sharp','corective',100,'11:30','12:30',1,1),
('java','exam',100,'11:30','12:30',1,2),
('java','corective',100,'12:30','13:30',1,2),
('html','exam',100,'12:30','13:30',2,5),
('html','corective',100,'09:30','10:30',2,5),
('css 3','exam',100,'09:30','10:30',2,6),
('css 3','corective',100,'11:30','12:30',2,6),
('python','exam',100,'11:30','12:30',1,4),
('python','corective',100,'09:30','10:30',1,4);

select * from Exam.Exams;
------------------student------------
select * from Exam.[User]
select * from Exam.Course;
select * from Exam.Departmant;
select * from Exam.IntakeBranchTrack;

insert into Exam.Student(UserId,DepartmantId,IntakeBranchTrackID)
values
(3,1,1),
(4,1,1),
(5,1,2),
(6,2,2),
(7,2,3);
select * from Exam.Student
select * from [Exam].[Course]
-------------------------------
insert into [Exam].[StudentCourse]([StudentId] ,[CourseId] )
values
(1,1),(1,2),(2,1),(2,4),(3,5),(4,4),(5,6);

select * from [Exam].[StudentCourse];

----------------------------
select * from Exam.Student
select * from[Exam].[Exams]

insert into  [Exam].[SpaseficExam]([ExamId] ,[StudentId] )
values (1,1),(2,1)
select * from [Exam].[SpaseficExam]
-------------------------------------------
insert into Exam.QuestionsType(Id,[Type]) 
values (1,'text') , (2,'muliuable choice'),(3,'true or false');
select * from Exam.QuestionsType
-----------------------------------------------
insert into Exam.Questions(Content,CourseId,TypeId)
values (' Which of the following is used to define the member of a class externally?' , 1 ,2),
('  What is the most specified using class declaration?' , 1 ,2),
('  Which of the following statements about objects in “C#” is correct?' , 1 ,2),
(' Which of the following is/are not Relational operators in C#.NET?' , 1 ,2),
(' Which of the following statements are correct about functions?' , 1 ,2),
('How many values does a function return' , 1 ,2),
(' Correct statement about constructors in C#.NET is?' , 1 ,2),
(' Which among the following is the correct statement: Constructors are used to?' , 1 ,2),
(' Which of the following statements is correct about constructors in C#.NET?' , 1 ,2),
(' What is the return type of constructors?' , 1 ,2),


(' C# is an alias of C++' , 1 ,3),
(' We can use reserved keywords as identifiers in C#?' , 1 ,3),
('Dynamic polymorphism is implemented by abstract classes and virtual functions.' , 1 ,3),
(' The System.SystemException class is the base class for all predefined system exception in C#?' , 1 ,3),
(' C# does not support multiple inheritance' , 1 ,3),
('Value type variables in C# are derived from the class System.ValueType?
' , 1 ,3),
('  A class can inherit one or more Structs' , 1 ,3),
('can print eny thing in c# ' , 1 ,3),
('c# is a oop' , 1 ,3);


insert into Exam.Questions(Content,CourseId,TypeId)
values (' Who invented Java Programming? ' , 2 ,2),
('Which statement is true about Java? ' , 2 ,2),
(' Which component is used to compile, debug and execute the java programs? ' , 2 ,2),
(' JDK is a core component of Java Environment and provides all the tools, executables and binaries required to compile, debug and execute a Java Program' , 2 ,2),
('Which of these cannot be used for a variable name in Java? ' , 2 ,2),
(' Which of the following is not an OOPS concept in Java?' , 2 ,2),
('  What is not the use of “this” keyword in Java?' , 2 ,2),
(' What is Truncation in Java? ' , 2 ,2),
('  What is the extension of compiled java classes? ' , 2 ,2),
(' Who invented Java Programming? ' , 2 ,2),
('Which of the following language was developed as the first purely object programming language?
' , 2 ,2)

select * from Exam.Questions 
----------------------------------------------------
insert into Exam.QuestionsAnswer (Answer,Flag,QuestionId)
values(':' , 0 ,1),
('::' , 1 ,1),
('#' , 0 ,1),
('none of the mentioned' , 0 ,1),
('type' , 0 ,2),
('scope' , 0 ,2),
('type & scope
' , 1 ,2),
('none of the mentioned
' , 0 ,2),
('Everything you use in C# is an object, including Windows Forms and controls
' , 0 ,3),
('b) Objects have methods and events that allow them to perform actions' , 0 ,3),
('c) All objects created from a class will occupy equal number of bytes in memory' , 0 ,3),
('d) All of the mentioned' , 1 ,3),
('>=' , 0 ,4),
('<>=' , 1 ,4),
('Not' , 0,4),
('<=' , 0,4),
('C# allows a function to have arguments with default values' , 1,5),
('Redefining a method parameter in the method’s body causes an exception' , 0,5),
('C# allows function to have arguments with default values
' , 0,5),
('Omitting the return type in method definition results into exception
' , 0,5),
('0' , 0,6),
('2' , 0,6),
('1' , 1,6),
('any number of values' , 0,6),
('Constructors can be overloaded' , 0,7),
('Constructors are never called explicitly' , 0,7),
('Constructors have same name as name of the class' , 0,7),
('All of the mentioned' , 1,7),
('initialize the objects' , 1,8),
('construct the data members' , 0,8),
('initialize the objects & construct the data members' , 0,8)
,('none of the mentioned
' , 0,8),
('A constructor cannot be declared as private' , 0,9),
('A constructor cannot be overloaded' , 0,9),
('A constructor can be a static constructor'
 , 1,9)
,('None of the mentioned
' , 0,9),
('int' , 0,10),
('float' , 0,10),
('void', 0,10)
,('None of the mentioned
' , 1,10),
('True' , 1,11),
('False' , 0,11),
('True' , 0,12),
('False' , 1,12),
('True' , 1,13),
('False' , 0,13),
('True' , 1,14),
('False' , 0,14),
('True' , 1,15),
('False' , 0,15),
('True' , 1,16),
('False' , 0,16),
('True' , 1,17),
('False' , 0,17),
('True' , 1,18),
('False' , 0,18),
('True' , 1,19),
('False' , 0,19);
---- insert  Question -------

select * from Exam.Questions
insert into Exam.ExamQuestion(Degree,QuestionsId)
values 
(10,1),
(10,2),
(10,3),
(10,4),
(10,5),
(10,6),
(10,7),
(10,8),
(10,9),
(10,10),
(20,11),
(10,12),
(10,13),
(10,14),
(10,15),
(10,16),
(10,17),
(10,18),
(10,19);
insert into Exam.ExamQuestion(Degree,QuestionsId)
values 
(5,20),
(5,21),
(10,22),
(10,23),
(10,24),
(10,25),
(10,26),
(10,27),
(10,28),
(10,29),
(10,30);
select * from Exam.Questions


