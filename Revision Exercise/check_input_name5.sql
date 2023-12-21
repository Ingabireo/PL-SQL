DECLARE
	name employee.emp_last_name%type := '&name';
	cursor c_emp is select * from employee;
	checker int :=0;
	last_name_not_match Exception;
	pragma Exception_init(last_name_not_match,-20001);
BEGIN
	
	for t_emp in c_emp loop
		if t_emp.emp_first_name = name then
			checker := 2;
			dbms_output.put_line('Code: '||t_emp.emp_code);
			dbms_output.put_line('Full Name: '||t_emp.emp_first_name||' '||t_emp.emp_last_name);
			dbms_output.put_line('Department: '||t_emp.emp_department);
			dbms_output.put_line('Salary: '||t_emp.emp_salary);
			dbms_output.put_line('Address: '||t_emp.emp_address);
			dbms_output.put_line('Account: '||t_emp.emp_account);
		end if;
	end loop;

	if(checker = 0) then
		raise_application_error(-20001,'First and last name do not match');
	end if;
Exception
	when last_name_not_match then
		dbms_output.put_line(SQLERRM);
END; 