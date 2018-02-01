## -----------
## Name: BuffJoinFire.R
## Program version: R 3.3.3
## Dependencies: sp, rgeos, rgdal
## Data dependencies: Combined files containing other information needed for model, files containing fire spot locations over GA in a year
## Author: J.H. Belle
## Purpose: Cycle through each day, and count any fire spots at each location
## -----------

# Load libraries
library(sp)
library(rgdal, lib.loc = "H://R/")
library(rgeos)

## ----
# Set up definitions
## ----

# Time
Year = 2003
Yearstart = 1
Yearend = 365

# TA flag
TAflag = "A"

# MAIAC grid
MAIACgrid = readOGR("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_StudyDefs/FinGrid/MAIACgrid_Proj.shp", "MAIACgrid_Proj")

# Fire Spots
FireSpots = read.table("C://Users/jhbelle/Desktop/FireSpots_2003_GA_Aqua.csv", header = T, stringsAsFactors = F)

# Combined files
CombLoc = "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/"

## ----
# Loop over days in year
## ----

for (day in Yearstart:Yearend){
  # Try reading combined file
  CombDat = try(read.csv(sprintf("%sCombMAIACCloudNLDASGC_Text_%d%03d_%s.csv", CombLoc, Year, day, TAflag)))
  if (is.data.frame(CombDat)){
    DaysFires = subset(FireSpots, FireSpots$DayTAflag. == sprintf("A%d%03d", Year, day))
    if (nrow(DaysFires) == 0){
      CombDat$FireCount = rep(0, nrow(CombDat))
    } else {
      coordinates(DaysFires) = ~lonfire + latfire.
      proj4string(DaysFires) = CRS("+proj=longlat +datum=WGS84")
      DaysFires@data$FireID = seq(1, nrow(DaysFires@data))
      DaysFiresProj = spTransform(DaysFires, proj4string(MAIACgrid))
      DaysFiresBuffed = gBuffer(DaysFiresProj, byid=T, width=25000)
      ListFiresMAIAC = over(MAIACgrid, DaysFiresBuffed, returnList = T)
      if (length(ListFiresMAIAC) > 1){
        CombDat$FireCount = unlist(lapply(ListFiresMAIAC, nrow))
      } else {
        CombDat$FireCount = rep(0, nrow(CombDat))
      }
    }
  write.csv(CombDat, sprintf("%sCombMAIACCloudNLDASGC_Text_%d%03d_%s.csv", CombLoc, Year, day, TAflag))  
  }
}
