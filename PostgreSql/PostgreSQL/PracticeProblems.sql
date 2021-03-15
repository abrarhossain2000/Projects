-- 1.	Create a list of employee names and their full addresses using the INNER JOIN.
SELECT E.FIRSTNAME, E.LASTNAME, A.ADDRESSLINE1, A.ADDRESSLINE2, A.CITY, A.STATE, A.ZIP1, A.ZIP2
FROM EMPLOYEES E
INNER JOIN ADDRESSES A
ON E.EMPLOYEEID = A.EMPLOYEEID

--2. Create a list of employee names and their full addresses using the INNER JOIN for employees who live either in Massachusetts or California.
SELECT E.FIRSTNAME, E.LASTNAME, A.ADDRESSLINE1, A.ADDRESSLINE2, A.CITY, A.STATE, A.ZIP1, A.ZIP2
FROM EMPLOYEES E
INNER JOIN ADDRESSES A
ON E.EMPLOYEEID = A.EMPLOYEEID
WHERE UPPER(A.STATE) = 'MA' OR UPPER(A.STATE) = 'CA'

--3.Create an example of a Cartesian product using the Employees and Addresses table.
SELECT E.FIRSTNAME, E.LASTNAME, A.ADDRESSLINE1, A.ADDRESSLINE2, A.CITY, A.STATE, A.ZIP1, A.ZIP2
FROM EMPLOYEES E
CROSS JOIN ADDRESSES A

--4.Use a LEFT OUTER JOIN to list all employee first and last names as well as the gender and birthdates of their dependents if they have any.
SELECT E.FIRSTNAME, E.LASTNAME, E.GENDER, E.BIRTHDATE
FROM EMPLOYEES E
LEFT OUTER JOIN ADDRESSES A
ON E.EMPLOYEEID = A.EMPLOYEEID

--5.Use a RIGHT OUTER JOIN to list all employee first and last names as well as the gender and birthdates of their dependents if they have any (Same as above but change location of tables).
SELECT E.FIRSTNAME, E.LASTNAME, E.GENDER, E.BIRTHDATE
FROM EMPLOYEES E
RIGHT OUTER JOIN ADDRESSES A
ON E.EMPLOYEEID = A.EMPLOYEEID

--6.Use a SELF JOIN to select the employee first name, last name, title as well as the manager's first name, last name and title.
SELECT E.EMPLOYEEID, E.FIRSTNAME, E.LASTNAME, E.TITLE, M.FIRSTNAME, M.LASTNAME, E.MANAGERID
FROM EMPLOYEES E
INNER JOIN EMPLOYEES M 
ON M.EMPLOYEEID = E.MANAGERID
ORDER BY E.EMPLOYEEID

--7.Retrieve the employee first name, last name, department name and group name for the employee named Gail Erickson.
SELECT E.FIRSTNAME, E.LASTNAME, D.DEPARTMENTNAME, D.GROUPNAME
FROM EMPLOYEES E
INNER JOIN EMPLOYEESDEPARTMENTS ED
ON E.EMPLOYEEID = ED.EMPLOYEEID
INNER JOIN DEPARTMENTS D
ON ED.EMPLOYEEID = D.DEPARTMENTID
WHERE UPPER(E.FIRSTNAME) = 'GAIL'

--8.Retrieve the employee first name, last name, address, city, state, zip, department name and group name for the employee named David Bradley.
SELECT E.FIRSTNAME, E.LASTNAME, A.ADDRESSLINE1, A.ADDRESSLINE2, A.CITY, A.STATE, A.ZIP1, A.ZIP2, D.DEPARTMENTNAME, D.GROUPNAME
FROM EMPLOYEES E
INNER JOIN ADDRESSES A
ON E.EMPLOYEEID = A.EMPLOYEEID
INNER JOIN EMPLOYEESDEPARTMENTS ED
ON E.EMPLOYEEID = ED.EMPLOYEEID
INNER JOIN DEPARTMENTS D
ON ED.EMPLOYEEID = D.DEPARTMENTID
WHERE UPPER(E.FIRSTNAME) = 'DAVID'

--9.Retrieve the employee first name, last name, dependent first name, last name and gender for female dependents.
SELECT E.FIRSTNAME, E.LASTNAME, E.GENDER, E.EMPLOYEEID, D.EMPLOYEEID, D.FIRSTNAME, D.LASTNAME,D.GENDER
FROM EMPLOYEES E
INNER JOIN DEPENDENTS D
ON E.EMPLOYEEID = D.EMPLOYEEID
WHERE UPPER(D.GENDER) = 'F'

--10.Retrieve the employee first name, last name, dependent first name, last name, birth date for dependents who have birth dates less than or equal to 11/02/2008. 
SELECT E.FIRSTNAME, E.LASTNAME, E.EMPLOYEEID, D.EMPLOYEEID, D.FIRSTNAME, D.LASTNAME, D.BIRTHDATE
FROM EMPLOYEES E
INNER JOIN DEPENDENTS D
ON E.EMPLOYEEID = D.EMPLOYEEID
WHERE D.BIRTHDATE <= '11/02/2008'
ORDER BY D.BIRTHDATE

--11.	Use LEFT OUTER JOINS to list all Employees, their Department Names, and their dependent names, if any.
SELECT E.FIRSTNAME, E.LASTNAME, D.FIRSTNAME, D.LASTNAME
FROM EMPLOYEES E
LEFT OUTER JOIN DEPENDENTS D
ON E.EMPLOYEEID = D.EMPLOYEEID

--12.	Use RIGHT OUTER JOINS to list all Employees, their Department Names, and their dependent names, like you did in the question above.
SELECT E.FIRSTNAME, E.LASTNAME, D.FIRSTNAME, D.LASTNAME
FROM EMPLOYEES E
RIGHT OUTER JOIN DEPENDENTS D
ON E.EMPLOYEEID = D.EMPLOYEEID

--13.	Retrieve the employee first name, last name, dependent first name, last name and gender for dependents who were born in or before 1998.
SELECT E.FIRSTNAME, E.LASTNAME, E.EMPLOYEEID, D.EMPLOYEEID, D.FIRSTNAME, D.LASTNAME, D.GENDER
FROM EMPLOYEES E
INNER JOIN DEPENDENTS D
ON E.EMPLOYEEID = D.EMPLOYEEID
WHERE D.BIRTHDATE <= '12/31/1998'

--14.	Retrieve all employees belonging to the department “Marketing” using INNER JOINS.
SELECT E.FIRSTNAME, E.MIDDLENAME, E.LASTNAME, D.DEPARTMENTNAME
FROM EMPLOYEES E
INNER JOIN EMPLOYEESDEPARTMENTS ED 
ON ED.EMPLOYEEID = E.EMPLOYEEID
INNER JOIN DEPARTMENTS D 
ON D.DEPARTMENTID = D.DEPARTMENTID
WHERE D.DEPARTMENTNAME = 'Marketing'

--15.	Retrieve the first name, last name, and title of the manager responsible for the Employee with the first name “Ben” and last name “Miller”.

SELECT M.FIRSTNAME, M.LASTNAME, M.TITLE
FROM EMPLOYEES M
INNER JOIN EMPLOYEES E
ON M.EMPLOYEEID = E.MANAGERID
WHERE UPPER(E.FIRSTNAME) = 'BEN'
AND UPPER(E.LASTNAME) = 'MILLER'
