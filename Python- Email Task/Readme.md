Task:  Email Supervisors for every Sub Division about their employees’ missing information in the Web Software App. Missing information fields include employees’ supervisor ID #, work location info (WhichBuilding), location floor info (SpecificFloor), site type info (BuildingType), and supervisor’s Title

Contents of this folder:
1.	SupervisorEmailContactsV3.csv- This file contains Contact Information on how to email each Subdivision supervisor.
2.	FinalProductV4.py – This is a query that finds the employees in the Company WebApp with missing or outdated supervisor information. The csv contains the emails of the Heads of every Sub Division and use this csv to email them about the employees that are returned from the query.

CSV Content:
There are 4 columns in the SupervisorEmailContactsV3.csv- SubDivision, Name, Emails, Instructions. There are 17 departments, 29 Supervisors (Last + First Name) & their corresponding email, and instructions on how to email them, or how to address them.

Definitions:
WhichBuilding- which building the employee works in, 
SpecificFloor- which floor the employee works in, 
BuildingType- the type of building that the employee works in, 
Title- the title that the employee has

Information regarding Database and Tables:
Database: These tables are all located on the same Database
Table 1: Employee Records Table 
Table 1 contains many columns such as: ID#, FirstName, LastName, Rank, supervisorID, WhichBuilding, SpecificFloor, BuildingType, Title
Table 2: Supervisor Records Table
 Table 2 contains many columns as well: FirstName (which is overwritten as SupFirstName), LastName (which is overwritten as SupLastName), Rank (which is overwritten as HigherRank), ID#
Table 3: Master Database with two important columns: SubDivision and DivisionUnitNum

Query Logic:
In Table 2, if the Supervisor ID is NULL, then there is ‘no supervisor ID’. I create a new column called “NoSupervisor”
In Table 2, if the Supervisor Rank contains ‘B/C/K/M/N/Q/R/S’, then this means that there is an ‘Inactive supervisor’. I create a new column called “InactiveSupervisor”
If the Employee ID in Table 1 is the same as the Supervisor ID in Table 2, then this means that the “Employee is their own supervisor” and this new column is called “OwnBoss”
In Table 1, if the WhichBuilding is Null, then there is “No WhichBuilding” and this new column is called “MissingSite”
In Table 1, if the SpecificFloor is Null, then there is “No Specific Floor”, and this new column is called “MissingActualFloor”
In Table 1, if the BuildingType is Null, then there is “No BuildingType” and this new column is called “MissingSiteType”
In Table 1, if the Title is Null, then there is “No title” and this new column is called “MissingTitle”
Some IDs are excluded in this query “ ‘1234567’ ‘0203014’ ‘7410922’, ‘3748932’ “ this is because these individuals are in very High Level positions so they are excluded (not that their employee information is empty).
The columns “NoSupervisor”, “InactiveSupervisor”, “OwnBoss”, “MissingSite”, “MissingActualFloor”, “MissingSiteType”, “MissingTitle” is concatenated together and is labeled as “MissingData”. So if any of these 7 columns contain NULL then there is sufficient employee data in its respective locations in the original tables. If there is a “No …” then the Supervisor knows to fill in that corresponding column for the employee. 
For example, for a specific employee’s “NoSupervisor” column is NULL, then that means that the employee has a valid supervisor (might want to double check with the “InactiveSupervisor” column). But if the “MissingSiteType” column says “No BuildingType”, then that means that the Employee’s BuildingType data is empty in the column and that it needs to be filled in.

Query Results:
![image](https://user-images.githubusercontent.com/66147832/165105995-4d7d49bd-c635-42fa-ab7a-c015acd49aad.png)

 


Email Results:
  