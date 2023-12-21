DECLARE
	
	id employee.emp_code%type :=&id;
	code employee.emp_code%type;
	not_equal_input Exception;
	pragma Exception_init(not_equal_input,-20001);
BEGIN
	select max(emp_code) into code from employee;
	
	if(code <> id) then 
		raise_application_error(-20001,' they are not equal');
	end if;
Exception
	WHEN not_equal_input then
		dbms_output.put_line(SQLERRM);
end;

