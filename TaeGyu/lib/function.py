

"""
    소셜네트워크 분석 과제
    순천향대학교 빅데이터공학과
    20171483 한태규
    
    email : gksxorb147@naver.com
    update : 2021.03.13 06:51
"""


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
## URL 크롬 연결
## 코스피 200

def find_evnet_code(pagination_number):
    
    """
        URL의 주식명과 주식 코드를
        dict 형으로 return해주는 함수 입니다.
        
        이 함수는 크롬브라우저를 사용하고 있습니다.
        chrome_driver_path 인자에 자신의 크롬 
        브라우져 경로를 넣어야 합니다.
        ex ) 'C:/Users/gksxo/Downloads/chromedriver_win32/chromedriver.exe'
        
        Dependency Module : selenium, BeautifulSoup
        Dependency function : read_html
        email : gksxorb147@naver.com
        update : 2021.03.14
    """
    
    # return 변수
    item_dict = {}
    
    
    ## URL
    url = 'https://finance.naver.com/sise/entryJongmok.nhn?&page={}'.format(pagination_number)
    
    #
    soup = read_html(url)

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

def find_kospi_200_code():
    
    """
        네이버의 최대 pagination 숫자를 찾아
        kospi_200 데이터를 dict 형으로 return
    
        Dependency Module   : selenium, BeautifulSoup
        Dependency function : find_evnet_code, read_html
        email : gksxorb147@naver.com
        update : 2021.03.13 08:15
        
    """

    url = 'https://finance.naver.com/sise/entryJongmok.nhn?&page=1'
    
    soup = read_html(url)
    
    pagination_number = soup.find("table",class_="Nnavi"
                           ).find("td"   ,class_="pgRR"
                           ).find("a"
                           ).attrs["href"
                           ].split("=")[-1]
    
    item_dict = {}  ## 결과 저장 dict
    
    for num in range(1,int(pagination_number)+1):
        item_dict.update(find_evnet_code(num))
    
    return item_dict

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
        
list_extensions_dir("경로 입력")

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


#-----------------------------------------------------------------------------------#
## json 파일 저장하기
#import os

path = "C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu/json"

file_name = "kospi_200_item_code.json"

def save_json_file(data, path, file_name):
    
    """        
        json 파일을 저장해줍니다.
        
        Dependency Module : os
        Dependency function : x
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