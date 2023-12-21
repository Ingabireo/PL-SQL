
CREATE OR REPLACE PACKAGE employee_package IS
PROCEDURE  update_emp_record(e_code employee.emp_code%type);
FUNCTION delete_emp_record(e_code employee.emp_code%type) RETURN boolean;
END employee_package;
/


CREATE OR REPLACE PACKAGE body employee_package IS

PROCEDURE  update_emp_record(e_code employee.emp_code%type)
	is
		min_salary float;
		av_salaly float;
		initual_salary float;
		sal_count integer;
	begin

		select SAL_UPDATE_COUNTER into sal_count from employee where emp_code = e_code;
		if(sal_count <= 2 or sal_count is null) then 

			if(sal_count  is null ) then
				sal_count := 0;
			end if;

			update employee set SAL_UPDATE_COUNTER = sal_count + 1 where emp_code = e_code;

			select min(emp_salary) into min_salary from employee;
			select avg(emp_salary) into av_salaly from employee;
			select emp_salary into initual_salary from employee where emp_code = e_code;

			dbms_output.put_line('Min Salary: '||min_salary);
			dbms_output.put_line('Average Salary: '||av_salaly);
			dbms_output.put_line('initual salary: '||initual_salary);

			if (initual_salary > min_salary and initual_salary < av_salaly) then
				update employee set emp_salary = emp_salary + 0.1 * emp_salary where emp_code = e_code; 
			end if;

	end if;
end update_emp_record;

FUNCTION delete_emp_record(e_code employee.emp_code%type) RETURN boolean
	is 
		rowsAffected int;
	begin
		delete from employee where emp_code = e_code and SAL_UPDATE_COUNTER = 2;

		rowsAffected := SQL%rowcount;

		if (rowsAffected > 0 ) then
			return true;
		else
			return false;
		end if;
end delete_emp_record;



END employee_package;
/



declare 
	emp employee%rOWTYPE;
	check_deleted boolean;
begin
	
	employee_package.update_emp_record(2);
	check_deleted := employee_package.delete_emp_record(2);
	if(check_deleted = true) then
		dbms_output.put_line('Employee deleted ');
	else
		dbms_output.put_line('Employee Not deleted');
	end if;
	
END;


alter table employee add SAL_UPDATE_COUNTER int;



