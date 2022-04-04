import pandas as pd
import pyodbc as odbc
import win32com.client as win32
from datetime import datetime

#This function connects to the server and appropriate database. It runs the specific query and returns a dataframe with that information 
def connection (database):
    server = 'REALISTICSERVERNAME' 
    #For the connection, we are connecting to a Microsoft SQL Server Database
    conn = odbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+server+';DATABASE='+database+';Trusted_Connection=yes;')
    query = pd.read_sql_query(""" 
    SELECT
        Table1.[ID#]
        ,Table1.[FirstName]
        ,Table1.[LastName]
        ,Table1.[Rank]
        ,Table3.[SubDivision]
        ,Table1.[supervisorID]
        ,Table2.[FirstName] AS SupFirstName
        ,Table2.[LastName] AS SupLastName
        ,Table2.[Rank] AS HigherRank
        ,Table1.[WhichBuilding]
        ,Table1.[SpecificFloor]
        ,Table1.[BuildingType]
        ,Table1.[Title]

        ,CASE 
        when Table2.[ID#] is NULL
        then 'No supervisor ID' end as NoSupervisor

        ,CASE
        when Table2.[Rank] <> 'B'
            AND Table2.[Rank] <> 'C'
            AND Table2.[Rank] <> 'K'
            AND Table2.[Rank] <> 'M'
            AND Table2.[Rank] <> 'N'
            AND Table2.[Rank] <> 'Q'
            AND Table2.[Rank] <> 'R'
            AND Table2.[Rank] <> 'S'
        then 'Inactive supervisor' end as InactiveSupvisor

        ,CASE
        when Table1.[ID#] = Table2.[ID#]
        then 'Employee is their own supervisor' end as OwnBoss

        ,CASE
        when Table1.[WhichBuilding] IS NULL
        then 'No WhichBuilding' end as MissingSite

        ,CASE
        when Table1.[SpecificFloor] IS NULL
        then 'No SpecificFloor' end as MissingActualFloor

        ,CASE
        when Table1.BuildingType IS NULL
        then 'No BuildingType' end as MissingSiteType

        ,CASE
        when Table1.Title IS NULL
        then 'No Title' end as MissingTitle

    FROM tblEmployees AS Table1
    LEFT JOIN tblEmployees AS Table2
    ON Table1.supervisorID = Table2.[ID#]
    LEFT JOIN Table3
    ON Table1.[DivisonUnitNum] = Table3.[DivisonUnitNum]
    WHERE
    (
        Table1.[Rank] = 'B'
        OR Table1.[Rank] = 'C'
        OR Table1.[Rank] = 'K'
        OR Table1.[Rank] = 'M'
        OR Table1.[Rank] = 'N'
        OR Table1.[Rank] = 'Q'
        OR Table1.[Rank] = 'R'
        OR Table1.[Rank] = 'S'
    )
    AND
    (
        (  -- Person has no supervisor
            Table2.[ID#] IS NULL
        )
        OR
        (  -- Person's supervisor is Inactive Rank
            Table2.[Rank] <> 'B'
            AND Table2.[Rank] <> 'C'
            AND Table2.[Rank] <> 'K'
            AND Table2.[Rank] <> 'M'
            AND Table2.[Rank] <> 'N'
            AND Table2.[Rank] <> 'Q'
            AND Table2.[Rank] <> 'R'
            AND Table2.[Rank] <> 'S'
        )
        OR
        (  -- Person is its own supervisor
            Table1.[ID#] = Table2.[ID#]
        )
        OR
        (  -- Person has no Building
        Table1.[WhichBuilding] IS NULL
        )
        OR
        (  -- Person has no SpecificFloor
            Table1.[SpecificFloor] IS NULL
        )
        OR
        (  --Person has no BuildingType
            Table1.[BuildingType] IS NULL
        )
        OR
        (  --Person has no Title
            Table1.[Title] IS NULL
        )
    )
    AND (Table1.[ID#] NOT IN ('1827345','0510501','1512594','1292901'))
    AND (SubDivision IS NOT NULL)
    ORDER BY Table3.[SubDivision]""", conn)
    df = pd.DataFrame(query)
    #New Columns are created and appended to the dataframe
    cols = ['NoSupervisor', 'InactiveSupvisor', 'OwnBoss', 'MissingSite', 'MissingActualFloor', 'MissingSiteType', 'MissingTitle']
    df['MissingData'] = df[cols].apply(lambda x: ', '.join(x.dropna()), axis=1)
    return(df)

def keys(input): #Takes the DataFrame, Sorts it by subdivison, and Returns 5 columns
    df = connection(database ='somedatabase')
    sortbydiv = df.sort_values(by = ["SubDivision"], inplace = False) #Sorts by Sub Division
    findData = sortbydiv[sortbydiv['SubDivision'].isin([input])] #Search through the new sorted dataframe for the input (specific Sub Division)
    if findData.empty: #If there is no missing employee data for this specific Sub Division then return this:
        print( "Nothing to Print for this division:" + input)
    else: #Return these Columns for the Employees with Missing Data for this specific Sub Division
        df = findData[['ID#', 'FirstName', 'LastName', 'SubDivision', 'MissingData']].reset_index(drop=True)
        return(df)

