# projekt_chinook

## 1. Úvod a popis zdrojových dát
Cieľom projektu je analyzovať Chinook databázu, ktorá obsahuje údaje o predaji hudby (interpretov, albumov, skladieb a zákazníkov). Táto analýza umožňuje identifikovať najpredávanejšie skladby a albumy, analyzovať správanie zákazníkov a predajné trendy, sledovať výkonnosť zamestnancov.

Chinook databáza obsahuje tieto hlavné tabuľky:

Artist: Informácie o interpretoch.
Album: Albumy interpretov.
Track: Skladby albumov.
Genre: Hudobné žánre skladieb.
MediaType: Typ média skladieb (napr. MP3, AAC).
Invoice a InvoiceLine: Predaj a jednotlivé položky faktúr.
Customer: Zákazníci a ich údaje.
Employee: Zamestnanci a ich informácie.
Playlist.

### 1.1 Dátová architektúra
ERD diagram
ERD diagram Chinook databázy (priložený obrázok) znázorňuje prepojenia medzi tabuľkami.![Chinook_ERD](https://github.com/user-attachments/assets/c8d88214-eba3-4383-8336-b15cb279dcc4)


## 2. Dimenzionálny model 
Pre efektívnu analýzu Chinook databázy navrhneme hviezdicový model s centrálnou faktovou tabuľkou fact_sales, ktorá obsahuje predaje jednotlivých skladieb. Táto faktová tabuľka bude prepojená s dimenziami:

dim_customer: Informácie o zákazníkoch (meno, adresa, mesto, štát).
dim_employee: Zamestnanci, ktorí spracovali predaje.
dim_track: Informácie o skladbách (názov, album, interpret, žáner, typ média, cena).
dim_album: Informácie o albumoch a interpretoch.
dim_date: Dátum predaja (deň, mesiac, rok, štvrťrok).
dim_genre: Žáner skladieb.
dim_mediatype: Typ média skladby.

<img width="695" alt="Snímka obrazovky 2025-01-04 133649" src="https://github.com/user-attachments/assets/27f1c40b-b860-474e-b213-cf07129111de" />

## 3. ETL proces v Snowflake
### 3.1 Extrakcia dát
Dáta z Chinook databázy budú extrahované v .sql alebo .csv formáte a nahraté do Snowflake do staging tabuliek.

Príklad vytvorenia stage a načítania dát:
```sql
CREATE OR REPLACE STAGE chinook_stage; 
COPY INTO artist_staging  
FROM @chinook_stage/Artist.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1);
```

### 3.2 Transformácia dát
Transformácia dát bude zahŕňať čistenie a prípravu dimenzií a faktovej tabuľky.

Vytvorenie dimenzie zákazníkov (dim_customer):

```sql
CREATE TABLE dim_customer AS
SELECT 
    CustomerId AS dim_customer_id,
    FirstName || ' ' || LastName AS full_name,
    City, State, Country, Email
FROM customer;
```
Vytvorenie dimenzie skladieb (dim_track):

```sql
CREATE TABLE dim_track AS
SELECT 
    t.TrackId AS dim_track_id,
    t.Name AS track_name,
    a.Title AS album_title,
    ar.Name AS artist_name,
    g.Name AS genre,
    mt.Name AS media_type,
    t.UnitPrice AS price
FROM track t
JOIN album a ON t.AlbumId = a.AlbumId
JOIN artist ar ON a.ArtistId = ar.ArtistId
JOIN genre g ON t.GenreId = g.GenreId
JOIN mediatype mt ON t.MediaTypeId = mt.MediaTypeId;
```

Vytvorenie faktovej tabuľky predajov (fact_sales):

```sql
CREATE TABLE fact_sales AS
SELECT 
    il.InvoiceLineId AS fact_id,
    i.InvoiceDate AS sale_date,
    c.CustomerId AS customer_id,
    e.EmployeeId AS employee_id,
    il.TrackId AS track_id,
    il.Quantity AS quantity_sold,
    il.UnitPrice * il.Quantity AS total_amount
FROM invoiceline il
JOIN invoice i ON il.InvoiceId = i.InvoiceId
JOIN customer c ON i.CustomerId = c.CustomerId
JOIN employee e ON c.SupportRepId = e.EmployeeId;
```

### 3.3 Načítanie dát
Po vytvorení finálnych dimenzií a faktovej tabuľky nahráme dáta do Snowflake. Staging tabuľky môžu byť odstránené pre optimalizáciu úložiska:
```sql
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
```
## 4. Vizualizácia dát
Dashboard ponúka 4 vizualizácie, ktoré poskytujú prehľad o kľúčových metrikách a trendoch súvisiacich s knihami, používateľmi a hodnoteniami. Pomáhajú pochopiť správanie používateľov a ich preferencie.
