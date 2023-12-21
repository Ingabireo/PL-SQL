DECLARE
	id int :=&id;
BEGIN
	if(id >14) then
		if(id >= 15) then
			dbms_output.put_line('Id '||id||' is greater than 14');
		end if;
	end if;
end;


