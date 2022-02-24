--les continents 
drop type continent3 force;

Create type continent3 as object (
	name varchar(10),
	percent varchar(10),
 	member function toXML return XMLType

);
/
show errors

--creation de XML-continent
Create or Replace type body continent3 as member function toXML return XMLType is
   	output XMLType;
	begin
      		output := XMLType.createxml('<continent3/>');
      		output := XMLType.appendchildxml(output,'continent3',XMLType('<name>'||name||'</name>'));
		      output := XMLType.appendchildxml(output,'continent3', 	XMLType('<percent>'||percent||'</percent>'));
      		return output;
   		end;
	end;


--Aéroports
drop type airport3 force;

Create type airport3 as object (
	name varchar(10),
	nearCity varchar(10),
	member function toXML return XMLType

);
/
show errors


--crétaion de XML-Aéroport
Create or Replace type body airport3 as member function toXML return XMLType is
   	output XMLType;
	begin
      		output := XMLType.createxml('<airport3/>');
      		output := XMLType.appendchildxml(output,'airport3', XMLType('<name>'||name||'</name>'));
		      output := XMLType.appendchildxml(output,'airport3', XMLType('<nearCity>'||nearCity||'</nearCityt>'));
	
      		return output;
   		end;
	end;


drop type coordonnees3 force;

--Coordonnées
Create type coordonnees3 as object (
	latitude number,
	longitude number,
 	member function toXML return XMLType

);
/
show errors


-- Création de XML-Coordonnées
Create or Replace type body coordonnees3 as member function toXML return XMLType is
   	output XMLType;
	begin
      		output := XMLType.createxml('<coordonnees3/>');
      		output := XMLType.appendchildxml(output,'coordonnees3', XMLType('<latitude>'||latitude||'</latitude>'));
		      output := XMLType.appendchildxml(output,'coordonnees3', XMLType('<longitude>'||longitude||'</longitude>'));

      		return output;
   		end;
	end;
	
--Montagnes

drop type mountain3 force;

Create type mountain3 as object (
	name varchar(10),
	height number,
 	member function toXML return XMLType

);
/
show errors

--Création de XML-Montagnes

Create or Replace type body mountain3 as member function toXML return XMLType is
   	output XMLType;
	begin
      		output := XMLType.createxml('<mountain3/>');
      		output := XMLType.appendchildxml(output,'mountain3', XMLType('<name>'||name||'</name>'));
		      output := XMLType.appendchildxml(output,'mountain3', XMLType('<height>'||height||'</height>'));
		
      		return output;
   end;
end;

--Desert

drop type desert3 force;

Create type desert3 as object (	
	name varchar(10),
	area varchar(10),
	member function toXML return XMLType

);
/
show errors


--Création XML-Désert
Create or Replace type body desert3 as member function toXML return XMLType is
   	output XMLType;
	begin
      		output := XMLType.createxml('<desert3/>');
      		output := XMLType.appendchildxml(output,'desert3',XMLType('<name>'||name||'</name>'));
		      output := XMLType.appendchildxml(output,'desert3',XMLType('<area>'||area||'</area>'));
          
      		return output;
   		end;
	end;

-- Création des types EnsContinent3, EnsCoord3, EnsMountain3, EnsDesert3, EnsAirport3

Create type EnsContinent3 as table of continent3 ;
Create type EnsCoord3 as table of coordonnees3 ;
Create type EnsMountain3 as table of mountain3 ;
Create type EnsDesert3 as table of desert3 ;
Create type EnsAirport3 as table of airport3 ;


-- Island

drop type island3 force;

Create type island3 as object (
	name varchar(10),
	coordonnees EnsCoord3,
	member function toXML return XMLType
);
/
show errors

Create table LesCoord3 of coordonnees3 ; 

-- Création de XML-Island 
Create or Replace type body island3 as member function toXML return XMLType is
   	output XMLType;
   	tmpCoord3 EnsCoord3;
	begin
      		output := XMLType.createxml('<island3/>');
      		output := XMLType.appendchildxml(output,'island3', XMLType('<name>'||name||'</name>'));
		      -- pour accéder à l'ensembke des coordonnées constituer de latitude et de longitude
		      select value(c)bulk collect into tmpCoord3
		      from LesCoord3 c
		      for indx IN 1..tmpCoord3.COUNT
      		loop
         			output := XMLType.appendchildxml(output,'island3',tmpDesert3(indx).toXML());   
      		end loop;
		
		      return output;
   		end;
	end;

--création d'un nouveau type issu d'island3
Create type EnsIsland3 as table of island3 ;

-- Province

drop type province3 force;

Create type province3 as object (
	capital varchar(10),
	nom  varchar(10),
	mountain EnsMountain3,
	Island EnsIsland3,
	desert EnsDesert3,
	member function toXML return XMLType
);
/
show errors

