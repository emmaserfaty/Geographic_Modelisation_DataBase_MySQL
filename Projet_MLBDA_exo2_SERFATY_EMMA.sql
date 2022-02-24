
--Coordonnées
drop type coordoonnes force;
/
Create type coordonnees3 as object (
	latitude number,
	longitude number,
 	member function toXML return XMLType

);
/
show errors

--Continent
drop type continent3 force;
/

Create type continent3 as object (
	name varchar(10),
	percent varchar(10),
 	member function toXML return XMLType

);
/

Create type EnsCoord3 as table of coordonnees3 ;

--Island
drop type lisland3 force;
/
Create type island3 as object (
	name varchar(10),
	coordonnees EnsCoord3,
	member function toXML return XMLType
);
/
show errors

--Montagnes
drop type mountain3 force;
/
Create type mountain3 as object (
	name varchar(10),
	height number,
 	member function toXML return XMLType

);
/
show errors

--desert
drop type desert3 force;
/
Create type desert3 as object (	
	name varchar(10),
	area varchar(10),
	member function toXML return XMLType

);
/
show errors

--Province
drop type province3 force;
/
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

--Création de type d'ensemble 
Create type EnsMountain3 as table of mountain3 ;
Create type EnsDesert3 as table of desert3 ;
Create type EnsIsland3 as table of island3 ;
Create type EnsProvince3 as table of province3 ;
Create type EnsContinent3 as table of continent3 ;

--Geomountain
drop type GeoMountain3 force;
/
Create type GeoMoutain3 as object (
    province EnsProvince3,
    country EnsCountry3,
    mountain EnsMountain3,
    
);
/
show errors

--GeoIsland
drop type GeoIsland3 force;
/
Create type GeoIsland3 as object (
    province EnsProvince3,
    country EnsCountry3,
    island EnsIsland3,
    
);
/

show errors


--GeoDesert
drop type GeoDesert3 force;
/
Create type GeoDesert3 as object (
    province EnsProvince3,
    country EnsCountry3,
    desert EnsDesert3,
    
);
/
show errors

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

--Création des tables
Create table LesGeoMountain3 of Geomountain3;
Create table LesGeoDesert3 of GeoDesert3 ;
Create table LesGeoIsland3 of GeoIsland3 ;

--Geo
drop type geo force;
/
Create type geo as object(
  desert EnsDesert3,
  mountain EnsMountain3,
  island EnsIsland3,
  member function liste return EnsProvince3,
  member function toXML return XMLType,
  )
  
Create table LesDesert3 of Desert3;
Create table LesIsland3 of Island3;
Create table LesMountain3 of Mountain3;

--Peak
drop type Peak force;
/
Create or Replace type Peak as object(
  member function peak_h return number, 
  member function toXML return XMLType,
  
)


Create type EnsGeo as table of geo;
Create table LesGeo of EnsGeo;

--PAYS
drop type country5 force;
/
Create type country5 as object (
  name varchar(10),
  geo EnsGeo,
  peak Peak,
  member function continent_p return Continent3,
  contCountries ContCountries,
  member function blength return number,
  member function toXML return XMLType,
 );
 


 --question 1
Create type body geo as member function liste return EnsProvince3 is res EnsProvince3;
  begin 
      select gm.province, gd.province, gi.province
      from LesGeoMountain3 gm, LesGeoDesert3 gd, LesGeoIsland3 gi,
      where gm.name=table(geo.mountain).name and gi.name=table(geo.island).name and gd.name=table(geo.desert).name
      
      return res
  end;
 end;
 /
 
--question 2

Create table LesCountry5 of country5;

Create type body country5 as
  member function peak_h return number is
  res number;
  h number; -- h correspond à la valeur max
  i number
  begin
    select g.height
    from LesCountry5 c, table(c.geo) g
    where if g.mountain=EMPTY then return 0
          else
              i=0
              h=g.mountain[0]
              for i in g.mountain.COUNT
              loop
                if h<g.mountain[i]
                    h=g.mountain[i]
                i= i+1
              end loop;
              
     return res;
    end;
  end; 
/

--question3

create or replace  type Border4 as object (
   country_f     VARCHAR(10),    
   country_b     VARCHAR(10),
   length_b      VARCHAR(10),
   member function toXML return XMLType
)
/


Create type body country5 as
  member function continent_p return Continent3 is
  res Continent3;
  
  begin 
         Select c.nom
         from LesCountry5 c, table(c.continent) cont1
         where percent=max(cont1.percent)

         return res; 
       end;
    end;
 /
 
