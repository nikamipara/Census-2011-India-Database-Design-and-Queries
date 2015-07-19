drop schema census cascade ;

create schema census;
set search_path to census;


create table state_codes
(
	state_code VARCHAR(2) NOT NULL primary key,
	state_name VARCHAR(30) NOT NULL,
	area DECIMAL(10,0) NOT NULL
);

create table statistics
(
    index VARCHAR(30) NOT NULL PRIMARY KEY default 'DATA',
	literacy_rate DECIMAL(3,0) NOT NULL DEFAULT 0,
	sex_ratio DECIMAL(3,0) NOT NULL DEFAULT 0,
	population integer NOT NULL DEFAULT 0,
	population_density DECIMAL(10,0) NOT NULL DEFAULT 0,
	total_children INTEGER NOT NULL DEFAULT 0,
	total_senior_citizen INTEGER NOT NULL DEFAULT 0,
	total_adults INTEGER NOT NULL DEFAULT 0
);
/*1###########################################################################*/

create table light_source
(
	light_source_typeno DECIMAL(1,0) NOT NULL primary key, /*PK*/ 
	light_source_type VARCHAR(40) NOT NULL
);


/*2###########################################################################*/

create table fuel
(
	fuel_typeno DECIMAL(1,0) NOT NULL primary key, /*PK*/ 
	fuel_type VARCHAR(40) NOT NULL
);

/*3###########################################################################*/

create table water_source
(
	water_source_typeno DECIMAL(1,0) NOT NULL primary key , /*PK*/ 
	water_source_type VARCHAR(40) NOT NULL
);
/*4##########################################################################*/

create table use_of_house
(
	use_of_house_typeno DECIMAL(1,0) primary key NOT NULL, /*PK*/ 
	use_of_house_type VARCHAR(40) NOT NULL
);
/*5##########################################################################*/

create table taluk
(
	tno DECIMAL(4,0) NOT NULL primary key , /*PK*/
	tname VARCHAR(40) NOT NULL,
	dname VARCHAR(40) NOT NULL,
	sname VARCHAR(2) NOT NULL REFERENCES state_codes/*REFERENCES 
state_area*//* FK */
	ON DELETE NO ACTION
);

/*6##########################################################################*/

create table address
(
	home_id DECIMAL (10,0) NOT NULL primary key, /*PK*/
	--census_year DECIMAL (4,0) NOT NULL,
	home_no VARCHAR(10),
	name_of_society VARCHAR (30),
	ward_no DECIMAL(2,0),
	town_or_villiage_name VARCHAR (30) NOT NULL,
	tno DECIMAL(4,0) NOT NULL REFERENCES taluk/*FK*/
	ON DELETE NO ACTION
);
/*7#########################################################################*/

create table el_items_type
(
	item_typeno DECIMAL (1,0) NOT NULL primary key , /*PK*/
	item_name VARCHAR (40) NOT NULL
);

/*8#########################################################################*/

create table vehicle_type
(
	vehicle_typeno DECIMAL (1,0) primary key,/*PK*/
	vehicle_name VARCHAR (40)
);

/*9##########################################################################*/

create table roof_material
(
	roof_no DECIMAL (2,0) NOT NULL primary key ,/*PK*/
	roof_type VARCHAR (40) NOT NULL
);
/*10##########################################################################*/

create table floor_material
(
	floor_no DECIMAL (2,0) NOT NULL primary key ,/*PK*/
	floor_type VARCHAR (40) NOT NULL
);

/*11##########################################################################*/

create table wall_material
(
	wall_no DECIMAL (2,0) NOT NULL primary key ,/*PK*/
	wall_type VARCHAR (40) NOT NULL
);
/*12############################################################################*/

create table non_eco_activity
(
	non_eco_activity_no DECIMAL(1,0) NOT NULL primary key ,
	non_eco_activity_type VARCHAR(40) NOT NULL
);

/*13############################################################################*/

create table marital_status
(
	marital_status_no DECIMAL(1,0) NOT NULL primary key ,
	marital_status_type VARCHAR(40) NOT NULL
);

/*14###########################################################################*/

create table disability
(
	disability_no DECIMAL(1,0) NOT NULL primary key ,
	disability_type VARCHAR(40) NOT NULL
);

/*15###########################################################################*/

create table state_of_attendance
(
	attendance_no DECIMAL(1,0) NOT NULL primary key ,
	attendance_type VARCHAR(40) NOT NULL
);

/*16#########################################################################*/
create table material
(
	material_no DECIMAL(6,0) NOT NULL UNIQUE primary key,/*PK*/
	roof_no DECIMAL (2,0) NOT NULL REFERENCES roof_material,/*FK*/
	wall_no DECIMAL (2,0) NOT NULL REFERENCES wall_material,/*FK*/
	floor_no DECIMAL (2,0) NOT NULL REFERENCES floor_material/*FK*/
);

