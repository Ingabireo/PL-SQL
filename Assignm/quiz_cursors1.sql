
DECLARE
	cs_id departments.Id%type;
	arts_id departments.Id%type;

	cursor students_cs is select student.id as id, student.f_name,l_name, student.dpt_id, departments.id as d_id,departments.name from student, departments where student.dpt_id = departments.Id and departments.name = 'CS';
	cursor students is select student.id as id, student.f_name,l_name, student.dpt_id, departments.id as d_id,departments.name from student, departments where student.dpt_id = departments.Id; 

	stud1 students%rowtype;

BEGIN

	select id into cs_id from departments where name = 'CS';

	select id into arts_id from departments where name = 'Arts';	
	
	update student set dpt_id = arts_id where dpt_id = cs_id;
		

	open students;

	loop 
	fetch students into stud1;

	EXIT WHEN students%notfound;


	if stud1.dpt_id = arts_id then
		update students set students.nam
		update student set dpt_id = arts_id where dpt_id = cs_id AND id = stud1.id;
		dbms_output.put_line(stud1.Id||'-'||stud1.f_name||' '||stud1.l_name|'-'|stud1.name||' department');
	end if;

	end loop;

	dbms_output.put_line(students%rowcount||' has been updated');

	close students;

end;
/






CREATE TABLE STUDENT
(	Id int PRIMARY KEY,
	f_name varchar(15),
	l_name varchar(15),
	dpt_id int	
);

CREATE Table departments
(
	id int PRIMARY KEY,
	name varchar(10)
);

alter table student add foreign key (dpt_id) references departments (id);

insert into student values (1,'Ingabire','Olivier',1);
insert into student values (2,'Munezero','Eugene',2);
insert into student values (3,'Safari','Samuel',3);
insert into student values (4,'Mugisha','Arsene',1);
insert into student values (5,'Mudaheranwa','Lingard',2);
insert into student values (6,'Ishimwe','Eugene',2);
insert into student values (7,'Niyonkuru','Samuel',4);
insert into student values (8,'Itangishaka','Arsene',1);
insert into student values (9,'Nshuti','Lingard',3);


insert into departments values (1,'Arts');
insert into departments values (2,'CS');
insert into departments values (3,'Computer');
insert into departments values (4,'Software');
insert into departments values (5,'Medecine');

