####----------------------디렉토리 설정 + 패키지 불러오기----------------------####

setwd('C:\\Users\\LeeGeon.DESKTOP-C5M3NRB.000\\Documents\\GitHub\\social_network_project\\LeeGeon\\OP_GG_Data')

library(httr)
library(rvest)
library(urltools)
library(readr)
library(tidyverse)

#---------------------------------------------------------------------------------#

####----------------------승률 구하기(52개 챔피언)----------------------####

Champion_total <- read.csv("Champion_name.csv") # 앞서 저장한 OPGG_Champion_name.csv 파일 불러오기

My_Champion <- Champion_total[53:104,] # 내 담당부분(블리츠-일라오이)만 꺼낸다
My_Champion <- My_Champion[-which(My_Champion$Korean_Champ=="스카너"),]

# 각 라인을 검색 시
# top
# jungle
# mid
# bot
# support 로 검색해야한다

url <- character()

for(x in 1:nrow(My_Champion)){ # 라인에 값이 있으면(그 라인 데이터가 존재함) position 데이터프레임에 추가
  position=data.frame()
  if(My_Champion[x,3]==1){
    position=rbind(position,data.frame(Line="top"))
  }
  if(My_Champion[x,4]==1){
    position=rbind(position,data.frame(Line="jungle"))
  }
  if(My_Champion[x,5]==1){
    position=rbind(position,data.frame(Line="mid"))
  }
  if(My_Champion[x,6]==1){
    position=rbind(position,data.frame(Line="bot"))
  }
  if(My_Champion[x,7]==1){
    position=rbind(position,data.frame(Line="support"))
  }
  url <- rbind(url,data.frame(url=paste0("https://www.op.gg/champion/",My_Champion$search[x],"/statistics/",position$Line,"/matchup")))
  # position을 이용해 https://www.op.gg/champion/챔피언/statistics/position/matchup을 완성시킨다(사용할 Url)
}

ChampionWinRate <- data.frame() # 승률을 구하기 위한 데이터 프레임

for(x in 1:nrow(url)){
  res <- GET(url=url[x,])
  
  VsChampion <- res %>% read_html() %>%
    html_nodes(css='div.champion-matchup-champion-list>div') %>% 
    html_attr(c('data-champion-name'))
  
  VsWinRate <- res %>% read_html() %>%
    html_nodes(css='div.champion-matchup-champion-list>div') %>% 
    html_attr(c('data-value-winrate'))
  
  VsTotalPlayed<- res %>% read_html() %>%
    html_nodes(css='div.champion-matchup-champion-list>div') %>% 
    html_attr(c('data-value-totalplayed')) %>% as.integer()
  
  ChampionWinRate <- rbind(ChampionWinRate,data.frame(Line=str_sub(url[x,],start=url[x,] %>% str_locate_all('/statistics/') %>% unlist() %>% .[[2]]+1,
                                                                   end=url[x,] %>% str_locate_all('/matchup') %>% unlist() %>%.[[1]]-1),
                                                      Champion=str_sub(url[x,],start=url[x,] %>% str_locate_all('/champion/') %>% unlist() %>% .[[2]]+1,
                                                                       end=url[x,] %>% str_locate_all('/statistics/') %>% unlist() %>%.[[1]]-1),
                                                      VsChampion=VsChampion,
                                                      VsWinRate=VsWinRate,
                                                      VsTotalPlayed=VsTotalPlayed))
}

write.csv(ChampionWinRate,"ChampionWinRate(Blitz-Illa).csv",row.names=FALSE)

#--------------------------------------------------------------------------#

####----------------------티어 구하기(52개 챔피언)----------------------####

ChampionTirelist <- data.frame() # 각 챔피언-라인별 티어를 구하기 위한 데이터프레임

for(x in 1:nrow(url)){
  res <- GET(url=url[x,])
  
  Tier <- res %>% read_html() %>%
    html_nodes(css='div.champion-stats-header-info__tier > b') %>% html_text() %>% str_sub(start=-1) %>% as.integer()
  
  VsWinRate <- res %>% read_html() %>%
    html_nodes(css='div.champion-matchup-champion-list>div') %>% 
    html_attr(c('data-value-winrate'))
  
  ChampionTirelist <- rbind(ChampionTirelist,data.frame(Line=str_sub(url[x,],start=url[x,] %>% str_locate_all('/statistics/') %>% unlist() %>% .[[2]]+1,
                                                                   end=url[x,] %>% str_locate_all('/matchup') %>% unlist() %>%.[[1]]-1),
                                                      Champion=str_sub(url[x,],start=url[x,] %>% str_locate_all('/champion/') %>% unlist() %>% .[[2]]+1,
                                                                       end=url[x,] %>% str_locate_all('/statistics/') %>% unlist() %>%.[[1]]-1),
                                                      Tier=Tier))
}

ChampionTirelist$Line <- as.character(factor(ChampionTirelist$Line,
                                   levels=c("top","jungle","mid","bot","support"),
                                   labels=c("Top","Jungle","Middle","Bottom","Support")))

for(x in 1:nrow(ChampionTirelist)){
  My_Champion[which(str_detect(My_Champion$search,ChampionTirelist$Champion[x])),
              which(str_detect(colnames(My_Champion),ChampionTirelist$Line[x]))] <- ChampionTirelist$Tier[x]
  
}

write.csv(My_Champion,"ChampionTierList(Blitz-Illa).csv",row.names=FALSE)

#--------------------------------------------------------------------------#