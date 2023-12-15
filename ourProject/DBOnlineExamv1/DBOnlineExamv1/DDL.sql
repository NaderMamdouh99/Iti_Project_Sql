
-- create Database on Primary File Group
CREATE DATABASE ExamSystem
ON 
(
	NAME=projects_dat,
	FILENAME = 'E:\.0000000000000\My Project\SQL Project\Oline Exam System\ourProject\DBOnlineExamv1.mdf',
	SIZE = 5,
	MAXSIZE = 10,
	FILEGROWTH = 2
)
LOG ON
(
	NAME=projects_log,
	FILENAME = 'E:\.0000000000000\My Project\SQL Project\Oline Exam System\ourProject\DBOnlineExamv1_log.ldf',
	SIZE = 1,
	MAXSIZE = 10,
	FILEGROWTH = 1
);	


-- Add Secondary File Group to our DB
ALTER DATABASE ExamSystem
ADD FILEGROUP SecondaryFG

-- Add File To Secondary File Group

ALTER DATABASE ExamSystem
ADD FILE 
( 
	NAME = 'ProdectScondaryGroub',
	FILENAME ='E:\.0000000000000\My Project\SQL Project\Oline Exam System\ourProject\Secondart_ndf1.ndf',
	SIZE = 2MB,
	MAXSIZE=5,
	FILEGROWTH=1
)
TO FILEGROUP SecondaryFG;

use ExamSystem;
-----
create schema Exam;
---

create table Exam.QuestionsType(
Id int primary key,
[Type] varchar(20) not null unique,
constraint CheckType check([Type] in ('text','muliuable choice' , 'true or false'))
)

create table Exam.Intake(
Id int primary key,
[Name] varchar(15),
[year] Date ,
)

create table Exam.[User] 
(
	Id int  identity(1,1) primary key ,
	UserName varchar (50) not null unique check(len(UserName) > 10 ),
	Phone varchar(11) not null ,
	FirstName varchar(50) not null check(len(FirstName)>=3),
	LastName varchar(50) not null check(len(LastName)>=3 ),
	City varchar(50) not null ,
	StreetName varchar(50) not null,
	Birthdate date not null,
	Age int not null,
	[Password] varchar (30) not null,
)

create table Exam.Questions(
Id int identity(1,1) primary key ,
Content varchar(max) not null,
CourseId int  ,
TypeId int
)

create table Exam.QuestionsAnswer(
Id int  identity(1,1) primary key,
Flag bit not null,
Answer varchar(max),
QuestionId int ,
)
 create  table Exam.TrackInstactor(
instractorId int not null,
TrackId int not null,
)



create table Exam.IntakeBranchTrack(
Id  int identity(1,1) Unique,
BranchId int,
TrackId int,
IntakeId int,
constraint IntakeBranchTrackCompositePK primary key(BranchId,TrackId,IntakeId)
)
create table Exam.Track(
Id int identity(1,1) primary key,
NameTrack varchar(50) not null check(len(NameTrack) >=1) ,
SupervisiorId int ,
)
create table Exam.Branch(
Id int identity(1,1) primary key ,
NameBranch varchar(20) NOT NULL,
MangerId int,
)

-----
create table Exam.Departmant(
 Id  int identity(1,1) primary key,
 [Name] varchar(30) NOT NULL,
 ManagerId int,
 )


 create table Exam.Student(
 
 Id int identity(1,1) primary key,
 UserId int ,
 IntakeBranchTrackID int,
 DepartmantId int
 )


  create table Exam.Instractor(
  Id int identity(1,1) primary key,
  UserId int,
  MangerId int,
  BranchId int,
  DepartmantId int,
)
create table Exam.Course
(
	Id int identity(1,1) primary key not null,
	[Name] varchar(30) not null check(len(Name)>=3),
	MaxDegree int not null ,
	MinDegree int not null,
	Discraption nvarchar(max) not null check(len(Discraption)>=5),
	InstractorId int 
)
create table Exam.Exams 
(
	Id int primary key identity(1,1) not null,
	[Name] varchar(30) not null check(len(Name)>=3),
	[Type] varchar (10) not null default 'exam' check ([Type] in ('exam' , 'corective')),
	StartTime time not null,
	EndTime time not null ,
	TotalDegree int not null,
	IntakeBranchTrackId int ,
	CourseId int
)
create table Exam.ExamAnswer
(
	Id int  identity(1,1) primary key,
	AnswerText varchar(30) not null ,
	Flag bit not null,
	Degree int not null,
	StudentId int ,
	QuestionsId int 
)

create table Exam.ExamQuestion
(
	Id int primary key identity(1,1) not null,
	Degree int not null,
	QuestionsId int 
)

create table  Exam.SpaseficExam
(
	ExamId int,
	StudentId int
	constraint SpaseficExamPK primary key (ExamId,StudentId)
)

create table Exam.ExamsResult
(
	Id int primary key identity(1,1) ,
	[Type] varchar (15) not null,
	StartTime time not null,
	EndTime time not null ,
	TotalDegreeStudent int not null,
	TotalDegreeExam int not null,
	StudentId int not null,
	IntakeBranchTrackId int,
	CourseId int
)
 
 create table Exam.StudentCourse
 (
	StudentId int ,
	CourseId int ,
	constraint StudentCourseCompositKey primary key(StudentId,CourseId)

 )

