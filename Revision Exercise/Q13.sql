DECLARE
	n number :=5;
	i int :=9;
	j int :=0;
BEGIN

	for i  in  1..4 loop
		/*for j in 1..i loop
			dbms_output.put(' ');
		end loop;
		for k in 0..n-i loop
			dbms_output.put('*');
		end loop;*/
		dbms_output.put_line(i);
	end loop;
	dbms_output.put_line(i);

end;