Create table LesGeoMountain3 of Geomountain3;
Create table LesMountain3 of mountain3;
Create table LesGeoDesert3 of GeoDesert3 ;
Create table LesDesert3 of desert3 ;

--Création de XML-province
Create or Replace type body province3 as member function toXML return XMLType is
   	output XMLType;
   	tmpMountain3 EnsMountain3;
   	tmpIsland3 EnsIsland3;
   	tmpDesert3 EnsDesert3;
	begin
      		output := XMLType.createxml('<province3/>');
      		output := XMLType.appendchildxml(output,'province3',XMLType('<capitale>'||capitale||'</capitale>'));
		      output := XMLType.appendchildxml(output,'province3',XMLType('<nom>'||nom||'</nom>'));
		

		      select value (m) bulk collect into tmpMountain3
		      From LesGeoMountain3 gm, LesMountain3 m 
		      where m.name=gm.mountain and gm.province=name
		      for indx IN 1..tmpMountain3.COUNT
      		loop
         			output := XMLType.appendchildxml(output,'province3', tmpMountain3(indx).toXML());   
      		end loop;

		      select value (i) bulk collect into tmpIsland3
		      From LesGeoIsland3 gi, LesIsland3 i 
		      where  i.name=gi.island and gi.province=name
		      for indx IN 1..tmpIsland3.COUNT
      		loop
         			output := XMLType.appendchildxml(output,'province3',tmpIsland3(indx).toXML());   
      		end loop;

		      select value (d) bulk collect into tmpDesert3
		      From LesGeoDesert3 gd, LesDesert3 d
		      where  d.name=gd.desert and gd.province=name
		      for indx IN 1..tmpDesert3.COUNT
      		loop
         			output := XMLType.appendchildxml(output,'province3',tmpDesert3(indx).toXML());   
      		end loop;

      		return output;
   		end;
	end;

--Création d'un nouveau type

Create type EnsProvince3 as table of province3 ;


--Pays

drop type country3 force;

Create type country3 as object (

	idCountry number,
	nom varchar(10),
	continent EnsContinent3,
	province EnsProvince3,
	airport EnsAirport3,
	member function toXML return XMLType
);
/
show errors

Create table LesContinent3 of continent3 ; 
Create table LesProvince3 of province3 ;

-- Création de XML-Pays
Create or Replace type body country3 as member function toXML return XMLType is
   	output XMLType;
   	tmpContinent3 EnsContinent3;
   	tmpProvince3 EnsProvince3;
   	tmpAirport3 EnsAirport3;
   	
	begin
      		output := XMLType.createxml('<country3/>');
      		output := XMLType.appendchildxml(output,'country3',XMLType('<idCountry3>'||idCountry3||'</idCountry3>'));
		      output := XMLType.appendchildxml(output,'country3', XMLType('<nom>'||nom||'</nom>')); 

		      select value (c) bulk collect into tmpContinent3
		      From LesContinent3 c
		      where table(self.continent) c
		      for indx IN 1..tmpContinent3.COUNT
      		loop
         			output := XMLType.appendchildxml(output,'country3', tmpContinent3(indx).toXML());   
      		end loop;

		      select value (p) bulk collect into tmpProvince3
		      From LesProvince3 p,
		      where p.idCountry=idCountry
		      for indx IN 1..tmpProvince3.COUNT
      		loop
         			output := XMLType.appendchildxml(output,'country3',tmpProvince3(indx).toXML());   
      		end loop;

		      select value (a) bulk collect into tmpAirport3
		      From LesAirport3 a
		      where a.idCountry=idCountry
		      for indx IN 1..tmpAirport3.COUNT
      		loop
         			output := XMLType.appendchildxml(output,'country3',tmpAirport3(indx).toXML());   
      		end loop;

      		return output;
   		end;
	end;

--Création d'un nouveau type
Create type EnsCountry3 as table of country3;


--Mondial
Create type mondial3 as object(
    country EnsCountry3;
    
)

Create table LesCountry3 of Country3


--Création de XML-Mondial
Create or Replace type body mondial3 as member function toXML return XMLType is
   	output XMLType;
   	tmpCountry3 EnsCountry3;
	begin
      
      		output := XMLType.createxml('<mondial3/>');
      		select value(c) bulk collect into tmpCountry3
          from LesCountry3 c ;  
          for indx IN 1..tmpCountry3.COUNT
          loop
            output := XMLType.appendchildxml(output,'mondial3',tmpCountry3(indx).toXML());   
          end loop;
      		
          
      		return output;
   		end;
	end;



Create type Geomoutain3 as object (
    province EnsProvince3,
    country EnsCountry3,
    mountain EnsMountain3,
    
);
/
show errors

