previous_saturday <- function(x){
  today_date = Sys.Date() - x
  today_date = today_date - 7 + which(format(seq(today_date - 6, by=1, length.out = 7), "%u") == 6)
  return(today_date)
}


latest_day <- function(x){
  today_date = Sys.Date()- x
  return(today_date)
}
