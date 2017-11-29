## -------
## Name: AggMAIACcalcMiss.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Aggregate MAIAC files by season to produce seasonal tabulation mapS and statistics of missing observations by QA code value
## -------

## -------
# Define these variables
## -------

Tile = "h04v00"
TAflag = "T"
Startdate = as.Date("2005-01-01", "%Y-%m-%d")
Enddate = as.Date("2005-12-31", "%Y-%m-%d")
#Enddate = as.Date("2016-12-31", "%Y-%m-%d")
Days = seq(Startdate, Enddate, by="day")
LatLonfile = read.csv("/gc_runs/Jess_Harbin/MAIAC_output/LatLong/MAIACLatlon.h04v00.csv", stringsAsFactors = F)

## ------
# Define seasons
## ------

Winter=c("Jan", "Feb", "Dec")
Fall=c("Nov", "Oct", "Sep")
Spring=c("Mar", "Apr", "May")
Summer=c("Jun", "Jul", "Aug")

## ------
# Create number of day variables so can divide total days with AOD by number of days in each season at end
## ------

Winterdays=0
Falldays=0
Springdays=0
Summerdays=0

## ------
# Procedural code
## ------

for (day in seq_along(Days)){
  # Get date as date
  date=Days[day]
  # Pull Year, Month, and day of year from date as separate variables
  Year = as.numeric(as.character(date, "%Y"))
  Month = as.character(date, "%b")
  Doy = as.numeric(as.character(date, "%j"))
  # Read MAIAC data for this day
  MAIACdat = read.csv(sprintf("/gc_runs/Jess_Harbin/MAIAC_output/%s/%d/%s/MAIAC_%sAOT_%s_%d%03d.csv", Tile, Year, TAflag, TAflag, Tile, Year, Doy))[,c("Latitude","Longitude", "AOT550")]
  # Round lat/lon to number of significant figures from my files
  # Need to round Lat to 4 digits; Lon to 3
  MAIACdat$RoundLat = round(MAIACdat$Latitude, digits=4)
  MAIACdat$RoundLon = round(MAIACdat$Longitude, digits=3)
  # Join this days MAIAC data to lat/lon file
  DaysMAIAC = merge(LatLonfile, MAIACdat, all.x=T, by.x=c("lat", "lon"), by.y=c("RoundLat", "RoundLon"))
  # Define HasAOD variable
  DaysMAIAC$HasAOD = ifelse(is.na(DaysMAIAC$AOT550, 0, 1))
  DayMAIACagg = aggregate(HasAOD~RoundLat + RoundLon, DaysMAIAC, mean)
  # Calculate number of days in each season, and add up has AOD days for each location
  if (Month %in% Winter){
    Winterdays=Winterdays+1
    if (exists("WinterAODcount")){
      WinterAODcount$HasAOD = WinterAODcount$HasAOD + DayMAIACagg$HasAOD
    } else {
      WinterAODcount = DayMAIACagg
    }
  } else if (Month %in% Fall){
    Falldays=Falldays+1
    if (exists("FallAODcount")){
      FallAODcount$HasAOD = FallAODcount$HasAOD + DayMAIACagg$HasAOD
    } else {
      FallAODcount = DayMAIACagg
    }
  } else if (Month %in% Summer){
    Summerdays=Summerdays+1
    if (exists("SummerAODcount")){
      SummerAODcount$HasAOD = SummerAODcount$HasAOD + DayMAIACagg$HasAOD
    } else {
      SummerAODcount = DayMAIACagg
    }
  } else if (Month %in% Spring){
    Springdays=Springdays+1
    if (exists("SpringAODcount")){
      SpringAODcount$HasAOD = SpringAODcount$HasAOD + DayMAIACagg$HasAOD
    } else {
      SpringAODcount = DayMAIACagg
    }
  } else print("WTF")
}
WinterAODcount$Ndays = rep(Winterdays, length(WinterAODcount$HasAOD))
WinterAODcount$Percdays = WinterAODcount$HasAOD/WinterAODcount$Ndays
write.csv(WinterAODcount, "/gc_runs/Jess_Harbin/MAIAC_output/WinterAODcounts.csv", row.names=F)

FallAODcount$Ndays = rep(Falldays, length(FallAODcount$HasAOD))
FallAODcount$Percdays = FallAODcount$HasAOD/FallAODcount$Ndays
write.csv(FallAODcount, "/gc_runs/Jess_Harbin/MAIAC_output/FallAODcounts.csv", row.names=F)

SummerAODcount$Ndays = rep(Summerdays, length(SummerAODcount$HasAOD))
SummerAODcount$Percdays = SummerAODcount$HasAOD/SummerAODcount$Ndays
write.csv(SummerAODcount, "/gc_runs/Jess_Harbin/MAIAC_output/SummerAODcounts.csv", row.names=F)

SpringAODcount$Ndays = rep(Springdays, length(SpringAODcount$HasAOD))
SpringAODcount$Percdays = SpringAODcount$HasAOD/SpringAODcount$Ndays
write.csv(SpringAODcount, "/gc_runs/Jess_Harbin/MAIAC_output/SpringAODcounts.csv", row.names=F)