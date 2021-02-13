library(readxl)
library(lubridate)
require(reshape)
source("functions.R")
buyer_data <- read_excel("Data.xlsx")
buyer_data$WEEK_END_DT <- as.Date(buyer_data$WEEK_END_DT, format="%d-%m-%Y")
# buyer_data$WEEK_END_DT <- format(buyer_data$WEEK_END_DT, "%Y-%m-%d")
buyer_data$year <- format(as.Date(buyer_data$WEEK_END_DT), "%Y")
buyer_data$week <- substr(buyer_data$WEEK_ID, 5, 7)
buyer_data <- buyer_data[rev(order(as.Date(buyer_data$WEEK_END_DT))),]
# dt_consider <- 13
buyer_data <- buyer_data[buyer_data$ACTIVE_365D_BYRS != 0,]
buyer_data$active_goal_vs_active_buyers <- buyer_data$ACTIVE_365D_GOAL - buyer_data$ACTIVE_365D_BYRS
active_buyer_years <- cast(buyer_data, week~year, value = "active_goal_vs_active_buyers") 
  

