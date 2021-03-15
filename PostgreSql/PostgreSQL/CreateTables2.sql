 CREATE TABLE Addresses(
	AddressesID int  NOT NULL,
	EmployeeID int NULL,
	AddressLine1 varchar(60) NOT NULL,
	AddressLine2 varchar(60) NULL,
	City varchar(50) NOT NULL,
	State char(2) NOT NULL,
	Zip1 char(5) NOT NULL,
	Zip2 char(4) NULL,
    ModifiedDate date NULL,
 CONSTRAINT PK_ADDRESSES PRIMARY KEY 
(AddressesID ))

CREATE TABLE Departments(
	DepartmentID smallint NOT NULL,
	DepartmentName varchar(50) NOT NULL,
	GroupName varchar(50) NOT NULL,
	ModifiedDate date NULL,
 CONSTRAINT PK_Departments PRIMARY KEY (DepartmentID))

CREATE TABLE EmployeesDepartments(
	EmployeeID int NOT NULL,
	DepartmentID smallint NOT NULL,
	StartDate date NOT NULL,
	EndDate date NULL,
	ModifiedDate date NULL,
 CONSTRAINT PK_EmployeesDepartments PRIMARY KEY 
(
	EmployeeID ,
	DepartmentID 
))

CREATE TABLE Dependents(
	DependentID int NOT NULL,
	EmployeeID int NULL,
	FirstName varchar(50) NULL,
	MiddleName varchar(50) NULL,
	LastName varchar(50) NULL,
	Gender char(1) NULL,
	BirthDate date NULL,
	CONSTRAINT PK_Dependents PRIMARY KEY (DependentID))

CREATE TABLE Employees(
	EmployeeID int NOT NULL,
	FirstName varchar(50) NULL,
	MiddleName varchar(50) NULL,C
	LastName varchar(50) NULL,
	Title varchar(50) NOT NULL,
	BirthDate date NOT NULL,
	MaritalStatus char(1) NOT NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	Salary money NULL,
	VacationHours smallint NOT NULL,
	SickLeaveHours smallint NOT NULL,
	Active char(3) NOT NULL,
	ManagerID int NULL)