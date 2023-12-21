declare 
	cursor emp_fname is 
		select emp_first_name 
		from employee;

	emp_name employee.emp_first_name%type;	
BEGIN
	open emp_fname;

	loop 
		fetch emp_fname into emp_name;
		exit when emp_fname%notfound;
		dbms_output.put_line(emp_name);
	end loop;
	close emp_fname;
end;
/

-- Q2

declare 
	cursor emp_details is select * from employee;
	i int :=1;
BEGIN
	for emp1 in emp_details loop
		dbms_output.put_line('emp'||i);
		dbms_output.put_line('--------------');
		dbms_output.put_line('Emp Code:'||emp1.emp_code);
		dbms_output.put_line('Full Name: '||emp1.emp_first_name||' '||emp1.emp_last_name);
		dbms_output.put_line('Emp department: '||emp1.emp_department);
		dbms_output.put_line('Salary: '||emp1.emp_salary);
		dbms_output.put_line('Address: '||emp1.emp_address);
		dbms_output.put_line('Account: '||emp1.emp_account);
		dbms_output.new_line;
		i:=i+1;
	end loop;
end;
/

-- Q3

declare 
	cursor emp_details is select * from employee;
	emp1 employee%rowtype;
	i int :=1;
BEGIN
	OPEN emp_details;

	
	while(emp_details%found || i=1) loop
		
		dbms_output.put_line('emp'||i);
		dbms_output.put_line('--------------');
		dbms_output.put_line('Emp Code:'||emp1.emp_code);
		dbms_output.put_line('Full Name: '||emp1.emp_first_name||' '||emp1.emp_last_name);
		dbms_output.put_line('Emp department: '||emp1.emp_department);
		dbms_output.put_line('Salary: '||emp1.emp_salary);
		dbms_output.put_line('Address: '||emp1.emp_address);
		dbms_output.put_line('Account: '||emp1.emp_account);
		dbms_output.new_line;
		i:=i+1;
		fetch emp_details into emp1;
	end loop;
	close emp_details;
end;
 
 --------------------------------------------

declare 
	cursor emp_details is select * from employee;
	emp1 employee%rowtype;
	i int :=1;
BEGIN
	OPEN emp_details;

	
	   loop
	   fetch emp_details into emp1;
	   -- exit  when 	emp_details%notfound;
		dbms_output.put_line('emp'||i);
		dbms_output.put_line('--------------');
		dbms_output.put_line('Emp Code:'||emp1.emp_code);
		dbms_output.put_line('Full Name: '||emp1.emp_first_name||' '||emp1.emp_last_name);
		dbms_output.put_line('Emp department: '||emp1.emp_department);
		dbms_output.put_line('Salary: '||emp1.emp_salary);
		dbms_output.put_line('Address: '||emp1.emp_address);
		dbms_output.put_line('Account: '||emp1.emp_account);
		dbms_output.new_line;
		i:=i+1;
	end loop;
	close emp_details;
end;


-- Q4

declare 
	cursor emp_sal is select emp_salary from employee where emp_salary<2000;
	salary employee.emp_salary%type;
BEGIN
	open emp_sal;
	loop
	fetch emp_sal into salary;
	exit when emp_sal%notfound;
	update employee set emp_salary = emp_salary ;
	end loop;
	dbms_output.put_line(emp_sal%rowcount||' rows were affected');
	close emp_sal;
end;


-- Q6

emp_rec employee%rowtype;
close emp_cur;

-- Q7

CURSOR tot_cur IS SELECT  SUM (EMP_SALARY) as EMP_DEPARTMENT FROM employee GROUP BY EMP_DEPARTMENT; 

-- Q8

give_raise (emp_rec.EMP_CODE, 1); 

Because give_raise is not declared


declare 
	cursor emps is select emp_code, emp_salary from employee where emp_salary < 2000;
	emp1 emps%rowtype;

begin
	open emps;

	loop
		fetch emps into emp1;
		exit when emps%notfound;

		update employee set emp_salary = emp_salary +emp_salary *0.1 where emp_code = emp1.emp_code;
		
		end loop;

		dbms_output.put_line(emps%rowcount||' rows has been updated');
		close emps;

end;		

