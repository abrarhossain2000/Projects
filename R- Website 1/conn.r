defaultDb = "Example"

conn_ <- function(db = defaultDb){
    require("RODBC")
    require(stringr)
    cs <- paste0(
        "driver={ODBC Driver 17 for SQL Server};",
        "server=SomeServer;",
        "Trusted_Connection=Yes;",
        "database=Example;"
    )
    conn <- 0
    conn <- odbcDriverConnect(cs)
    return(conn)
}

showTbl <- function(db = defaultDb){
    #dbListTables(conn_())
    X <- sqlTables((conn_(db)))
    return(X[X$TABLE_SCHEM == "dbo", ]$TABLE_NAME)
}

showCols <- function(tbl, db = defaultDb){
    #dbListFields(conn_(), tbl)
    X <- sqlColumns(conn_(db), tbl)
    return(unique(X$COLUMN_NAME))
}


easyQuery <- function(qry = "select * from TBL", tbl, table_schema = "dbo", db = defaultDb){
    conn <- conn_(db)
    qry = str_replace_all(qry, "TBL", paste0(db, ".", table_schema, ".", tbl))

    #to keep full PMS numbers    
    col_qry = paste0("select COLUMN_NAME from ", db, ".information_schema.columns where table_name = '", tbl,"' and table_schema = '", table_schema,"'")
    x = sqlQuery(conn, col_qry)

    out <- sqlQuery(conn, qry, as.is = rep(TRUE, nrow(x) ) )
    odbcClose(conn)
    rm(conn)
    return(out)
}

query <- function(qry = NULL, db = defaultDb){
    conn <- conn_(db)
    #to keep full PMS numbers    
    out <- sqlQuery(conn, qry, stringsAsFactors = FALSE)
    odbcClose(conn)
    rm(conn)
    return(out)
}

#import queries
source(paste0(root, '/mainQueries.r'))