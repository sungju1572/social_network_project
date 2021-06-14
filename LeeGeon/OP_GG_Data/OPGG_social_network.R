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

# graph(Line, 승률)을 받는 함수를 하나 만들자

#### 1. 티어 1,2,3,4,5로 하고 막대그래프 (엣지개수 평균) ####

ChampionWinRate <- read.csv('ChampionWinRate(Total).csv') %>% filter(VsWinRate>=0.5)
colnames(ChampionWinRate) <- c("Line","Source","Target","weight","VsTotalPlayed")

ChampionTier <- read.csv("ChampionTierList(Total).csv") # 153개

Tier_1 <- ChampionTier[which(ChampionTier$Top==1 | 
                                 ChampionTier$Jungle==1 | 
                                 ChampionTier$Middle==1 | 
                                 ChampionTier$Bottom==1 | 
                                 ChampionTier$Support==1),]

ChampionTier <- ChampionTier[-which(ChampionTier$Top==1 |
                                      ChampionTier$Jungle==1 | 
                                      ChampionTier$Middle==1 | 
                                      ChampionTier$Bottom==1 | 
                                      ChampionTier$Support==1),]

Tier_2 <- ChampionTier[which(ChampionTier$Top==2 | 
                                 ChampionTier$Jungle==2 | 
                                 ChampionTier$Middle==2 | 
                                 ChampionTier$Bottom==2 | 
                                 ChampionTier$Support==2),]

ChampionTier <- ChampionTier[-which(ChampionTier$Top==2 | 
                               ChampionTier$Jungle==2 | 
                               ChampionTier$Middle==2 | 
                               ChampionTier$Bottom==2 | 
                               ChampionTier$Support==2),]

Tier_3 <- ChampionTier[which(ChampionTier$Top==3 | 
                                 ChampionTier$Jungle==3 | 
                                 ChampionTier$Middle==3 | 
                                 ChampionTier$Bottom==3 | 
                                 ChampionTier$Support==3),]

ChampionTier <- ChampionTier[-which(ChampionTier$Top==3 | 
                               ChampionTier$Jungle==3 | 
                               ChampionTier$Middle==3 | 
                               ChampionTier$Bottom==3 | 
                               ChampionTier$Support==3),]

Tier_4 <- ChampionTier[which(ChampionTier$Top==4 | 
                                 ChampionTier$Jungle==4 | 
                                 ChampionTier$Middle==4 | 
                                 ChampionTier$Bottom==4 | 
                                 ChampionTier$Support==4),]

ChampionTier <- ChampionTier[-which(ChampionTier$Top==4 | 
                               ChampionTier$Jungle==4 | 
                               ChampionTier$Middle==4 | 
                               ChampionTier$Bottom==4 | 
                               ChampionTier$Support==4),]

Tier_5 <- ChampionTier[which(ChampionTier$Top==5 | 
                                 ChampionTier$Jungle==5 | 
                                 ChampionTier$Middle==5 | 
                                 ChampionTier$Bottom==5 | 
                                 ChampionTier$Support==5),]

ChampionTier <- read.csv("ChampionTierList(Total).csv") # 다시 부르기

ChampionTier %>% nrow() # 153개

round(sum(ChampionWinRate$Source %in% Tier_1$search)/nrow(Tier_1)) # 36
round(sum(ChampionWinRate$Source %in% Tier_2$search)/nrow(Tier_2)) # 40
round(sum(ChampionWinRate$Source %in% Tier_3$search)/nrow(Tier_3)) # 33
round(sum(ChampionWinRate$Source %in% Tier_4$search)/nrow(Tier_4)) # 24
round(sum(ChampionWinRate$Source %in% Tier_5$search)/nrow(Tier_5)) # 21

Tier_count <- data.frame(Tier_count = c(round(sum(ChampionWinRate$Source %in% Tier_1$search)/nrow(Tier_1)),
                                        round(sum(ChampionWinRate$Source %in% Tier_2$search)/nrow(Tier_2)),
                                        round(sum(ChampionWinRate$Source %in% Tier_3$search)/nrow(Tier_3)),
                                        round(sum(ChampionWinRate$Source %in% Tier_4$search)/nrow(Tier_4)),
                                        round(sum(ChampionWinRate$Source %in% Tier_5$search)/nrow(Tier_5))),
                         Tier = c("Tier_1","Tier_2","Tier_3","Tier_4","Tier_5"))