alter table Exam.Track
add constraint Track_InstractorFK 
foreign key (SupervisiorId)  
references [Exam].[Instractor](Id) ;


alter table Exam.Branch
add constraint Branch_InstractorFK 
foreign key (MangerId) 
references [Exam].[Instractor](Id)
on delete set null
on update cascade

alter table Exam.Departmant
add constraint Departmant_InstractorFK 
foreign key (ManageRId) 
references [Exam].[Instractor](Id) 

---- MangerId=null --d--> null
----update ->cascade
-------------------
alter table [Exam].[Student]
add constraint Student_UserFK 
foreign key (UserId) 
references [Exam].[User](Id) 
on delete no action
on update no action
-----------------------------**
alter table [Exam].[Student]
add constraint Student_IntakeBranchTrackIDFK 
foreign key (IntakeBranchTrackID) 
references[Exam].[IntakeBranchTrack](Id) 


--*************************--
alter table [Exam].[Student]
add constraint Student_DepartmantFK 
foreign key (DepartmantId) 
references[Exam].[Departmant](Id)
ON delete no action
on update no action



--------------------------------------
------NO ACTION---
alter table [Exam].[Instractor]
add constraint Instractor_UserFK 
foreign key (UserId) 
references [Exam].[User](Id)
ON UPDATE no action
ON DELETE no action
--u -- cascade
--d -- cascade
--*******************************----
alter table [Exam].[Instractor]
add constraint Instractor_BranchFK 
foreign key (BranchId) 
references [Exam].[Branch](Id) 

alter table [Exam].[Instractor]
add constraint Instractor_DepartmantFK 
foreign key (DepartmantId) 
references [Exam].[Departmant](Id)

alter table [Exam].[Instractor]
add constraint Instractor_Manger_SelfFK 
foreign key (MangerId) 
references [Exam].[Instractor](Id)

-----------------------------
--***NO ACTION---
alter table [Exam].[Course]
add constraint Course_InstractorFK 
foreign key (InstractorId) 
references [Exam].[Instractor](Id)

----------------------------------------
alter table [Exam].[Exams]
add constraint Exam_IntakeBranchTrackFK 
foreign key (IntakeBranchTrackId) 
references [Exam].[IntakeBranchTrack](Id)

---------------------------------------
alter table [Exam].[Exams]
add constraint Exams_CourseFK 
foreign key (CourseId) 
references [Exam].[Course](Id)

--alter table [Exam].[Exams]
--drop constraint Exams_CourseFK 
--------------------------------


alter table [Exam].[ExamAnswer]
add constraint ExamAnswer_StudentFK 
foreign key (StudentId) 
references [Exam].[Student](Id)
ON DELETE CASCADE
 ON UPDATE CASCADE



alter table [Exam].[ExamAnswer]
add constraint ExamAnswer_QuestionsFK 
foreign key (QuestionsId) 
references [Exam].[Questions](Id)
-----------------------------------------
alter table [Exam].[ExamQuestion]
add constraint ExamQuestion_QuestionsFK 
foreign key (QuestionsId) 
references [Exam].[Questions](Id)
----------------------------------------
alter table [Exam].[SpaseficExam]
add constraint SpaseficExam_ExamFK 
foreign key (ExamId) 
references [Exam].[Exams](Id)
-------------NO ACTION------------------------
alter table [Exam].[SpaseficExam]
add constraint SpaseficExam_StudentFK 
foreign key (StudentId) 
references [Exam].[Student](Id)
ON DELETE no action
ON UPDATE no action

--------------------------------------
alter table [Exam].[ExamsResult]
add constraint ExamsResult_StudentFK 
foreign key (StudentId) 
references [Exam].[Student](Id)
ON UPDATE CASCADE
ON DELETE CASCADE


-------------------------------------
alter table [Exam].[ExamsResult]
add constraint ExamsResult_IntakeBranchTrackFK 
foreign key (IntakeBranchTrackId) 
references [Exam].[IntakeBranchTrack](Id)

----------------------------------------
alter table [Exam].[ExamsResult]
add constraint ExamsResult_CourseFK 
foreign key (CourseId) 
references [Exam].[Course](Id)
ON DELETE no action
ON UPDATE no action 
 

alter table Exam.Exams 
add  DayOFExam date null ;
--- value manual 
---check constraint will add in proc
select * from Exam.Exams;


alter table  [Exam].[ExamQuestion]
ADD  ExamId int  Null ;

alter table  [Exam].[ExamQuestion]
ADD  constraint  ExamQuestion_Eams 
foreign key (ExamId) references [Exam].[Exams](Id);
select * from   [Exam].[ExamQuestion]

----------------------------------------------
alter table [Exam].[ExamAnswer]
add   ExamId int  Null ;

alter table [Exam].[ExamAnswer]
add  constraint  ExamAnswer_Exam 
foreign key (ExamId) references [Exam].[Exams](Id);
select * from   [Exam].[ExamAnswer]
------------------ ExamsResult
alter table [Exam].[ExamsResult]
add   ExamId int  Null ;

alter table [Exam].[ExamsResult]
add  constraint  ExamsResult_Exam 
foreign key (ExamId) references [Exam].[Exams](Id);


alter table [Exam].[ExamsResult]
drop constraint ExamsResult_IntakeBranchTrackFK

alter table [Exam].[ExamsResult]
drop column  [IntakeBranchTrackId] ;

select * from   [Exam].[ExamsResult];