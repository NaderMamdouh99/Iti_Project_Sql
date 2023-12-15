
-- View a Student FullName in Department
go
Create or alter view StudentInDepartmant
as
select [FirstName]+ ' ' +[LastName]as FullName,[Name]as Departmant
from[Exam].[User]inner join [Exam].[Student]
on [Exam].[User].Id=[Exam].[Student].UserId
inner join [Exam].[Departmant]
on[Exam].[Student].[DepartmantId]=[Exam].[Departmant].[Id]

go
select * from StudentInDepartmant

-- View a Instractor FullName in Department
go
Create or alter view InstractorInDepartmant
as
select [FirstName]+ ' ' +[LastName]as Instractor,[Name]as Departmant
from[Exam].[User]inner join [Exam].[Instractor]
on [Exam].[User].Id=[Exam].[Instractor].UserId
inner join [Exam].[Departmant]
on[Exam].[Instractor].DepartmantId=[Exam].[Departmant].[Id]
go

select * from InstractorInDepartmant

-- View Student in Course 
go
Create or alter view StudentNameInCourse
as
select [FirstName]+ ' ' +[LastName]as StudentName,[Name] as CourseName
from[Exam].[User]inner join [Exam].[Student]
on [Exam].[User].Id=[Exam].[Student].UserId
inner join [Exam].[StudentCourse]
on [Exam].[Student].[Id]=[Exam].[StudentCourse].[StudentId]
inner join [Exam].[Course]
on [Exam].[Course].[Id]=[Exam].[StudentCourse].[CourseId]

go
select * from StudentNameInCourse;

---View Instractor Name In Course
go
Create or alter View InstractorNameInCourse
as
select [FirstName]+ ' ' +[LastName]as InstractorName,[Name] as CourseName,[MaxDegree],[MinDegree]
from[Exam].[User]inner join [Exam].[Instractor]
on [Exam].[User].[Id]=[Exam].[Instractor].[UserId]
inner join [Exam].[Course]
on [Exam].[Instractor].[Id]=[Exam].[Course].[InstractorId]

go
select * from InstractorNameInCourse
--- View Instractor with Course Name and Discraption and The Track
go
Create or alter View In_Course_Discraption_Track
as
select top 100000 [FirstName]+ ' ' +[LastName]as InstractorName,[Name] as CourseName,[Discraption]as Discraption,[NameTrack]as Track
from[Exam].[User]inner join [Exam].[Instractor]
on [Exam].[User].[Id]=[Exam].[Instractor].[UserId]
inner join [Exam].[Course]
on [Exam].[Instractor].[Id]=[Exam].[Course].[InstractorId]
inner join [Exam].[TrackInstactor]
on[Exam].[Instractor].[Id]=[Exam].[TrackInstactor].[instractorId]
inner join [Exam].[Track]
on [Exam].[Track].[Id]=[Exam].[TrackInstactor].[TrackId]
order by Track
go
select * from In_Course_Discraption_Track

-- View Manger Name For Instractor (Self Join)
go
Create or alter View MangerforInstractor
as
select A.[FirstName]+ ' ' +A.[LastName]as Instractor ,B.[FirstName]+ ' ' +B.[LastName]as Manger
from [Exam].[User] A
join [Exam].[Instractor] M
on A.Id = M.UserId
join [Exam].[User] B
on B.Id = M.MangerId 

go
select * from MangerforInstractor


