
library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(pracma)
library(seewave)
library(changepoint)

makeEdageFilter <- function(champIndex){
  
    selectData <- NODES_DATA %>% 
        filter( id  %in% champIndex ) %>% 
        select(id, group)
    
      
    # "T" "J" "S"
    presenceLineList <- unique(strsplit(paste0(selectData$group, collapse=""), split="")[[1]])
    
    
    lineList <- list()
    
    for ( line in presenceLineList ){
      
        temp <- c()
        
        for( n in 1:nrow(selectData)){
            
            if (str_detect(selectData[[2]][n], line)) {
                temp <- c(temp, selectData[[1]][n])
            }
        }
        lineList[[line]] <- temp
    }
    
    
    
    resultEdgeFilter <- c()
    
    for ( line in presenceLineList ){
      
        for ( n in 1:length(lineList[[line]])){
          
            if ( n == length(lineList[[line]])) { break }
            
            for ( m in n+1:length(lineList[[line]])){
                resultEdgeFilter <- c(
                  resultEdgeFilter,
                  paste0("(from==",lineList[[line]][n],"&to==",lineList[[line]][m],")"),
                  paste0("(from==",lineList[[line]][m],"&to==",lineList[[line]][n],")")
                )
                if ( m == length(lineList[[line]])) { break }
            }
        }
    }
  
    return(paste0(resultEdgeFilter,  collapse ='|'))
}



server <- function(input, output, session) {

    output$txt <- renderText({
      
      icons <- paste(c( input$selectTopChamp,
                        input$selectMidChamp,
                        input$selectJungleChamp,
                        input$selectBotChamp,
                        input$selectSupportChamp), 
                        collapse = ", ")
      
      paste("You chose champ number : ", icons)
        
    })
  
  
    observe({
      
        updateCheckboxGroupInput(
          session, 'selectTopChamp',
          choices = TopLineChamp,
          selected = if(input$TopSelectAll) {TopLineChamp}
        )
        # select all
    
        updateCheckboxGroupInput(
          session, 'selectMidChamp',
          choices = MinLineChamp,
          selected = if(input$MidSelectAll) {MinLineChamp}
        )
        
        updateCheckboxGroupInput(
          session, 'selectJungleChamp',
          choices = JungleLineChamp,
          selected = if(input$JungleSelectAll) {JungleLineChamp}
        )
        
        updateCheckboxGroupInput(
          session, 'selectBotChamp',
          choices = BotLineChamp,
          selected = if(input$BotSelectAll) {BotLineChamp}
        )
        
        updateCheckboxGroupInput(
          session, 'selectSupportChamp',
          choices = SupportLineChamp,
          selected = if(input$SupportSelectAll) {SupportLineChamp}
        )
  
    })
  
  
  output$networkPlot <- renderVisNetwork({
    
    selectChamp <- c(
      input$selectTopChamp,
      input$selectMidChamp,
      input$selectJungleChamp,
      input$selectBotChamp,
      input$selectSupportChamp
    )
    
    if (makeEdageFilter(selectChamp) != "") {
      
      chamNum <-unique(c(
        input$selectTopChamp,
        input$selectMidChamp,
        input$selectJungleChamp,
        input$selectBotChamp,
        input$selectSupportChamp
      ))
      
      if (input$edgeShowType == 0) {
        
            visNetwork(
              
              NODES_DATA %>% filter(
                id %in% c( input$selectTopChamp,
                           input$selectMidChamp,
                           input$selectJungleChamp,
                           input$selectBotChamp,
                           input$selectSupportChamp )
              ),
              
              EDGE_DATA %>% 
                filter( 
                  eval(parse(text=makeEdageFilter(selectChamp)))
                )
            
          ) %>% 
            visOptions(highlightNearest = list(enabled = T, degree = 0, hover = T))
          
        } else if (input$edgeShowType == 1) {
          
            visNetwork(
              
              NODES_DATA %>% filter(
                id %in% c( input$selectTopChamp,
                           input$selectMidChamp,
                           input$selectJungleChamp,
                           input$selectBotChamp,
                           input$selectSupportChamp )
              ),
              
              EDGE_DATA %>% 
                filter( 
                  eval(parse(text=makeEdageFilter(selectChamp))),
                  win > 50
                )
            
          ) %>% 
            visOptions(highlightNearest = list(enabled = T, degree = 0, hover = T))
          
        } else if (input$edgeShowType == 2) {
          
          visNetwork(
            
            NODES_DATA %>% filter(
              id %in% c( input$selectTopChamp,
                         input$selectMidChamp,
                         input$selectJungleChamp,
                         input$selectBotChamp,
                         input$selectSupportChamp )
            ),
            
            EDGE_DATA %>% 
              filter( 
                eval(parse(text=makeEdageFilter(selectChamp))),
                win < 50
              )
            
          ) %>% 
            visOptions(highlightNearest = list(enabled = T, degree = 0, hover = T))
        } else if (input$edgeShowType == 3) {
          visNetwork(
            
            NODES_DATA %>% filter(
              id %in% c( input$selectTopChamp,
                         input$selectMidChamp,
                         input$selectJungleChamp,
                         input$selectBotChamp,
                         input$selectSupportChamp )
            ),
            
            EDGE_DATA %>% 
              filter( 
                eval(parse(text=makeEdageFilter(selectChamp))),
                win == 50
              )
            
          ) %>% 
            visOptions(highlightNearest = list(enabled = T, degree = 0, hover = T))
        }
      
    } else {
      
      visNetwork(

        NODES_DATA %>% filter(
          id %in% c( input$selectTopChamp,
                     input$selectMidChamp,
                     input$selectJungleChamp,
                     input$selectBotChamp,
                     input$selectSupportChamp )
        ),

        EDGE_DATA %>% filter(
          win < 50
        )

      ) %>%
        visEdges(label = NULL) %>%
        visOptions(highlightNearest = list(enabled = T, degree = 0, hover = T))
      
    }
    
  })
    
  output$Nodes = DT::renderDataTable( {
    
      selectChamp <- c( input$selectTopChamp,
                        input$selectMidChamp,
                        input$selectJungleChamp,
                        input$selectBotChamp,
                        input$selectSupportChamp )
      
      if ( length(selectChamp ) > 0) {
          NODES_DATA %>% 
              filter( id %in% selectChamp )
      } else {
          NODES_DATA
      }
    
  },
  options = list(scrollX = TRUE))
  
  
  output$Edge = DT::renderDataTable({
    
      selectChamp <- c(
        input$selectTopChamp,
        input$selectMidChamp,
        input$selectJungleChamp,
        input$selectBotChamp,
        input$selectSupportChamp
      )
  
      if (makeEdageFilter(selectChamp) != "") {
        
          chamNum <-unique(c(
            input$selectTopChamp,
            input$selectMidChamp,
            input$selectJungleChamp,
            input$selectBotChamp,
            input$selectSupportChamp
          ))
          
          EDGE_DATA %>% 
            filter( eval(parse(text=makeEdageFilter(selectChamp))) )
      } else {
        EDGE_DATA
      }
  },
  options = list(scrollX = TRUE))
  
}







