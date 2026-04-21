CREATE OR ALTER PROCEDURE load_data AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '------------------------------------------------';
        PRINT 'Loading Credit Risk Table';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: credit_risk';
        TRUNCATE TABLE credit_risk;

        PRINT '>> Inserting Data Into: credit_risk';
        BULK INSERT credit_risk
        FROM 'E:\Project\Credit_Risk_Analysis\Credit_Risk_Dataset.csv'
        WITH (
            FIRSTROW = 2,          
            FIELDTERMINATOR = ',',
            CODEPAGE = 'RAW',
            FIELDQUOTE = '"',
            ROWTERMINATOR = '0x0a',
            TABLOCK
        );
          
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Loading is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT '==========================================';
    END TRY
    BEGIN CATCH
        PRINT '==========================================';
        PRINT 'ERROR OCCURED DURING LOADING';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END;

EXEC load_data;