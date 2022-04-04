server = function(input, output, session) {
    options(warn=-1)
    options(shiny.maxRequestSize = 50*1024^2)

    access <<- FALSE # no access
    WRITE <<- FALSE

    #=================================================#
    #                  APP Start                      #
    #=================================================#
    observe({
        w <- Waiter$new() #Creates a waiter (loading screen)
        
        AppTbl <- reactiveValues(df = query(qryFmsTbl)) #AppTbl has the reactive values from the dataframe which is queried from the db
        #----------------------
        # App Tab
        #----------------------
        #renderDT renders a data table; DT::renderDT is the syntax
        #DT supports both serverside and clientside support , default is server-side processing: server = TRUE, client-side processing: server = FALSE
        #When the data object is relatively large, do not use server = FALSE, otherwise it will be too slow to render the table in the web browser, 
        #and the table will not be very responsive, either.
        output$tblAppTbl <- DT::renderDT(server = TRUE, { #The output of the tbl 
            flag(debug_, "tblAppTbl", 0) #This starts a flag onto the R screen
            main <- AppTblDf()

            m <- datatable(
                main,
                escape = FALSE,
                rownames = FALSE, 
                filter = list(position = "top", clear = FALSE, plain = TRUE), 
                extensions = c('Buttons'),
                selection = "single",
                options = list(
                    autoWidth = TRUE,
                    pageLength = 50,
                    lengthMenu = c(50, 100, 1000), 
                    dom = 'Blfrtip', 
                    buttons = list(
                        list(
                            extend = "collection",
                            text = 'Excel',
                            action = DT::JS(
                                "function ( e, dt, node, config ) {
                                    Shiny.setInputValue('excelAppTbl', true, {priority: 'event'});
                                }"
                            )
                        ),
                        list(
                            extend = "collection",
                            text = 'Add Row',
                            action =  DT::JS(
                                "function ( e, dt, node, config ) {
                                    Shiny.setInputValue('addAppTbl', true, {priority: 'event'});
                                }"
                            )                        
                        ),
                        list(
                            extend = "collection",
                            text = 'Edit Row',
                            action =  DT::JS(
                                "function ( e, dt, node, config ) {
                                    Shiny.setInputValue('editAppTbl', true, {priority: 'event'});
                                }"
                            )                        
                        ),
                        list(
                            extend = "collection",
                            text = 'Delete Row',
                            action =  DT::JS(
                                "function ( e, dt, node, config ) {
                                    Shiny.setInputValue('deleteAppTbl', true, {priority: 'event'});
                                }"
                            )                        
                        )
                        
                    )
                )
            )
            
            flag(debug_, "tblAppTbl", 1)  #The 1 ends the flag onto the R screen
            m
        })
        #This reactive only removes columns
        AppTblDf <- reactive({
            flag(debug_, "AppTblDf", 0)
            df <- AppTbl$df
            if(!is.null(input$selectAppTbl)){ 
                df <- dplyr::select(AppTbl$df, input$selectAppTbl)
            }
            # if not sorted, we sort based on original data
            if(!input$sortCheckboxAppTbl){
                df <- dplyr::select(df, names(AppTbl$df)[names(AppTbl$df) %in% names(df)])
            }else{
                df <- dplyr::select(df, sort(names(df)))
            }

            #this is at end because of 1 column error
            if(!is.null(input$selectAppTbl)){ 
                if(length(input$selectAppTbl) == 1){
                    df = as.data.frame(df)
                    names(df) = input$selectAppTbl
                }
            }
            flag(debug_, "AppTblDf", 1)
            return(df)
        })
        output$selectAppTbl <- renderUI({
            pickerInput(
                inputId = "selectAppTbl", 
                label = "Select columns", 
                choices = sort(names(AppTbl$df)),
                options = pickerOptions(
                    title = "Select columns",
                    actionsBox = TRUE,
                    liveSearch = TRUE
                ),
                multiple = TRUE
            )
        })

        output$downloadAppTbl <- downloadHandler(
            filename = function() {
                paste("data-", Sys.Date(), ".xlsx", sep="")
            },
            content = function(file) {                        
                write.xlsx(AppTbl$df, file) #CHANGED the first input to AppTbl$df since this is the data in a dataframe
            }
        )
        observeEvent(input$excelAppTbl, {
            print("excelAppTbl")
            runjs("$('#downloadAppTbl')[0].click();")
        })
        #----input data
        observeEvent(input$addAppTbl, {        
            showModal(
                modalDialog(
                    title = "Add New Entry",
                    selectizeInput(
                        "fmsNameField", "FMS Name", 
                        choices = c(""),
                        multiple = FALSE, selected =  NULL,
                        options = list(create = TRUE, placeholder = "Enter a New FMS Name")
                    ),
                    textInput("AgencyNameField", "Agency Name",
                        placeholder = 'Enter an Agency Name'
                    ),
                    textInput("AgencyFmsNameField", "Agency FMS Name",
                        placeholder = 'Enter a username'
                    ),
                    textInput("DivisionNameField", "Division Name",
                        placeholder = 'Enter a username'
                    ),
                    footer = tagList(
                        actionButton("saveAppTbl", "Save"),
                        modalButton("Cancel")
                        
                    )
                )
            )
        })
        observeEvent(input$deleteAppTbl, {
            print(input$tblAppTbl_rows_selected)
            r = input$tblAppTbl_rows_selected
            if(!is.null(r)){
                print(AppTbl$df[r, ])
                cat("\n\n")
                showModal(
                    modalDialog(
                        title = "Delete Entry",
                        footer = tagList(
                            actionButton("delete_AppTbl", "Delete"),
                            modalButton("Cancel")
                            
                        )
                    )
                )
            }
        })
        observeEvent(input$editAppTbl, {
            flag(debug_, "editAppTblRow", 0)
            print(input$tblAppTbl_rows_selected)
            r = input$tblAppTbl_rows_selected
            if(!is.null(r)){
                #print(UsersTblDf())
                print(AppTblDf()[r, ])
                cat("\n\n")
                id = AppTblDf()$Id[r]
                df = AppTbl$df[AppTbl$df$Id == id, ]
                out <- data.frame(
                    Id = id,
                    fms = df$fms, 
                    agency = df$agency,
                    agencyFms = df$agencyFms,
                    division = df$division,
                    stringsAsFactors = FALSE
                )     
                print(out)

                showModal(
                    modalDialog(
                        title = "Rename Entry",                      
                        textInput("fmsNameField", "FMS Name", 
                            placeholder = 'Enter a New FMS Name',
                            value = out$fmsNameField
                        ),
                        textInput("AgencyNameField", "Agency Name",
                            placeholder = 'Enter an Agency Name',
                            value = out$AgencyNameField
                        ),
                        textInput("AgencyFmsNameField", "Agency FMS Name",
                            placeholder = 'Enter an Agency FMS Name',
                            value = out$AgencyFmsNameField
                        ),
                        textInput("DivisionNameField", "Division Name",
                            placeholder = 'Enter A Division',
                            value = out$DivisionNameField
                        ),                                       
                        footer = tagList(
                            actionButton("saveAppTblEdit", "Save"),
                            modalButton("Cancel")
                        )
                    )
                )
            }
            flag(debug_, "editAppTblRow", 1)
        })

        #---save the data
        observeEvent(input$saveAppTbl, {
            flag(debug_, "saveAppTbl")
            print(input$fmsNameField)
            print(input$AgencyNameField)
            print(input$AgencyFmsNameField)
            print(input$DivisionNameField)
            # ---- required fields test
            test1 <- length_(input$fmsNameField) > 0
            test1 <- length_(input$AgencyNameField) > 0
            test2 <- length_(input$AgencyFmsNameField) > 0
            test2 <- length_(input$DivisionNameField) > 0

            if(test1 & test2){
                out <- data.frame(
                    fms = input$fmsNameField,
                    agency = input$AgencyNameField,
                    agencyFms = input$AgencyFmsNameField,
                    division = input$DivisionNameField,
                    stringsAsFactors = FALSE
                )
                print(out)
                #---------------------------------------
                # add fms
                #---------------------------------------
                qry <- str_replace(qryInsertfmsApp, "<fms>", out$fms)
                qry <- str_replace(qry, "<agency>", out$agency)
                qry <- str_replace(qry, "<agencyFms>", out$agencyFms)
                qry <- str_replace(qry, "<division>", out$division)
                print(query(qry))
                Id <- query(str_replace(qrySpecificfmsApp, "<fms>", out$fms))$fms #the last fms returns the data of fms to the screen
                #find the last created id
                print(Id)
                out$Id = Id
                out <- dplyr::select(out, Id, fms, agency, agencyFms, division)
                #---------------------------------------
                # next line activates addRow functionality
                #---------------------------------------
                AppTbl$df = bind_rows(out, AppTbl$df)
                
                removeModal()                    
            }else{
                #removeModal()
                showModal(modalDialog(
                    title = "Error",
                    "Missing fields because of save"
                ))
            }
            flag(debug_, "saveAppTbl", 1)
        })
        observeEvent(input$saveAppTblEdit, {
            flag(debug_, "saveAppTblEdit") 
            print(input$fmsNameField)
            print(input$AgencyNameField)
            print(input$AgencyFmsNameField)
            print(input$DivisionNameField)
            # ---- required fields test
            test1 <- length_(input$fmsNameField) > 0
            test1 <- length_(input$AgencyNameField) > 0
            test2 <- length_(input$AgencyFmsNameField) > 0
            test2 <- length_(input$DivisionNameField) > 0

            r = input$tblAppTbl_rows_selected
            print(AppTblDf()[r, ])
            cat("\n\n")
            id = AppTblDf()$Id[r]
            df = AppTbl$df[AppTbl$df$Id == id, ]
            if(test1 & test2){
                out <- data.frame(
                    Id = id,
                    fms = input$fmsNameField,
                    agency = input$AgencyNameField,
                    agencyFms = input$AgencyFmsNameField,
                    division = input$DivisionNameField,
                    stringsAsFactors = FALSE
                )            
                print(out)
                print("starting Query:")
                
                #---------------------------------------
                # add user
                #---------------------------------------
                qry <- str_replace(qryUpdatefmsApp, "<fms>", out$fms)
                "\n query check: " %>% cat()
                qry %>% dput()
                qry <- str_replace(qry, "<agency>", out$agency)
                "\n query check: " %>% cat()
                qry %>% dput()
                qry <- str_replace(qry, "<agencyFms>", out$agencyFms)
                "\n query check: " %>% cat()
                qry %>% dput()
                qry <- str_replace(qry, "<division>", out$division) #create a string to replace id
                "\n query check: " %>% cat()
                qry %>% dput()
                qry <- str_replace(qry, "<Id>", as.character(out$Id))
                "\n query check: " %>% cat()
                qry %>% dput()
                print(query(qry))

                #---------------------------------------
                # next line activates addRow functionality
                #---------------------------------------
                AppTbl$df[AppTbl$df$Id == id, ]$fms = out$fms
                AppTbl$df[AppTbl$df$Id == id, ]$agency = out$agency
                AppTbl$df[AppTbl$df$Id == id, ]$agencyFms = out$agencyFms
                AppTbl$df[AppTbl$df$Id == id, ]$division = out$division
                
                
                removeModal()                    
            }else{
                #removeModal()
                showModal(modalDialog(
                    title = "Error",
                    "Missing fields because of edit"
                ))
            }
            flag(debug_, "saveAppTblEdit", 1)
        })
        observeEvent(input$delete_AppTbl, {
            r = input$tblAppTbl_rows_selected
            if(!is.null(r)){
                id = AppTblDf()$Id[r]
                df = AppTbl$df[AppTbl$df$Id == id, ]

                print(df)
                cat("\n\n")

                #remove from database
                qry <- "DELETE FROM TBL WHERE [Id] = <Id>"
                qry <- str_replace(qry, "<Id>", as.character(id))
                g <- easyQuery(qry = qry, tbl = "AHTestTable")
                cat("\n\nQuery results: ", g)

                #remove from website table
                AppTbl$df <- AppTbl$df[ !AppTbl$df$Id == id, ]
                removeModal()
            }
        })

    })
}
