create or replace package branch_pkg as
	procedure branch_details_pro(br_id branch.id%type, month item_sold.month_sold%type);
	procedure break_down_pro(br_id branch.id%type, month item_sold.month_sold%type);
	procedure price_detail_pro(br_id branch.id%type, month item_sold.month_sold%type);
	procedure total_sales_pro(br_id branch.id%type, month item_sold.month_sold%type);
	procedure other_branches_pro(br_id branch.id%type, month item_sold.month_sold%type);
	procedure print_report(br_id branch.id%type, month item_sold.month_sold%type);
	function check_branch_Exists_fun(br_id branch.id%type) return boolean;
	function check_sales_fun(br_id branch.id%type, month item_sold.month_sold%type) return boolean;
end branch_pkg;
/


create or replace package body branch_pkg as

	function check_sales_fun(br_id branch.id%type, month item_sold.month_sold%type) return boolean is
		no_items number;
		begin
			select count (Customers.id)  into no_items
				from branch
				join Customers on branch.id = Customers.branch_id
				join branch_manager on branch.id = branch_manager.branch_id
				join item_sold on Customers.id = item_sold.Customer_id
				where branch.id = br_id and month_sold = month;
			if(no_items > 0 ) then 
				return true;
				else
					return false;
			end if;

		exception
			when no_data_found then return false;

	end check_sales_fun;

	function check_branch_Exists_fun(br_id branch.id%type) return boolean is 

		check_var int;
		begin
			select count(id) into check_var from branch where branch.id = br_id;
			if(check_var = 0 ) then return false;
			else
				return true;
			end if;

	end check_branch_Exists_fun;

	procedure branch_details_pro(br_id branch.id%type, month item_sold.month_sold%type) is 
			cursor details_cur is select distinct branch.name as br_name, branch_manager.f_name as man_fname, branch_manager.l_name as man_lname, sum(distinct item_sold.quantity) as quantity, count(distinct Customers.id) as no_customers
				from branch
				join Customers on branch.id = Customers.branch_id
				join branch_manager on branch.id = branch_manager.branch_id
				join item_sold on Customers.id = item_sold.Customer_id
				where branch.id = br_id
				group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name;

			cursor sales_cur is select sum(distinct item_sold.quantity) as quantity, count(distinct Customers.id) as no_customers
				from branch
				join Customers on branch.id = Customers.branch_id
				join branch_manager on branch.id = branch_manager.branch_id
				join item_sold on Customers.id = item_sold.Customer_id
				where branch.id = br_id and month_sold = month
				group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name;	

			details_var details_cur%rowtype;
			sales_var sales_cur%rowtype;

			id_notfount exception ;
			pragma exception_init(id_notfount,-20001);
		begin	

			open sales_cur;
			open details_cur;
			fetch details_cur into details_var;
			fetch sales_cur into sales_var;

			if details_cur%notfound then raise_application_error(-20001,'Id Does not exist');
			end if;

			if sales_cur%notfound then 
				sales_var.quantity := 0;
				sales_var.no_customers := 0;
			end if;
			dbms_output.put_line('**********************************************************');
			dbms_output.put_line('This is a report of the sales in '||details_var.br_name||', '||month||' - 2023');
			dbms_output.put_line('**********************************************************');

			dbms_output.put_line('Branch: '||details_var.br_name);
			dbms_output.put_line('Manager: '||details_var.man_fname||' '||details_var.man_lname);
			dbms_output.put_line('No of Items Sold : '||sales_var.quantity);
			dbms_output.put_line('No of Customers : '||sales_var.no_customers);

			close details_cur;
			CLOSE sales_cur;

		-- exception
		-- 	when id_notfount then
		-- 		dbms_output.put_line(SQLERRM);
		end branch_details_pro;

	procedure break_down_pro(br_id branch.id%type, month item_sold.month_sold%type) is 
			
		cursor break_down_cur is select distinct item_type.name as type_name, item.name as item_name, item_sold.quantity as quantity
			from branch
			join Customers on branch.id = Customers.branch_id
			join branch_manager on branch.id = branch_manager.branch_id
			join item_sold on Customers.id = item_sold.Customer_id
			join item on item_sold.item_id = item.id
			join item_type on item.item_type_id = item_type.id 
			where branch.id = br_id and month_sold = month;
			-- group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name
			break_down_var break_down_cur%rowtype;

			check_sold_var boolean;
		begin

			check_sold_var := check_sales_fun(br_id,month);
			if check_sold_var = false then dbms_output.put_line('.'); 
			dbms_output.put_line('No Items sold in This Branch in the month of '||month);
			else

				dbms_output.put_line('Break Down Of Items sold');
				dbms_output.put_line('.');
				

				open break_down_cur;
				loop 
				fetch break_down_cur into break_down_var;
				exit when break_down_cur%notfound;
				dbms_output.put_line(break_down_var.quantity||' '||break_down_var.type_name);
				dbms_output.put_line(break_down_var.item_name);
				end loop;
			end if;
	end break_down_pro;
	procedure price_detail_pro(br_id branch.id%type, month item_sold.month_sold%type) is

		cursor price_detail_cur is select distinct item_type.name as type_name, item.name as item_name, item_sold.quantity as  quantity ,item.price * item_sold.quantity as total
			from branch
			join Customers on branch.id = Customers.branch_id
			join branch_manager on branch.id = branch_manager.branch_id
			join item_sold on Customers.id = item_sold.Customer_id
			join item on item_sold.item_id = item.id
			join item_type on item.item_type_id = item_type.id 
			where branch.id = br_id and month_sold = month;
			-- group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name	

			price_detail_var price_detail_cur%rowtype;
			begin

				open price_detail_cur;
				loop 
				fetch price_detail_cur into price_detail_var;
				exit when price_detail_cur%notfound;
				dbms_output.put_line('The price of '||price_detail_var.quantity||' '||price_detail_var.type_name||' '||price_detail_var.item_name||' : '||price_detail_var.total);

				end loop;
				close price_detail_cur;
				dbms_output.put_line('.');

	end price_detail_pro;
	procedure total_sales_pro(br_id branch.id%type, month item_sold.month_sold%type) is

		cursor total_sales_cur is select branch.name as br_name, sum( distinct item.price * item_sold.quantity) as total
			from branch
			join Customers on branch.id = Customers.branch_id
			join branch_manager on branch.id = branch_manager.branch_id
			join item_sold on Customers.id = item_sold.Customer_id
			join item on item_sold.item_id = item.id
			join item_type on item.item_type_id = item_type.id 
			where branch.id = br_id and month_sold = month
			group by branch.name;
			total_sales_var total_sales_cur%rowtype;

	begin

		for i in total_sales_cur loop

			dbms_output.put_line('Total sales made in '||i.br_name||' in the month of '||month||' '||' : USD '||i.total);
			dbms_output.put_line('Total sales made in '||i.br_name||' in the month of '||month||' '||' : FRW '||i.total * 1952 ||' (Exchange rate: $1952)');
		end loop;

		dbms_output.put_line('.');

	end total_sales_pro;
	procedure other_branches_pro(br_id branch.id%type, month item_sold.month_sold%type) is 

		Total_sales number;

		cursor names is select  distinct (branch.name) as name
			from branch
			join Customers on branch.id = Customers.branch_id
			join branch_manager on branch.id = branch_manager.branch_id
			join item_sold on Customers.id = item_sold.Customer_id
			join item on item_sold.item_id = item.id
			join item_type on item.item_type_id = item_type.id 
			where branch.id != br_id
			group by branch.name;
			-- order by branch.id desc;

	begin

		dbms_output.put_line('Sales  in other Branches in FRW (Exchange rate : $1952)');
		dbms_output.put_line('*********************************************************************');
		dbms_output.put_line('.');


		for i in names loop
			Total_sales := 0;
			select  sum( distinct item.price * item_sold.quantity)
				into Total_sales
				from branch
				join Customers on branch.id = Customers.branch_id
				join branch_manager on branch.id = branch_manager.branch_id
				join item_sold on Customers.id = item_sold.Customer_id
				join item on item_sold.item_id = item.id
				join item_type on item.item_type_id = item_type.id 
				where branch.name = i.name and month_sold = month;
				-- group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name
				-- order by branch.id desc;
				if Total_sales is null then
						Total_sales := 0;
				end if;

				dbms_output.put_line('Total sales made in '||i.name||' is FRW '||Total_sales * 1952);
		end loop;

	end other_branches_pro;

	procedure print_report(br_id branch.id%type, month item_sold.month_sold%type) is 
		check_var boolean;

		branch_id_not_exists_ex exception;

		pragma exception_init(branch_id_not_exists_ex , -20002);
		begin
			check_var := check_branch_Exists_fun(br_id);

			if(check_var = false) then raise_application_error(-20002,'Branch ID does not exist');
			else

			branch_pkg.branch_details_Pro(br_id,month);
			branch_pkg.break_down_pro(br_id,month);
			branch_pkg.price_detail_pro(br_id,month);
			branch_pkg.total_sales_pro(br_id,month);
			branch_pkg.other_branches_pro(br_id,month);

			end if;
			exception
				when branch_id_not_exists_ex then dbms_output.put_line(SQLERRM);
	end print_report;

end branch_pkg;
/


begin
	branch_pkg.print_report(1,'February');	
end;

/