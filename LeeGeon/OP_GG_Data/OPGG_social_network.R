setwd("C:\\Users\\LeeGeon.DESKTOP-C5M3NRB.000\\Documents\\GitHub\\social_network_project\\LeeGeon\\OP_GG_Data")
library(igraph)
library(stringr)
library(RColorBrewer)
library(tidyverse)

abc <- read.csv('ChampionWinRate(Total).csv') %>% filter(VsWinRate>=0.54)
abc %>% nrow()

TotalPlayed <- abc %>% group_by(Line,Champion) %>% summarize(TotalPlayed=sum(VsTotalPlayed))

colnames(abc) <- c("Line","Source","Target","weight","VsTotalPlayed")

top_abc <- filter(abc,Line=='top') %>% .[,-c(1,5)]
mid_abc <- filter(abc,Line=='mid') %>% .[,-c(1,5)]
bot_abc <- filter(abc,Line=='bot') %>% .[,-c(1,5)]
sup_abc <- filter(abc,Line=='support') %>% .[,-c(1,5)]
jun_abc <- filter(abc,Line=='jungle') %>% .[,-c(1,5)]

mid_abc <- mid_abc %>% graph.data.frame()
mid_abc

mid_abc %>% plot.igraph(layout=layout.fruchterman.reingold,
                                               vertex.size=4, edge.arrow=NA,
                                               edge.width=1, edge.curved=T, # 연결 선을 곡선으로
                                               vertex.label.dist=2,
                                               edge.arrow.size=0.2)
