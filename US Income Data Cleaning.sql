-- Automated Data Cleaning 
USE ushouseholdincome;
SELECT *
FROM ushouseholdincome;

SELECT * 
FROM ushouseholdincome_cleaned;

DROP PROCEDURE IF EXISTS Copy_and_Clean_data;

DELIMITER $$
CREATE PROCEDURE Copy_and_Clean_data()
BEGIN

-- CREATING OUR TABLE 

	CREATE TABLE IF NOT EXISTS `ushouseholdincome_cleaned` (
	  `row_id` int DEFAULT NULL,
	  `id` int DEFAULT NULL,
	  `State_Code` int DEFAULT NULL,
	  `State_Name` text,
	  `State_ab` text,
	  `County` text,
	  `City` text,
	  `Place` text,
	  `Type` text,
	  `Primary` text,
	  `Zip_Code` int DEFAULT NULL,
	  `Area_Code` int DEFAULT NULL,
	  `ALand` BIGINT,
	  `AWater` BIGINT,
	  `Lat` double DEFAULT NULL,
	  `Lon` double DEFAULT NULL,
	`TimeStamp` TIMESTAMP DEFAULT NULL
	) ;
    
-- COPY DATA TO NEW TABLE 

INSERT INTO `ushouseholdincome_cleaned`
SELECT 
    row_id,
    id,
    State_Code,
    State_Name,
    State_ab,
    County,
    City,
    Place,
    `Type`,
    `Primary`,
    Zip_Code,
    CASE WHEN Area_Code = 'M' THEN NULL ELSE Area_Code END AS Area_Code,
    ALand,
    AWater,
    Lat,
    Lon,
    CURRENT_TIMESTAMP AS TimeStamp
  FROM ushouseholdincome
  WHERE ALand BETWEEN -2147483648 AND 2147483647
  AND AWater BETWEEN -2147483648 AND 2147483647 
; 

-- Data Cleaning Steps

-- Removing Duplicates

DELETE FROM ushouseholdincome_cleaned 
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, id,
		ROW_NUMBER() OVER (PARTITION BY id, `TimeStamp`
        ORDER BY id, `TimeStamp`) AS row_num
		FROM ushouseholdincome_cleaned ) AS duplicates
		WHERE row_num > 1
	);
    
-- Fixing some data quality issues by fixing typos and general standardization
UPDATE ushouseholdincome_cleaned 
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE ushouseholdincome_cleaned
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

UPDATE ushouseholdincome_cleaned 
SET `Type` = 'Borough'
WHERE `Type` = 'Boroughs';

UPDATE ushouseholdincome_cleaned 
SET `Type` = 'CDP'
WHERE `Type` = 'CPD';

UPDATE ushouseholdincome_cleaned
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

UPDATE ushouseholdincome_cleaned 
SET County = UPPER(County);

UPDATE ushouseholdincome_cleaned 
SET City = UPPER(City);

UPDATE ushouseholdincome_cleaned 
SET Place = UPPER(Place);

UPDATE ushouseholdincome_cleaned 
SET State_Name = UPPER(State_Name);

END $$
DELIMITER ;

CALL Copy_and_Clean_data();

-- CREATE EVENT 
DROP EVENT run_data_cleaning;
CREATE EVENT run_data_cleaning
	ON SCHEDULE EVERY 30 DAY
    DO CALL Copy_and_Clean_data();





