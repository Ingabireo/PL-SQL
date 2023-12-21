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
	open students_cs;
	
	update students_cs set name = 'Arts' where name = 'CS';


	
	open students;

	dbms_output.put_line(students_cs%rowcount||' has been updated');

	loop 
	fetch students into stud1;

	EXIT WHEN students%notfound;
	if stud1.name = 'Arts' then

	dbms_output.put_line(stud1.Id||'-'||stud1.f_name||' '||stud1.l_name||'-'||stud1.name||' department');
	end if;
	end loop;

	close students;
	close students_cs;

end;
/