/*create table material as
(
select 
wall_material.wall_no , 
roof_material.roof_no , 
floor_material.floor_no 
from wall_material, roof_material, floor_material 
);

alter table material
add column material_no serial UNIQUE primary key,
add constraint wallfk FOREIGN keys(wall_no) REFERENCES wall_material(wall_no),
add constraint rooffk FOREIGN keys(roof_no) REFERENCES roof_material(roof_no),
add constraint floorfk FOREIGN keys(floor_no) REFERENCES floor_material(floor_no);
*/
/*17#########################################################################*/

create table person
(
	pid DECIMAL(12,0) NOT NULL primary key ,
	home_id DECIMAL (10,0),/*a person can be homeless*/
	--census_year DECIMAL (4,0) NOT NULL,
	fname VARCHAR(20),
	lname VARCHAR(20),
	occupation VARCHAR(30),
	salary DECIMAL (10,0) NOT NULL CHECK(salary >= 0),/* zero if he or she is not earning*/
	non_eco_activity_no DECIMAL(1,0) REFERENCES non_eco_activity ON DELETE SET DEFAULT ,/*FK*/
	mode_of_travel_to_work VARCHAR(20),/*if he is jobless then value=NULL*/
	attendance_no DECIMAL(1,0) REFERENCES state_of_attendance,
	DOB DATE NOT NULL,/*if he doesnt know then an approax value is put*/
	edu_level VARCHAR(20) ,/*ENTER NULL IF HE OR SHE IS ILLITERATE*/
	marital_status_no DECIMAL(1,0) NOT NULL REFERENCES marital_status ON DELETE SET DEFAULT ,/*fk*/
	
	mother_tongue VARCHAR(20) ,
	literacy_status VARCHAR(15),
	sex CHAR(1) NOT NULL CHECK(sex in ('M','F','OTHER')),
	caste VARCHAR(5) NOT NULL CHECK(caste in ('SC','ST','OBC','OTHER')),
	religion VARCHAR(20),/*not cumpulsory to have a religion*/
	disability_no DECIMAL(1,0) REFERENCES disability ON DELETE SET DEFAULT ,/*null= no disabilty*/
	no_of_children DECIMAL (1,0)/*null=no child*/
	
);
/*18##########################################################################*/
create table home
(
	home_id DECIMAL (10,0) NOT NULL CHECK(home_id>=0) primary key,/*DECIMAL(total precision,scale)*/
	/*--census_year DECIMAL (4,0)  NOT NULL  CHECK(--census_year>0),*/
	ownership_status VARCHAR(20)  NOT NULL CHECK( ownership_status in ('OWNED' ,'RENTED','OTHER')),
	no_of_dwelling_rooms DECIMAL(3,0),/*if any null values then value=0*/
	no_of_married_couples DECIMAL(2,0),/*if any null values then value=0*/
	drinking_water_within_premises CHAR(1) NOT NULL CHECK ( drinking_water_within_premises in ('Y' ,'N')),
	water_source_typeno DECIMAL(1,0) REFERENCES water_source ON DELETE NO ACTION,/*FK*/
	light_source_typeno DECIMAL(1,0) REFERENCES light_source ON DELETE NO ACTION,/*FK*/
	latrine_within_premises CHAR(1) NOT NULL CHECK ( latrine_within_premises in ('Y' ,'N')),
	fuel_typeno DECIMAL(1,0)   REFERENCES fuel ON DELETE NO ACTION,/*FK*/
	bathing_facility CHAR(1) NOT NULL CHECK ( bathing_facility in ('Y' ,'N')),
	availibility_of_kitchen CHAR(1) NOT NULL CHECK ( availibility_of_kitchen in ('Y' ,'N')),
	/*availibility_of_banking CHAR(1) NOT NULL CHECK ( availibility_of_banking in ('Y' ,'N')),*/
	use_of_house_typeno DECIMAL(1,0) NOT NULL REFERENCES use_of_house ON DELETE NO ACTION,/*FK*/
	material_no INTEGER NOT NULL REFERENCES material ON DELETE NO ACTION,/*FK*/
	head_pid DECIMAL(12,0) NOT NULL REFERENCES person ON DELETE NO ACTION/*FK..Yearwise?? problem :| */

	
);
/*19##########################################################################*/

create table electronic_items_of_house
(
	home_id DECIMAL (10,0) NOT NULL REFERENCES home ON DELETE NO ACTION, /*FK???*/

	----census_year DECIMAL (4,0) NOT NULL,
	item_typeno DECIMAL (1,0) REFERENCES el_items_type ON DELETE NO ACTION, /*NOT NULL?? */   /*FK*/
	primary key(home_id,item_typeno)
);


