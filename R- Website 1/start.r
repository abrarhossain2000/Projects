root127 <- "C:/Users/ahossain/Desktop/Website 1"
rootDocker <<- "" # global for IP addy in auth mod

debug_ <<- TRUE
root <<- root127
LOCAL_ = TRUE

#--------------------
# run app
#--------------------
if(root == rootDocker){
    SHINY_PROXY <<- TRUE
    PDAM_IP <<- TRUE
    LCL_IP <<- FALSE
    NO_IP <<- FALSE
}else if(root == root127){
    SHINY_PROXY <<- TRUE
    PDAM_IP <<- FALSE
    NO_IP <<- TRUE
    LCL_IP <<- FALSE
    if(LOCAL_){
        LCL_IP <<- TRUE
        NO_IP <<- FALSE
    }
}

source(paste0(root, "/depend.r"))
source(paste0(root, "/conn.r"))
source(paste0(root, "/ui.r"))
source(paste0(root, "/server.r"))

#SHINY_PROXY <<- TRUE
if(NO_IP) runApp(shinyApp(ui, server))
if(SHINY_PROXY & root == rootDocker) runApp(shinyApp(ui, server),port = 3838, host = "0.0.0.0")
if(PDAM_IP) runApp(shinyApp(ui, server), host="",port=5050) #place I.P address into host
if(LCL_IP) runApp(shinyApp(ui, server), host="",port=8000) #place I.P address into host