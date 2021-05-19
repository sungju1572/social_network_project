####----------------------디렉토리 설정 + 패키지 불러오기----------------------####

setwd('C:\\Users\\LeeGeon.DESKTOP-C5M3NRB.000\\Documents\\GitHub\\social_network_project\\LeeGeon\\OP_GG_Data')

library(httr)
library(rvest)
library(urltools)
library(readr)
library(tidyverse)

#---------------------------------------------------------------------------------#

####----------------------챔피언 이름 크롤링----------------------####

res <- GET(url='https://www.op.gg/champion/statistics')
status_code(res) # 정상작동 확인

Champion_list <- res %>% read_html() %>% 
  html_nodes(css='div.champion-index__champion-item__name') %>% 
  html_text() %>% as.data.frame() # 챔피언 이름

colnames(Champion_list) <- "English_Champ"

Champion_position <- res %>% read_html() %>% 
  html_nodes(css='div.champion-index__champion-list>div') %>% 
  html_text() %>% as.data.frame() # 챔피언 포지션

Champion_position # "챔피언포지션1포지션2"식으로 되어 있음

Line_Data_frame <- data.frame(Top=rep(0,nrow(Champion_position)),
                              Jungle=rep(0,nrow(Champion_position)),
                              Middle=rep(0,nrow(Champion_position)),
                              Bottom=rep(0,nrow(Champion_position)),
                              Support=rep(0,nrow(Champion_position)))

for(x in 1:nrow(Champion_position)){ # 챔피언별 포지션 더미변수화
  if(str_detect(Champion_position[x,],"Top")){
    Line_Data_frame[x,1] <-1
  }
  
  if(str_detect(Champion_position[x,],"Jungle")){
    Line_Data_frame[x,2] <- 1
  }
  
  if((str_detect(Champion_position[x,],"Middle"))){
    Line_Data_frame[x,3] <- 1
  }
  
  if(str_detect(Champion_position[x,],"Bottom")){
    Line_Data_frame[x,4] <- 1
  }
  
  if(str_detect(Champion_position[x,],"Support")){
    Line_Data_frame[x,5] <- 1
  }
}

Champion_list <- cbind(Champion_list,
                       Line_Data_frame,
                       Line_count=apply(Line_Data_frame,1,sum)) # 가는 라인 종류 count

filter(Champion_list,Line_count==0) # 가는 라인이 안 잡히는 경우(픽률이 매우 낮아 통계 x)

search <- res %>% read_html() %>%  # 검색 할 때 쓰는 챔피언 이름(원래 이름과 조금 다른 애들 존재)
  html_nodes(css='div.champion-index__champion-list>div>a') %>% 
  html_attr('href')%>% as.data.frame() %>% 
  separate(1,sep="/",into=c("A","B","Champ","C")) %>% .[,3]

Can_search <- cbind(search, # 검색 가능한 이름만 cbind
                  Champion_list$English_Champ[-which(Champion_list$Line_count==0)])

colnames(Can_search) <- c("search","English_Champ")

Champion_list <- merge(Champion_list,Can_search,all.x = TRUE)
# 챔피언 리스트 + 검색용 이름 결합


# 영어 한글 매칭
# op.gg에는 한글 이름이 존재하지 않아 fow.kr 이용
res2 <- GET(url="http://fow.kr/champs")

Korea_Champ <- res2 %>% read_html() %>% 
  html_nodes(css='ul>a>li>font') %>% 
  html_text() %>% as.data.frame() # 한글 이름 크롤링

colnames(Korea_Champ) <- "Korean_Champ"

English_Champ <- res2 %>% read_html() %>% 
  html_nodes(css='ul>a') %>%
  html_attr('href') %>% as.data.frame() %>% 
  separate(1,sep="/",into=c("A","B","Champ")) %>% .[,3] # 영어 이름 크롤링

Champ_total <- data.frame(Korea_Champ=Korea_Champ,
                          English_Champ=English_Champ)

# 표본이 안잡히는 스카너, 직스 제거
Champ_total <- Champ_total[-which(Champ_total$Korean_Champ %in% c("스카너","직스")),]

# fow.kr에서의 영어 이름과 op.gg의 검색용 이름이 같다는 것을 확인함(대소문자 차이)
# 결합해서 최종적으로 데이터 프레임 하나로 생성
Match_search<- Champ_total$English_Champ %>% sort() %>% unname() %>%
  cbind(Champion_list$search %>% sort()) 

colnames(Match_search) <- c("English_Champ","search")
Champ_KE <- merge(Champ_total,Match_search,all.x=TRUE)
Champ_KE <- Champ_KE[,-1]

Champion_total <- merge(Champion_list,Champ_KE,all.x=TRUE)
Champion_total <- Champion_total[,c(9,2:7,1)] # 보기 좋게 순서 바꾸기

# NA값들 이름 주기(한국어 이름으로 정렬해야 하므로)
Champion_total$Korean_Champ[154] <- c("직스")
Champion_total$Korean_Champ[155] <- c("스카너")
Champion_total <- arrange(Champion_total,Korean_Champ)

Champion_total

write.csv(Champion_total,"OPGG_Champion_name.csv",row.names=FALSE)

#--------------------------------------------------------------------#