## ------------
## Name: IDW_COD.R
## Program version: R 3.3.3
## Dependencies: gstat, sp, akima, rgdal
## Function file: Functions_IDW.R
## Author: J.H. Belle; Function taken from Jianzhao Bi
## Purpose: Interpolate Cloud AOD values to the MAIAC grid
## -------------

library(gstat)
library(sp)
library(rgdal)
library(akima)
source("/home/jhbelle/Aim3Repo/Functions_IDW.R")

# ------
# Define parameters
# ------

# Location of 1 km extracted MODIS swath values
SwathLoc = "/aura/Jess_MOYD06_MOYD03_Georgia/MOD03_Extr/"

# MAIAC grid values
MAIACgrid = read.csv("/terra/Data/FinGrid/XYpoints_MAIACgrid.csv")[,c("FID", "POINT_X", "POINT_Y")]

# Define MAIAC projection - http://epsg.io/102005
MAIACproj = "+proj=eqdc +lat_0=0 +lon_0=0 +lat_1=33 +lat_2=45 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"

# Define WGS projection that the MODIS swath data is in
SwathProj = "+proj=longlat +datum=WGS84"

# Set up time steps
Startday = as.Date("2003-01-01", "%Y-%m-%d")
Endday = as.Date("2005-12-31", "%Y-%m-%d")
SeqDays = seq(Startday, Endday, by="day")

# COD scale factor 
Scale = 0.009999999776482582

# Output location
OutLoc = "/aura/Jess_MOYD06_MOYD03_Georgia/InterpCOD_Terra/"

# ------
# For each day and time stamp, interpolate values
# ------

for (day in seq_along(SeqDays)){
  date = SeqDays[day]
  # Pull year
  Year = as.numeric(as.character(date, "%Y"))
  # Pull julian day
  Jday = as.numeric(as.character(date, "%j"))
  # Read this days data
  DaysDat = try(read.csv(sprintf("%s%d/Extr_%d_%03d_S1.csv", SwathLoc, Year, Year, Jday), stringsAsFactors = F))
  if (is.data.frame(DaysDat)){
    DaysDat = DaysDat[,c("Lat", "Long", "CloudAOD", "hr", "min")]
    # Get number of distinct time stamps in day
    DaysDat$Timestamp = sprintf("%02d:%02d", DaysDat$hr, DaysDat$min)
    Timestamps = names(summary(as.factor(DaysDat$Timestamp)))
    for (timestamp in Timestamps){
      TimeDat = subset(DaysDat, DaysDat$Timestamp == timestamp)
      # Handle missings and scale COD
      TimeDat$COD = ifelse(TimeDat$CloudAOD == -9999, 0, TimeDat$CloudAOD)*Scale
      # Interpolate values
      InterpolCOD = idw.interp(xo = TimeDat$Long, yo = TimeDat$Lat, zo = TimeDat$COD, xn = MAIACgrid$POINT_X, yn = MAIACgrid$POINT_Y, projold = SwathProj, projnew = MAIACproj)
      Interpoldat = cbind.data.frame(MAIACgrid$FID, InterpolCOD)
      if (exists("Outdat")){
        Outdat = rbind.data.frame(Outdat, Interpoldat)
      } else {
        Outdat = Interpoldat
      }
    }
    write.csv(Outdat, sprintf("%sInterpolatedCOD_%d_%03d.csv", OutLoc, Year, Jday), row.names=F)
    rm(Outdat)
  }
}


