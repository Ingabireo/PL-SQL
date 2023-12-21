DECLARE
	id int :=&id;
	cursor c_employee is 
		select * from employee;
		counter int :=0;
BEGIN

	for this_emp in c_employee loop
		if(this_emp.emp_code = id) then
			counter := counter + 1;
			dbms_output.put_line('employee Exists');
			exit;
		end if;
	end loop;
	if(counter = 0) then
		dbms_output.put_line('Employee does not exist');
	end if;

END;

