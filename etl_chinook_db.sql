CREATE OR REPLACE TABLE `album` (
    `AlbumId` INT,
    `Title` VARCHAR,
    `ArtistId` INT
);

INSERT INTO `album` (`AlbumId`, `Title`, `ArtistId`)
VALUES 
    (1, 'For Those About To Rock We Salute You', 1),
    (2, 'Balls to the Wall', 2),
    (3, 'Restless and Wild', 2),
    ...
  
CREATE TABLE dim_customer AS
SELECT 
    `CustomerId` AS dim_customer_id,
    `FirstName` || ' ' || `LastName` AS full_name,
    `City`, `State`, `Country`, `Email`
FROM `customer`;