/*20#########################################################################*/

create table vehicle
(
	home_id DECIMAL (10,0) NOT NULL REFERENCES home ON DELETE NO ACTION,
	----census_year DECIMAL (4,0),
	vehicle_typeno DECIMAL (1,0) NOT NULL REFERENCES vehicle_type ON DELETE NO ACTION,/*FK*/
	primary key(home_id,vehicle_typeno)
);


/*21#########################################################################*/

create table known_languages
(
	pid DECIMAL(12,0) NOT NULL REFERENCES person ON DELETE NO ACTION,/*FK*/
	--census_year DECIMAL (4,0) NOT NULL,
	language_name VARCHAR (20) NOT NULL,
	primary key(pid,language_name)
);



/*22###########################################################################*/

create table relationship_with_head
(
	pid DECIMAL(12,0) NOT NULL REFERENCES person ON DELETE NO ACTION,/*FK*/
--	--census_year DECIMAL (4,0) NOT NULL ,
	relashionship VARCHAR(20) NOT NULL ,
	primary key(pid,relashionship)
);

--##############################################################################
--create view temp as select roof_material.roof_no , wall_material.wall_no , floor_material.floor_no FROM roof_material, wall_material, floor_material ;

/*#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################*/
/*TRIGGER TO UPDATE OR CREATE MATERIAL TABLE*/
/*TRIGGER TO UPDATE OR CREATE MATERIAL TABLE*/
set search_path to census;
 create or replace function update_material()
 returns trigger as $$
 begin 
	if (TG_OP='INSERT') THEN
	truncate material cascade;
	insert into material(material_no,roof_no,wall_no,floor_no) SELECT (10000*roof_material.roof_no)+(100*wall_material.wall_no)+(1*floor_material.floor_no),roof_material.roof_no,wall_material.wall_no,floor_material.floor_no from roof_material,wall_material,floor_material;
	end if;
	RETURN NULL;
 end;
	$$ LANGUAGE plpgsql;

/*TRIGGER ON UPDATE OF ROOF MATERIAL*/
create trigger update_material_trigger1
after insert on roof_material
for each row execute procedure update_material();

/*TRIGGER ON UPDATE OF WALL MATERIAL*/
create trigger update_material_trigger2
after insert on wall_material
for each row execute procedure update_material();
/*TRIGGER ON UPDATE OF FLOOR MATERIAL*/
create trigger update_material_trigger3
after insert on floor_material
for each row execute procedure update_material();


/*#*.................*.**.*.......................................*.*..*.**/
--roof_material.roof_no , wall_material.wall_no , floor_material.floor_no FROM roof_material, wall_material, floor_material ;
/*
 create or replace function counter() returns trigger as $$
 declare
	_population integer :=0;
	_literacy_rate literacy_rate DECIMAL(3,0):=0;
	_sex_ratio DECIMAL(3,0):=0;
	_population DECIMAL(3,0):=0;
	_population_density DECIMAL(6,0):=0;
	_total_children INTEGER:=0;
	_total_senior_citizen INTEGER:=0;
	_total_adults INTEGER:=0;

begin
	if(TG_OP='INSERT') THEN
	_population=_population+1;
	if
	insert into statistics values (_population,DEFAULT);
	end if;
end
*/
 
/*###############################STORED PROCEDURE TO ANS SOME QUARRIES ######################################*/
 create or replace function find_info( state_ varchar(30) , action_ varchar(30) ) returns real AS
 $$
 declare
 temp real;
 temp2 bigint;
 begin 
	case action_
		WHEN 'population' then
			select count(pid) into temp2 from person natural join address natural join taluk where taluk.sname=state_ ;
			temp=(temp2::bigint);
		--raise notice 'Population of State % is %',state_,temp;
		--return temp;
		--when
		when 'sex_ratio' then
			
		select(((fno::decimal(5,2)/tno::decimal(5,2))::decimal(5,2)*1000)::decimal(5,0)) into temp
		from (select count(person.pid) as fno
		from person natural join address natural join taluk
		where person.sex ='F' AND taluk.sname=state_) as r1 natural join
		(select count(person.pid) as tno
		from person natural join address natural join taluk
		where person.sex ='M'
		AND taluk.sname=state_) as r2;

		when 'literacy_rate' then
		
		--SET SEARCH_PATH TO census;

		SELECT ((e1.literate_of_rajkot1::decimal(5,2)) /(e2.total_of_rajkot :: decimal(5,2))*100)::decimal(5,2) into temp
		FROM(SELECT (count(person.pid))As literate_of_rajkot1 
		FROM address NATURAL JOIN taluk NATURAL JOIN person
		WHERE taluk.sname=state_ 
		and person.edu_level is NOT NULL)As e1,
		(SELECT (count(person.pid))As total_of_rajkot 
		FROM address NATURAL JOIN taluk NATURAL JOIN person
		WHERE taluk.sname=state_ )As e2;

		when 'area' then
		
		select state_codes.area into temp from state_codes where state_code=state_;
	end case;
