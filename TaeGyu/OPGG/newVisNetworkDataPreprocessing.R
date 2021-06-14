
# install.packages("DIZutils")
library(DIZutils)


# 경로 설정
setwd("C:/Users/gksxo/Desktop/Project/github/social_network_project/LeeGeon/OP_GG_Data")


# data
tierData <- read_csv("ChampionTierList(Total).csv")


windRateData <- read_csv("ChampionWinRate(Total).csv")






# 전처리
textTier <- tierData %>% 
  mutate(Top = replace(Top, Top != 0, "T"),
         Jungle = replace(Jungle, Jungle != 0, "J"),
         Middle  = replace(Middle , Middle  != 0, "M"),
         Bottom = replace(Bottom, Bottom != 0, "A"),
         Support = replace(Support, Support != 0, "S"))


textTier <- textTier %>% 
  mutate(Top = replace(Top, Top == 0, ""),
         Jungle = replace(Jungle, Jungle == 0, ""),
         Middle  = replace(Middle , Middle  == 0, ""),
         Bottom = replace(Bottom, Bottom == 0, ""),
         Support = replace(Support, Support == 0, ""))



champLine <- c()

for ( i in seq(nrow(textTier)) ){
  
  champLine  <- c(champLine , 
                  paste0( textTier[i,3],
                          textTier[i,4],
                          textTier[i,5],
                          textTier[i,6],
                          textTier[i,7] ))
  print(
    paste0( textTier[i,3],
            textTier[i,4],
            textTier[i,5],
            textTier[i,6],
            textTier[i,7] ))
}



match_count <- windRateData %>% 
  group_by(Champion ) %>% 
  summarise(count = sum(VsTotalPlayed))

match_count$id <- as.numeric(as.factor(match_count$Champion))

#  게임 합
sumCount <- data.frame(
  id  = as.numeric(as.factor(tierData$English_Champ))
) %>% left_join(match_count, by = "id")


# ---------------------------------------------------------------------------- #
# 완성 데이터

 


tierData[1,4]


# 노드 모양 만들기
makeNodeShape <- function()
{
  
  # 티어 번호 찾기
  # 겹치는 라인 존재시
  # 가장 낮은 티어 반환
  shape <- c()
  
  for (i in 1:nrow(tierData)) {
    
    for ( j in seq(1:5)){
      if(j %in% tierData[i,3:7]){
        print(j)
        shape <- c(shape, j)
        break
      }
    }
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


nodeShape <- makeNodeShape()


# 색 지정
## 색 지정하기
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
colors <- sample(col_vector, 18)

shape

# node 데이터 만들기
NODES_DATA <- data.frame(
  id = as.numeric(as.factor(tierData$search)),# 챔피언 id 번호
  shape =  nodeShape, # 노드 모양
  # size  =  sumCount$count, # 노드 크기
  title =  paste0("<p>Line : <b>", champLine,"</b><br>Match Cnt : <b>", sumCount$count,"</b><br>Tier : <b>", shape,"</b></p>"), # 노드 타이틀
  value =  sumCount$count, # 노드 크기
  label = tierData$search, # 노드 라벨
  group = champLine, # 노드 그룹
  color =  colors[as.numeric(as.factor(champLine))],# 노드 색
  shadow = FALSE # 노드 그림자
)




# ---------------------------------------------------------------------------- #







windRateData$VsWinRate*100

windRateData$Line



# 승패에 따라 색 변경
edgeColor <- c()    

for ( i in windRateData$VsWinRate*100 ){
  
  if ( i > 50 ) {
    edgeColor <- c(edgeColor, "#8CB4F7")
  } else if ( i < 50 ){
    edgeColor <- c(edgeColor, "#F6807F")
  } else {
    edgeColor <- c(edgeColor, "#C4F2C2")
  }
}



EDGE_DATA <- data.frame(
  from = as.numeric(as.factor(windRateData$Champion)), # 선 출발
  to = as.numeric(as.factor(windRateData$VsChampion)), # 선 끝
  title = paste0(
    "<p>",
    " Match Cnt : <b>",windRateData$VsTotalPlayed,"</b>",
    "<br>",
    " Winning rate : <b>",windRateData$VsWinRate*100,"%</b>",
    "<br>",
    " Line : <b>",windRateData$Line,"</b>",
    "</p>"
    
  ), # 선 타이틀
  length = 1000,
  win = paste(windRateData$VsWinRate*100), # 선 라벨
  color = edgeColor, # 선 색
  arrows = c("to"), # 선 화살표 방향
  dashes = FALSE, # 선 점선으로 만들기
  value = windRateData$VsTotalPlayed, # 선 두께
  # width = orginEdges$match_count,  # 선 두께
  smooth = FALSE,
  physics = FALSE,
  line = windRateData$Line
)


EDGE_DATA %>% filter(
  from == 64, to == 101
)

makeSelectList <- function(line)
{
  
  dataFrame1 <- NODES_DATA %>%
    filter(str_detect(group, line)) %>%
    select(id)
  
  dataFrame2 <- NODES_DATA %>%
    filter(str_detect(group,  line)) %>%
    select(label)
  
  resultList <- c(dataFrame1$id)
  names(resultList) <- dataFrame2$label
  
  return(resultList)
}

# make select filter list
TopLineChamp <- makeSelectList("T")
MinLineChamp <- makeSelectList("M")
JungleLineChamp <- makeSelectList("J")
BotLineChamp <- makeSelectList("A")
SupportLineChamp <- makeSelectList("S")



getwd()

save(EDGE_DATA, file = "EDGE_DATA.Rdata")
save(NODES_DATA, file = "NODES_DATA.Rdata")
save(TopLineChamp, file = "TopLineChamp.Rdata")
save(MinLineChamp, file = "MinLineChamp.Rdata")
save(JungleLineChamp, file = "JungleLineChamp.Rdata")
save(BotLineChamp, file = "BotLineChamp.Rdata")
save(SupportLineChamp, file = "SupportLineChamp.Rdata")


visNetwork(
  
  NODES_DATA,
  
  EDGE_DATA
  
) %>% 
  visIgraphLayout() %>%
  visOptions(highlightNearest = list(enabled = T, degree = 0, hover = T))




EDGE_DATA %>% filter(from %in% c(64, 101), to %in% c(64, 101))
  





getwd()




