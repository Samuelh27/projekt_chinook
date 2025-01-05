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


CREATE TABLE dim_track AS
SELECT 
    t.`TrackId` AS dim_track_id,
    t.`Name` AS track_name,
    a.`Title` AS album_title,
    ar.`Name` AS artist_name,
    g.`Name` AS genre,
    mt.`Name` AS media_type,
    t.`UnitPrice` AS price
FROM `track` t
JOIN `album` a ON t.`AlbumId` = a.`AlbumId`
JOIN `artist` ar ON a.`ArtistId` = ar.`ArtistId`
JOIN `genre` g ON t.`GenreId` = g.`GenreId`
JOIN `mediatype` mt ON t.`MediaTypeId` = mt.`MediaTypeId`;