def file(input = "Go"): #Queries the Database with the Keys function and concatenates the results into one excel based off today's date
    inputFile1 = pd.DataFrame(keys(input =  "Accounting Dept")) #Runs the keys function with a specific Sub Division Name
    inputFile2 = pd.DataFrame(keys(input =  "Department 2"))
    inputFile3 = pd.DataFrame(keys(input =  "Department 3"))
    inputFile4 = pd.DataFrame(keys(input =  "Dept 4"))
    inputFile5 = pd.DataFrame(keys(input =  "Bridges Department"))
    inputFile6 = pd.DataFrame(keys(input =  "Commissioner Dept"))
    inputFile7 = pd.DataFrame(keys(input =  "Facilities Dept"))
    inputFile8 = pd.DataFrame(keys(input =  "Ferry Department"))
    inputFile9 = pd.DataFrame(keys(input =  "Fleet Department"))
    inputFile10 = pd.DataFrame(keys(input = "Department 9"))
    inputFile11 = pd.DataFrame(keys(input = "Human Resources"))
    inputFile12 = pd.DataFrame(keys(input = "IT Department"))
    inputFile13 = pd.DataFrame(keys(input = "Law Department"))
    inputFile14 = pd.DataFrame(keys(input = "Department 13"))
    inputFile15 = pd.DataFrame(keys(input = "Road Department"))
    inputFile16 = pd.DataFrame(keys(input = "Department 15"))
    inputFile17 = pd.DataFrame(keys(input = "Department 16"))
    inputFile18 = pd.DataFrame(keys(input = "Traffic Department"))
    #append every sub Division onto one dataframe
    newExcel = pd.concat([inputFile1, inputFile2, inputFile3, inputFile4, inputFile5, inputFile6, inputFile7, inputFile8, inputFile9, inputFile10, inputFile11, inputFile12, inputFile13, inputFile14, inputFile15, inputFile16, inputFile17, inputFile18],ignore_index=True)
    exceldata = pd.DataFrame(newExcel)
    #Using the datetime library, export this new dataframe (exceldata) to an actual .xlsx file that will be saved in the path of your choosing using today's date
    datestring = datetime.strftime(datetime.now(), ' %Y_%m_%d')
    exceldata.to_excel(excel_writer=r"C:\Users\ahossain\Desktop\{0}".format('supervisorError_' + datestring + '.xlsx'))#Fill in your path

file(input = "Go") #By running "Go" in the file function, it runs the function and returns an excel with the necessary data

def sup(input): #Scans a Supervisor Email CSV, Sorts it by subdivison, and Compares it to the first DataFrame. This returns who to email to.
    olddataframe = keys(input) #The input is a specific Sub Division
    #Read the Supervisor Email CSV and put it in a new dataframe
    df = pd.read_csv(r'C:\Users\ahossain\Desktop\Resume-Github\OrgChartTask\Final Product (Product Version)\Div Contacts to Update OCP Supervisor Info V3.csv', encoding= 'cp1252')
    newdataframe = pd.DataFrame(df)
    #Sort the new dataframe by Sub Division values
    sortbydiv = newdataframe.sort_values(by = ['SubDivision'], inplace = False)
    #Search through the new sorted dataframe for the input (specific Sub Division)
    findData = sortbydiv[sortbydiv['SubDivision'].isin([input])]
    #Merge the old dataframe (with missing employee data) with the new dataframe (Supervisor Email CSV- sorted by specific Sub Divisions)
    dataframe2 = olddataframe.merge(findData, on='SubDivision', how='left')
    fine1= dataframe2.drop_duplicates(subset = ["Emails"]) #This returns unique emails
    newdf =', '.join(fine1["Emails"].tolist()) #This returns the emails as a string
    return(newdf)

def body(input): #Drafts up an email inserting specific instructions per subDivision
    if input == "Ferry Department": #Special Condition- For Ferry Department, address the Supervisor by a specific nickname
        value = "Nickname"
    if input == "Department 15": #Special Condition- For Department 15, address the Supervisors by "Special Team"
        value = "Special Team"
    else:
        value = (input) #Return Sub Division name as the value for the Greeting 
    df = keys(input) #Returns the employee missing data 
    df2 = sup(input) #Returns the email addresses of the Supervisors for the appropriate Sub Division
    #Returns the df (employee missing data) as a table which is called "html"
    html = (df.style.set_properties(**{'font-size': '12pt', 'font-family': 'Calibri', 'border-color': 'black','border-style' :'solid', 'border-width': '1px', 'border-collapse':'collapse' }).render())
    olApp = win32.Dispatch('Outlook.Application')
    mailItem = olApp.CreateItem(0)
    mailItem.Subject = "Missing Employee Data- Supervisor Action Required"
    mailItem.BodyFormat = 1
    mailItem.HTMLBody = """<html><font face="Calibri" size="10px"> <div> Good Afternoon """ + value + """, <br> <br> I am writing to remind you that the Supervisor Information for the following employees is 
    missing or needs to be updated in the Web Software app: <br> <br>""" + html + """<br> <br> Please enter the correct information by COB Sunday. If you have any questions or experience 
    any technical difficulties, please let me know. Thank you and stay safe! </div> </font></html>"""
    mailItem.To = df2
    mailItem.Display()

body(input = "Accounting Dept") #By calling the body function on "Accounting Dept",m it returns an email with the missing employee data and the email address the appropriate 
body(input = "Department 2")
body(input = "Department 3")
body(input = "Dept 4")
body(input = "Bridges Department")
body(input = "Commissioner Dept")
body(input = "Facilities Dept")
body(input = "Ferry Department")
body(input = "Fleet Department")
body(input = "Department 9")
body(input = "Human Resources")
body(input = "IT Department")
body(input = "Law Department")
body(input = "Department 13")
body(input = "Road Department")
body(input = "Department 15")
body(input = "Department 16")
body(input = "Traffic Department")