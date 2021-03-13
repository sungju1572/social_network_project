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
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

from pyprnt import prnt # 리스트구조 이쁘게 출력하기

from bs4 import BeautifulSoup

import time

#-----------------------------------------------------------------------------------#



#-----------------------------------------------------------------------------------#
## URL 링크 연결
## 코스피 200
s
chrome_driver = 'C:/Users/gksxo/Downloads/chromedriver_win32/chromedriver.exe'

def find_evnet_code(pagination_number, chrome_driver_path):
    
    """
        URL의 주식명과 주식 코드를
        dict 형으로 return해주는 함수 입니다.
        
        이 함수는 크롬브라우저를 사용하고 있습니다.
        chrome_driver_path 인자에 자신의 크롬 
        브라우져 경로를 넣어야 합니다.
        ex ) 'C:/Users/gksxo/Downloads/chromedriver_win32/chromedriver.exe'
        
        Dependency Module : selenium, BeautifulSoup
        email : gksxorb147@naver.com
        update : 2021.03.13 
    """
    
    # return 변수
    item_dict = {}
    
    
    ## URL
    url = 'https://finance.naver.com/sise/entryJongmok.nhn?&page={}'.format(pagination_number)
    
    ## chromedriver.exe 연결
    driver = webdriver.Chrome(chrome_driver_path)    
    
    # chrome driver 로 해당 페이지가 물리적으로 open
    driver.get(url)

    src = driver.page_source

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
                                        



prnt(find_evnet_code(1, chrome_driver))








