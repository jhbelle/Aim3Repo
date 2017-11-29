## -----------
## Name: CalcPercSnowMonth.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Calculate the percentage of days in each pixel with snow in the MODIS snow product
## -----------

# Get list of directories to iterate over

ListDirs = list.dirs("/aqua/Jess_Harbin/SnowProduct/Aqua")
ListDirs = ListDirs[2:length(ListDirs)]

# Set number of days in each month to 0 for both of the two possible tiles, h26v04 and h27v04
Jandays=c(0,0)
Febdays=c(0,0)
Mardays=c(0,0)
Aprdays=c(0,0)
Maydays=c(0,0)
Jundays=c(0,0)
Juldays=c(0,0)
Augdays=c(0,0)
Sepdays=c(0,0)
Octdays=c(0,0)
Novdays=c(0,0)
Decdays=c(0,0)

## -----
# Procedural code
## -----

for (Dir in ListDirs){
  # The file we're interested in is the third file
  file = list.files(path=Dir, pattern="M[YO]D10A1_A*")[3]
  # Pull year, day, date, month, and tile out of filename
  year = as.numeric(substr(file, 10,13))
  day = as.numeric(substr(file, 14,16))
  date = as.Date(paste(year, day), "%Y %j")
  month = as.character(date, "%b")
  tile = substr(file, 18, 23)
  # 
  
  
}