--Write a program that request a user to enter date ( day , month, year) and dispalys it as
 --'7th January 2021' take in mind that when it is 1st and 2nd 3rd and others'
DECLARE
	day int :=&day;
	month int :=&month;
	year int :=&year;
	hold_day varchar(4);
	hold_month varchar(20);
	above_31_exception EXCEPTION; 
	above_12_exception EXCEPTION;
BEGIN
	-- DEALS with day
	if(day=1 OR day=21 or day=31) then
		hold_day := 'st';
	elsif (day=2 or day=22 ) then
		hold_day := 'nd';
	elsif (day=3 or day=23) then
		hold_day := 'rd';
	elsif(day>31) then
		raise above_31_exception;
	else
		hold_day := 'th';
	end if;
	
/*	CASE 
		when (day=1 OR day=21 or day=31) then
		hold_day := 'st';
		when (day=2 or day=22 ) then
		hold_day := 'nd';
		When (day=3 or day=23) then
		hold_day := 'rd';
		when (day>31) then
		raise above_31_exception;
		else
		hold_day := 'th';
	end case; */

	hold_day :=
	case
		when (day=1 OR day=21 or day=31) then 'st'
		when (day=2 or day=22 ) then 'nd'
		when (day=3 or day=23) then 'rd'
		when (day>31) then '0'
		else 'th'
	END; 

	--DEAL WITH THE MONTH

hold_month :=
	CASE (month)
		when 1 then 'January'
		when 2 then hold_month := 'February';
		when 3 then hold_month := 'March';
		when 4 then hold_month := 'April';
		when 5 then hold_month := 'May';
		when 6 then hold_month := 'June';
		when 6 then hold_month := 'July';
		when 8 then hold_month := 'August';
		when 9 then hold_month := 'September';
		when 10 then hold_month := 'October';
		when 11 then hold_month := 'November';
		when 12 then hold_month := 'December';
		else raise above_12_exception;

	END; --CASE;
	dbms_output.put_line(day||hold_day||'-'||hold_month||'-'||year);
EXCEPTION
	WHEN above_12_exception THEN
		dbms_output.put_line('tHE month can not be greater than 12');
	when above_31_exception then
		dbms_output.put_line('Date is never greater than 31');
END;





'12th-March-2021'
1
