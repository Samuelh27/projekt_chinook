CREATE TABLE `Album`
(
    `AlbumId` INT NOT NULL,
    `Title` NVARCHAR(160) NOT NULL,
    `ArtistId` INT NOT NULL,
    CONSTRAINT `PK_Album` PRIMARY KEY  (`AlbumId`)
);

CREATE TABLE `Artist`
(
    `ArtistId` INT NOT NULL,
    `Name` NVARCHAR(120),
    CONSTRAINT `PK_Artist` PRIMARY KEY  (`ArtistId`)
);

CREATE TABLE `Customer`
(
    `CustomerId` INT NOT NULL,
    `FirstName` NVARCHAR(40) NOT NULL,
    `LastName` NVARCHAR(20) NOT NULL,
    `Company` NVARCHAR(80),
    `Address` NVARCHAR(70),
    `City` NVARCHAR(40),
    `State` NVARCHAR(40),
    `Country` NVARCHAR(40),
    `PostalCode` NVARCHAR(10),
    `Phone` NVARCHAR(24),
    `Fax` NVARCHAR(24),
    `Email` NVARCHAR(60) NOT NULL,
    `SupportRepId` INT,
    CONSTRAINT `PK_Customer` PRIMARY KEY  (`CustomerId`)
);

CREATE TABLE `Employee`
(
    `EmployeeId` INT NOT NULL,
    `LastName` NVARCHAR(20) NOT NULL,
    `FirstName` NVARCHAR(20) NOT NULL,
    `Title` NVARCHAR(30),
    `ReportsTo` INT,
    `BirthDate` DATETIME,
    `HireDate` DATETIME,
    `Address` NVARCHAR(70),
    `City` NVARCHAR(40),
    `State` NVARCHAR(40),
    `Country` NVARCHAR(40),
    `PostalCode` NVARCHAR(10),
    `Phone` NVARCHAR(24),
    `Fax` NVARCHAR(24),
    `Email` NVARCHAR(60),
    CONSTRAINT `PK_Employee` PRIMARY KEY  (`EmployeeId`)
);

CREATE TABLE `Genre`
(
    `GenreId` INT NOT NULL,
    `Name` NVARCHAR(120),
    CONSTRAINT `PK_Genre` PRIMARY KEY  (`GenreId`)
);

CREATE TABLE `Invoice`
(
    `InvoiceId` INT NOT NULL,
    `CustomerId` INT NOT NULL,
    `InvoiceDate` DATETIME NOT NULL,
    `BillingAddress` NVARCHAR(70),
    `BillingCity` NVARCHAR(40),
    `BillingState` NVARCHAR(40),
    `BillingCountry` NVARCHAR(40),
    `BillingPostalCode` NVARCHAR(10),
    `Total` NUMERIC(10,2) NOT NULL,
    CONSTRAINT `PK_Invoice` PRIMARY KEY  (`InvoiceId`)
);

CREATE TABLE `InvoiceLine`
(
    `InvoiceLineId` INT NOT NULL,
    `InvoiceId` INT NOT NULL,
    `TrackId` INT NOT NULL,
    `UnitPrice` NUMERIC(10,2) NOT NULL,
    `Quantity` INT NOT NULL,
    CONSTRAINT `PK_InvoiceLine` PRIMARY KEY  (`InvoiceLineId`)
);

CREATE TABLE `MediaType`
(
    `MediaTypeId` INT NOT NULL,
    `Name` NVARCHAR(120),
    CONSTRAINT `PK_MediaType` PRIMARY KEY  (`MediaTypeId`)
);

CREATE TABLE `Playlist`
(
    `PlaylistId` INT NOT NULL,
    `Name` NVARCHAR(120),
    CONSTRAINT `PK_Playlist` PRIMARY KEY  (`PlaylistId`)
);

CREATE TABLE `PlaylistTrack`
(
    `PlaylistId` INT NOT NULL,
    `TrackId` INT NOT NULL,
    CONSTRAINT `PK_PlaylistTrack` PRIMARY KEY  (`PlaylistId`, `TrackId`)
);

CREATE TABLE `Track`
(
    `TrackId` INT NOT NULL,
    `Name` NVARCHAR(200) NOT NULL,
    `AlbumId` INT,
    `MediaTypeId` INT NOT NULL,
    `GenreId` INT,
    `Composer` NVARCHAR(220),
    `Milliseconds` INT NOT NULL,
    `Bytes` INT,
    `UnitPrice` NUMERIC(10,2) NOT NULL,
    CONSTRAINT `PK_Track` PRIMARY KEY  (`TrackId`)
);




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


CREATE TABLE fact_sales AS
SELECT 
    il.`InvoiceLineId` AS fact_id,
    i.`InvoiceDate` AS sale_date,
    c.`CustomerId` AS customer_id,
    e.`EmployeeId` AS employee_id,
    il.`TrackId` AS track_id,
    il.`Quantity` AS quantity_sold,
    il.`UnitPrice` * il.`Quantity` AS total_amount
FROM `invoiceline` il
JOIN `invoice` i ON il.`InvoiceId` = i.`InvoiceId`
JOIN `customer` c ON i.`CustomerId` = c.`CustomerId`
JOIN `employee` e ON c.`SupportRepId` = e.`EmployeeId`;

DROP TABLE IF EXISTS PlaylistTrack_staging;
DROP TABLE IF EXISTS InvoiceLine_staging;
DROP TABLE IF EXISTS Playlist_staging;
DROP TABLE IF EXISTS Track_staging;
DROP TABLE IF EXISTS Invoice_staging;
DROP TABLE IF EXISTS Customer_staging;
DROP TABLE IF EXISTS Album_staging;
DROP TABLE IF EXISTS Genre_staging;
DROP TABLE IF EXISTS MediaType_staging;
DROP TABLE IF EXISTS Artist_staging;
DROP TABLE IF EXISTS Employee_staging;
