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

CREATE OR REPLACE STAGE chinook_stage; 
COPY INTO artist_staging  
FROM @chinook_stage/Artist.csv 
FILE_FORMAT = (TYPE = 'CSV' SKIP_HEADER = 1); 

### 3.2 Transformácia dát
Transformácia dát bude zahŕňať čistenie a prípravu dimenzií a faktovej tabuľky.

Vytvorenie dimenzie zákazníkov (dim_customer):

sql
Kopírovať kód
CREATE TABLE dim_customer AS
SELECT 
    CustomerId AS dim_customer_id,
    FirstName || ' ' || LastName AS full_name,
    City, State, Country, Email
FROM customer;
