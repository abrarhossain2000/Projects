ui = fluidPage(
    theme = shinytheme("flatly"), 
    #shinythemes::themeSelector(),
    navbarPage("Demo Site", selected = "Apps", position = "fixed-top", id = "tabs",
        tags$style(type="text/css", "body {padding-top: 70px;}"),
        useShinyjs(),
        use_waiter(),
        tags$style(HTML("#hideMe{display: none}")),
        tabPanel("Apps", id = "idAppTbl",
            fluidPage(
                useShinyjs(),  # to hide alphabetical sort
                bsCollapse(id = "cntrlAppTbl",
                    bsCollapsePanel("Control Panel",
                        fluidRow(
                            column(3,
                                htmlOutput("selectAppTbl", inline = TRUE)
                            ),
                            column(3, 
                                #tags$b("Active only"),
                                hidden(
                                    checkboxInput("activeCheckboxAppTbl", "", value = TRUE, width = NULL)
                                )
                            ),
                            column(3, 
                                hidden(
                                    tags$b("Sort Alphabetical")
                                ),
                                hidden(
                                    checkboxInput("sortCheckboxAppTbl", "", value = FALSE, width = NULL)
                                )
                            )
                        )                           
                    )
                ),
                tags$head(tags$style("#tblQ1 {white-space: nowrap;}")),                
                tags$head(tags$style(
                    "input {
                        min-width: 75px !important;
                    }"
                )),
                DTOutput('tblAppTbl'),
                downloadButton("downloadAppTbl", label = "Download")
            )
        )
    )
)