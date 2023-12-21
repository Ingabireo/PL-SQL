DECLARE
	id employee.emp_code%type;
	salary number;

BEGIN
	select emp_salary into salary from employee where emp_code =id;

	case
		when salary <=10000 then
			case 
				when salary <=2000 then 
					update employee set emp_salary = salary + 1000 where emp_code =id; 
					 salary := salary +1000						
					dbms_output.put_line('emp_code: '||id||'	New salary: '||salary);
				when salary between 2000 and 6000 then 
					update employee set emp_salary = salary + 1500 where emp_code =id; 
						 salary := salary +1500
					dbms_output.put_line('emp_code: '||id||'	New salary: '||salary);
				when salary > 6000 then 
					update employee set emp_salary = salary + 2000 where emp_code =id; 
						 salary := salary +2000
					dbms_output.put_line('emp_code: '||id||'	New salary: '||salary);
				else 
					update employee set emp_salary = salary + 200 where emp_code =id; 
						 salary := salary +200
					dbms_output.put_line('emp_code: '||id||'	New salary: '||salary);
			end case;
	end case;
EXCEPTION
	when case_not_found then dbms_output.put_line('The salary must be less or equal to 10000');
	when no_data_found then dbms_output.put_line('Id does not exist');
end;