DECLARE
	id int := &id;
	emp1 employee%rowtype;
BEGIN
	select * into emp1 from employee where emp_code = id;

	case
		when emp1.emp_code=id then
			dbms_output.put_line('Full Name: '||emp1.emp_first_name||' '||emp1.emp_last_name);
		else
			dbms_output.put_line('No data found');
	end case;
EXCEPTION
	when no_data_found then dbms_output.put_line('Id does not exists');
end;
