#크롤링

library(RSelenium)
library(seleniumPipes)
library(rvest)
library(httr)
library(dplyr)

#4445번 포트와 크롬 연결
remDr <-  remoteDriver(
  remoteServerAddr="localhost",
  port=4445L,
  browserName="chrome")

#크롬 웹창 열기
remDr$open()


#주소입력
remDr$navigate('https://www.op.gg/champion/statistics')


page_parse <- remDr$getPageSource()[[1]]
page_html <- page_parse %>% read_html()

#챔피언별 검색 코드 찾기
x <- page_html %>% 
  html_nodes(., ".champion-index__champion-list>div>a") %>% 
  html_attr('href') %>% 
  as.data.frame()
  

x_split <- data.frame(do.call('rbind',
                              strsplit(as.character(x$.),
                                       split = '/',
                                       fixed=TRUE))) 
#검색코드 저장  
code <- x_split$X3




#데이터 프레임 생성
Line_Data_frame <- data.frame(Name=code,
                              Top=rep(0,length(code)),
                              Jungle=rep(0,length(code)),
                              Middle=rep(0,length(code)),
                              Bottom=rep(0,length(code)),
                              Support=rep(0,length(code)))



#코드별로 반복
for(z in code){
  print(z)
  
  #챔피언별 사이트 접속
  remDr$navigate(paste0('https://www.op.gg/champion/',z,'/statistics'))
  
  #페이지창 받고 html로 변경
  page_parse <- remDr$getPageSource()[[1]]
  page_html <- page_parse %>% read_html()
  
  #챔피언별 라인 확인
  line <- page_html %>% 
    html_nodes(., ".champion-stats-header__position__role") %>% 
    html_text()
  
  print(line)
  
  #만든 데이터 프레임 행수만큼 반복
  for(j in 1:nrow(Line_Data_frame)){
    
    #데이터프레임의 이름과 챔피언코드(현재 동작중 z)와 같을때
    if(Line_Data_frame$Name[j]==z){
      
      #챔피언별 라인수만큼 반복
      for(i in line){
        
        #챔피언의 라인에따라 조건문
        if(i=="탑"){
          #TOP페이지열기
          remDr$navigate(paste0('https://www.op.gg/champion/',z,'/statistics/top'))
          
          #페이지받고 html로 변경
          page_parse <- remDr$getPageSource()[[1]]
          page_html <- page_parse %>% read_html()
          
          #챔피언별 티어 받아오기
          tier <- page_html %>% 
            html_nodes(., ".champion-stats-header-info__tier>b") %>% 
            html_text() %>% 
            strsplit(.," ") %>% 
            .[[1]] %>% 
            .[1]
          
          #데이터 프레임에 티어저장
          Line_Data_frame$Top[j] <-tier
          print("탑추가")
          
        }
        else if(i=="정글"){
          remDr$navigate(paste0('https://www.op.gg/champion/',z,'/statistics/jungle'))
          page_parse <- remDr$getPageSource()[[1]]
          page_html <- page_parse %>% read_html()
          tier <- page_html %>% 
            html_nodes(., ".champion-stats-header-info__tier>b") %>% 
            html_text() %>% 
            strsplit(.," ") %>% 
            .[[1]] %>% 
            .[1]
          Line_Data_frame$Jungle[j] <-tier
          print("정글추가")
        }
        else if(i=="미드"){
          remDr$navigate(paste0('https://www.op.gg/champion/',z,'/statistics/mid'))
          page_parse <- remDr$getPageSource()[[1]]
          page_html <- page_parse %>% read_html()
          tier <- page_html %>% 
            html_nodes(., ".champion-stats-header-info__tier>b") %>% 
            html_text() %>% 
            strsplit(.," ") %>% 
            .[[1]] %>% 
            .[1]
          Line_Data_frame$Middle[j] <-tier
          print("미드추가")
        }
        else if(i=="바텀"){
          remDr$navigate(paste0('https://www.op.gg/champion/',z,'/statistics/bot'))
          page_parse <- remDr$getPageSource()[[1]]
          page_html <- page_parse %>% read_html()
          tier <- page_html %>% 
            html_nodes(., ".champion-stats-header-info__tier>b") %>% 
            html_text() %>% 
            strsplit(.," ") %>% 
            .[[1]] %>% 
            .[1]
          Line_Data_frame$Bottom[j] <-tier
          print("바텀추가")
        }
        else if(i=="서포터"){
          remDr$navigate(paste0('https://www.op.gg/champion/',z,'/statistics/support'))
          page_parse <- remDr$getPageSource()[[1]]
          page_html <- page_parse %>% read_html()
          tier <- page_html %>% 
            html_nodes(., ".champion-stats-header-info__tier>b") %>% 
            html_text() %>% 
            strsplit(.," ") %>% 
            .[[1]] %>% 
            .[1]
          Line_Data_frame$Support[j] <-tier
          print("서폿추가")
        }

      }
      
    }
  }

}



setwd("C:/Users/Schbi/Desktop/소셜")
write.csv(Line_Data_frame, file="Champion_Line_Tier.csv",row.names=FALSE)



