--- add departement---
go
create or alter proc InsToDeprtment
  @deptname varchar(50),
  @managerid int
 as 
 begin
  begin try
  if(LEN(@deptname) > 0)
  begin
   if EXISTS(select 1 from [Exam].[Departmant] d where d.[Name] = @deptname )
    throw 51000,'this dpartment is exists already, change it !',16
   else
    begin
       if EXISTS(select 1 from [Exam].[Instractor] i where  i.id= @managerid)
	   begin
         if EXISTS(select 1 from [Exam].[Departmant] d where  d.ManagerId= @managerid)
		 	throw 51000,'instructor is a manager for another department, change it !',16
         else
		 begin 
		   insert into [Exam].[Departmant] ([Name], ManagerId) values
		   (@deptname , @managerid);
		 end
	     
	   end
	   else
	     throw 51000,'invalid instructor id !',19

    end
 end

 else
  throw 51000,'invalid name !!',16
  end try

  begin catch
    declare @error varchar(max)
	select @error = ERROR_MESSAGE();
	print 'Error  : ' + @error;
  end catch
end
go

exec InsToDeprtment 'New 888888' , 3;
select * from Exam.Instractor;
select * from Exam.Departmant;
---------------update Departement ---------------------------
GO
CREATE OR ALTER TRIGGER UpdateToDept
ON [Exam].[Departmant]
INSTEAD OF UPDATE
AS
BEGIN 
  
    DECLARE
       @NewDeptName VARCHAR(30),
       @NewManagerId INT,
       @NewDeptId INT,
	   ----*****------
       @OldManagerId INT,
       @OldDeptId INT;

    SELECT  @OldManagerId = d.ManagerId,
            @OldDeptId = d.Id
    FROM deleted d;
	
    SELECT  @NewDeptName = i.[Name],
            @NewManagerId = i.ManagerId,
            @NewDeptId = i.Id
    FROM inserted i;
	
    IF (@NewDeptId = @OldDeptId)
    BEGIN
      IF (LEN(@NewDeptName) >= 3)
      BEGIN
        IF NOT EXISTS(SELECT 1 FROM [Exam].[Departmant] d WHERE d.[Name] = @NewDeptName )
        
          
          BEGIN 
            IF NOT EXISTS(
                SELECT 1
                FROM [Exam].[Departmant] d WHERE d.ManagerId= @NewManagerId)
				and exists(select 1 from Exam.Instractor where Id = @NewManagerId)
            BEGIN
              -- Update----
			  select 'here';
              UPDATE [Exam].[Departmant]
              SET [Name] = @NewDeptName,
                  [ManagerId] = @NewManagerId
              WHERE [Id] = @OldDeptId;
            END
            ELSE
              THROW 51000, 'Invalid id manger!', 16;
          END
          ELSE
            THROW 51000, 'Invalid manager id, not an instructor', 16;
        
      END
      ELSE
        THROW 51000, 'Invalid name!!!', 16;
    END
    ELSE
      THROW 51000, 'Invalid Dept id!!!', 16;
    
END;

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

--------------delete -----------------------
create or alter trigger Prevent_dep_Deletion
on[Exam].[Departmant]
instead of delete
as
begin
  
      throw 51000,'Cannot delete the Departemnt ',16;
	  
End 


begin try 
delete from  Exam.Departmant
where Id =5
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch
