DECLARE
	id integer :=&id;
	account_number int;
BEGIN
	select emp_account into account_number from employee where emp_code=id;
	case (account_number)
		when 1 then dbms_output.put_line('Savings');
		when 2 then dbms_output.put_line('Expenses');
		when 3 then dbms_output.put_line('Revenue');
		else dbms_output.put_line('No such account');
	end case;
EXCEPTION
	when no_data_found then dbms_output.put_line('NO such Id');
END;