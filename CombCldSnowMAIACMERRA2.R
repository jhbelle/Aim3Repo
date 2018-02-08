## -----------
## Name: CombCldSnowMAIACMERRA2.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Combine MAIAC with the corresponding cloud, snow, and Merra2 values. Also add in distance to roads and percent impervious surface
## -----------

# Load libraries

## ----
# Define parameters
## ----

# Time
StartDate = as.Date("2013-01-01", "%Y-%m-%d")
EndDate = as.Date("2016-12-31", "%Y-%m-%d")
SeqDates = seq(StartDate, EndDate, by="day")

# TA flag
TAflag="A"

# MAIAC location
MAIACLoc = "/aqua/Jess_Harbin/MAIAC_output/"
MAIACtiles = c("h04v00", "h04v01")

# MAIAC grid
MAIACgrid = read.csv("/aqua/Jess_Harbin/CreateGridFin/MAIACpolys_XYpoints.csv", stringsAsFactors = F)[,c("Input_FID", "lat", "lon", "POINT_X", "POINT_Y")]

# Distance to roads
DistHighways = read.csv("/aqua/Jess_Harbin/CreateGridFin/DistHighways.csv", stringsAsFactors = F)[,c("Input_FID", "Distance")]

# Percent Impervious surface
PImperv = read.csv("/aqua/Jess_Harbin/CreateGridFin/PImperv.csv")[,c("Input_FID", "MEAN")]
DistPImp = merge(DistHighways, PImperv)

# Cloud location

# Snow location

# MERRA2 location

# Output location


## ----
# Loop over days
## ----

for (day in seq_along(SeqDates)){
  # Pull needed information from day/date
  Date = SeqDates[day]
  Year = as.numeric(as.character(Date, "%Y"))
  Jday = as.numeric(as.character(Date, "%j"))
  # Combine both MAIAC tiles
  for (tile in MAIACtiles){
    MAIACdat = try(read.csv())
    if (is.data.frame(MAIACdat)){
      
    }
  }
}