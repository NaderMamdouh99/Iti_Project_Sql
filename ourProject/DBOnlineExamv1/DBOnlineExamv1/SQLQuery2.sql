/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Id]
      ,[Name]
      ,[Type]
      ,[StartTime]
      ,[EndTime]
      ,[TotalDegree]
      ,[IntakeBranchTrackId]
      ,[CourseId]
      ,[DayOFExam]
  FROM [ExamSystem].[Exam].[Exams]
