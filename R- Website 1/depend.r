library(shiny)
library(DT)
library(shinyWidgets) #pickerInput
library(dplyr) #select & rename
library(stringr) #str_replace_all
library("RODBC")
library(shinyFeedback)
library(shinyjs)
library(readxl)
library("shinythemes")
library(rapportools) #is.empty, length_()
library(openxlsx)
library(waiter)
library(shinyBS) #collapse panel
library(fun) # random_password
library(tools) #toTitleCase
library(magrittr) # %<>%
#---------------------------
#   user definitions
#---------------------------

#---------------------------
#   Helper Functions
#---------------------------
flag = function(debug, title, type = 0){ 
    if(debug == 1 | debug == TRUE){
        header <- ifelse(type == 0, "Start ", "Fin ")

        msg = paste0(header, title)

        if(debug == 1) cat("\n\n\n")
        if(debug == 1) print("------------------------------------------")
        if(debug == 1) print(msg)
        if(debug == 1) print("------------------------------------------")
        if(debug == 1) cat("\n\n\n")
    }
}

is.wholenumber <- function(x, tol = .Machine$double.eps^0.5)  abs(x - round(x)) < tol

trueFeedback <- function(label, msg, fire = TRUE){
    shinyFeedback::feedbackDanger(
        label, 
        fire,
        msg
    )
}

pmsPad <- function(df, colName, pad = 7){
    #requrire(stringr)
    df[, colName] <- str_pad(df[, colName], pad, pad = "0")
    #out$EmpPMS = str_pad(out$EmpPMS, 7, pad = "0")
    return(df)
}

length_ <- function(x){
    library(rapportools)
    if(is.null(x)) return(0)
    if(is.data.frame(x)) return(nrow(x))
    if(is.list(x)) return(length(x))
    if(is.empty(x, trim = FALSE)) return(0)
    if(is.character(x)) return(nchar(x))
    if(is.na(x)) return(0)
    if(is.numeric(x)) return(nchar(x))
}