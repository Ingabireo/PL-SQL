DECLARE
	loan_amount number := &loan_amount;
	id employee.emp_code%type :=&id;
	emp1 employee%rowtype;
BEGIN
	select * into emp1 from employee where emp_code = id;

	if(loan_amount > emp1.emp_salary * 12) then
		dbms_output.put_line('Salary : '||emp1.emp_salary||' loan_amount: '||loan_amount);
		dbms_output.put_line('You are not allowed to get this loan');
	else
		dbms_output.put_line('Salary : '||emp1.emp_salary||' loan_amount: '||loan_amount);
		dbms_output.put_line('You are eligible for this loan');
	end if;
EXCEPTION
	when no_data_found then
		dbms_output.put_line('Id does not match');
end;
