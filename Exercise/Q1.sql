CREATE OR REPLACE PACKAGE EMP_DETAILS 
IS
PROCEDURE set_record (p_emp_rec IN employee%ROWTYPE);
FUNCTION get_record (p_emp_no IN NUMBER) RETURN employee%ROWTYPE;
END EMP_DETAILS;
/




create or replace package body EMP_DETAILS
	is
	

	FUNCTION get_record(p_emp_no IN NUMBER) RETURN employee%ROWTYPE
		is
		empl employee%ROWTYPE;
		begin

		select * into empl from employee where emp_code  = p_emp_no;
		return empl;
	end get_record;



	PROCEDURE set_record(p_emp_rec in employee%ROWTYPE)
	is
	emp employee%rOWTYPE;
	begin

	insert into employee values(p_emp_rec.emp_code,p_emp_rec.emp_first_name,p_emp_rec.emp_last_name,p_emp_rec.emp_department,p_emp_rec.emp_salary,p_emp_rec.emp_address,p_emp_rec.emp_account);

	emp := get_record(p_emp_rec.emp_code);

	dbms_output.put_line('Emp Code: '||emp.emp_code);
	dbms_output.put_line('First Name: '||emp.emp_first_name);
	dbms_output.put_line('Laast Name: '||emp.emp_last_name);
	dbms_output.put_line('Department: '||emp.emp_department);
	dbms_output.put_line('Salary : '||emp.emp_salary);
	dbms_output.put_line('Address: '||emp.emp_address);
	dbms_output.put_line('Account: '||emp.emp_account);
	end set_record;

end EMP_DETAILS;
/


declare 
	emp employee%rOWTYPE;
begin
	
	emp.emp_code := 1;
	emp.emp_first_name := 'Serge';
	emp.emp_last_name := 'Ngoga';
	emp.emp_department := 2;
	emp.emp_salary := 12009;
	emp.emp_address := 'Kagugu';
	emp.emp_account := 3;

	EMP_DETAILS.set_record(EMP);
END;

	
-- B CREATE TRIGGER THAT PREVENT  

CREATE OR REPLACE TRIGGER prevent_ExistId
	
	before insert on employee

	for each row 

		declare

			ExistingId exception;
			pragma exception_init(ExistingId,-20001);

			num_id number;
		begin

			select count(emp_code) into num_id from employee where emp_code = :new.emp_code;

			if num_id > 0 then
				raise_application_error(-20001,'Id exists Already');
			end if;
end prevent_ExistId;



-- C create trigger ...........

create or replace trigger TImeRestrict_trig
	before insert or update on employee

	for each row 

	declare

		c_time number;
		badtime exception;
		pragma exception_init(badtime,-20002);
	begin

		select extract(hour from systimestamp) into c_time  from dual;

		if(c_time  not between 7 and 17)  then
			raise_application_error(-20002,'Update or insert time is not allowedd');
		end if;
end TImeRestrict_trig;
 
