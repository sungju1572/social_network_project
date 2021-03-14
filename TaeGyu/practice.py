# -*- coding: utf-8 -*-
"""
Created on Sat Mar 13 20:23:07 2021

@author: gksxo
"""

import json
import os
from selenium import webdriver
from bs4 import BeautifulSoup

#-----------------------------------------------------------------------------------#

#from selenium import webdriver
#from bs4 import BeautifulSoup

#chrome_driver_path = 'C:/Users/gksxo/Downloads/chromedriver_win32/chromedriver.exe'

def read_html(URL):

    """
        selenium, BeautifulSoup을 사용해서
        html문서를 불러옵니다.
    
        Dependency Module   : selenium, BeautifulSoup
        Dependency function : x
        email : gksxorb147@naver.com
        update : 2021.03.14 11:20
        
    """

    chrome_driver_path = 'C:/Users/gksxo/Downloads/chromedriver_win32/chromedriver.exe'
    
    ## chromedriver.exe 연결
    driver = webdriver.Chrome(chrome_driver_path)    
    
    # chrome driver 로 해당 페이지가 물리적으로 open
    driver.get(URL)
    
    src = driver.page_source
    
    soup = BeautifulSoup(src)
    
    # chrome driver 사용 후, close 함수로 종료
    driver.close()

    return soup

#-----------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------#
## json 파일 불러오기
#import os

path = "C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu/json"

file_name = "kospi_200_item_code.json"

def read_json_file(path, file_name):
    
    """        
        json 파일을 읽어옵니다.
        
        email : gksxorb147@naver.com
        update : 2021.03.13 
    """
    
    json_data = {}
    
    try:
        fs = open(path+"/"+file_name, "r", encoding='UTF-8')
        print("파일 열기 성공")
        data_json = json.load(fs)
        json_data.update(data_json)
        # ensure_ascii=False 한글 인코딩 문제
        fs.close()
        
    except:
        print("파일 열기 실패")
        
    return json_data


#-----------------------------------------------------------------------------------#
## 페이지 번호 찾기
# print(read_json_file(path,file_name))

# https://finance.naver.com/item/sise_day.nhn?code={}&page={}

# URL = "https://finance.naver.com/item/sise_day.nhn?code=005930&page=1"

# soup = read_html(URL)

# pagination_number = soup.find("table",class_="Nnavi"
#                        ).find("td"   ,class_="pgRR"
#                        ).find("a"
#                        ).attrs["href"
#                        ].split("=")[-1]
                               
# print(pagination_number)

#-----------------------------------------------------------------------------------#


def find_evnet_daily_data(evnet_code, page_number):
    
    """
        종목의 데일리 데이터를  return합니다.
    
        Dependency Module   : selenium, BeautifulSoup
        Dependency function : read_html
        email : gksxorb147@naver.com
        update : 2021.03.14 11:20
        
    """

    data_list = []          ## data return list
    datd_row_list = []      ## row 만들 때 사용
    
    URL = "https://finance.naver.com/item/sise_day.nhn?code={}&page={}".format(evnet_code, page_number)
    
    soup = read_html(URL)
    
    table = soup.find("table", class_="type2").find("tbody").find_all("tr")
    
    ## 컬럼 이름 생성
    for tag in table[0].find_all("th"):
        datd_row_list.append(tag.get_text())
        #print(tag.get_text())
    
    ## 상태 컬럼 넣기
    datd_row_list.insert(2, '상태') 
    data_list.append(datd_row_list) 
    
    ## row 생성하기
    for num in range(len(table)-1):
        
        datd_row_list = []
        
        if (num > 1 and num < 7) or ( num > 9 and num < 16): # 위에 5개 아래 5개
            try:
                table_row = table[num].find_all("td") # 테이블 찾기
                datd_row_list.append(table_row[0].find("span", class_="tah").get_text()) # 날짜
                datd_row_list.append(table_row[1].find("span", class_="tah").get_text()) # 종가
                
                try:
                    datd_row_list.append(table_row[2].find("img").attrs["alt"]) # 전일비
                except:
                    if table_row[2].find("span", class_="tah").get_text().strip() == "0":
                        datd_row_list.append("전진")
                    else:
                        datd_row_list.append("상승")
        
                datd_row_list.append(table_row[2].find("span", class_="tah").get_text().strip())
                
                datd_row_list.append(table_row[3].find("span", class_="tah").get_text()) # 시가
                datd_row_list.append(table_row[4].find("span", class_="tah").get_text()) # 고가
                datd_row_list.append(table_row[5].find("span", class_="tah").get_text()) # 저가
                datd_row_list.append(table_row[6].find("span", class_="tah").get_text()) # 거래량
    
                data_list.append(datd_row_list) 
            except:
                print(str(num)+": 번째 데이터 없음")
                print()
                break
        
    return data_list
            
#-----------------------------------------------------------------------------------#






















# def event_data(evnet_code):
    
#     """
#         종목의 코드를 받아서
#         데이터를 반환 합니다.
    
#         Dependency Module   : selenium, BeautifulSoup
#         Dependency function : read_html
#         email : gksxorb147@naver.com
#         update : 2021.03.14 11:20
        
#     """
    
#     URL = "https://finance.naver.com/item/sise_day.nhn?code={}&page=1".format(evnet_code)
    
#     soup = read_html(URL)
    
#     pagination_number = soup.find("table",class_="Nnavi"
#                            ).find("td"   ,class_="pgRR"
#                            ).find("a"
#                            ).attrs["href"
#                            ].split("=")[-1]
                                   
#     pagination_number
        
    