Create type GeoIsland3 as object (
    province EnsProvince3,
    country EnsCountry3,
    island EnsIsland3,
    
);
/

show errors

Create type GeoDesert3 as object (
    province EnsProvince3,
    country EnsCountry3,
    desert EnsDesert3,
    
);
/
show errors



-- faire les insertions
Create table LesAirport3 of Airport3;

insert into LesAirport3
  select Airport3(a.name,a.city,a.country)
  from Airport a
 ;


-- DTD 2

-- les langages   

drop type language4 force;
/
create or replace  type language4 as object (
   country_l  VARCHAR2(10),  
   langue     VARCHAR2(10),  
   percent    NUMBER,
   member function toXML return XMLType
)
/

-- Création de XML-language
create or replace type body language4 as
 member function toXML return XMLType is
   output XMLType;
   begin
          output := XMLType.createxml('<language4/>');
		      output := XMLType.appendchildxml(output,'language4', 	XMLType('<percent>'||percent||'</percent>'));
		      output := XMLType.appendchildxml(output,'language4', 	XMLType('<langue>'||langue||'</langue>'));
      return output;
   end;
end;
/

-- les voisins  
drop type Border4 force;
/
create or replace  type Border4 as object (
   country_f     VARCHAR(10),    
   country_b     VARCHAR(10),
   length_b      VARCHAR(10),
   member function toXML return XMLType
)
/

-- Création de XML-voisin

create or replace type body Border4 as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<Border4/>');
      output := XMLType.appendchildxml(output,'Border4', 	XMLType('<country_b>'||country_b||'</country_b>'));
      output := XMLType.appendchildxml(output,'Border4', 	XMLType('<lenght>'||country_b||'</length>'));
      
      return output;
   end;
end;
/

-- Création de l'element headquarter 
drop type Hq4 force;
/
create or replace  type Hq4 as object (
   cd       varchar(10),
   name      varchar(10),
   member function toXML return XMLType
)
/

--Création de XML-headquarter
create or replace type body Hq4 as
 member function toXML return XMLType is
   output XMLType;
   begin
      output := XMLType.createxml('<Hq4/>');
      output := XMLType.appendchildxml(output,'Hq4', 	XMLType('<name>'||name||'</name>'));
      return output;
   end;
end;
/      

-- création de l'element organization 
drop type organization4 force;
/
create or replace  type organization4 as object (
   cd_orga         varchar(10),
   name_orga      varchar(10),
   member function toXML return XMLType
)
/
    
create or replace type EnsHq4 as table of Hq4;
/

-- les membres de l organisation

drop type membreHd4 force;
/
create or replace  type TmembreHd4 as object (
   country_member varchar(10),
   cd_org_member  varchar2(10)
)
/
create or replace type EnsMembreHd4 as table of TmembreHd4 ;

/
-- PAYS
drop type country4 force;
/
create or replace  type country4 as object (
   name        VARCHAR(10),
   code        VARCHAR(10),
   population       number,
   member function toXML return XMLType
)
/
create or replace type EnsBorder4 as table of Border4;
/
create or replace type EnsLangue4 as table of langue4;
/

Create table Leslanguages4 of language4;
Create table LesBorder41 of border4;
Create table LesBorder42 of border4;


--Création de XML-pays
create or replace type body country4 as
   member function toXML return XMLType is
   output XMLType;
   tmpvoisin1 EnsBorder4;
   tmpvoisin2 EnsBorder4;
   tmplangue EnsLangue4;
  begin
          output := XMLType.createxml('<country4/>');
		      output := XMLType.appendchildxml(output,'country4', 	XMLType('<code>'||code||'</code>'));
		      output := XMLType.appendchildxml(output,'country4', 	XMLType('<name>'||name||'</name>'));
		      output := XMLType.appendchildxml(output,'country4', 	XMLType('<population>'||name||'</population>'));
      
           
      -- les langues    
      select value(l) bulk collect into tmplangue
      from Leslangue4 l   
      where l.country_l = code_pays ; 
      for indx IN 1..tmplangue.COUNT
      loop
         output := XMLType.appendchildxml(output,'country4',tmplangue(indx).toXML());   
      end loop;
      

      -- les voisins1
      select value(v1) bulk collect into tmpborder1
      from LesBorder41 v1   
      where v1.country_f = code_pays ; 
      for indx IN 1..tmpborder1.COUNT
      loop
         output := XMLType.appendchildxml(output,'country4',tmpvoisin1(indx).toXML());   
      end loop;
      
      -- les voisins2        
      select value(v2) bulk collect into tmpborder2
      from LesBorder42 v2   
      where v2.country_f = code_pays ; 
      for indx IN 1..tmpborder2.COUNT
      loop
         output := XMLType.appendchildxml(output,'country4',tmpvoisin2(indx).toXML());   
      end loop;
 
      return output;
   end;
