create or replace package branch_management as 

     type other_branches_rec is record(
               Id branch.id%type,
               name branch.name%type,               
               total_sales number
          );

     type branch_details_rec is record(
               Id branch.id%type,
               name branch.name%type,
               manager_fname branch_manager.f_name%type,
               manager_lname branch_manager.l_name%type,
               no_customers number,               
               no_sold_items number,
               total_sales number
          );

     type item_details_rec is record(
               Id item.id%type,
               name item.name%type,
               type item_type.name%type,
               quantity item_sold.quantity%type ,
               price  item.price%type            
          );
     type branch_details_type is table of branch_details_rec;
     type item_details_type is table of item_details_rec;
     type other_branches_type is table of other_branches_rec;

     function get_branch_details(branchId branch.id%type, month item_sold.month_sold%type) return branch_details_type;
     function get_other_branch_details(branchId branch.id%type, month item_sold.month_sold%type) return other_branches_type;
     function get_items_sold(branchId branch.id%type, month item_sold.month_sold%type) return item_details_type;
     -- function customer_no(branchid branch.id%type) return number;
     -- function dollar_convert(price number, currency varchar2) return number;
     -- function branchTotalSales(branch_id number) return number;
     procedure print_report(branch_id branch.id%type, month item_sold.month_sold%type);
     procedure print_branch_info(branchid branch.id%type, month item_sold.month_sold%type);
end branch_management;
/


create or replace package body branch_management as 

     function get_items_sold(branchId branch.id%type, month item_sold.month_sold%type) return item_details_type is 
          item_details item_details_type := item_details_type();


          begin
               select item.id, item.name, item_type.name, item_sold.quantity,item.price 
                  bulk collect into item_details 
                  from item 
                  join item_type on item.item_type_id = item_type.id
                  join item_sold on item.id = item_sold.item_id
                  join customers on item_sold.customer_id = customers.id 
                  join branch on customers.branch_id = branch.id
                  where branch.id = branchId and item_sold.month_sold = month
                  order by item_id desc;

                  return item_details;
          
          end get_items_sold;
          function get_branch_details(branchId branch.id%type, month item_sold.month_sold%type) return branch_details_type is
               branch_details branch_details_type := branch_details_type();

               begin

                    select branch.id , branch.name, branch_manager.f_name, branch_manager.l_name, count(distinct customers.id), sum(distinct item_sold.quantity),sum(item.price)

                         bulk collect into branch_details
                         from branch 
                         join customers on branch.id = customers.branch_id
                         join item_sold on customers.id = item_sold.customer_id
                         join item on item_sold.item_id = item.id
                         join branch_manager on branch.id = branch_manager.branch_id
                         where branch.id = branchId and item_sold.month_sold = month
                         group by branch.id , branch.name, branch_manager.f_name, branch_manager.l_name;

                         return branch_details;
          exception
               when no_data_found then raise_application_error(-20001,'Branch Id provided does not exist');
     end get_branch_details;
     -- function customer_no(branchid branch.id%type) return number;
     -- function dollar_convert(price number, currency varchar2) return number;
     -- function branchTotalSales(branch_id number) return number;
     procedure print_report(branch_id branch.id%type, month item_sold.month_sold%type) is 
          item_details item_details_type := item_details_type();
          other_branches other_branches_type := other_branches_type();
          begin
               print_branch_info(branch_id,month);
               item_details := get_items_sold(branch_id,month);
               other_branches := get_other_branch_details(branch_id,month);
               dbms_output.put_line('***************************');

               for i in 1..item_details.count loop
                    dbms_output.put_line(item_details(i).quantity||' '||item_details(i).name);
                    dbms_output.put_line(item_details(i).type);
                    dbms_output.put_line('***************************');
               end loop;

               for i in 1..other_branches.count loop
                    dbms_output.put_line('Total sales made in '||other_branches(i).name ||' In the month of '||month||' : RWF '||other_branches(i).total_sales);
               end loop;
     end print_report;

     

     function get_other_branch_details(branchId branch.id%type, month item_sold.month_sold%type) return other_branches_type is

          branches other_branches_type := other_branches_type();
          tot int :=0;

          begin

               select branch.id, branch.name,null
                    bulk collect into branches
                    from branch 
                    where branch.id != branchId;

                    for i in 1..branches.count loop
                         tot := 0;
                         select sum(item.price)
                         into tot 
                         from branch 
                         join customers on branch.id = customers.branch_id
                         join item_sold on customers.id = item_sold.customer_id
                         join item on item_sold.item_id = item.id
                         join branch_manager on branch.id = branch_manager.branch_id
                         where branch.id = branches(i).id and item_sold.month_sold = month;
                         if tot != 0 then
                         branches(i).total_sales := tot; 
                         else
                              branches(i).total_sales := 0;
                         end if;
                    end loop;                    
               return branches;      

     end get_other_branch_details;

     procedure print_branch_info(branchid branch.id%type, month item_sold.month_sold%type) is
          branch_info branch_details_type := branch_details_type();
          lname varchar(20);
          fname varchar(20);
          branch_name  varchar(20);        
          begin
               branch_info := get_branch_details(branchid,month);
               
               if branch_info.count  = 0 then 
                     select  branch.name, branch_manager.f_name, branch_manager.l_name

                         into branch_name , fname, lname
                         from branch 
                         join customers on branch.id = customers.branch_id
                         join item_sold on customers.id = item_sold.customer_id
                         join item on item_sold.item_id = item.id
                         join branch_manager on branch.id = branch_manager.branch_id
                         where branch.id = branchid  and rownum = 1;
                         -- group by  branch.name, branch_manager.f_name, branch_manager.l_name;

               dbms_output.put_line('******************************************************');
               dbms_output.put_line('This is a report made in '||branch_name||' '||month||' - 2023');
               dbms_output.put_line('******************************************************');

               dbms_output.put_line('Branch: '||branch_name);
               dbms_output.put_line('Manager: '||fname||' '||lname);
               dbms_output.put_line('No of customers: 0');
               dbms_output.put_line('No of Items sold: 0');
               dbms_output.put_line('-----------------------------------');

               else

               dbms_output.put_line('******************************************************');
               dbms_output.put_line('This is a report made in '||branch_info(1).name||' '||month||' - 2023');
               dbms_output.put_line('******************************************************');

               dbms_output.put_line('Branch: '||branch_info(1).name);
               dbms_output.put_line('Manager: '||branch_info(1).manager_fname||' '||branch_info(1).manager_lname);
               dbms_output.put_line('No of customers: '||branch_info(1).no_customers);
               dbms_output.put_line('No of Items sold: '||branch_info(1).no_sold_items);
               dbms_output.put_line('-----------------------------------');
               
               end if;
          exception
               when no_data_found then raise_application_error(-20001,'Branch Id provided does not exist');
     end print_branch_info;
end branch_management;
/

begin
     branch_management.print_report(100,'February');
end;