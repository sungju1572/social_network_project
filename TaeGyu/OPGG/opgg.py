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
import requests

class OPGG():

    def __init__(self):
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
            print(type(soup))
            return soup
        except:
            print("read_html ERROR")


if __name__ == '__main__':

    a = OPGG()
    b = a.read_html("https://www.op.gg/champion/statistics")
    # print(b)
    
