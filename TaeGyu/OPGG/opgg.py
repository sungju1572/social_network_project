"""
    소셜네트워크 분석 과제
    순천향대학교 빅데이터공학과
    20171483 한태규
    
    ------------------------- memo -------------------------

    --------------------------------------------------------
     
    email : gksxorb147@gmail.com
"""

from bs4 import BeautifulSoup
import time
import requests
import csv


class OPGG():

    def __init__(self):

        self.OPGG_URL = "https://www.op.gg/champion/statistics"

        pass

    def read_html(self, URL):
        """
            URL을 받아서 html을 bs4.BeautifulSoup
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
        """
           원하는 챔피언의 라인을 받아서 
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
        """
            모든 라인의 티어를 list로
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
        """
            챔피언이 가는 라인을 찾아서
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
        champion_info_list = html.find("div", class_="champion-index__champion-list"
                                ).find_all("a")


        for n in range(len(champion_info_list)):

            lt = []

            champion_name = champion_info_list[ n
                            ].find("div", class_="champion-index__champion-item__name"
                            ).get_text()

            champion_line = champion_info_list[ n
                            ].find("div", class_="champion-index__champion-item__positions"
                            ).find_all("div", class_="champion-index__champion-item__position")
            # 챔피언의 라인 넣기
            # 1개 이상이 나올 수 있어서 전부 찾아줌
            for cl in champion_line:
                lt.append(cl.get_text())

            result_dict[champion_name] = lt

        return result_dict
    

    
    def champion_line_url(self):
        """ 
            챔피언의 라인별로 URL을 생성 후
            list type으로 return 합니다.

        Returns:
            [list]: 아래와 같은 형식으로 리턴 합니다.
                ['https://www.op.gg/champion/Aatrox/statistics/Top',
                 'https://www.op.gg/champion/Ahri/statistics/Middle',
                    ... ]
        """

        result_list = []

        champion_line = self.find_champion_line()


        for k, value_list in champion_line.items():
            for vl in value_list:
                URL = "https://www.op.gg/champion/{}/statistics/{}".format(k, vl)
                result_list.append(URL)

        return result_list




    def find_champion_counter(self, URL):
        """ 
            OP.GG 챔피언 line URL를 입력받아서
            같은 라인의 상대 챔피언간의 상성을 
            비교후 list 형으로 return 한다.

        Args:
            [string]: URL을 입력합니다.
                ex) : https://www.op.gg/champion/Aatrox/statistics/Top

        Returns:
            [list]: 아래와 같은 형식으로 리턴 합니다.
                [ ['Support', 'Zac', 'Xerath', '53.38', '133'],
                  ['Support', 'Zac', 'Blitzcrank', '52.27', '132'],
                    ... ]
        """

        result_list = []

        MATHCUP_URL = "{}/matchup?".format(URL)

        find_champion = MATHCUP_URL.split("/")[4]
        find_champion_line = MATHCUP_URL.split("/")[-2]

        html = self.read_html(MATHCUP_URL)

        champion_matchup = html.find("div", class_="champion-matchup-champion-list")

        matchup_list = champion_matchup.find_all("div", class_="champion-matchup-champion-list__item")

        for n in range(len(matchup_list)):

            # 상대 챔피언 이름
            cntr_name = matchup_list[n].find("span"
                                      ).get_text()

            # 상대 챔피언과 승률
            winning_rate = matchup_list[n
                          ].find("span", class_="champion-matchup-list__winrate"
                          ).get_text(
                          ).strip()[:-1] 

            # 상대 챔피언과 판수
            matchup_cnt = matchup_list[n].find("small").get_text()

            result_list.append([ find_champion_line,
                                 find_champion,
                                 cntr_name,
                                 winning_rate,
                                 matchup_cnt  ])

        return result_list



    def find_champion_counter_all(self):
        """ 
            모든 챔피언의 같은 라인의
            상대 챔피언간의 상성을 
            비교후 list 형으로 return 한다.

        Returns:
            [list]: 아래와 같은 형식으로 리턴 합니다.
                [ ['Support', 'Zac', 'Xerath', '53.38', '133'],
                  ['Support', 'Zac', 'Blitzcrank', '52.27', '132'],
                    ... ]
        """

        result_list = []

        champion_line_url_list = self.champion_line_url()

        i = 0

        for url in champion_line_url_list:

            time.sleep(1)
            print("현재 작업중인 URL > {}".format(url))
            result_list += self.find_champion_counter(url)
            i += 1
        
        return result_list



    def tier_all_save_csv(self):
        """ 
            챔피언의 티어정보를 csv 파일로
            만들어 줍니다.

        """

        # table 만들 때 필요한 정보
        tier = self.find_champion_tier_all()
        champion_name_list = self.find_champion_line().keys()
        
        # talbe 만들기
        table = [["champion", "top", "jungle", "mid", "adc", "support"]]

        for name in champion_name_list:
            # champion, top, jungle, mid, adc, support
            table += [[name, 0, 0, 0, 0, 0]]

        print(tier)

        for ti in tier:
            # ti[0] > line
            # ti[1] > name
            # ti[2] > tier
            for n in range(len(table)):
                if table[n][0] == ti[1]:

                    if ti[0] == 'top':
                        table[n][1] = ti[2]

                    elif ti[0] == 'mid':
                        table[n][2] = ti[2]

                    elif ti[0] == 'jungle':
                        table[n][3] = ti[2]

                    elif ti[0] == 'adc':
                        table[n][4] = ti[2]

                    elif ti[0] == 'support':
                        table[n][5] = ti[2]

        # csv file 생성
        with open('./csv/tier.csv', 'w', newline='') as f:

            writer = csv.writer(f)

            for row in table:
                writer.writerow(row)

        f.close()




    def counter_all_save_csv(self):
        """
            find_champion_counter_all 함수가
            return 하는 정보를 csv file로 만들어서
            저장합니다.
        """

        col_name = [["line", "champion1", "champion2", "winning_rage", "match_count"]]

        data = self.find_champion_counter_all()

        table = col_name + data

        # csv file 생성
        with open('./csv/counter.csv', 'w', newline='') as f:

            writer = csv.writer(f)

            for row in table:
                writer.writerow(row)

        f.close()



if __name__ == '__main__':

    # counter_all_save_csv 호출
    OPGG.counter_all_save_csv()

    # tier_all_save_csv 호출
    OPGG.tier_all_save_csv()
