# Demo Site

**Task:**  
Email Supervisors for every Sub Division about their employees’ missing information in the Web Software App. Missing information fields include employees’ supervisor ID #, work location info (WhichBuilding), location floor info (SpecificFloor), site type info (BuildingType), and supervisor’s Title

**Contents of this folder:**
1. **Ui.r**- is the User Interface file, which includes the heading and the sortable checkbox style “Control Panel”. This Control Panel is used to select specific columns, and as many columns as you want. You can deselect every column and select every column as well.
2. **Start.r**- is the Start file, this includes a rootDocker. Docker is used as the root, because Docker is an open source containerization platform, that helps developers package applications into containers-combining an application’s source code with the OS libraries and dependencies necessary to run in any environment. The file also contains configurations for the host I.P address and port number. You can read more about Docker here: https://colinfay.me/docker-r-reproducibility/
3. **Conn.r**- contains 5 functions. “conn_” is the database connection function, “showTbl” is a function that can display the table within a database, while “showCols” is a function that can show the columns within that specific table. “easyQuery” is a function that has a query in the col_qry variable that keeps the same “PMS number”, this query is executed as well. “query” is the last function within this file and this function helps us execute whatever new queries we create.
Depend.r**- is a Depend file that includes the necessary libraries for the application to run. This includes: 1. shiny 2. DT 3. shinyWidgets 4. dplyr 5. stringr 6. ”RODBC” 7. shinyFeedback 8. shinyjs 9. readxl 10. “shinythemes” 11. rapportools 12. openxlsx 13. waiter 14. shinyBS 15. fun 16. tools 17. magrittr
This file also contains some helper functions: 1. Flag function- used to help debug 2. WholeNumber function- used to find a whole Number 3. pmsPad function- used to provide specific formatting 4. Length function- help identify the length of a list, dataframe, character, etc 5. TrueFeedback function- is also used to help debug 
4. **mainQueries.r**- is a SQL query file and contains 4 query functions. <br />
Function 1: qryFmsTbl- This is a SELECT query to select the appropriate table <br />
Function 2: qryInsertfmsApp- This is a INSERT query to add rows into that table ^ from user-inputted values <br />
Function 3: qryUpdatefmsApp- This is an UPDATE query that updates the values in a selected row in the table with user-inputted values <br />
Function 4: qrySpecificfmsApp- This is a SELECT query that selects the table but only where fms equals an inserted fms value <br />
5. **Server.r**- is a server file that creates a loading screen that leads to a datatable in R. This table allows the users to be able to add, edit, and delete rows. Furthermore you are able to download the table as an csv.

**Once the site is live, this is what should be displayed:**
![image](https://user-images.githubusercontent.com/66147832/165128265-403efbaa-d7db-4199-b927-903386077e9f.png)

**When the user wants to add a new entry to the table, they first must click on “Add Row”:**
![image](https://user-images.githubusercontent.com/66147832/165128329-ffcc501f-bed0-4cea-bbd5-d575d305980a.png)

**This is the result:** <br />
![image](https://user-images.githubusercontent.com/66147832/165128392-eb733da5-51db-4f9a-a9f4-2400fb743f86.png)

**This is the result in the database:**
![image](https://user-images.githubusercontent.com/66147832/165128449-fdd6de12-5f5f-49e1-8168-1c563e26549c.png)

**When the user wants to edit an existing row in the table, they first must click on “Edit Row”:**
![image](https://user-images.githubusercontent.com/66147832/165128539-b1e85d1a-920a-43ba-a6f2-c9b563470a7a.png)

**This is the result:** <br />
![image](https://user-images.githubusercontent.com/66147832/165128548-8f63bb5d-61a1-406d-8dcc-0adf9d7cf615.png)

**This is the result in the database:**
![image](https://user-images.githubusercontent.com/66147832/165128591-a05f41c9-e9cf-4f4e-8857-7c74919ecd45.png)

**When the user wants to delete an existing row in the table, they first must click on “Delete Row”:**
![image](https://user-images.githubusercontent.com/66147832/165129184-0c711aa0-b4bc-40a1-98a2-a2bc3a03981c.png)

**This is the result:**
![image](https://user-images.githubusercontent.com/66147832/165129207-032972ce-c87d-40de-8c28-825e28664ee6.png)

**This is the result in the database:**
![image](https://user-images.githubusercontent.com/66147832/165129230-b28078bb-3d96-4d5d-856f-9684ed033ac9.png)

**When the user wants to view specific columns in the table, they first must click on the Control Panel and select the columns they want to see via the DropDown menu:**
![image](https://user-images.githubusercontent.com/66147832/165129299-43a74c1b-12ee-47f3-9f12-ea27703b7faa.png)

