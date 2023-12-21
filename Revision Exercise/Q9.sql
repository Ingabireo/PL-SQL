DECLARE 
	salary number :=1000;

BEGIN

	case
		when salary <=10000 then
			case 
				when salary <=2000 then dbms_output.put_line('Bonus is 1000');
				when salary between 2000 and 6000 then dbms_output.put_line('Bonus is 1500');
				when salary > 6000 then dbms_output.put_line('Bonus is 2000');
				else dbms_output.put_line('Bonus is 200');
			end case;
	end case;
EXCEPTION
	when case_not_found then dbms_output.put_line('The salary must be less or equal to 10000');
end;