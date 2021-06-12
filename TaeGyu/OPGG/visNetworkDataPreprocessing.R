# ------------------------------------------------------------ #
# 순천향 대학교 소셜네트워크
# 빅데이터 공학과 20171483 한태규
# ------------------------------------------------------------ #


# ------------------------------------------------------------ #
# import library
# install.packages("network")
# install.packages("sna")
# install.packages("ndtv")
# install.packages("tidyverse")
# install.packages("igraph")
# install.packages("network")
# install.packages("visNetwork")
# install.packages("networkD3")
# install.packages("RColorBrewer")
# install.packages("geomnet")

library(shiny)
library(shinydashboard)

library(network)
library(sna)
library(ndtv)
library(tidyverse)
library(igraph)
library(network)
library(visNetwork)
library(networkD3)
library(RColorBrewer)
library(geomnet)
# ------------------------------------------------------------ #

# ------------------------------------------------------------ #
# read data
setwd("C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu/OPGG")

edges <- read_csv("./csv/igraph_data/edges.csv")[,2:7]
nodes <- read_csv("./csv/igraph_data/nodes.csv")[,2:4]

orginEdges <- read_csv("./csv/data/counter.csv")
orginNodes <- read_csv("./csv/data/ChampionTierList(Total).csv")
# ------------------------------------------------------------ #


# 노드 모양 만들기
makeNodeShape <- function()
{
    
    # 티어 번호 찾기
    # 겹치는 라인 존재시
    # 가장 낮은 티어 반환
    shape <- c()
    
    for (i in seq(length(orginNodes$English_Champ))) {
      
        shape <- c(shape, 
                   max(orginNodes[i,3],
                       orginNodes[i,4],
                       orginNodes[i,5],
                       orginNodes[i,6],
                       orginNodes[i,7]))
    }
    
    
    # 노드 모양 반환
    nodeShape <- c()
    
    for (i in shape) {
      
        if ( i == 1 ) {
            nodeShape <- c(nodeShape, "star")
        } else if (  i == 2 ) {
            nodeShape <- c(nodeShape, "diamond")
        } else if (  i == 3 ) {
            nodeShape <- c(nodeShape, "circle")
        } else if (  i == 4 ) {
            nodeShape <- c(nodeShape, "triangle")
        } else if (  i == 5 ) {
            nodeShape <- c(nodeShape, "square")
        }
      
    }
    
    return(nodeShape)
}



# 노드 티어 만들기
makeNodeShapeNum <- function()
{
  
    shape <- c()
    
    for (i in seq(length(orginNodes$English_Champ))) {
      
      shape <- c(shape, 
                 max(orginNodes[i,3],
                     orginNodes[i,4],
                     orginNodes[i,5],
                     orginNodes[i,6],
                     orginNodes[i,7]))
    }

  return(shape)
}


# 모양 티어 반환
nodeShape <- makeNodeShape()
shape <- makeNodeShapeNum()


## 색 지정하기
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
colors <- sample(col_vector, 18)


# 호출 편하게 칼럼 이름 변경
colnames(nodes) <- c("champion", "line", "count")


# 레전드 만들기

NODES_LEGEND <- data.frame(
  color = colors[as.numeric(as.factor(unique(nodes$line)))],
  label = unique(nodes$line)
)


# node 데이터 만들기
NODES_DATA <- data.frame(
      id = as.numeric(factor(nodes$champion)), # 챔피언 id 번호
      shape = nodeShape, # 노드 모양
      size  = nodes$count, # 노드 크기
      title = paste0("<p>Line : <b>", nodes$line,"</b><br>Match Cnt : <b>",nodes$count,"</b><br>Tier : <b>",shape,"</b></p>"), # 노드 타이틀
      value = nodes$count*100, # 노드 크기
      label = nodes$champion, # 노드 라벨
      group = nodes$line, # 노드 그룹
      color = colors[as.numeric(as.factor(nodes$line))], # 노드 색
      shadow = FALSE # 노드 그림자
)



orginEdges

# orginEdges데이터 프레임에 from to 제작
champNumeric1 <- data.frame(
  from = as.numeric(factor(nodes$champion)),
  champion1  = nodes$champion
)

champNumeric2 <- data.frame(
  to = as.numeric(factor(nodes$champion)),
  champion2  = nodes$champion
)

orginEdges <- left_join(orginEdges,champNumeric1,by='champion1')
orginEdges <- left_join(orginEdges,champNumeric2,by='champion2')



# 승패에 따라 색 변경
edgeColor <- c()    

for ( i in orginEdges$winning_rage ){
  
    if ( i > 50 ) {
        edgeColor <- c(edgeColor, "#8CB4F7")
    } else if ( i < 50 ){
        edgeColor <- c(edgeColor, "#F6807F")
    } else {
        edgeColor <- c(edgeColor, "#C4F2C2")
    }
}


#  화살표 열 만들기
edgeArrows <- c()    

for ( i in orginEdges$winning_rage ){
  
  if ( i > 50 ) {
    edgeArrows <- c(edgeArrows, "from")
  } else if ( i < 50 ){
    edgeArrows <- c(edgeArrows, "to")
  } else {
    edgeArrows <- c(edgeArrows, "middle")
  }
}



EDGE_DATA <- data.frame(
    from = orginEdges$from, # 선 출발
    to = orginEdges$to, # 선 끝
    title = paste0(
                "<p>",
                " Match Cnt : <b>",orginEdges$match_count,"</b>",
                "<br>",
                " Winning rate : <b>",orginEdges$winning_rage,"</b>",
                "</p>"
                
            ), # 선 타이틀
    length = 1000,
    win = paste(orginEdges$winning_rage), # 선 라벨
    color = edgeColor, # 선 색
    arrows = c("to"), # 선 화살표 방향
    dashes = FALSE, # 선 점선으로 만들기
    value = orginEdges$match_count, # 선 두께
    # width = orginEdges$match_count,  # 선 두께
    smooth = c(FALSE)
)


# select filter 만들기
# data frame에 필요

makeEdageFilter <- function(champIndex){
  
  
    selectData <- NODES_DATA %>% 
                      filter( id  %in% indexNUm ) %>% 
                      select(id, group)
    
    # 존재하는 라인 찾기
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




EDGE_DATA %>% 
  filter( 
    eval(parse(text=makeEdageFilter(selectChamp))),
    win == 50
  )


# write_csv(EDGE_DATA, "EDGE_DATA.csv")
# write_csv(NODES_DATA, "NODES_DATA.csv")

# indexNum <- c(106, 104, 107, 108, 89, 139)
# show <- makeEdageFilter(indexNum)