return temp;
end;
	$$ language plpgsql;
--select find_info('RJ','population');
--select find_info('GJ','area');
--select find_info('GJ','literacy_rate');
--select find_info('GJ','sex_ratio');
	
/*###############################THIS PROCEDURE  is to find average no of person living in a home######################################*/
 create or replace function find_ratio() returns real AS
 $$
 declare
 temp real;
 person_ bigint;
 home_ bigint;
 begin 
	
	select count(pid) into person_
	from person;
	
	select count(home_id) into home_
	from home;
	
	temp = (person_/home_)::real;
return temp;
end;
	$$ language plpgsql;
--select find_ratio() AS "person per Home";	
--################################################################################
--################################################################################	
	create or replace function counter() returns trigger as
	$$
	declare 
	--gender person.sex%TYPE;
	female integer:=0;
	_population integer:=0;
	literates integer:=0;
	child integer:=0;
	adults integer:=0;
	senior integer:=0;
	_area decimal(11,0):=0;
	begin
	if(TG_OP='INSERT') then
		_population=_population+1;
		--select person.sex into gender  from person where person.pid
		if(NEW.sex='F') then
			female=female+1;
		end if;
		if(NEW.literacy_status='literate') then
			literates=literates+1;
		end if;
		if(((current_date-NEW.dob)::integer /365 )< 12) then
			child=child+1;
		elsif(((current_date-NEW.dob)::integer /365 ) > 12) then
			adults=adults+1;
		elsif(((current_date-NEW.dob)::integer /365 ) > 65) then
			senior=senior+1;
		end if;
		select sum(area) into _area from state_codes;
		update census.statistics
		set literacy_rate=(literates::decimal(12,2))/(population::decimal(12,2))
		,	sex_ratio=(female::decimal(12,2))/(population::decimal(12,2))
		,	population=_population
		,	population_density=((_population::decimal(12,0))/_area)::decimal(12,2)
		,	total_children=child
		,	total_senior_citizen=senior
		,	total_adults=adults
		where index='DATA';
		end if;
		
	if(TG_OP='DELETE') then
		_population=_population-1;
		--select person.sex into gender  from person where person.pid
		if(OLD.sex='F') then
			female=female-1;
		end if;
		if(OLD.literacy_status='literate') then
			literates=literates-1;
		end if;
		if(((current_date-OLD.dob)::integer /365 )< 12) then
			child=child-1;
		elsif(((current_date-OLD.dob)::integer /365 ) > 12) then
			adults=adults-1;
		elsif(((current_date-OLD.dob)::integer /365 ) > 65) then
			senior=senior-1;
		end if;
		select sum(area) into _area from state_codes;
		update statistics
		set literacy_rate=(literates::decimal(12,2))/(population::decimal(12,2))
		,	sex_ratio=(female::decimal(12,2))/(population::decimal(12,2))
		,	population=_population
		,	population_density=((_population::decimal(12,0))/_area)::decimal(12,2)
		,	total_children=child
		,	total_senior_citizen=senior
		,	total_adults=adults
		where statistics='DATA';
		end if;
		
	if(TG_OP='UPDATE') then
			if(OLD.sex='F' and NEW.sex='M') then
			female=female-1;
			elsif(old.sex='M' and NEW.sex='F') then
			female=female+1;
			end if;
			if(OLD.literacy_status='literate' and NEW.literacy_status='illiterate') then
			literates=literates-1;
			elsif(OLD.literacy_status='illiterate' and NEW.literacy_status='literate') then
			female=female+1;
			end if;
		select sum(area) into _area from state_codes;
		update statistics
		set literacy_rate=(literates::decimal(12,2))/(population::decimal(12,2))
		,	sex_ratio=(female::decimal(12,2))/(population::decimal(12,2))
		,	population=_population
		,	population_density=((_population::decimal(12,0))/_area)::decimal(12,2)
		,	total_children=child
		,	total_senior_citizen=senior
		,	total_adults=adults
		where index='DATA';
	end if;
return null;
	end;
$$ language plpgsql;
	
create trigger update_stat
after insert or delete or update on person
for each row execute procedure counter();
		
/*################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################*/



