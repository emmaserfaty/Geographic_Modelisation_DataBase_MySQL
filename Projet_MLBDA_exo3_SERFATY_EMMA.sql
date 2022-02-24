--Organisation
drop type Organisation6 force;
/
Create type Organisation6 as object (
  date_c varchar(10),
  nom varchar(10),
 )

--Ensemble d'orgnaisations
drop type EnsOrga6 force;
/
Create type EnsOrga6 as table of Organisation6;

--pays
drop type country6 force;
/
Create type country6 as object (
  name varchar(10),
  population_totale number, 
  affilie_a EnsOrga,
  frontiere float
 )
/

--Ensemble de Pays
drop type EnsCountry6 force;
/
Create type EnsCountry6 as table of country6;

--Continent
drop type Continent6 force;
/
Create type Continent6 as object(
   name varchar(10),
   Country EnsCountry6,
);
/

--Montagnes
drop type Mountain6 force;
/
Create type Mountain6 as object(
  name varchar(10),
  altitude float,
  latitude float,
  longitude float,
 );
 /

--Ensemble de Montagnes
drop type EnsMountain6 force;
/
Create type EnsMountain6 as table of Mountain6;

--Province
drop type Province6 force;
/
Create type Province6 as object(
   name varchar(10),
   mountain EnsMountain6,
);
/
-- GeoSource
drop type GeoSource force;
/
Create type GeoSource6 as object( 
  
