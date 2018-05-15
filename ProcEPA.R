## ---------
## Name: ProcEPA.R 
## Program version: R 3.3.3
## Dependencies:
## Function file: NA
## Author: J.H. Belle
## Purpose: Create a file, as output, with a list of EPA stations and some information about them in a study area covering the state of GA
## ---------

# --------
# Function 1: SortSite - A function to create a list of observations within a study site area
#   NOTE: Study site defined using a vector of coordinates: c(Longitude west/left side, Longitude east/right side, latitude south/bottom side, latitude north/top side)
#   NOTE: Coordinates are assumed to be in the same datum and (optionally) projection as the siteDef coordinates
# --------

SiteSort <- function(dat, siteDef, datLatField="Latitude", datLonField="Longitude"){
  # dat is assumed to be a dataframe, siteDef a vector of coordinates, and datLatField/datLonField are each strings with the field names in dat that correspond to lat/long
  Outp <- subset(dat, dat[datLonField] <= siteDef[2] & dat[datLonField] >= siteDef[1] & dat[datLatField] <= siteDef[4] & dat[datLatField] >= siteDef[3])
  return(Outp)
}

#---------
# Function 2: ProcList
# --------

ProcList <- function(dat){
  Nobs = aggregate(Arithmetic.Mean ~ State.Code + County.Code + Site.Num + POC + Sample.Duration + Latitude + Longitude, dat, length)
  MedPMval = aggregate(Arithmetic.Mean ~ State.Code + County.Code + Site.Num + POC + Sample.Duration + Latitude + Longitude, dat, median)
  Outp = merge(Nobs, MedPMval, by=c("State.Code", "County.Code", "Site.Num", "POC", "Sample.Duration", "Latitude", "Longitude"))
  FirstDateObs = aggregate(Date~State.Code + County.Code + Site.Num + POC + Sample.Duration + Latitude + Longitude, dat, min)
  LastDateObs = aggregate(Date~State.Code + County.Code + Site.Num + POC + Sample.Duration + Latitude + Longitude, dat, max)
  NDays = merge(FirstDateObs, LastDateObs, by=c("State.Code", "County.Code", "Site.Num", "POC", "Sample.Duration", "Latitude", "Longitude"))
  Outp = merge(Outp, NDays, by=c("State.Code", "County.Code", "Site.Num", "POC", "Sample.Duration", "Latitude", "Longitude"))
  Outp$Ndays = as.numeric(Outp$Date.y - Outp$Date.x, "days")
  Outp$PercDays = Outp$Arithmetic.Mean.x/Outp$Ndays
  return(Outp)
}

## -----
# Define study area
## -----

GAbox = c(-85.972334, -80.447327, 29.748322, 35.408746)

## -----
# Read in EPA datasets
## -----

USFRM2003 = read.csv("T:/eohprojs/CDC_climatechange/Jess/Dissertation/EPAarchives/EPA_GroundMonitors/PM25_FRM/daily_88101_2003.csv", stringsAsFactors=F)[,c("State.Code", "County.Code", "Site.Num", "POC", "Latitude", "Longitude", "Sample.Duration", "Date.Local", "Arithmetic.Mean")]
GAFRM2003 = SiteSort(USFRM2003, GAbox)
USFRM2004 = read.csv("T:/eohprojs/CDC_climatechange/Jess/Dissertation/EPAarchives/EPA_GroundMonitors/PM25_FRM/daily_88101_2004.csv", stringsAsFactors=F)[,c("State.Code", "County.Code", "Site.Num", "POC", "Latitude", "Longitude", "Sample.Duration", "Date.Local", "Arithmetic.Mean")]
GAFRM2004 = SiteSort(USFRM2004, GAbox)
USFRM2005 = read.csv("T:/eohprojs/CDC_climatechange/Jess/Dissertation/EPAarchives/EPA_GroundMonitors/PM25_FRM/daily_88101_2005.csv", stringsAsFactors=F)[,c("State.Code", "County.Code", "Site.Num", "POC", "Latitude", "Longitude", "Sample.Duration", "Date.Local", "Arithmetic.Mean")]
GAFRM2005 = SiteSort(USFRM2005, GAbox)
USFRM2006 = read.csv("T:/eohprojs/CDC_climatechange/Jess/Dissertation/EPAarchives/EPA_GroundMonitors/PM25_FRM/daily_88101_2006.csv", stringsAsFactors=F)[,c("State.Code", "County.Code", "Site.Num", "POC", "Latitude", "Longitude", "Sample.Duration", "Date.Local", "Arithmetic.Mean")]
GAFRM2006 = SiteSort(USFRM2006, GAbox)
USFRM2007 = read.csv("T:/eohprojs/CDC_climatechange/Jess/Dissertation/EPAarchives/EPA_GroundMonitors/PM25_FRM/daily_88101_2007.csv", stringsAsFactors=F)[,c("State.Code", "County.Code", "Site.Num", "POC", "Latitude", "Longitude", "Sample.Duration", "Date.Local", "Arithmetic.Mean")]
GAFRM2007 = SiteSort(USFRM2007, GAbox)
USFRM2008 = read.csv("T:/eohprojs/CDC_climatechange/Jess/Dissertation/EPAarchives/EPA_GroundMonitors/PM25_FRM/daily_88101_2008.csv", stringsAsFactors=F)[,c("State.Code", "County.Code", "Site.Num", "POC", "Latitude", "Longitude", "Sample.Duration", "Date.Local", "Arithmetic.Mean")]
GAFRM2008 = SiteSort(USFRM2008, GAbox)
USFRM2009 = read.csv("T:/eohprojs/CDC_climatechange/Jess/Dissertation/EPAarchives/EPA_GroundMonitors/PM25_FRM/daily_88101_2009.csv", stringsAsFactors=F)[,c("State.Code", "County.Code", "Site.Num", "POC", "Latitude", "Longitude", "Sample.Duration", "Date.Local", "Arithmetic.Mean")]
GAFRM2009 = SiteSort(USFRM2009, GAbox)
rm(USFRM2003, USFRM2004, USFRM2005, USFRM2006, USFRM2007, USFRM2008, USFRM2009)

# Stack up 2003, 2004, and 2005
GAFRM = rbind.data.frame(GAFRM2003, GAFRM2004, GAFRM2005, GAFRM2006, GAFRM2007, GAFRM2008, GAFRM2009)
# Write file containing all EPA observations within study area
write.csv(GAFRM, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/GAFRM_EPAobs.csv", row.names = F)

## ------
# Create and export list of unique monitors
## ------

GAFRM$Date = as.Date(GAFRM$Date.Local, "%Y-%m-%d")
Monitors = ProcList(GAFRM)
Monitors = Monitors[which(Monitors$Ndays != 0),]
summary(Monitors)

nrow(unique(Monitors[,c("State.Code", "County.Code", "Site.Num", "POC")]))
nrow(unique(Monitors[,c("Latitude", "Longitude")]))

MonitorsUnique = unique(Monitors[,c("State.Code", "County.Code", "Site.Num", "Latitude", "Longitude")]) 
write.csv(MonitorsUnique, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/GAFRM_Monitors.csv", row.names = F)
