DECLARE
	CURSOR all_employees is select emp_code,emp_salary from employee;
	salary float;
	counter int:=0;
BEGIN
	for c_employee in all_employees loop
		if(c_employee.emp_salary > 200) then
			counter := counter + 1;
			update employee set emp_salary = emp_salary -200 where emp_code = c_employee.emp_code;
			select emp_salary into salary from employee where emp_code = c_employee.emp_code;
			dbms_output.put_line(counter||' '||c_employee.emp_code||' old salary is '||c_employee.emp_salary||' new salary is '||salary);
		END IF;
	END LOOP;

exception
	when no_data_found then
		dbms_output.put_line('Id does not exist');
	WHEN invalid_cursor then
		dbms_output.put_line('No data');
end;