end;
/

create or replace type EnsCountry4 as table of country4;


Create table LesCountry4 of country4;
Create table LesHq4 of Hq4; 
/
-- traite l'organisation
--Création de XML-organisation
create or replace type body organization4 as
   member function toXML return XMLType is
   output XMLType;
   tmppays TX_enspays;
   tmphq   TX_enshq;
  begin
      output := XMLType.createxml('<organization4/>');
      -- les hq et pays                
      select value(p) bulk collect into tmppays
      from LesCountry4 p, LesmembreHq m    
      where p.code_pays = m.country_member and cd_orga=m.cd_org_member ; 
       for indx IN 1..tmppays.COUNT
      loop
         output := XMLType.appendchildxml(output,'organization4',tmppays(indx).toXML());   
      end loop;
      -- les headquarters   
      select value(h) bulk collect into tmphq
      from LesHq4 h    
      where h.cd = cd_orga ; 
       for indx IN 1..tmphq.COUNT
      loop
         output := XMLType.appendchildxml(output,'organization4',tmphq(indx).toXML());   
      end loop;
 
      return output;
   end;
end;
/


-- Mondial    
drop type mondial4 force;
/
create or replace  type mondial4 as object (
    nombre number,
    member function toXML return XMLType
)
/

create or replace type EnsOrga4 as table of organization4;

Create table LesOrga4 of organization4;
/

-- Création de XML-mondial
create or replace type body mondial4 as
   member function toXML return XMLType is
   output XMLType;
   tmporga EnsOrga4;
   begin
      output := XMLType.createxml('<mondial4/>');
      
      -- les pays    
      select value(o) bulk collect into tmporga
      from Lesorgas o ;  
      for indx IN 1..tmporga.COUNT
      loop
         output := XMLType.appendchildxml(output,'mondial4',tmporga(indx).toXML());   
      end loop;
      return output;
   end;
end;
/

 -- INSERTIONS
 
 -- création mondial avec un seul enregistrement
drop table EnsMondial4;
/ 
create table EnsMondial of mondial4;
/
insert into EnsMondial values (1)
/

select p.toXML().getClobVal() 
from ensmondial p;
/
insert into LesHq4
  select Hq4 (ABBREVIATION, name) 
         from ORGANIZATION o
         where ABBREVIATION IN ('UN','NATO');
/  

-- exporter le r�sultat dans un fichier 
WbExport -type=text
         -file='Hq4.xml'
         -createDir=true
         -encoding=ISO-8859-1
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select h.toXML().getClobVal() 
from LesHq4 h;
/
insert into Lesorga4
  select organization4 (ABBREVIATION, name) 
         from OTGANIZATION o
         where ABBREVIATION IN ('UN','NATO');
/  
-- exporter le r�sultat dans un fichier 
WbExport -type=text
         -file='organization4.xml'
         -createDir=true
         -encoding=ISO-8859-1
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select o.toXML().getClobVal() 
from Lesorga4 o;

/ 
create table LesMembresHq4 of membreHq4;
/
insert into LesmembresHq4
  select membreHq4 (country4, organization4) 
         from ismember  ;
/  
-- exporter le r�sultat dans un fichier 
WbExport -type=text
         -file='membreHq4.xml'
         -createDir=true
         -encoding=ISO-8859-1
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select h.toXML().getClobVal() 
from LesmembresHq4 h;
/
-- pays avec au moins une langue 
insert into LesCountry4
  select country4(p.name, p.code, p.population) 
         from COUNTRY p, (select distinct l.country from language l) lg
         where p.code =  lg.country
     ;
 /  
 
-- exporter le r�sultat dans un fichier 
WbExport -type=text
         -file='country4.xml'
         -createDir=true
         -encoding=ISO-8859-1
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select c.toXML().getClobVal() 
from LesCountry4 c;
    
insert into LesBorder41
  select border4 (b.country1, b.country2, length) 
         from BORDERS  b ;
 /      

-- exporter le r�sultat dans un fichier 
WbExport -type=text
         -file='border4.xml'
         -createDir=true
         -encoding=ISO-8859-1
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select b.toXML().getClobVal() 
from LesBorder41 b;
/
insert into LesBorder42
  select border4(b.country2, b.country1,  length) 
         from Borders b  ;
 /    
-- exporter le r�sultat dans un fichier 
WbExport -type=text
         -file='border4.xml'
         -createDir=true
         -encoding=ISO-8859-1
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select b.toXML().getClobVal() 
from LesBorder42 b;


/
insert into LesLanguages4
  select language4(country, name, percentage) 
         from LANGUAGE  ;
 /  


WbExport -type=text
         -file='language4.xml'
         -createDir=true
         -encoding=ISO-8859-1
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/

      
select l.toXML().getClobVal() 
from LesLanguages4 l;













