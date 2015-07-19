
 drop function find_info( varchar(30) ,  varchar(30) );

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
		
		--SET SEARCH_PATH TO census_with_keys;

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