# 이기는 캐릭터 개수
Tier_list <- data.frame(Tier_list=c(nrow(Tier_1),nrow(Tier_2),nrow(Tier_3),nrow(Tier_4),nrow(Tier_5)),
                        Tier = c("Tier_1","Tier_2","Tier_3","Tier_4","Tier_5"))

ggplot(Tier_list,aes(x=Tier,y=Tier_list))+geom_bar(stat="identity",alpha=0.7,fill="#3C3631",col="white",size=1.3)+
  theme(plot.background = element_rect(fill = "#061C25"),
        panel.background = element_rect(fill= "#061C25"),
        axis.text = element_text(colour = "#D9D9D9"),
        axis.title.x = element_blank(),
        axis.title.y= element_blank(),
        panel.grid.major.x=element_blank(),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.y=element_line(size=1.5),
        panel.grid.minor.y=element_line(size=1.5))

ggsave("mybar_count.png")

# 티어별 캐릭터 분포수
ggplot(Tier_count,aes(x=Tier,y=Tier_count))+geom_bar(stat="identity",alpha=0.7,fill="#E4DDAF",col="white",size=1.3)+
  theme(plot.background = element_rect(fill = "#061C25"),
        panel.background = element_rect(fill= "#061C25"),
        axis.text = element_text(colour = "#D9D9D9"),
        axis.title.x = element_blank(),
        axis.title.y= element_blank(),
        panel.grid.major.x=element_blank(),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.y=element_line(size=1.5),
        panel.grid.minor.y=element_line(size=1.5))

ggsave("mybar.png")

#### 2. 승률 hist --> 50~100이 이기는놈, 0~50 지는놈 --> 50에 많이 분포 --> 양 끝으로 갈수록 적어짐 --> 이걸 시각화로 보여주기 ####

ChampionWinRate <- read.csv('ChampionWinRate(Total).csv')  # %>% filter(VsWinRate>=0.5)
colnames(ChampionWinRate) <- c("Line","Source","Target","weight","VsTotalPlayed")

ChampionWinRate$group <- ifelse(ChampionWinRate$weight>0.5,"Winner",
                                ifelse(ChampionWinRate$weight<0.5,"Loser","Draw"))

ChampionDrawRate <- ChampionWinRate[ChampionWinRate$group=="Draw",]
ChampionWinRate <- ChampionWinRate[ChampionWinRate$group!="Draw",]

ChampionWinRate$weight <- ifelse(ChampionWinRate$weight>0.5,
                                 ceiling(ChampionWinRate$weight*100)/100,
                                 floor(ChampionWinRate$weight*100)/100)

# Loser 강조
ggplot(ChampionWinRate,aes(x=weight))+geom_histogram(aes(fill=group,alpha=group),binwidth = 0.01)+
  annotate("rect", xmin = 0.495, xmax = 0.505, ymin = 0, ymax= nrow(ChampionDrawRate), fill="#C4F2C2",alpha=0.3)+
  theme(plot.background = element_rect(fill = "#061C25"),
        panel.background = element_rect(fill= "#061C25"),
        axis.text = element_text(colour = "#D9D9D9"),
        axis.title.x = element_blank(),
        axis.title.y= element_blank(),
        panel.grid.major.x=element_blank(),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.y=element_line(size=1.5),
        panel.grid.minor.y=element_line(size=1.5),
        legend.background = element_rect(fill = "#061C25"),
        legend.key=element_rect("#061C25"),
        legend.text = element_text(colour="white"),
        legend.title = element_text(colour="white"))+
  scale_fill_manual(values=c("#F6807F","#8CB4F7"))+
  scale_alpha_manual(values=c(1,0.3))

ggsave("Loser_hist.png")

