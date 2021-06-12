setwd("C:\\Users\\LeeGeon.DESKTOP-C5M3NRB.000\\Documents\\GitHub\\social_network_project\\LeeGeon\\OP_GG_Data")
library(igraph)
library(stringr)
library(RColorBrewer)
library(tidyverse)

ChampionWinRate <- read.csv('ChampionWinRate(Total).csv')  # %>% filter(VsWinRate>=0.5)
colnames(ChampionWinRate) <- c("Line","Source","Target","weight","VsTotalPlayed")
ChampionWinRate %>% nrow()

TotalPlayed <- ChampionWinRate %>% group_by(Line,Source) %>% summarize(TotalPlayed=sum(VsTotalPlayed))


top_ChampionWinRate <- filter(ChampionWinRate,Line=='top') %>% .[,-c(1,5)] %>% graph.data.frame()
mid_ChampionWinRate <- filter(ChampionWinRate,Line=='mid') %>% .[,-c(1,5)] %>% graph.data.frame()
bot_ChampionWinRate <- filter(ChampionWinRate,Line=='bot') %>% .[,-c(1,5)] %>% graph.data.frame()
sup_ChampionWinRate <- filter(ChampionWinRate,Line=='support') %>% .[,-c(1,5)] %>% graph.data.frame()
jun_ChampionWinRate <- filter(ChampionWinRate,Line=='jungle') %>% .[,-c(1,5)] %>% graph.data.frame()

top_ChampionWinRate %>%  plot.igraph(layout=layout.auto,
                         vertex.size=4, edge.arrow=NA,
                         edge.width=1, edge.curved=T, # 연결 선을 곡선으로
                         vertex.label.dist=2,
                         edge.arrow.size=0.2)

#### graph(Line, 승률)을 받는 함수를 하나 만들자

#### 1. 티어 1,2,3,4,5로 하고 막대그래프 (엣지개수 평균) ####
#### 2. 승률 hist --> 50~100이 이기는놈, 0~50 지는놈 --> 50에 많이 분포 --> 양 끝으로 갈수록 적어짐 --> 이걸 시각화로 보여주기 ####
#### 3. 멀티 포지션(3라인 가는 친구들)의 라인별 승률 비교 ####

ChampionTier <- read.csv("ChampionTierList(Total).csv")
ChampionPosition <- data.frame(ChampionTier[,3:7]==0)

Champion_multi_tier <- ChampionTier[which(ChampionPosition %>% apply(1,sum)-4 != 0),]
Champion_multi_tier$search


ChampionWinRate[which(ChampionWinRate$Source %in% Champion_multi_tier$search),]

# 3라인 멀티 포지션
All_Multi <- ChampionTier[which(ChampionPosition %>% apply(1,sum) == 2),]
# 그웬, 녹턴, 럼블, 비에고, 오공(Top, Jungle, Mid)(6,11,22,54,90)
Top_Jun_Mid <- ChampionTier[c(6,11,22,54,90),]
# 루시안, 야스오(Top,Mid,Bottom)(28,87)
Top_Mid_Bot <- ChampionTier[c(28,87),]
# 세트, 판테온(Top, Mid, Support)(64,148)
Top_Mid_Sup <- ChampionTier[c(64,148),]
# 뽀삐, 자크(Top, Jungle, Support)(56,107)
Top_Jun_Sup <- ChampionTier[c(56,107),]

# 노드(챔피언)
# 엣지(승률), 두께(경기 횟수)
# 포지션벌 색깔

# 시각화

# Top, Jungle, Mid
ChampionWinRate <- read.csv('ChampionWinRate(Total).csv') %>% filter(VsWinRate>=0.5)
colnames(ChampionWinRate) <- c("Line","Source","Target","weight","VsTotalPlayed")

Top_Jun_Mid_WinRate <- ChampionWinRate[which(ChampionWinRate$Source %in% Top_Jun_Mid$search & ChampionWinRate$Target %in% Top_Jun_Mid$search),]

Top_Jun_Mid_WinRate$Source <- paste0(Top_Jun_Mid_WinRate$Line,"_",Top_Jun_Mid_WinRate$Source)
Top_Jun_Mid_WinRate$Target <- paste0(Top_Jun_Mid_WinRate$Line,"_",Top_Jun_Mid_WinRate$Target)

g2 <- Top_Jun_Mid_WinRate[,-c(1,5)] %>% graph.data.frame()

color <- ifelse(str_detect(V(g2)$name,"top"),"red",ifelse(str_detect(V(g2)$name,"jungle"),"blue","yellow"))
color

E(g2)
rank(Top_Jun_Mid_WinRate$VsTotalPlayed)/10

g2 %>%  plot.igraph(layout=layout.fruchterman.reingold,
                    vertex.size=10, edge.arrow=NA,
                    edge.width=rank(Top_Jun_Mid_WinRate$VsTotalPlayed)/5,
                    edge.color="grey",
                    vertex.label.dist=2,
                    edge.arrow.size=0.5,
                    vertex.color=color)

# Top,Mid,Bottom
ChampionWinRate <- read.csv('ChampionWinRate(Total).csv') %>% filter(VsWinRate>=0.5)
colnames(ChampionWinRate) <- c("Line","Source","Target","weight","VsTotalPlayed")

Top_Mid_Bot_WinRate <- ChampionWinRate[which(ChampionWinRate$Source %in% Top_Mid_Bot$search & ChampionWinRate$Target %in% Top_Mid_Bot$search),]

