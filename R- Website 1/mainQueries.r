qryFmsTbl <<- "
    SELECT 
        [Id]
        ,[fms]
        ,[agency]
        ,[agencyFms]
        ,[division] 
    FROM [AHTestTable]
"

qryInsertfmsApp <<- "
    INSERT INTO [AHTestTable] (
        [fms]
        ,[agency]
        ,[agencyFms]
        ,[division]
    ) VALUES (
        '<fms>'
        ,'<agency>'
        ,'<agencyFms>'
        ,'<division>'
    ) 
"

qryUpdatefmsApp <<- "
    UPDATE [AHTestTable]
    SET 
        [fms] = '<fms>'
        ,[agency] = '<agency>'
        ,[agencyFms] = '<agencyFms>'
        ,[division] = '<division>'
    WHERE [Id] = '<Id>'
"

qrySpecificfmsApp <<- "
    SELECT
        [Id]
        [fms]
        ,[agency]
        ,[agencyFms]
        ,[division]
    FROM [AHTestTable]
    WHERE [fms] = '<fms>'
"