set search_path to census;
INSERT INTO census.state_codes(state_code, state_name,area)

    VALUES
 ('AP','Andhra Pradesh',196024)
,('GJ','Gujarat',103552)
,('RJ','Rajasthan',123453)
,('MH','Maharastra',789456)
,('DL','Delhi',456789);

INSERT INTO census.water_source(water_source_typeno, water_source_type)

    VALUES(0,'N/A')
,(1,'Tap water(treated)')
,(2,'Tapwater(untreated)')
,(3,'Covered Well')
,(4,'Un-covered well')
,(5,'Hand Pump')
,(6,'Tubewell/borehole')
,(7,'Spring')
,(8,'River/canal')
,(9,'Tank/pond/lake');


INSERT INTO census.wall_material(
            wall_no, wall_type)
    Values(0,'N/A')
,(1,'Grass/thatch/... etc')
,(2,'Plastic/Polythene')
,(3,'Mud/unburnt brick')
,(4,'Wood')
,(5,'Stone ! packed with')
,(6,'Stone packed with')
,(7,'G.I./metal/abestos')
,(8,'Burnt Brick')
,(9,'Concrete');


INSERT INTO census.vehicle_type(
            vehicle_typeno, vehicle_name)
    VALUES (0,'None')
,(1,'Bicycle')
,(2,'Scooter/Moped')
,(3,'Car/Jeep/Van');

INSERT INTO census.use_of_house(
            use_of_house_typeno, use_of_house_type)
    VALUES (0,'Vacant')
,(1,'Residence')
,(2,'Residence other use')
,(3,'Shop/office')
,(4,'School/College etc')
,(5,'Hotel/guesthouse etc')
,(6,'Hospital/dispensary')
,(7,'Factory/workshop etc')
,(8,'Place of worship')
,(9,'non-residential use');

INSERT INTO census.state_of_attendance(
            attendance_no, attendance_type)
    VALUES (0,'N/A')
,(1,'School')
,(2,'College')
,(3,'Vocational')
,(4,'Inst. for disabled')
,(5,'Literacy centre')
,(6,'Other institution')
,(7,'Attended before')
,(8,'Never attended');


INSERT INTO census.non_eco_activity(
            non_eco_activity_no, non_eco_activity_type)
    VALUES (0,'N/A')
,(1,'Student')
,(2,'Hosehold duties')
,(3,'Dependent')
,(4,'Pensioner')
,(5,'Rentier')
,(6,'Beggar')
,(7,'Other');

INSERT INTO census.marital_status(
            marital_status_no, marital_status_type)
    VALUES (0,'N/A')
,(1,'Never married')
,(2,'Currently married')
,(3,'Widowed')
,(4,'Separated')
,(5,'Divorced');

INSERT INTO census.light_source(
            light_source_typeno, light_source_type)
    VALUES (0,'N/A')
,(1,'Electricity')
,(2,'Kerosene')
,(3,'Solar')
,(4,'Other oil')
,(5,'Any other')
,(6,'No lightning');

INSERT INTO census.fuel(
            fuel_typeno, fuel_type)
    VALUES (0,'N/A')
,(1,'Firewood')
,(2,'Crop residue')
,(3,'Cowdung cake')
,(4,'Coal/lignite/...')
,(5,'Kerosene')
,(6,'LPG/PNG')
,(7,'Electricity')
,(8,'Bio-gas')
,(9,'Any other');

INSERT INTO census.floor_material(
            floor_no, floor_type)
    VALUES (0,'N/A')
,(1,'Mud')
,(2,'Wood/bamboo')
,(3,'Burnt Brick')
,(4,'Stone')
,(5,'Cement')
,(6,'Mosaic/floor tiles')
,(7,'Any other');

INSERT INTO census.el_items_type(
            item_typeno, item_name)
    VALUES (0,'None')
,(1,'Radio/Transistor')
,(2,'Television')
,(3,'Computer/Laptop')
,(4,'Tele/Mobile-phone');


INSERT INTO census.roof_material(
            roof_no, roof_type)
    VALUES (0,'N/A')
,(1,'Grass/bamboo/.. etc')
,(2,'Plastic/Polythene')
,(3,'Hand made tiles')
,(4,'Machine made tiles')
,(5,'Burnt brick')
,(6,'Stone')
,(7,'Slate')
,(8,'G.I./metal/abestos')
,(9,'Concrete');


INSERT INTO census.disability(
            disability_no, disability_type)
    VALUES (0,'None')
    ,(1,'In seeing')
,(2,'In hearing')
,(3,'In speech')
,(4,'In Movement')
,(5,'Mental retardness')
,(6,'Mental illness')
,(7,'Any Other')
,(8,'Multiple disability');

/*#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################
#####################################################################################################################################################*/

