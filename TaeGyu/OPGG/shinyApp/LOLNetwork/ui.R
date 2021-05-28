

library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(pracma)
library(seewave)
library(changepoint)

selectStyle <- "
                 /*max-height: 500px;
                 overflow-y:scroll;*/
                 -webkit-column-count: 3;
                 column-count: 3;
               "

edgeShowTypeList <- c(
    "All" = 0,
    "Win" = 1,
    "Lose" = 2,
    "Draw" = 3
)


ui <- dashboardPage(
    
    # Header
    dashboardHeader(title = "Social Network"),
    
    # Sidebar
    dashboardSidebar(
        
        sidebarMenu(
            menuItem("Visualization", tabName = "visualization", icon = icon("cloudsmith"))
        )

    ),
    
    # Body
    dashboardBody(
        
        tabItems(
          
            tabItem(
              
                tabName = "visualization",
                
                fluidPage(
                    
                  
                    fluidRow(
                        
                            tabBox(
                                width = 4,
                                height = "780px",
                                tabPanel( "Top",
                                     style = selectStyle,
                                     checkboxGroupInput(inputId = "selectTopChamp",
                                                        label = "Select Champion",
                                                        choices = TopLineChamp
                                     ),
                                     checkboxInput(inputId = "TopSelectAll",
                                                   label = "Top select all",
                                                   value = FALSE)
                                ),
                                tabPanel("Mid",
                                     style = selectStyle,
                                     checkboxGroupInput(inputId = "selectMidChamp",
                                                        label = "Select Champion",
                                                        choices = MinLineChamp
                                     ),
                                     checkboxInput(inputId = "MidSelectAll",
                                                   label = "Mid select all",
                                                   value = FALSE)
                                ),
                                tabPanel("Jungle",
                                     style = selectStyle,
                                     checkboxGroupInput(inputId = "selectJungleChamp",
                                                        label = "Select Champion",
                                                        choices = JungleLineChamp
                                     ),
                                     checkboxInput(inputId = "JungleSelectAll",
                                                   label = "Jungle select all",
                                                   value = FALSE)
                                ),
                                tabPanel("Bottom",
                                     style = selectStyle,
                                     checkboxGroupInput(inputId = "selectBotChamp",
                                                        label = "Select Champion",
                                                        choices = BotLineChamp
                                     ),
                                     checkboxInput(inputId = "BotSelectAll",
                                                   label = "Bot select all",
                                                   value = FALSE)
                                ),
                                tabPanel("Support",
                                     style = selectStyle,
                                     checkboxGroupInput(inputId = "selectSupportChamp",
                                                        label = "Select Champion",
                                                        choices = SupportLineChamp
                                     ),
                                     checkboxInput(inputId = "SupportSelectAll",
                                                   label = "Support select all",
                                                   value = FALSE)
                                )
                            
                            ),
                            
                        
                        column(
                            
                            width = 8,
                            

                            fluidRow(
                                visNetworkOutput("networkPlot", height = "600px", width = "100%")
                            ),
                            fluidRow(
                                box(
                                    width = "100%",
                                    radioButtons(width = "30%",
                                                 inputId = "edgeShowType",
                                                 label = "Edge Select",
                                                 choices = edgeShowTypeList)
                                )
                            )
                            
                        )
                    ),
                    
                    fluidRow(
                        
                        tabBox(
                            
                            title = "Data",
                            id = "tabset2", width = "1000px",
                            
                            tabPanel("Nodes Data",
                                DT::dataTableOutput('Nodes')             
                            ),
                            
                            tabPanel("Edges Data ",
                                DT::dataTableOutput('Edge')
                            )
                        )
                    )
                )
            )
        )
    )
)