Top_Mid_Bot_WinRate$Source <- paste0(Top_Mid_Bot_WinRate$Line,"_",Top_Mid_Bot_WinRate$Source)
Top_Mid_Bot_WinRate$Target <- paste0(Top_Mid_Bot_WinRate$Line,"_",Top_Mid_Bot_WinRate$Target)

g2 <- Top_Mid_Bot_WinRate[,-c(1,5)] %>% graph.data.frame()

color <- ifelse(str_detect(V(g2)$name,"top"),"red",ifelse(str_detect(V(g2)$name,"bot"),"blue","yellow"))
color

E(g2)
rank(Top_Mid_Bot_WinRate$VsTotalPlayed)/10

g2 %>%  plot.igraph(layout=layout.fruchterman.reingold,
                    vertex.size=10, edge.arrow=NA,
                    edge.width=rank(Top_Mid_Bot_WinRate$VsTotalPlayed)/5,
                    edge.color="grey",
                    vertex.label.dist=2,
                    edge.arrow.size=0.5,
                    vertex.color=color)

# Top, Mid, Support
ChampionWinRate <- read.csv('ChampionWinRate(Total).csv') %>% filter(VsWinRate>=0.5)
colnames(ChampionWinRate) <- c("Line","Source","Target","weight","VsTotalPlayed")

Top_Mid_Sup_WinRate <- ChampionWinRate[which(ChampionWinRate$Source %in% Top_Mid_Sup$search & ChampionWinRate$Target %in% Top_Mid_Sup$search),]

Top_Mid_Sup_WinRate$Source <- paste0(Top_Mid_Sup_WinRate$Line,"_",Top_Mid_Sup_WinRate$Source)
Top_Mid_Sup_WinRate$Target <- paste0(Top_Mid_Sup_WinRate$Line,"_",Top_Mid_Sup_WinRate$Target)

g2 <- Top_Mid_Sup_WinRate[,-c(1,5)] %>% graph.data.frame()

color <- ifelse(str_detect(V(g2)$name,"top"),"red",ifelse(str_detect(V(g2)$name,"sup"),"blue","yellow"))
color

E(g2)
rank(Top_Mid_Sup_WinRate$VsTotalPlayed)/10

g2 %>%  plot.igraph(layout=layout.fruchterman.reingold,
                    vertex.size=10, edge.arrow=NA,
                    edge.width=rank(Top_Mid_Sup_WinRate$VsTotalPlayed)/5,
                    edge.color="grey",
                    vertex.label.dist=2,
                    edge.arrow.size=0.5,
                    vertex.color=color)

# Top, Jungle, Support
ChampionWinRate <- read.csv('ChampionWinRate(Total).csv') %>% filter(VsWinRate>=0.5)
colnames(ChampionWinRate) <- c("Line","Source","Target","weight","VsTotalPlayed")

Top_Jun_Sup_WinRate <- ChampionWinRate[which(ChampionWinRate$Source %in% Top_Jun_Sup$search & ChampionWinRate$Target %in% Top_Jun_Sup$search),]

Top_Jun_Sup_WinRate$Source <- paste0(Top_Jun_Sup_WinRate$Line,"_",Top_Jun_Sup_WinRate$Source)
Top_Jun_Sup_WinRate$Target <- paste0(Top_Jun_Sup_WinRate$Line,"_",Top_Jun_Sup_WinRate$Target)

g2 <- Top_Jun_Sup_WinRate[,-c(1,5)] %>% graph.data.frame()

color <- ifelse(str_detect(V(g2)$name,"top"),"red",ifelse(str_detect(V(g2)$name,"sup"),"blue","yellow"))
color

E(g2)
rank(Top_Jun_Sup_WinRate$VsTotalPlayed)/10

g2 %>%  plot.igraph(layout=layout.fruchterman.reingold,
                    vertex.size=10, edge.arrow=NA,
                    edge.width=rank(Top_Jun_Sup_WinRate$VsTotalPlayed)/5,
                    edge.color="grey",
                    vertex.label.dist=2,
                    edge.arrow.size=0.5,
                    vertex.color=color)


# all
ChampionWinRate <- read.csv('ChampionWinRate(Total).csv') %>% filter(VsWinRate>=0.5)
colnames(ChampionWinRate) <- c("Line","Source","Target","weight","VsTotalPlayed")

All_Multi_WinRate <- ChampionWinRate[which(ChampionWinRate$Source %in% All_Multi$search & ChampionWinRate$Target %in% All_Multi$search),]

All_Multi_WinRate$Source <- paste0(All_Multi_WinRate$Line,"_",All_Multi_WinRate$Source)
All_Multi_WinRate$Target <- paste0(All_Multi_WinRate$Line,"_",All_Multi_WinRate$Target)

g2 <- All_Multi_WinRate[,-c(1,5)] %>% graph.data.frame()

color <- ifelse(str_detect(V(g2)$name,"top"),"red",
                ifelse(str_detect(V(g2)$name,"jungle"),"blue",
                       ifelse(str_detect(V(g2)$name,"mid"),"yellow",
                              ifelse(str_detect(V(g2)$name,"support"),"orange","green"))))
color

E(g2)
rank(All_Multi_WinRate$VsTotalPlayed)/10

g2 %>%  plot.igraph(layout=layout.kamada.kawai,
                    vertex.size=5, edge.arrow=NA,
                    edge.width=rank(All_Multi_WinRate$VsTotalPlayed)/20,
                    edge.color="grey",
                    vertex.label.dist=2,
                    edge.arrow.size=0.5,
                    vertex.color=color)