INSERT INTO census.taluk(
            tno, tname, dname, sname)
    Values(1,'Valsad','Valsad','GJ' )
    , (2,'Sankheda','Vadodara' ,'GJ' )
    , (3,'Vadodara','Vadodara' ,'GJ' )  
    , (4,'Vasana','Rajkot','GJ')
    , (5,'Virpur','Vasana','RJ' )  
    , (6, 'Malpura', 'Banswara','RJ' )
    , (7, 'Rampur', 'Bhilwara','RJ' )    
    , (8,'Kamanpalle','Adilabad' ,'AP' )
    , (9,'gudupalle','Chittor' ,'AP' );

INSERT INTO census.address(
            home_id, home_no, name_of_society, ward_no, town_or_villiage_name, 
            tno)
    Values(1, 'Q-13','Govt Colony', 99, 'Valsad', 
            1)
    , (2, 'Q-14','Amar Colony', 98, 'Sankheda', 
            2)
    , (3, 'Q-15','Akbar Colony', 97, 'Vadodara', 
            3)
    , (4, 'Q-16','Anthony Colony', 96, 'Vasana', 
            4)
    , (5, 'Q-17','Birbal Society', 95, 'Virpur', 
            5)
    , (6, 'Q-18','A Society', 94, 'Malpura', 
            6)
    , (7, 'Q-19','B Colony', 93, 'Rampur', 
            7)
    , (8, 'Q-20','C Colony', 92, 'Kamanpalle', 
            8)
    , (9, 'Q-21','D Colony', 91, 'gudupalle', 
            9) ;      

