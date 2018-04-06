## -----------
## Name: Vis_IDW.R
## Program version: R 3.3.3
## Dependencies: plyr
## Author: J.H. Belle
## Purpose: Interpolate the visibility data at each overpass
## ------------

# Load libraries
library(plyr)
library(gstat, lib.loc = "H:/R/")
library(sp)
library(rgdal, lib.loc = "H:/R/")
library(akima)
source("T:/eohprojs/CDC_climatechange/Jess/Dissertation/Aim3Repo/Functions_IDW.R")
# ----
# Define processing function
# ----

InterpolateVis <- function(datblock, projold, projnew, maiacgrid){
  # Pull datetime from datblock
  dat = aggregate(VSB~ StationNums + LAT + LON, datblock, median)
  Date = as.Date(datblock[1,"Date"], "%Y%m%d")
  Year = as.numeric(as.character(Date, "%Y"))
  DOY = as.numeric(as.character(Date, "%j"))
  maiacgrid$InterpVis = idw.interp(xo=dat$LAT, yo=dat$LON, zo=dat$VSB, xn=maiacgrid$POINT_X, maiacgrid$POINT_Y, projold=projold, projnew=projnew)[,"var1.pred"]
  write.csv(maiacgrid, sprintf("T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/InterpolatedVisibility/InterpVis_%d_%02d.csv", Year, DOY))
}

# ----
# Set up vars
# ----

# MAIAC grid values
MAIACgrid = read.csv("T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_StudyDefs/FinGrid/XYpoints_MAIACgrid.csv")[,c("FID", "POINT_X", "POINT_Y")]

# Define MAIAC projection - http://epsg.io/102005
MAIACproj = "+proj=eqdc +lat_0=0 +lon_0=0 +lat_1=33 +lat_2=45 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"

# Define WGS projection that the MODIS swath data is in
SwathProj = "+proj=longlat +datum=WGS84"


# Station data
StationLocs = read.csv("F://NCDC/StationList.csv", stringsAsFactors = F)
StationLocs = subset(StationLocs, StationLocs$LAT > 29.8 & StationLocs$LAT < 35.6 & StationLocs$LON > -86.2 & StationLocs$LON < -80.2)
StationLocs$CTRY <- NULL
StationLocs$StationNums = sprintf("%06d-%05d", StationLocs$USAF, StationLocs$WBAN)
Stations = unique(StationLocs$StationNums)
StationLocs = StationLocs[,c("LAT", "LON", "StationNums")]

DatLoc = "F://NCDC/NCDC_US/"
Year = 2009

for (station in Stations){
  StationDat = try(read.fwf(sprintf("%s%s-%d.out", DatLoc, station, Year), widths=c(6, 6, 14, 4, 4, 4, 4, 4, 2, 2, 2, 5, 3, 3, 3, 3, 3, 3, 3, 2,5, 5, 3, 7, 6, 6, 4, 4, 6, 6, 6, 6, 3), stringsAsFactors=F, skip=1, colClasses="character"))
  if (is.data.frame(StationDat)){
    StationDat = StationDat[,c("V1", "V2", "V3", "V12")]
    colnames(StationDat) <- c("USAF", "WBAN", "DateTime", "VSB")
    StationDat$VSB = as.numeric(StationDat$VSB)
    StationDat$WBAN = ifelse(StationDat$WBAN == " *****", "99999", StationDat$WBAN)
    StationDat$StationNums = sprintf("%06d-%05d", as.numeric(StationDat$USAF), as.numeric(StationDat$WBAN))
    StationDat = merge(StationLocs, StationDat, by="StationNums")
    if (exists("Dat")) { Dat = rbind.data.frame(Dat, StationDat)} else Dat = StationDat
  }
}

Dat$Date = substr(Dat$DateTime, 2, 9)
Outp = ddply(Dat, .(Date), InterpolateVis, projold=SwathProj, projnew=MAIACproj, maiacgrid=MAIACgrid)
rm(Dat)