# Winner 강조
ggplot(ChampionWinRate,aes(x=weight))+geom_histogram(aes(fill=group,alpha=group),binwidth = 0.01)+
  annotate("rect", xmin = 0.495, xmax = 0.505, ymin = 0, ymax= nrow(ChampionDrawRate), fill="#C4F2C2",alpha=0.3)+
  theme(plot.background = element_rect(fill = "#061C25"),
        panel.background = element_rect(fill= "#061C25"),
        axis.text = element_text(colour = "#D9D9D9"),
        axis.title.x = element_blank(),
        axis.title.y= element_blank(),
        panel.grid.major.x=element_blank(),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.y=element_line(size=1.5),
        panel.grid.minor.y=element_line(size=1.5),
        legend.background = element_rect(fill = "#061C25"),
        legend.key=element_rect("#061C25"),
        legend.text = element_text(colour="white"),
        legend.title = element_text(colour="white"))+
  scale_fill_manual(values=c("#F6807F","#8CB4F7"))+
  scale_alpha_manual(values=c(0.3,1))

ggsave("Winner_hist.png")

# Draw 강조
ggplot(ChampionWinRate,aes(x=weight))+geom_histogram(aes(fill=group,alpha=group),binwidth = 0.01)+
  annotate("rect", xmin = 0.495, xmax = 0.505, ymin = 0, ymax= nrow(ChampionDrawRate), fill="#C4F2C2",alpha=1)+
  theme(plot.background = element_rect(fill = "#061C25"),
        panel.background = element_rect(fill= "#061C25"),
        axis.text = element_text(colour = "#D9D9D9"),
        axis.title.x = element_blank(),
        axis.title.y= element_blank(),
        panel.grid.major.x=element_blank(),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.y=element_line(size=1.5),
        panel.grid.minor.y=element_line(size=1.5),
        legend.background = element_rect(fill = "#061C25"),
        legend.key=element_rect("#061C25"),
        legend.text = element_text(colour="white"),
        legend.title = element_text(colour="white"))+
  scale_fill_manual(values=c("#F6807F","#8CB4F7"))+
  scale_alpha_manual(values=c(0.3,0.3))

ggsave("Draw_hist.png")

# 전체
ggplot(ChampionWinRate,aes(x=weight))+geom_histogram(aes(fill=group),binwidth = 0.01)+
  annotate("rect", xmin = 0.495, xmax = 0.505, ymin = 0, ymax= nrow(ChampionDrawRate), fill="#C4F2C2")+
  theme(plot.background = element_rect(fill = "#061C25"),
        panel.background = element_rect(fill= "#061C25"),
        axis.text = element_text(colour = "#D9D9D9"),
        axis.title.x = element_blank(),
        axis.title.y= element_blank(),
        panel.grid.major.x=element_blank(),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.y=element_line(size=1.5),
        panel.grid.minor.y=element_line(size=1.5),
        legend.background = element_rect(fill = "#061C25"),
        legend.key=element_rect("#061C25"),
        legend.text = element_text(colour="white"),
        legend.title = element_text(colour="white"))+
  scale_fill_manual(values=c("#F6807F","#8CB4F7"))

ggsave("Total_hist.png")

#### 3. 멀티 포지션(3라인 가는 친구들)의 라인별 승률 비교 ####

par(bg = "#061C25")

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

# all
ChampionWinRate <- read.csv('ChampionWinRate(Total).csv') %>% filter(VsWinRate>=0.5)
colnames(ChampionWinRate) <- c("Line","Source","Target","weight","VsTotalPlayed")

All_Multi_WinRate <- ChampionWinRate[which(ChampionWinRate$Source %in% All_Multi$search & ChampionWinRate$Target %in% All_Multi$search),]

All_Multi_WinRate$Source <- paste0(All_Multi_WinRate$Line,"_",All_Multi_WinRate$Source)
All_Multi_WinRate$Target <- paste0(All_Multi_WinRate$Line,"_",All_Multi_WinRate$Target)

g2 <- All_Multi_WinRate[,-c(1,5)] %>% graph.data.frame()

color <- ifelse(str_detect(V(g2)$name,"top"),"white",
                ifelse(str_detect(V(g2)$name,"jungle"),"red",
                       ifelse(str_detect(V(g2)$name,"mid"),"yellow",
                              ifelse(str_detect(V(g2)$name,"support"),"orange","green"))))

g2 %>%  plot.igraph(layout=layout.kamada.kawai,
                    vertex.size=7,
                    edge.width=(scale(All_Multi_WinRate$VsTotalPlayed,
                                     center=min(All_Multi_WinRate$VsTotalPlayed))+1)*1.5,
                    vertex.label.color="white",
                    edge.color="#8CB4F7",
                    vertex.label.dist=2,
                    edge.arrow.size=0.5,
                    vertex.label.font=15,
                    vertex.color=color,
                    vertex.frame.color=color)

