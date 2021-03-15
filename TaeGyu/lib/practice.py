# -*- coding: utf-8 -*-
"""
    소셜네트워크 분석 과제
    순천향대학교 빅데이터공학과
    20171483 한태규
    
    ------------------------- memo -------------------------
    연습장입니다.
    
    --------------------------------------------------------
     
    email : gksxorb147@naver.com
    update : 2021.03.15 09:58
    
"""

#-----------------------------------------------------------------------------------#
## modul 연결
import json
import os
#-----------------------------------------------------------------------------------#

#-----------------------------------------------------------------------------------#
## 폴더의 종류별 리스트 출력하기
#import os

def list_extensions_dir(dir_path):
    
    """        
        폴더안의 파일들의 이름을 확장자 별로
        딕셔너리를 만들어 출력합니다.
        
        Dependency Module : os
        Dependency function : x
        email : gksxorb147@naver.com
        update : 2021.03.13 
    """

    extensions_list = [] ## 확장자를 담을 리스트
    dict_key_list = [] ## dict key lsit
    folder_list = {}
    
    file_list = os.listdir(dir_path) ## list 불러오기
    
    ## 폴더안의 확장자 추출
    for file_name in file_list:
        if len(file_name.split(".")) > 1:
            extensions_list.append(file_name.split(".")[-1])
        else:
            extensions_list.append("folder")
    
    dict_key_list = set(extensions_list)
    
    ## dict에 키 추가
    for file_extensions in dict_key_list:
        folder_list[file_extensions] = []
    
    ## folder_list 
    for num in range(len(extensions_list)):
        folder_list[extensions_list[num]].append(file_list[num])
        
    return folder_list
        

#-----------------------------------------------------------------------------------#

#-----------------------------------------------------------------------------------#
## json 파일 불러오기
#import os
#import json

# path = "C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu/json"

# file_name = "kospi_200_item_code.json"

def read_json_file(path, file_name):
    
    """        
        json 파일을 읽어옵니다.
        
        Dependency Module : os, json
        Dependency function : x
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


#-----------------------------------------------------------------------------------#w
## 

def json_group(path):
    
    """        
        모든 json 데이터를 하나의 list로 합쳐줍니다.
        
        email : gksxorb147@naver.com
        update : 2021.03.15 13:26 
    """

    
    
    kospi_200_all_data = []
    kospi_200_all_data_csv = [['종목','코드','날짜', '종가', '상태', '전일비', '시가', '고가', '저가', '거래량']]
    
    for file_name in list_extensions_dir(path)["json"]:
        kospi_200_all_data.append(read_json_file(path,file_name))    
    
    # print(kospi_200_all_data)
    
    for kospi_item_dict in kospi_200_all_data:
        
        event_item = list(kospi_item_dict.keys())[0] # 종목명
        event_code = kospi_item_dict[list(kospi_item_dict.keys())[0]]['codoe'] # 종목 코드
        
        for num in range(len(kospi_item_dict[list(kospi_item_dict.keys())[0]]['data'])):
            data_list = []
            
            if kospi_item_dict[list(kospi_item_dict.keys())[0]]['data'][num][0] != "날짜": # 칼럼명 list 제거
                data_list.append(event_item) # 종목명
                data_list.append(event_code) # 종목 코드
                data_list += kospi_item_dict[list(kospi_item_dict.keys())[0]]['data'][num] # 데이터
                kospi_200_all_data_csv.append(data_list)
                
    return kospi_200_all_data_csv

#-----------------------------------------------------------------------------------#


import pandas as pd

#-----------------------------------------------------------------------------------#
##

def list_to_csv(data):
    
    """        
        list 데이터를 csv 형태로 변경해줍니다.
        
        email : gksxorb147@naver.com
        update : 2021.03.15 13:26 
    """
    
    for data_list in data:
        for num in range(len(data_list)):
            if num==9:
                print(data_list[num],end="\n")
            else:
                print(data_list[num],end="/")

#-----------------------------------------------------------------------------------#    
    
#-----------------------------------------------------------------------------------#
## 현재 경로 변경하기
#import os

#path = "C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu"

def change_current_path(path):
    
    """        
        현재 작업하고 있는 경로를 변경해 줍니다.
        
        Dependency Module : os
        Dependency function : x
        email : gksxorb147@naver.com
        update : 2021.03.13 
    """
    
    print("before: %s"%os.getcwd())
    
    os.chdir(path)
    
    print("after: %s"%os.getcwd())

#-----------------------------------------------------------------------------------#  

path = "C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu/json/data"

data = json_group(path)


path = "C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu/csv"
change_current_path(path)


df = pd.DataFrame(data[1:],
               columns=data[0])

df.to_csv('kospi_200_daily_data.csv', encoding='utf-8')


 
print(df.head(10))





