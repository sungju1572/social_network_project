


#------------------------------------------------------------------#
# install.packages("shiny")
# install.packages("shinydashboard")
# install.packages("tidyverse")
# install.packages("DT")
# install.packages("pracma")
# install.packages("seewave")
# install.packages("changepoint")
# install.packages("visNetwork")

library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
# library(pracma)
# library(seewave)
# library(changepoint)
library(visNetwork)
library(rsconnect)
#------------------------------------------------------------------#

setwd("C:/Users/LeeGeon.DESKTOP-C5M3NRB.000/Documents/GitHub/social_network_project/TaeGyu/OPGG/shinyApp")

load(file = "./data/Rdata/EDGE_DATA.Rdata")
load(file = "./data/Rdata/NODES_DATA.Rdata")
load(file = "./data/Rdata/TopLineChamp.Rdata")
load(file = "./data/Rdata/MinLineChamp.Rdata")
load(file = "./data/Rdata/JungleLineChamp.Rdata")
load(file = "./data/Rdata/BotLineChamp.Rdata")
load(file = "./data/Rdata/SupportLineChamp.Rdata")


#------------------------------------------------------------------#
# save.image(file = ".RData")

runApp("LOLVisNetwork")


#------------------------------------------------------------------#