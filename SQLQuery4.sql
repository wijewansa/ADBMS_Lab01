use MyOfficeDB;
create table Employee (
Fname varchar(30) NOT NULL,
Lname varchar(30) NOT NULL,
Emp_Id int,
DOB date,
Salary money,
Gender varchar(1),
Address varchar(100),
Dep_no int,
Designation varchar(15),
CONSTRAINT pk_empid PRIMARY KEY (Emp_Id));

select * from Employee;

insert into Employee values('Maria','Smith','10011','1972-02-03','20000','F','231,Los Angeles,California','1','Manager');
insert into Employee values('Soobin','Choi','10012','1963-05-09','50000','M','112,San Diego,California','2','Eecutive');
insert into Employee values('Kai','James','10024','1995-01-18','30000','M','143,Oakland,California','2','Manager');
insert into Employee values('John','Wang','10013','1991-06-21','10000','M','085,Castle,Texas','3','Cashier');
insert into Employee values('Lisa','Ash','10032','1991-08-09','10500','M','022,Houston,Texas','3','Cashier');
insert into Employee values('Jennie','Kim','10045','1980-11-13','40000','M','311,Texas city,Texas','3','Manager');

select Fname,Address from Employee where Emp_Id='10013';

create table Department (
Dep_name varchar(15) NOT NULL,
Dnumber int NOT NULL,
Manager_Id int,
Manager_start_date date,
CONSTRAINT pk_Dnumber PRIMARY KEY (Dnumber));

insert into Department values('HQ','1','10011','2020-01-14');
insert into Department values('Admin','2','10024','2020-03-15');
insert into Department values('Production','3','10045','2020-03-24');


select * from Department;

create table Dep_location (
Dnumber int NOT NULL,
Dlocation varchar(25) NOT NULL,
CONSTRAINT pk_Dnumber_Dlocation PRIMARY KEY (Dnumber,Dlocation));

insert into Dep_location values('1','Texas');
insert into Dep_location values('2','LA');
insert into Dep_location values('3','Oakland');
insert into Dep_location values('3','Texas');

select * from Dep_location;

create table Project (
Pr_name varchar(15) NOT NULL,
Pr_no int NOT NULL,
Dlocation varchar(25) NOT NULL,
Dep_no int NOT NULL,
CONSTRAINT pk_PrNo PRIMARY KEY (Pr_no));

insert into Project values('Pro_A','1','Beverly Hills','1');
insert into Project values('Pro_B','2','Houston','1');
insert into Project values('Pro_C','3','Los Angeles','1');
insert into Project values('Pro_D','15','San Francisco','2');
insert into Project values('Pro_E','10','Los Angeles','3');
insert into Project values('Pro_F','9','Houston','3');

select * from Project;


create table Work_on (
Emp_Id int NOT NULL,
Pnumber int NOT NULL,
Hours varchar(10),
CONSTRAINT pk_Pno PRIMARY KEY (Emp_Id,Pnumber));

insert into Work_on values('10011','1','32.5');
insert into Work_on values('10010','3','40.0');
insert into Work_on values('10032','2','10.0');
insert into Work_on values('10045','10','10.0');
insert into Work_on values('10099','10','');
insert into Work_on values('10011','15','8.5');


select * from Work_on;

create table Dependent (
Emp_Id int NOT NULL,
Dependent_name varchar(15) NOT NULL,
DOB date,
Relationship varchar(30),
CONSTRAINT pk_DependentName PRIMARY KEY (Emp_Id,Dependent_name));

insert into  Dependent values('10012','Rose','1997-08-08','Daughter');
insert into  Dependent values('10012','Billie','1995-07-02','Son');
insert into  Dependent values('10013','Selena','1990-03-04','Spouse');
insert into  Dependent values('10011','Jimin','1991-11-14','Son');

select * from Dependent;

create table Supervisor (
Supervisor_Id int NOT NULL,
Supervisor_name varchar(15) NOT NULL,
Employee_Id int,
CONSTRAINT pk_SupervisorId PRIMARY KEY (Supervisor_Id));

insert into Supervisor values('7','Jeremy','10013');
insert into Supervisor values('8','Anne','10032');

select * from Supervisor;

/* Foreign Keys */
Alter table Employee Add FOREIGN KEY (Dep_no) REFERENCES Department(Dnumber);
Alter table Work_on add FOREIGN KEY (Pnumber) REFERENCES Project(Pr_no);
Alter table Dependent add FOREIGN KEY (Emp_id) REFERENCES Employee(Emp_Id);
Alter table Supervisor add FOREIGN KEY (Employee_Id) REFERENCES Employee(Emp_Id);
Alter table Project add FOREIGN KEY (Dep_no) REFERENCES Department(Dnumber);

/* Exaple sub queries */
select Fname,Salary from Employee where Salary = (select max(Salary) from Employee where Dep_no = 3);

/* Part 2 - sub Queries */
/* A */
select Emp_Id,Fname,Lname from Employee where Dep_no =(select Dep_no from Employee where Emp_Id ='10045');

/* B */
select Emp_Id,Fname,Dep_no from Employee where Dep_no IN (select Dnumber from Dep_location where Dlocation='Texas');

/* C */
select Fname from employee where NOT EXISTS (select * from Dependent where Employee.Emp_Id=Dependent.Emp_Id);
select * from dependent;
select * from Employee;

/* D */
select Dnumber, count(*) as no_of_employees from Department D, Employee E where D.Dnumber = E.Dep_no AND Salary > 10500 AND
E.Dep_no IN (select Dep_no from Employee group by Dep_no having count(*) >= 2) Group by D.Dnumber

/* E */
select Fname from Employee E where (select count(*) from Dependent D where E.Emp_Id = D.Emp_Id) >=2 Group by Fname
