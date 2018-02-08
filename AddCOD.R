## -----------
## Name: AddCOD.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Add Interpolated Cloud AOD values to Combined files containing other variables
## -----------

# Load libraries

## ----
# Define parameters
## ----

# TA flag
TAflag = "T"

# Time 
Startdate = as.Date("2003-01-01", "%Y-%m-%d")
Enddate = as.Date("2005-12-31", "%Y-%m-%d")
SeqDates = seq(Startdate, Enddate, by="day")

# Location of Combined files
CombLoc = "/terra/CombinedValues_Jess_GA_Terra/"

# Location of interpolated COD files
InterpCODLoc = "/aura/Jess_MOYD06_MOYD03_Georgia/InterpCOD_Terra/"

## ----
# Loop over days
## ----

for (day in seq_along(SeqDates)){
  # Extract time variables from date
  Date = SeqDates[day]
  Year = as.numeric(as.character(Date, "%Y"))
  Jday = as.numeric(as.character(Date, "%j"))
  Combfile = sprintf("%sCombMAIACCloudNLDASGC_Text_%d%03d_%s.csv", CombLoc, Year, Jday, TAflag)
  # Read Combined file, if it exists
  CombDat = try(read.csv(Combfile, stringsAsFactors = F))
  if (is.data.frame(CombDat)){
    CombDat = CombDat[,1:48]
    InterpCODDat = try(read.csv(sprintf("%sInterpolatedCOD_%d_%03d.csv", InterpCODLoc, Year, Jday), stringsAsFactors = F))
    if (is.data.frame(InterpCODDat)){
      colnames(InterpCODDat) <- c("Input_FID", "x", "y", "InterpCOD")
      InterpCOD = aggregate(InterpCOD~Input_FID, InterpCODDat, max)
      CombDat = merge(CombDat, InterpCOD, by="Input_FID", all.x=T)
    } else {
      CombDat$InterpCOD = rep(NA, nrow(CombDat))
    }
    write.csv(CombDat, Combfile, row.names = F)
  }
}
