# -*- coding: utf-8 -*-
"""
Created on Sat Mar 13 20:23:07 2021

@author: gksxo
"""

import json
import os



#-----------------------------------------------------------------------------------#
## 파일 저장하기
#import os

# path = "C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu"
# file_name = "sample.json"

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


path = "C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu"
file_name = "sample.json"


save_json_file(dict1,path,file_name)



#data = json.load(open(filename))

