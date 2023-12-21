

select distinct branch.name, branch_manager.f_name, branch_manager.l_name, sum( item_sold.quantity), count( Customers.id)
from branch
join Customers on branch.id = Customers.branch_id
join branch_manager on branch.id = branch_manager.branch_id
join item_sold on Customers.id = item_sold.Customer_id
where branch.id = 3 and month_sold = 'February'
group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name
order by branch.id desc;

Branch: Mali
Manager: Iris Joanna
No of Items sold: 10
No of Customers: 2


***********************************

select distinct item_type.name, item.name, item_sold.quantity 
from branch
join Customers on branch.id = Customers.branch_id
join branch_manager on branch.id = branch_manager.branch_id
join item_sold on Customers.id = item_sold.Customer_id
join item on item_sold.item_id = item.id
join item_type on item.item_type_id = item_type.id 
where branch.id = 3 and month_sold = 'March'
-- group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name
order by branch.id desc;

Break down of items sold:

2 Computers
Dell

8 Phones
Techno C9

****************************************


select distinct item_type.name, item.name, item_sold.quantity,item.price * item_sold.quantity
from branch
join Customers on branch.id = Customers.branch_id
join branch_manager on branch.id = branch_manager.branch_id
join item_sold on Customers.id = item_sold.Customer_id
join item on item_sold.item_id = item.id
join item_type on item.item_type_id = item_type.id 
where branch.id = 3 and month_sold = 'March'
-- group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name
order by branch.id desc;


The price of 2 Dell Computers: USD 700.9
The price of 8 Techno C9: USD 963.2


***********************************************

select  sum( distinct item.price * item_sold.quantity)
from branch
join Customers on branch.id = Customers.branch_id
join branch_manager on branch.id = branch_manager.branch_id
join item_sold on Customers.id = item_sold.Customer_id
join item on item_sold.item_id = item.id
join item_type on item.item_type_id = item_type.id 
where branch.id = 3 and month_sold = 'March'
-- group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name
order by branch.id desc;


Total sales made in Mali in the Month of January: USD 1,664.1
Total sales made in Mali in the Month of January: FRW 3,248,323.2 (Exchange rate: $1952)




*************************************************************
declare

Total_sales number;

cursor names is select  distinct (branch.name) as name
	from branch
	join Customers on branch.id = Customers.branch_id
	join branch_manager on branch.id = branch_manager.branch_id
	join item_sold on Customers.id = item_sold.Customer_id
	join item on item_sold.item_id = item.id
	join item_type on item.item_type_id = item_type.id 
	where branch.id != 3
	group by branch.name;
	-- order by branch.id desc;

begin

	open names;
	loop
	fetch names into names_var;
	exit when names%notfound;
		Total_sales :=0;
		select  sum( distinct item.price * item_sold.quantity)
			into Total_sales
			from branch
			join Customers on branch.id = Customers.branch_id
			join branch_manager on branch.id = branch_manager.branch_id
			join item_sold on Customers.id = item_sold.Customer_id
			join item on item_sold.item_id = item.id
			join item_type on item.item_type_id = item_type.id 
			where branch.name = i.name and month_sold = 'March'
			-- group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name
			order by branch.id desc;
			if Total_sales is null then
					Total_sales := 0;
			end if;

			dbms_output.put_line('Total sales made in '||i.name||' is '||Total_sales);
	end loop;
end;


declare

Total_sales number;

cursor names is select  distinct (branch.name) as name
	from branch
	join Customers on branch.id = Customers.branch_id
	join branch_manager on branch.id = branch_manager.branch_id
	join item_sold on Customers.id = item_sold.Customer_id
	join item on item_sold.item_id = item.id
	join item_type on item.item_type_id = item_type.id 
	where branch.id != 3
	group by branch.name;
	-- order by branch.id desc;

begin

	for i in names loop
		Total_sales :=0;
		select  sum( distinct item.price * item_sold.quantity)
			into Total_sales
			from branch
			join Customers on branch.id = Customers.branch_id
			join branch_manager on branch.id = branch_manager.branch_id
			join item_sold on Customers.id = item_sold.Customer_id
			join item on item_sold.item_id = item.id
			join item_type on item.item_type_id = item_type.id 
			where branch.name = i.name and month_sold = 'March'
			-- group by branch.id,branch.name,branch_manager.f_name, branch_manager.l_name
			order by branch.id desc;
			if Total_sales is null then
					Total_sales := 0;
			end if;

			dbms_output.put_line('Total sales made in '||i.name||' is '||Total_sales);
	end loop;
end;

