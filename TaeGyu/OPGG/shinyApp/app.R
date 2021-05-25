#------------------------------------------------------------------#
# 
# ?ˆœì²œí–¥ ??€?•™êµ? ë¹„ì •?˜•?°?´?„° ê³¼ì œ
# ë¹…ë°?´?„° ê³µí•™ê³? 20171483 ?•œ?ƒœê·?
# Shiny App ê°œë°œ?•˜ê¸?
# 
#------------------------------------------------------------------#



#------------------------------------------------------------------#
# install.packages("shiny")
# install.packages("shinydashboard")
# install.packages("tidyverse")
# install.packages("DT")
# install.packages("pracma")
# install.packages("seewave")
# install.packages("changepoint")

library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(pracma)
library(seewave)
library(changepoint)
#------------------------------------------------------------------#


#------------------------------------------------------------------#
load( "./.RData" )

setwd("C:/Users/gksxo/Desktop/Project/github/social_network_project/TaeGyu/OPGG/shinyApp")

runApp("myapp")
#------------------------------------------------------------------#

