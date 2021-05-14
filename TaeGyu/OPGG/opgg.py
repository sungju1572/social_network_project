"""
    소셜네트워크 분석 과제
    순천향대학교 빅데이터공학과
    20171483 한태규
    
    ------------------------- memo -------------------------

    --------------------------------------------------------
     
    email : gksxorb147@naver.com
    update : 2021.05.14 00:11
"""

from selenium import webdriver
from bs4 import BeautifulSoup
import time
import requests



class OPGG():

    def __init__(self):

        self.OPGG_URL = "https://www.op.gg/champion/statistics"

        pass

    def read_html(self, URL):
        """URL을 받아서 html을 bs4.BeautifulSoup
          type으로 변환해서 돌려줍니다.

        Args:
            URL ([String]]): "https://www.google.com"

        Returns:
            [class(bs4.BeautifulSoup)]: BeautifulSoup
        """

        try:
            req = requests.get(URL)
            html = req.text
            soup = BeautifulSoup(html, 'html.parser')
            return soup

        except:
            print("read_html ERROR")




    def find_champion_tier(self, line="TOP"):
        """원하는 챔피언의 라인을 받아서 
           그 라인의 티어 list를
           return 합니다. 

        Args:
            line (str, optional): Defaults to "TOP".
                 원하는 라인을 입력합니다.
            
            들어가야할 인자. : 
                 (TOP, JUNGLE, MID, ADC, SUPPORT)

        Returns:
            [list]]: 해당 라인의 챔피언 티어정보
                     아래와 같은 형식으로 return 합니다.
                [['top', 'Shen', '1'], ['top', 'Aatrox', '1'], ... ]
        """

        # 결과 저장 리스트
        result_list = []

        ## html 읽기
        html = self.read_html(self.OPGG_URL)
        
        ## 티어 챔피언 정보 tag 리스트
        champion_info_list= html.find("tbody", class_='tabItem champion-trend-tier-{}'.format(line)
                               ).find_all('tr')

        for n in range(len(champion_info_list)):

            # line 찾기
            line_position = champion_info_list[n].find("a"
                                                ).attrs["href"
                                                ].split("/")[-1]

            # champion_name 찾기
            champion_name = champion_info_list[n].find("div", class_="champion-index-table__name"
                                                ).get_text() 

            # tier 찾기
            tier = champion_info_list[n].find_all("img")[-1
                                       ].attrs["src"
                                       ].split("-")[-1
                                       ].split(".")[0]

            # 결과 list에 저장
            result_list.append([line_position, champion_name, tier])

        # type : list
        return result_list




    def find_champion_tier_all(self):
        """모든 라인의 티어를 list로
           return 합니다.

        Returns:
            [list]: 모든 라인의 티어 list
                    아래와 같은 형식으로 return 합니다.
                [['top', 'Shen', '1'], ['top', 'Aatrox', '1'], ... ]
        """

        
        result_list = []

        line_tuple = ( "TOP", "JUNGLE",
                       "MID", "ADC",
                       "SUPPORT" )

        for line in line_tuple:

            print("정보를 크롤링 하고 있습니다. 라인 > {}".format(line))

            # OP.GG 서버 방지를 위한 sleep
            time.sleep(1)

            result_list += self.find_champion_tier(line)
        
        print("티어 정보 추출을 완료했습니다.")
        return result_list


    def find_champion_line(self):
        """챔피언이 가는 라인을 찾아서
           dict 형식으로 return 합니다.

        Returns:
            [dict]]: 아래와 같은 형식으로 리턴 합니다.
                { 'Aatrox': ['Top'], 'Ahri': ['Middle'], ... }
        """
  
        # 결과 저장 리스트
        result_dict = {}

        ## html 읽기
        html = self.read_html(self.OPGG_URL)
        
        ## 티어 챔피언 정보 tag 리스트
        champion_info_list = html.find("div", class_="champion-index__champion-list").find_all("a")


        for n in range(len(champion_info_list)):

            lt = []

            champion_name = champion_info_list[n].find("div", class_="champion-index__champion-item__name"
                                                 ).get_text()

            champion_line = champion_info_list[n].find("div", class_="champion-index__champion-item__positions"
                                                 ).find_all("div", class_="champion-index__champion-item__position")
            # 챔피언의 라인 넣기
            # 1개 이상이 나올 수 있어서 전부 찾아줌
            for cl in champion_line:
                lt.append(cl.get_text())

            result_dict[champion_name] = lt

        return result_dict

if __name__ == '__main__':

    a = OPGG()
    # c = a.find_champion_tier_all()
    # print(c)
    print(a.find_champion_tier("TOP"))
