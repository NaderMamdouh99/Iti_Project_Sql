CREATE OR ALTER PROCEDURE Add_Track
    @Track_Name VARCHAR(50),
    @Supervisor_id INT
AS
BEGIN
    IF (LEN(@Track_Name) > 3)
    BEGIN
        IF EXISTS (SELECT 1 FROM [Exam].[Track] WHERE [NameTrack] = @Track_Name)
            THROW 51000, 'Track name is exists. Please change it!', 16;
        ELSE
        BEGIN
            IF EXISTS (SELECT 1 FROM [Exam].[Instractor] WHERE [Id] = @Supervisor_id)
            BEGIN
                IF EXISTS (SELECT 1 FROM [Exam].[Track] WHERE [SupervisiorId] = @Supervisor_id)
                    THROW 51000, 'Instructor is a supervisor for another track. Change it!', 16;
                ELSE
                BEGIN
                    -- Insert into Track table
                    INSERT INTO  [Exam].[Track]([NameTrack], [SupervisiorId]) 
                    VALUES (@Track_Name, @Supervisor_id);
                END
            END
            ELSE
                THROW 51000, 'Instructor is not found. Change it!', 16;
        END
    END
    ELSE
        THROW 51000, 'Invalid Track name!', 16;
END
GO


begin try
exec Add_Track '. Development',7
end try
begin catch
select ERROR_MESSAGE()
end catch


--------------------------------------
select * from Exam.Track;
CREATE  TRIGGER Update_Track
ON [Exam].[Track]
INSTEAD OF UPDATE
AS
BEGIN
  declare
     @NewTrackName varchar(30),
     @oldSupervisorId int,
	 @NewTrackId int,
	 @OldTrackId int,
	 @newSupervisorId int,
	 @oldeTrackName varchar(30)
   
    select  @OldTrackId = d.[Id] , @oldeTrackName  = d.[NameTrack] ,@newSupervisorId = d.[SupervisiorId] from deleted d;
	select  @NewTrackId = i.[Id], @NewTrackName  = i.[NameTrack] ,@oldSupervisorId = i.[SupervisiorId]  from inserted i;

	IF(@NewTrackId = @OldTrackId)
	BEGIN
	  IF(LEN(@NewTrackName) >=2)
	  BEGIN
	    IF NOT EXISTS(SELECT 1 FROM [Exam].[Track] WHERE [NameTrack] = @NewTrackName )
		BEGIN 
		IF(@newSupervisorId = @oldSupervisorId)
		begin
			UPDATE [Exam].[Track]
			SET [NameTrack] =@NewTrackName , [SupervisiorId] =@newSupervisorId
			where [Id] = @OldTrackId
		end
		ELSE IF Not EXISTS(SELECT 1 from  [Exam].[Track] where [SupervisiorId] =@newSupervisorId)
		    ---------Update----------
			   UPDATE [Exam].[Track]
			   SET [NameTrack] =@NewTrackName , [SupervisiorId] =@newSupervisorId
			   where [Id] = @OldTrackId

           ELSE
		     THROW 51000, 'Instructor is supervosor for another track, change it!',16;

		END

		ELSE
           THROW 51000, 'Repeated name, please enter another name !',16;
		 
	  END
	  ELSE
	    THROW 51000, 'Invalid name !!!',16
 
	END

	ELSE
	  THROW 51000, 'Invalid Track id !!!',16;
END


begin try

update Exam.Track
 SET [NameTrack]='AYMAN'
 WHERE ID=55
end try
begin catch
select ERROR_MESSAGE()
end catch
-------------------------
 create or alter trigger Prevent_TRAK_Deletion
on[Exam].[Track]
instead of delete
as
begin
      throw 51000,'Cannot delete the Course',16;
End 