INSERT INTO census.person(
            pid, home_id, fname, lname, occupation, salary, non_eco_activity_no, 
            mode_of_travel_to_work, attendance_no, dob, edu_level, marital_status_no, 
            mother_tongue, literacy_status, sex, caste, religion, disability_no, 
            no_of_children)
    Values(1, 1, 'Hardik', 'Dhimmar', 'student', 0, 1, 
            'Walking',2 , '1991-04-21', 'B.Tech', 1, 
            'Gujarati', 'literate', 'M', 'OTHER', 'Hindu', 0, 
            0)
    , (2, 1, 'Ashwin', 'Dhimmar', 'Teacher', 250000, 5, 
            'Car',6 , '1964-12-27', 'Diploma', 2, 
            'Gujarati', 'literate', 'M', 'OTHER', 'Hindu', 0, 
            2)
    , (3, 1, 'Naina', 'Dhimmar', 'Household', 0, 2, 
            'None', 1, '1967-09-01', 'Diploma', 2, 
            'Gujarati', 'literate', 'F', 'OTHER', 'Hindu', 0, 
            2)
     , (4, 1, 'Tisha', 'Dhimmar', 'student', 0, 1, 
            'Auto-rikshaw', 1, '2002-10-04', 'student', 5, 
            'Gujarati', 'literate', 'F', 'OTHER', 'Hindu', 0, 
            0)

            
     , (5, 2, 'Nikunj', 'Amipara', 'student', 20000, 1, 
            'Walking',2 , '1992-10-29', 'B.Tech', 1, 
            'Gujarati', 'literate', 'M', 'OBC', 'None', 0, 
            0)
      , (6, 2, 'Maganbhai', 'Amipara', 'Acoountant', 3000000, 5, 
            'Car',6 , '1964-06-17', 'B.E', 2, 
            'Gujarati', 'literate', 'M', 'OBC', 'Hindu', 2, 
            1)
    , (7, 2, 'Kiranben', 'Amipara', 'Household', 4000000, 2, 
            'None', 1, '1967-05-04', 'LLB', 2, 
            'Gujarati', 'literate', 'F', 'OBC', 'Hindu', 0, 
            1)

            


     , (8, 3, 'Utsav', 'Patel', 'student', 0, 1, 
            'Bike',2 , '1992-01-18', 'B.Tech', 1, 
            'Gujarati', 'literate', 'M', 'SC', 'Hindu', 0, 
            0)
    , (9, 3, 'Sudhirbhai', 'Patel', 'Engineer', 150000, 5, 
            'Car',6 , '1964-12-27', 'B.E', 2, 
            'Gujarati', 'literate', 'M', 'SC', 'Hindu', 0, 
            2)
    , (10, 3, 'Varsha', 'Patel', 'Household', 0, 2, 
            'None', 1, '1967-09-01', 'LLB', 2, 
            'Gujarati', 'literate', 'F', 'SC', 'Hindu', 0, 
            2)
     , (11, 3, 'Vansh', 'Patel', 'student', 0, 1, 
            'Auto-rikshaw', 1, '1997-10-14', 'student', 5, 
            'Gujarati', 'literate', 'M', 'SC', 'Hindu', 0, 
            0)
	 , (28, 3, 'Ambubhai', 'Patel', 'farmer', 0, 1, 
            'Bus', 1, '1947-10-14', NULL, 5, 
            'Gujarati', 'illiterate', 'M', 'SC', 'Hindu', 0, 
            0)



     , (12, 4, 'Piyush', 'Kapoor', 'student', 0, 1, 
            'Bike',2 , '1990-01-20', 'B.E', 1, 
            'Gujarati', 'literate', 'M', 'ST', 'Hindu', 0, 
            0)
    , (13, 4, 'Rajendra', 'Kapoor', 'Manager', 650000, 5, 
            'Car',6 , '1964-12-27', 'MSc', 2, 
            'Gujarati', 'literate', 'M', 'ST', 'Hindu', 0, 
            1)
    , (14, 4, 'Sarita', 'Kapoor', 'Household', 200000, 2, 
            'None', 1, '1967-09-01', 'LLB', 2, 
            'Gujarati', 'literate', 'F', 'ST', 'Hindu', 0, 
            1) 
	,(29, 3, 'Harry', 'Potter', 'Magician', 0, 1, 
            'Broomstick', 1, '1937-07-31', NULL, 5, 
            'Gujarati', 'illiterate', 'M', 'SC', 'Hindu', 0, 
            0)			

     , (15, 5, 'Parth', 'Shah', 'student', 0, 1, 
            'Bike',2 , '1997-01-20', 'Studying', 1, 
            'Spanish', 'literate', 'M', 'OTHER', 'Muslim', 0, 
            0)
    , (16, 5, 'Ajitbhai', 'Shah', 'Chartered Accountant', 350000, 5, 
            'Car',6 , '1964-06-30', 'Chartered Accountant', 2, 
            'Gujarati', 'literate', 'M', 'OTHER', 'Muslim', 0, 
            1)
    , (17, 5, 'Minaben', 'Shah', 'Household', 0, 2, 
            'None', 1, '1967-10-06', 'LLB', 2, 
            'Gujarati', 'literate', 'F', 'OTHER', 'Muslim', 0, 
            1)


    , (18, 6, 'Ross', 'Geller', 'Paleontologist', 55000, 5, 
            'Car',6 , '1964-06-30', 'Paleontologist Phd', 2, 
            'Gujarati', 'literate', 'M', 'OTHER', 'Christian', 0, 
            2)
    , (19, 6, 'Rachel', 'Geller', 'Fashion Designer', 10000, 2, 
            'None', 1, '1967-10-06', 'Fashion Designer', 2, 
            'Gujarati', 'illiterate', 'F', 'OTHER', 'Christian', 0, 
            2) 


     , (20, 7, 'Joey', 'Tribuoni', 'Actor', 50000, 5, 
            'Car',6 , '1964-06-30', 'Paleontologist Phd', 2, 
            'Spanish', 'illiterate', 'M', 'OTHER', 'None', 0, 
            2)


	, (27, 4, 'Smriti', 'Patel', 'Actor', 50000, 5, 
            'Car',6 , '1964-08-30', null, 2, 
            'mandarine', 'illiterate', 'F', 'OTHER', 'None', 0, 
            2)




            

      , (21, 8, 'Achal', 'Seksaria', 'student', 0, 1, 
            'Bike',2 , '1991-01-21', 'Studying', 1, 
            'French', 'literate', 'M', 'OTHER', 'Muslim', 0, 
            0)
    , (22, 8, 'Aman', 'Seksaria', 'Chartered Accountant', 850000, 5, 
            'Car',6 , '1964-06-20', 'Chartered Accountant', 2, 
            'French', 'literate', 'M', 'OTHER', 'Muslim', 0, 
            1)
    , (23, 8, 'Minaxi', 'Seksaria', 'Household', 0, 2, 
            'None', 1, '1967-10-03', 'LLB', 2, 
            'French', 'literate', 'F', 'OTHER', 'Muslim', 0, 
            1)   

                
      , (24, 9, 'Jatan', 'Panchal', 'student', 0, 1, 
            'Bike',2 , '1991-03-21', 'Studying', 1, 
            'Telugu', 'literate', 'M', 'OTHER', 'None', 0, 
            0)
    , (25, 9, 'Rameshbhai', 'Panchal', 'Chartered Accountant', 1150000, 5, 
            'Car',6 , '1964-07-20', 'Chartered Accountant', 2, 
            'Telugu', 'literate', 'M', 'OTHER', 'None', 0, 
            1)
    , (26, 9, 'Mammi', 'Panchal', 'Household', 0, 2, 
            'None', 1, '1967-12-03', 'LLB', 2, 
            'Telugu', 'literate', 'F', 'OTHER', 'None', 0, 
            1)   ;