# top
g2 <- All_Multi_WinRate[which(All_Multi_WinRate$Line=="top"),-c(1,5)] %>% graph.data.frame()

g2 %>%  plot.igraph(layout=layout.kamada.kawai,
                    vertex.size=15,
                    edge.width=scale(All_Multi_WinRate[which(All_Multi_WinRate$Line=="top"),]$VsTotalPlayed,
                                     center=min(All_Multi_WinRate[which(All_Multi_WinRate$Line=="top"),]$VsTotalPlayed))+0.5,
                    vertex.label.color="white",
                    edge.color="#8CB4F7",
                    vertex.label.dist=2,
                    edge.arrow.size=0.7,
                    vertex.label.font=15,
                    vertex.color="white")

# jungle
g2 <- All_Multi_WinRate[which(All_Multi_WinRate$Line=="jungle"),-c(1,5)] %>% graph.data.frame()

g2 %>%  plot.igraph(layout=layout.kamada.kawai,
                    vertex.size=15,
                    edge.width=scale(All_Multi_WinRate[which(All_Multi_WinRate$Line=="jungle"),]$VsTotalPlayed,
                                     center=min(All_Multi_WinRate[which(All_Multi_WinRate$Line=="jungle"),]$VsTotalPlayed))+0.5,
                    vertex.label.color="white",
                    edge.color="#8CB4F7",
                    vertex.label.dist=2,
                    edge.arrow.size=0.7,
                    vertex.label.font=15,
                    vertex.color="red")

# mid
g2 <- All_Multi_WinRate[which(All_Multi_WinRate$Line=="mid"),-c(1,5)] %>% graph.data.frame()

g2 %>%  plot.igraph(layout=layout.kamada.kawai,
                    vertex.size=15,
                    edge.width=scale(All_Multi_WinRate[which(All_Multi_WinRate$Line=="mid"),]$VsTotalPlayed,
                                     center=min(All_Multi_WinRate[which(All_Multi_WinRate$Line=="mid"),]$VsTotalPlayed))+0.5,
                    vertex.label.color="white",
                    edge.color="#8CB4F7",
                    vertex.label.dist=2,
                    edge.arrow.size=0.7,
                    vertex.label.font=15,
                    vertex.color="yellow")

# bot
g2 <- All_Multi_WinRate[which(All_Multi_WinRate$Line=="bot"),-c(1,5)] %>% graph.data.frame()

g2 %>%  plot.igraph(vertex.size=15,
                    edge.width=1,
                    vertex.label.color="white",
                    edge.color="#8CB4F7",
                    vertex.label.dist=2,
                    edge.arrow.size=0.7,
                    vertex.label.font=15,
                    vertex.color="green")

# sup
g2 <- All_Multi_WinRate[which(All_Multi_WinRate$Line=="support"),-c(1,5)] %>% graph.data.frame()

g2 %>%  plot.igraph(layout=layout.kamada.kawai,
                    vertex.size=15,
                    edge.width=scale(All_Multi_WinRate[which(All_Multi_WinRate$Line=="support"),]$VsTotalPlayed,
                                     center=min(All_Multi_WinRate[which(All_Multi_WinRate$Line=="support"),]$VsTotalPlayed))+0.5,
                    vertex.label.color="white",
                    edge.color="#8CB4F7",
                    vertex.label.dist=2,
                    edge.arrow.size=2,
                    vertex.label.font=15,
                    vertex.color="orange")

# 그웬 비에고, 자크 뽀삐

# 3라인 멀티 포지션
All_Multi <- ChampionTier[which(ChampionPosition %>% apply(1,sum) == 2),]
# 그웬, 비에고(Top, Jungle, Mid)(6,54)
Top_Jun_Mid <- ChampionTier[c(6,54),]
# 루시안, 야스오(Top,Mid,Bottom)(28,87)
Top_Mid_Bot <- ChampionTier[c(28,87),]
# 세트, 판테온(Top, Mid, Support)(64,148)
Top_Mid_Sup <- ChampionTier[c(64,148),]
# 뽀삐, 자크(Top, Jungle, Support)(56,107)
Top_Jun_Sup <- ChampionTier[c(56,107),]

