select * from Exam.Branch;
create or alter proc InsToBranch
   @BranchName varchar(50),
   @username int
	
 as
 begin
  begin try
    declare @ManagerId int
   set @ManagerId = (@username)
 if(LEN(@BranchName) > 2)
  begin 
    if exists(select 1 from  [Exam].[Branch] b where b.[NameBranch] = @BranchName )
	   throw 51000,'the branch is exist', 16
    else
	 if @ManagerId is not null
	   begin
	     if exists(select 1 from [Exam].[Branch] where [MangerId] = @ManagerId)
		 or not exists(select 1 from Exam.Instractor where Id =@ManagerId )
		   throw 51000,'Invalid instractor !!!',16;
         else
		     -----------insert into branch ------------
		   	 insert into [Exam].[Branch] ([NameBranch] , [MangerId])
			 values(@BranchName , @ManagerId)

	   end

	 else
	   	   throw 51000,'this user not exist in instructors', 16
  end

   else
	   throw 51000,'please enter beanch name', 16
 end try

 begin catch
   declare @error varchar(50);
   select @error = ERROR_MESSAGE();
   print 'Error : '+ @error;
 end catch

end

go

Exec InsToBranch 'new',3;
--******************--
GO
CREATE  OR ALTER PROCEDURE UpdatInBranch
  @BranchName varchar(50),
  @username int
AS
BEGIN
  BEGIN TRY
    DECLARE @ManagerId int
    SET @ManagerId = (@username)
    IF @ManagerId IS NOT NULL
    BEGIN
      IF EXISTS (SELECT 1 FROM [Exam].[Branch] b WHERE b.[MangerId]= @ManagerId)
	  or not exists(select 1 from Exam.Instractor where Id =@ManagerId )

        THROW 51000, 'invalid Manger Id.', 16;
      ELSE
      BEGIN
        -- Update branch
        UPDATE  [Exam].[Branch]
        SET [MangerId] = @ManagerId 
        WHERE [NameBranch] = @BranchName;
      END
    END
    ELSE
    BEGIN
      THROW 51000, 'This user does not exist in instructors.', 16;
    END
  END TRY
  BEGIN CATCH
    DECLARE @error varchar(50);
    SELECT @error = ERROR_MESSAGE();
    PRINT 'Error: ' + @error;
  END CATCH
END
GO
SELECT * FROM [Exam].[Branch]
exec UpdatInBranch 'nnnn',1000
 
 --**********************-delete--

 create or alter trigger Prevent_branch_Deletion
on[Exam].[Branch]
instead of delete
as
begin
  
      throw 51000,'Cannot delete the Branch',16;
	  
End 
begin try
delete  Exam.Branch 
where Id = 1;
end tryCannot delete the Branch
begin catch
select ERROR_MESSAGE()
end catch