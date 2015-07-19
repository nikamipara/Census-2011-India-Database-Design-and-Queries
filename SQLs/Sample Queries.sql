/*1. Retrieve all homes  which are below poverty line */

SET SEARCH_PATH TO census;

select (person.fname) as Head_fname ,(person.lname) as Head_fname,t1.home_id,t1.total_income
from  
	(SELECT home.home_id,home.head_pid , (sum(salary)) AS total_income
	FROM  person NATURAL JOIN home
	GROUP BY home.home_id
	HAVING sum(salary)<=100000) as t1 join person on(t1.head_pid=person.pid)


/*2.Retrieve average salary of person in Gujarat */

SET SEARCH_PATH TO census;

SELECT (avg(salary))As avg_salary_per_person_of_Gujarat 
FROM address NATURAL JOIN taluk NATURAL JOIN person
WHERE taluk.sname='GJ';


/*3. •	Retrieve literacy rate in say rajkot gujarat  */
SET SEARCH_PATH TO census;

SELECT ((e1.literate_of_rajkot1::decimal(5,2)) /(e2.total_of_rajkot :: decimal(5,2))*100)::decimal(5,2) AS "Literacy rate of Rajkot"
FROM(SELECT (count(person.pid))As literate_of_rajkot1 
FROM address NATURAL JOIN taluk NATURAL JOIN person
WHERE taluk.dname='Rajkot' and taluk.sname='GJ' 
and person.edu_level is NOT NULL)As e1,
(SELECT (count(person.pid))As total_of_rajkot 
FROM address NATURAL JOIN taluk NATURAL JOIN person
WHERE taluk.dname='Rajkot' and taluk.sname='GJ' )As e2;

/*4. •	Find population of Vododara */

SET SEARCH_PATH TO census;

SELECT (count(person.pid))As "Population of Vadodara" 
FROM address NATURAL JOIN taluk NATURAL JOIN person
WHERE taluk.dname='Vadodara';


/*5. •	What is gender ratio in India state wise */
SET SEARCH_PATH TO census;
select r1.sname,(((fno::decimal(5,2)/tno::decimal(5,2))::decimal(5,2)*1000)::decimal(5,0)) as "Sex Ratio"
from (select count(person.pid) as fno,taluk.sname
from person natural join address natural join taluk
where person.sex ='F'
group by taluk.sname) as r1 natural join
(select count(person.pid) as tno,taluk.sname
from person natural join address natural join taluk
where person.sex ='M'
group by taluk.sname) as r2;


/*6. •	List down all citizens who are Hindu and had salary more than 1 lakhs. */
SET SEARCH_PATH TO census;
select *
from person
where religion='Hindu' and salary>=100000;
/*7.•	Average no of persons living in a home DONE BY STORED PROCEDURE*/

select find_ratio() AS "person per Home";	

/*8. •	Retrieve all senior citizen of vadodara city */
SET SEARCH_PATH TO census;
select person.* 
from person natural join address natural join taluk 
where (current_date-person.dob)::integer /365 > 60 and taluk.tname='Vadodara'

/*9. •	Retrieve all citizen who are student */
SET SEARCH_PATH TO census;
select *
from person 
where person.occupation = 'student';
/*10. •	•	Find Total population of India */
SET SEARCH_PATH TO census;
select count(pid)
from person

/*11. ••	Density of population per sq. km */
SET SEARCH_PATH TO census;
select sname, count(pid)as population, area ,(count(pid)/area)as "Populaton Density"
from person natural join address natural join taluk natural join state_codes
group by sname ,area
/*12. •	•	•	Child sex ratio of india*/
SET SEARCH_PATH TO census;
select((fno::decimal(5,2)/tno::decimal(5,2))::decimal(5,2)*1000)::decimal(5,0) as child_sex_ratio
from (select count(person.pid) as fno from person where person.sex ='F' and (current_date-person.dob)::integer /365 < 12) as r1,
(select count(person.pid) as tno from person where person.sex ='M' and (current_date-person.dob)::integer /365 < 12) as r2;