INSERT INTO census.known_languages(
            pid, language_name)
    VALUES     (1, 'marathi'),
    (1, 'gujarati'),
    (1, 'hindi'),
    (2, 'hindi'),
    (3, 'hindi'),
    (4, 'french'),
    (4, 'hindi'),
    (5, 'hindi'),
    (6, 'hindi'),
    (6, 'english'),
    (7, 'hindi'),
    (8, 'hindi'),
    (9, 'hindi'),
    (10, 'hindi'),
    (11, 'hindi'),
    (12, 'hindi'),
    (13, 'hindi'),
    (14, 'hindi'),
    (15, 'hindi'),
    (16, 'hindi'),
    (17, 'hindi'),
    (18, 'hindi'),
    (19, 'hindi'),
    (20, 'hindi'),
    (21, 'hindi'),
    (22, 'hindi'),
    (23, 'hindi'),
    (24, 'hindi'),
    (25, 'hindi'),
    (26, 'hindi'),
    (27, 'hindi'),
    (28, 'hindi'),
    (29, 'hindi'),
    (5, 'spanish');
	



  



INSERT INTO census.home(
            home_id, ownership_status, no_of_dwelling_rooms, no_of_married_couples, 
            drinking_water_within_premises, water_source_typeno, light_source_typeno, 
            latrine_within_premises, fuel_typeno, bathing_facility, availibility_of_kitchen, 
            use_of_house_typeno, material_no, head_pid)
	Values(1, 'RENTED', 2, 1, 
            'Y', 1, 1, 
            'Y', 7, 'Y', 'Y', 
            1, 10000,2)
	, (2, 'RENTED', 2, 1, 
            'Y', 1, 1, 
            'Y', 7, 'Y', 'Y', 
            1, 105,5)
	, (3, 'OWNED', 1, 3, 
            'Y', 3, 2, 
            'Y', 6, 'Y', 'Y', 
            1, 10901,10)
	, (4, 'OTHER', 1, 4, 
            'Y', 4, 4, 
            'N', 5, 'N', 'Y', 
            4, 60100,13)
	, (5, 'OWNED', 2, 1, 
            'Y', 1, 1, 
            'Y', 4, 'Y', 'Y', 
            1, 40000,15)
	, (6, 'RENTED', 3, 1, 
            'Y', 2, 5, 
            'Y', 1, 'Y', 'Y', 
            1, 20300,18)
	, (7, 'RENTED', 2, 1, 
            'Y', 5, 1, 
            'Y', 9, 'Y', 'Y', 
            1, 60101,20)
	, (8, 'OWNED', 4, 1, 
            'Y', 5, 6, 
            'Y', 7, 'Y', 'Y', 
            2, 107,23)
	, (9, 'RENTED', 3, 1, 
            'Y', 1, 1, 
            'Y', 6, 'Y', 'Y', 
            2, 30102,24);


INSERT INTO census.vehicle(
            home_id, vehicle_typeno)
    Values(1, 1)  
    , (1, 2)
    , (1, 3)
    , (2, 3)          
    , (3, 1)
    , (4, 2)
    , (5, 1)
    , (5, 2)
    , (6, 2)
    , (6, 3)
    , (7, 3)
    , (8, 2)
    , (9, 1);	

INSERT INTO census.electronic_items_of_house(
            home_id, item_typeno)
    Values(1, 1)    
    , (1, 2)
    , (1, 3)
    , (1, 4)
    , (2, 1)
    , (2, 3)
    , (3, 1)
    , (4, 2)
    , (4, 3)
    , (5, 4)
    , (6, 1)
    , (6, 3)
    , (6, 4)
    , (7, 2)
    , (8, 4)
    , (9, 3);


INSERT INTO census.relationship_with_head(
            pid, relashionship)
    Values(1, 'Father')
    , (2, 'Himself')
    , (3, 'Husband')
    , (4, 'Father')
    
    , (5, 'Himself')
    , (6, 'Son')
    , (7, 'Son')
    
    , (8, 'Mother')
    , (9, 'Wife')
    , (10, 'Himself')
    , (11, 'Mother')
    
    , (12, 'Father')
    , (13, 'Himself')
    , (14, 'Husband')
    
    , (15, 'Himself')
    , (16, 'Son')
    , (17, 'Son')
    
    , (18, 'Himself')
    , (19, 'Husband')
    
    , (20, 'Himself')
    
    , (21, 'Mother')
    , (22, 'Wife')
    , (23, 'Himself')

    , (24, 'Himself')
    , (25, 'Son')
    , (26, 'Son');	 
                            