ChampionWinRate <- read.csv('ChampionWinRate(Total).csv') %>% filter(VsWinRate>=0.5)
colnames(ChampionWinRate) <- c("Line","Source","Target","weight","VsTotalPlayed")

Top_Jun_Mid_WinRate <- ChampionWinRate[which(ChampionWinRate$Source %in% Top_Jun_Mid$search & ChampionWinRate$Target %in% Top_Jun_Mid$search),]
Top_Mid_Bot_WinRate <- ChampionWinRate[which(ChampionWinRate$Source %in% Top_Mid_Bot$search & ChampionWinRate$Target %in% Top_Mid_Bot$search),]
Top_Mid_Sup_WinRate <- ChampionWinRate[which(ChampionWinRate$Source %in% Top_Mid_Sup$search & ChampionWinRate$Target %in% Top_Mid_Sup$search),]
Top_Jun_Sup_WinRate <- ChampionWinRate[which(ChampionWinRate$Source %in% Top_Jun_Sup$search & ChampionWinRate$Target %in% Top_Jun_Sup$search),]

Want_Multi_WinRate <- rbind(Top_Jun_Mid_WinRate,Top_Mid_Bot_WinRate,Top_Mid_Sup_WinRate,Top_Jun_Sup_WinRate)

Want_Multi_WinRate$Source <- paste0(Want_Multi_WinRate$Line,"_",Want_Multi_WinRate$Source)
Want_Multi_WinRate$Target <- paste0(Want_Multi_WinRate$Line,"_",Want_Multi_WinRate$Target)

g2 <- Want_Multi_WinRate[,-c(1,5)] %>% graph.data.frame()

color <- ifelse(str_detect(V(g2)$name,"gwen") | str_detect(V(g2)$name,"viego"),adjustcolor("#CCDDD0",alpha=0.2),
                ifelse(str_detect(V(g2)$name,"lucian") | str_detect(V(g2)$name,"yasuo"),adjustcolor("#A49459",alpha=0.2),
                       ifelse(str_detect(V(g2)$name,"pantheon") | str_detect(V(g2)$name,"sett"),adjustcolor("#0E5C56",alpha=0.2),"#A63106")))

namecolor <- ifelse(str_detect(V(g2)$name,"poppy") | str_detect(V(g2)$name,"zac"),"white",adjustcolor("white",alpha=0.2))
namesize <- ifelse(str_detect(V(g2)$name,"poppy") | str_detect(V(g2)$name,"zac"),2,1)

g2 %>%  plot.igraph(layout=layout.circle,
                    vertex.size=7,
                    vertex.frame.color=color,
                    edge.width=(scale(Want_Multi_WinRate$VsTotalPlayed,
                                     center=min(Want_Multi_WinRate$VsTotalPlayed))+1)*2,
                    vertex.label.color=namecolor,
                    edge.color=color,
                    vertex.label.dist=2,
                    edge.arrow.size=0.5,
                    vertex.label.font=15,
                    vertex.label.cex=namesize,
                    vertex.color=color)


# 강조 없음
color <- ifelse(str_detect(V(g2)$name,"gwen") | str_detect(V(g2)$name,"viego"),"#CCDDD0",
                ifelse(str_detect(V(g2)$name,"lucian") | str_detect(V(g2)$name,"yasuo"),"#A49459",
                       ifelse(str_detect(V(g2)$name,"pantheon") | str_detect(V(g2)$name,"sett"),"#0E5C56","#A63106")))

namecolor <- ifelse(str_detect(V(g2)$name,"poppy") | str_detect(V(g2)$name,"zac"),"white",adjustcolor("white",alpha=0.2))
namesize <- ifelse(str_detect(V(g2)$name,"poppy") | str_detect(V(g2)$name,"zac"),2,1)

g2 %>%  plot.igraph(layout=layout.circle,
                    vertex.size=7,
                    vertex.frame.color=color,
                    edge.width=(scale(Want_Multi_WinRate$VsTotalPlayed,
                                      center=min(Want_Multi_WinRate$VsTotalPlayed))+1)*2,
                    vertex.label.color="white",
                    edge.color=color,
                    vertex.label.dist=2,
                    edge.arrow.size=0.5,
                    vertex.label.font=15,
                    vertex.color=color)

