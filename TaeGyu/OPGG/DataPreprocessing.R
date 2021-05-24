# ---------------------------------------------------- #
# 
# 순천향 대학교
# 소셜네트워크 과제
# 빅데이터공학과 20171483 한태규
# 
# ---------------------------------------------------- #




# ---------------------------------------------------- #

# 경로 변경
getwd()
setwd("C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu/OPGG/csv")

# ---------------------------------------------------- #
# install.packages('extrafont')


# 사용 라이브러리
library(tidyverse)
library(igraph)


# data read
counter <- read_csv("counter.csv")
tier <- read_csv("tier.csv")



# 전처리
textTier <- tier %>% 
            mutate(top = replace(top, top != 0, "T"),
                   jungle = replace(jungle, jungle != 0, "J"),
                   mid = replace(mid, mid != 0, "M"),
                   adc = replace(adc, adc != 0, "A"),
                   support = replace(support, support != 0, "S"))

textTier <- textTier %>% 
            mutate(top = replace(top, top == 0, ""),
                   jungle = replace(jungle, jungle == 0, ""),
                   mid = replace(mid, mid == 0, ""),
                   adc = replace(adc, adc == 0, ""),
                   support = replace(support, support == 0, ""))

champLine <- c()

for ( i in seq(nrow(textTier)) ){
    
  champLine  <- c(champLine , 
            paste0( textTier[i,2],
                    textTier[i,3],
                    textTier[i,4],
                    textTier[i,5],
                    textTier[i,6] ))
  print(
    paste0( textTier[i,2],
            textTier[i,3],
            textTier[i,4],
            textTier[i,5],
            textTier[i,6] ))
}


match_count <- counter %>% 
                group_by(champion1) %>% 
                summarise(count = sum(match_count))

nodes <- data.frame( id = textTier[,1],
                    line = champLine,
                    match_count = match_count[,2])

links <- counter %>% 
          mutate(winning_rageText = ifelse(winning_rage>50,"Win", ifelse(winning_rage<50, "Lose", "Draw")))


# 열 순서 변경
links <- links[, c(2,3,4,5,6,1)]


colnames(nodes) <- c()
colnames(links) <- c( "from"        
                    , "to"        
                    , "winningRate"     
                    , "matchCount"      
                    , "winningRateText"
                    , "line" )



net <- graph_from_data_frame(links,vertices = nodes,directed = T)


# write.csv(nodes, "./nodes.csv")
# write.csv(links, "./edges.csv")



