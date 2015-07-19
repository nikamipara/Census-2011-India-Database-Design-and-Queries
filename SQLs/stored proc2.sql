/* this function is to find average no of person living in a home*/
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
select find_ratio() AS "person per Home";