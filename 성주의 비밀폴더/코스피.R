
Sys.setenv(JAVA_HOME='C:/Program Files/Java/jre1.8.0_281')
install.packages("rJava")
library(rJava)


install.packages("RSelenium")
install.packages("seleniumPipes")

library(RSelenium)
library(seleniumPipes)
library(rvest)
library(httr)
library(dplyr)



remDr = remoteDriver(
  remoteServerAddr="localhost",
  port=4445L,
  browserName="chrome")

remDr$open()

remDr$navigate('https://finance.naver.com/sise/entryJongmok.nhn?&page=1')

page_parse <- remDr$getPageSource()[[1]]
page_html <- page_parse %>% read_html() #페이지 내용 받기

##마지막 페이지가 몇번째인지 찾아내기 : pgRR 클래스의 a 태그 중 href 속성에 위치

navi.final <- page_html %>%   #HTML 내용 읽어오기 인코딩 : EUC-KR
  html_nodes(., ".pgRR") %>% #클래스 정보만 불러오기 / 클래스의 경우 이름앞에 (.)을 붙여야함 
  html_nodes(., "a") %>% #태그 정보만 불러오기
  html_attr(., "href") #속성 불러오기

##page= 뒤에 있는 숫자 추출

navi.final <- navi.final %>% 
  strsplit(., "=") %>% # "=" 기준으로 문장 나누기
  unlist() %>% #결과를 벡터 형태로 변환
  tail(., 1) %>% #뒤에서 첫번째 데이터만 선택
  as.numeric() # 숫자형으로 변환


##첫번쨰부터 마지막 페이지까지 for문을 사용하여 테이블 추출

ticker <-  list()

for(j in 1:navi.final){
  url <- paste0("https://finance.naver.com/sise/entryJongmok.nhn?&page=",j)
  remDr$navigate(url)
  page_parse <- remDr$getPageSource()[[1]] #페이지 읽어오기
  page_html <- page_parse %>% read_html() #html형으로 변환
  
  Sys.setlocale("LC_ALL", "English") #로케일 언어를 영어로 설정(한글로하면 오류 발생 할 수 있음)
  
  table <- page_html %>% 
    html_table(fill = TRUE) #테이블정보 읽기, fll=TRUE : 빈값 NA로 채우기
  
  table <- table[[1]] #table리스트는 2개. 첫번째 리스트에 필요한 시고저종,거래량등 데이터 저장되어있음
  
  Sys.setlocale("LC_ALL", "Korean")  #한글을 읽기위해 로케일언어를 한글로 다시 설정
  
  table[, ncol(table)] = NULL #마지막열 제거
  table <- na.omit(table) #NA행 제거
  table <- table[c(2:11),] #필요한 데이터만 남기기
  
  ##각종목을 나타내는 6자리의 티커 추출 : tbody -> td -> a 태그의 href 속성에 위치
  
  symbol <- page_html %>% 
    html_nodes(., "tbody") %>% 
    html_nodes(., ".ctg") %>% 
    html_nodes(., "a") %>% 
    html_attr(., "href")
  
  print(head(symbol, 10))
  
  symbol <- sapply(symbol, function(x){       #티커 6자리만 추출
    substr(x, nchar(x)-5, nchar(x)) 
  })
  
  symbol <- unique(symbol) #중복제거하고 유일값만 남기기
  
  table$N <- symbol  #테이블 칼럼 N을 symbol로 설정
  
  colnames(table)[1] <- "종목코드" #N변수명 종목코드로 변환
  
  rownames(table) <- NULL #행이름 초기화
  
  ticker[[j]] <- table #ticker의 j번째 리스트에 정리된 데이터 삽입
  
}

#종목 리스트 저장
stock <- list()

for(i in 1:length(ticker)){
  for(j in 1:10){
    a <- (ticker[[i]][[1]][j])
    stock <- append(stock, a)
  }
}

for(i in 1:length(stock)){
  if (is.na(stock[i])){
    stock[i] <- NULL
  }
}

stock <- stock[c(2:201)]
stock <- append(stock,"남선알미늄")

#코드 리스트 저장
stock_code <- list()

for(i in 1:length(ticker)){
  for(j in 1:10){
    a <- (ticker[[i]][[7]][j])
    stock_code <- append(stock_code, a)
  }
}

for(i in 1:length(stock_code)){
  if (is.na(stock_code[i])){
    stock_code[i] <- NULL
  }
}

stock_code <- stock_code[c(1:201)]


#종목별 날짜 시고저종 가져오기
page <- 10 #가져올 데이터수 (페이지)
final_df <- data.frame()

for(i in 1:length(stock_code)){
  for(j in 1:page){
    url <- paste0("https://finance.naver.com/item/sise_day.nhn?code=",stock_code[i],"&page=",j)
    remDr$navigate(url)
    page_parse <- remDr$getPageSource()[[1]] #페이지 읽어오기
    page_html <- page_parse %>% read_html() #html형으로 변환
    
    Sys.setlocale("LC_ALL", "English") #로케일 언어를 영어로 설정(한글로하면 오류 발생 할 수 있음)
    
    table <- page_html %>% 
      html_table(fill = TRUE) #테이블정보 읽기, fll=TRUE : 빈값 NA로 채우기
    Sys.sleep(1) #1초동안 정지
    
    table <- table[[1]] #table리스트는 2개. 첫번째 리스트에 필요한 시고저종,거래량등 데이터 저장되어있음
    table <- na.omit(table) #NA행 제거
    
    Sys.setlocale("LC_ALL", "Korean")  #한글을 읽기위해 로케일언어를 한글로 다시 설정
    
    table <- data.frame(table) #df로 변환
    table$"종목" <- stock[[i]] #종목 칼럼 추가
    final_df <- rbind(final_df,table)
  }
  
  
}

final_df <- final_df[!(final_df$날짜==""),] #공백 제거


head(final_df)


write.csv(final_df,"C:/Users/Schbi/Desktop/stock_ksp.csv", row.names=FALSE) #csv로 저장

  