use hrdb;
use storedb;
show tables;
select * from customer;
select * from emp_department;
select * from emp_details;
select * from item_mast;
select * from orders;
select * from salesman;

-- 1. write a SQL query to find customers who are either from the city 'NewYork' or
-- who do not have a grade greater than 100. Return customer_id, cust_name, city, grade, and salesman_id.
select customer_id, cust_name, city, grade, salesman_id 
from customer where city = 'New York' or grade < 100;

-- 2. write a SQL query to find all the customers in ‘New York’ city who have agradevalue above 100. 
-- Return customer_id, cust_name, city, grade, and salesman_id.
select customer_id, cust_name, city, grade, salesman_id 
from customer where city = 'New York' or grade > 100;


-- 3. Write a SQL query that displays order number, purchase amount, and the
-- achieved and unachieved percentage (%) for those orders that exceed 50% of the target value of 6000. 
select ord_no, purch_amt, ((purch_amt*100) / 6000) as "Achieved %", 100 - ((purch_amt*100) / 6000) "unachieved %"
from orders where ((purch_amt*100) / 6000) > 50;

-- 4. write a SQL query to calculate the total purchase amount of all orders. Return total purchase amount. 
select sum(purch_amt) as total_purhchase 
from orders;

-- 5. write a SQL query to find the highest purchase amount ordered by each customer. 
-- Return customer ID, maximum purchase amount. 
select customer_id,max(purch_amt) as max_purchase
from orders 
group by customer_id;

-- 6. write a SQL query to calculate the average product price. Return average product price. 
select avg(pro_price) as average_pro_price 
from item_mast;

-- 7. write a SQL query to find those employees whose department is located at ‘Toronto’. 
-- Return first name, last name, employee ID, job ID. 
select * from locations;
select employee_id,concat(first_name,' ',last_name) as Full_Name, job_id
from employees e 
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where city = 'Toronto';

-- 8. write a SQL query to find those employees whose salary is lower than that of
-- employees whose job title is "MK_MAN". Exclude employees of the Jobtitle‘MK_MAN’.
-- Return employee ID, first name, last name, job ID. 
select employee_id, concat(first_name,' ',last_name) as Full_Name, job_id
from employees where job_id not in ('MK_MAN') and salary < (select salary from employees where job_id = 'MK_MAN');

-- 9. write a SQL query to find all those employees who work in department ID 80 or 40. 
-- Return first name, last name, department number and department name. 
select employee_id, concat(first_name,' ',last_name) as Full_Name, e.department_id , department_name
from employees e
join departments d on e.department_id = d.department_id
where e.department_id in (80,40);

-- 10.write a SQL query to calculate the average salary, the number of employees
-- receiving commissions in that department. Return department name, averagesalary and number of employees. 
select * from employees;
select department_name, avg(salary) as average_salary, count(*) as total_employees
from employees e 
join departments d on e.department_id = d. department_id
where commission_pct not in ('null')
group by department_name; 

-- 11.write a SQL query to find out which employees have the same designation as the employee whose ID is 169. 
-- Return first name, last name, department IDandjobID.
select employee_id, concat(first_name,' ',last_name) as Full_Name, job_id,department_id
from employees where job_id = (select job_id from employees where employee_id = 169);

-- 12.write a SQL query to find those employees who earn more than the averagesalary. 
-- Return employee ID, first name, last name. 
select employee_id, concat(first_name,' ',last_name) as Full_Name 
from employees where salary > (select avg(salary) from employees);

-- 13.write a SQL query to find all those employees who work in the Finance
-- department. Return department ID, name (first), job ID and department name. 
select e.department_id, first_name, job_id, department_name
from employees e 
join departments d on e.department_id = d. department_id
where department_name = 'Finance';

-- 14.From the following table, write a SQL query to find the employees who earn less than the employee of ID 182. 
-- Return first name, last name and salary. 
select concat(first_name,' ',last_name) as Full_Name, salary 
from employees where salary < (select salary from employees where employee_id = 182);

-- 15.Create a stored procedure CountEmployeesByDept that returns the number of
-- employees in each department.
DELIMITER $$
create procedure CountEmployeesByDep()
begin
	select department_id,count(*) as total_employees
    from employees
    group by department_id;
end $$
DELIMITER ;
call CountEmployeesBYDep();

-- 16.Create a stored procedure AddNewEmployee that adds a new employee tothedatabase. 
DELIMITER $$
CREATE PROCEDURE AddNewEmployee(
    IN p_employee_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_hire_date DATE,
    IN p_job_id VARCHAR(10),
    IN p_salary DECIMAL(10,2),
    IN p_manager_id INT,
    IN p_department_id INT
)
BEGIN
    INSERT INTO employees(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
	VALUES (p_employee_id, p_first_name, p_last_name, p_email, p_phone, p_hire_date, p_job_id, p_salary, p_manager_id, p_department_id);
END $$
DELIMITER ;
CALL AddNewEmployee(207,'John','Doe','jdoe@mail.com','515.123.4567','2025-01-15','IT_PROG',6500.00,103,60);
CALL AddNewEmployee(208,'John','Doe','jdoe@mail.com','515.123.4567','2025-01-15','it',50000,1,1);

-- 17.Create a stored procedure DeleteEmployeesByDept that removes all employeesfrom a specific department
DELIMITER $$ 
create procedure DeleteEmployeesByDept(in dept_id int)
begin
	delete from employees 
    where department_id = dept_id; 
end $$
DELIMITER ;
call DeleteEmployeesByDept(null);


-- 18.Create a stored procedure GetTopPaidEmployees that retrieves the highest-paidemployee in each department.
DELIMITER $$
create procedure GetTopPaidEmployees()
begin 
	select department_id,max(salary)
    from employees
    group by department_id;
end $$
DELIMITER ;
call GetTopPaidEmployees();
 
-- 19.Create a stored procedure PromoteEmployee that increases an employee’s salary and changes their job role. 
DELIMITER $$
create procedure PromoteEmployee(
	in p_emp_id INT, 
    in p_increment decimal(10,2), 
	in p_new_job_id varchar(10)
)
begin
    update employees 
    set salary = salary + p_increment,
        job_id = p_new_job_id
    where employee_id = p_emp_id;
    
    if row_count() > 0 then
        select concat('Employee ', p_emp_id, ' promoted successfully.') as status;
    else
        select concat('Error: Employee ', p_emp_id, ' not found.') as status;
    end if;
end $$
DELIMITER ;
call PromoteEmployee(207,1000,'');

-- 20.Create a stored procedure AssignManagerToDepartment that assigns a newmanager to all employees in a specific department
delimiter $$
create procedure assignmanagertodepartment(
    in p_department_id int, 
    in p_new_manager_id int
)
begin
    update employees 
    set manager_id = p_new_manager_id
    where department_id = p_department_id;
    
    select concat('successfully updated ', row_count(), ' employees in department ', p_department_id) as status;
end $$
delimiter ;
call assignmanagertodepartment(100,80);


