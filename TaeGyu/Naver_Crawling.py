# -*- coding: utf-8 -*-
"""
    소셜네트워크 분석 과제
    순천향대학교 빅데이터공학과
    20171483 한태규
    
    email : gksxorb147@naver.com
    update : 2021.03.13 06:51
"""

#-----------------------------------------------------------------------------------#
## modul 연결
import json

from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

from bs4 import BeautifulSoup


from pyprnt import prnt # 리스트구조 이쁘게 출력하기
#import time

#-----------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------#

chrome_driver_path = 'C:/Users/gksxo/Downloads/chromedriver_win32/chromedriver.exe'


def find_evnet_code(num):
    
    """
        URL의 주식명과 주식 코드를
        dict 형으로 return해주는 함수 입니다.
        
        이 함수는 크롬브라우저를 사용하고 있습니다.
        chrome_driver_path 인자에 자신의 크롬 
        브라우져 경로를 넣어야 합니다.        
        ex ) 'C:/Users/gksxo/Downloads/chromedriver_win32/chromedriver.exe'
        
        Dependency Module   : selenium, BeautifulSoup
        Dependency function : x
        email : gksxorb147@naver.com
        update : 2021.03.13 08:08
        
    """
    
    global chrome_driver_path ## 크롬 브라우져 경로
    item_dict = {}            ## 결과 저장 dict
    
    
    ## URL
    url = 'https://finance.naver.com/sise/entryJongmok.nhn?&page={}'.format(num)
    
    ## chromedriver.exe 연결
    driver = webdriver.Chrome(chrome_driver_path)    
    
    # chrome driver 로 해당 페이지가 물리적으로 open
    driver.get(url)

    # 페이지 소스
    src = driver.page_source

    # 페이지 소스 BeautifulSoup에 넣기
    soup = BeautifulSoup(src)
 
    # chrome driver 사용 후, close 함수로 종료
    driver.close()

    table = soup.find("tbody")

    table_row = table.find_all("tr")[2:-2]
    
    for num in range(len(table_row)):
        
        item_code = table_row[num].find("td", class_="ctg"
                                 ).find("a"
                                 ).attrs["href"
                                 ].split("=")[-1]
                               
        item_name = table_row[num].find("td", class_="ctg"
                                 ).find("a"
                                 ).get_text()
                                        
        item_dict[item_name] = item_code

    return item_dict

#-----------------------------------------------------------------------------------#
                                        
#-----------------------------------------------------------------------------------#
## 2021년 3월 13일 08:04 시간기준 >  pagination 21

def find_kospi_200(pagination_number):
    
    """
        네이버의 최대 pagination 숫자를 받아
        kospi_200 데이터를 dict 형으로 return
    
        Dependency Module   : selenium, BeautifulSoup
        Dependency function : find_evnet_code
        email : gksxorb147@naver.com
        update : 2021.03.13 08:15
        
    """
    
    item_dict = {}  ## 결과 저장 dict
    
    for num in range(1,pagination_number+1):
        item_dict.update(find_evnet_code(num))
    
    return item_dict

#-----------------------------------------------------------------------------------#

#-----------------------------------------------------------------------------------#
## json 파일 저장하기
#import os

path = "C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu"

file_name = "kospi_200_item_code.json"

def save_json_file(data, path, file_name):
    
    """        
        json 파일을 저장해줍니다.
        
        email : gksxorb147@naver.com
        update : 2021.03.13 
    """
    
    try:
        fs = open(path+"/"+file_name,"w", encoding='UTF-8')
        print("파일 열기 성공")
        json.dump(data, fs, ensure_ascii=False) 
        # ensure_ascii=False 한글 인코딩 문제
        
        fs.close()
    except:
        print("파일 열기 실패")
        
#-----------------------------------------------------------------------------------#

#data = find_kospi_200(21)

#save_json_file(data,path,file_name)



