## -----------
## Name: Vis_IDW.R
## Program version: R 3.3.3
## Dependencies: plyr
## Author: J.H. Belle
## Purpose: Interpolate the visibility data at each overpass
## ------------

# Load libraries
library(plyr)

# ----
# Set up vars
# ----

# Station data
StationLocs = read.csv("F://NCDC/StationList.csv", stringsAsFactors = F)
StationLocs = subset(StationLocs, StationLocs$LAT > 29.8 & StationLocs$LAT < 35.6 & StationLocs$LON > -86.2 & StationLocs$LON < -80.2)
StationLocs$CTRY <- NULL
StationLocs$StationNums = sprintf("%06d-%05d", StationLocs$USAF, StationLocs$WBAN)
Stations = unique(StationLocs$StationNums)
StationLocs = StationLocs[,c("LAT", "LON", "StationNums")]

DatLoc = "F://NCDC/NCDC_US/"
Year = 2003

for (station in Stations){
  StationDat = try(read.fwf(sprintf("%s%s-%d.out", DatLoc, station, Year), widths=c(6, 6, 14, 4, 4, 4, 4, 4, 2, 2, 2, 5, 3, 3, 3, 3, 3, 3, 3, 2,5, 5, 3, 7, 6, 6, 4, 4, 6, 6, 6, 6, 3), stringsAsFactors=F, skip=1, colClasses="character"))
  if (is.data.frame(StationDat)){
    StationDat = StationDat[,c("V1", "V2", "V3", "V12")]
    colnames(StationDat) <- c("USAF", "WBAN", "DateTime", "VSB")
    StationDat$VSB = as.numeric(StationDat$VSB)
    StationDat$StationNums = sprintf("%06d-%05d", as.numeric(StationDat$USAF), as.numeric(StationDat$WBAN))
    StationDat = merge(StationLocs, StationDat, by="StationNums")
    if (exists("Dat"))
  }
  
  
}