Create type ContCountries as object(
    member function f_contCountries return Border4;
 )
 
Create table LesContCountries of ContCountries;
Create table LesBorder4 of Border4;

 
Create type body  as ContCountries
  member function f_contCountries return Border4 is
  res Border4 ;
  
  begin 
        select b.country_b
        from LesBorder4 b,LesCountry5 c1, table (c1.continent) cont1, LesCountry5 c2, table(c2.continent) cont2
        where (continent_p=cont1 and c1.name=b.country_b) or (continent_p=cont2 and c2.name=b.country_b) or cont1=cont2
        
        return res;
        
     end;
     
   end;

-- question 4

Create type body  as country5
  member function blength return number is
  res number ;
  i number;
  begin 
        select *
        from LesCountry5 c, table(c.contCountries) co, Border4 b
        where b.country_f=c.nom and 
          for i in co.COUNT
          sum(co.length_b)
        
        return res;
     end;
  end;
  


-- XML  

create or replace type body geo as
   member function toXML return XMLType is
   output XMLType;
   tmpDesert EnsDesert3;
   tmpMountain EnsMountain3;
   tmpIsland EnsIsland3;
   
   begin
      output := XMLType.createxml('<geo/>');
      
      -- les deserts    
      select value(d) bulk collect into tmpDesert
      from LesDesert3 ;  
      for indx IN 1..tmpDesert.COUNT
      loop
         output := XMLType.appendchildxml(output,'geo',tmpDesert(indx).toXML());   
      end loop;
      return output;
      
      -- les iles    
      select value(i) bulk collect into tmpIsland
      from LesIsland3 ;  
      for indx IN 1..tmpIsland.COUNT
      loop
         output := XMLType.appendchildxml(output,'geo',tmpIsland(indx).toXML());   
      end loop;
      return output;
      
      -- les montagnes    
      select value(m) bulk collect into tmpMountain
      from LesMountain3 ;  
      for indx IN 1..tmpMountain.COUNT
      loop
         output := XMLType.appendchildxml(output,'geo',tmpMountain(indx).toXML());   
      end loop;
      return output;
      
   end;
end;




create or replace type body Peak as
   member function toXML return XMLType is
   output XMLType;
   
   begin
        output := XMLType.createxml('<Peak/>');
   end;
 end;
/


create or replace type body country5 as
   member function toXML return XMLType is
   output XMLType;
   tmpGeo EnsGeo;
   
   
   begin
      output := XMLType.createxml('<country5/>');
      output := XMLType.appendchildxml(output,'country5', 	XMLType('<name>'||name||'</name>'));
      output := XMLType.appendchildxml(output,'country5', 	XMLType('<blength>'||blength||'</blenght>'));
      output := XMLType.appendchildxml(output,'country5', 	XMLType('<continent_p>'||continent_p||'</continent_p>'));
      output := XMLType.appendchildxml(output,'country5', 	XMLType('<peak>'||peak||'</peak>'));
      
      -- contcoutries   
      select value(c) bulk collect into tmpCont
      from LesContCountries c ;  
      for indx IN 1..tmpCont.COUNT
      loop
         output := XMLType.appendchildxml(output,'country5',tmpCont(indx).toXML());   
      end loop;
      return output;
      
      -- geo    
      select value(g) bulk collect into tmpGeo
      from LesGeo g
      for indx IN 1..tmpGeo.COUNT
      loop
         output := XMLType.appendchildxml(output,'country5',tmpGeo(indx).toXML());   
      end loop;
      return output;
      
     
      
   end;
end; 

Create table LesPeak of Peak;
Insert into LesPeak
  select Peak(g.country,m.height)
  from mountain m,geo_mountain g
  where m.name=g.mountain and m.height=(select max(m2.height) 
                                        from mountain m2, geo_mountain g2
                                        where g2.country=g.country and g2.mountain=m2.name);

-- exporter le résultat dans un fichier 
WbExport -type=text
         -file='Peak.xml'
         -createDir=true
         -encoding=ISO-8859-1
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select p.toXML().getClobVal() 
from LesPeak p;


Insert into LesContCountries
  select contCountries(e.country,e.continent)
  from encompasses e
  where e.percentage=(select max(e2.percentage) from encompasses e2 where e2.country=e.country);
  
-- exporter le résultat dans un fichier 
WbExport -type=text
         -file='contCountries.xml'
         -createDir=true
         -encoding=ISO-8859-1
         -header=false
         -delimiter=','
         -decimal=','
         -dateFormat='yyyy-MM-dd'
/
select c.toXML().getClobVal() 
from LesContCountries c;
 
