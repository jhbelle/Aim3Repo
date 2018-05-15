## ----------
## Name: AddVis.R
## Program version: R 3.3.3
## Dependencies: none
## Author: J.H. Belle
## Purpose: Add Visibility data into Combined files at the Georgia site
## ----------

StartDate = as.Date("2003-01-01", "%Y-%m-%d")
EndDate = as.Date("2009-12-31", "%Y-%m-%d")
SeqDates = seq(StartDate, EndDate, by="day")

# Terra/Aqua flag
TAflag = "A"

# Location of combined files
CombLoc = "/terra/CombinedValues_Jess_GA_Aqua/"

# Visibility data location
VisLoc = "/terra/InterpolatedVisibility/"

for (day in seq_along(SeqDates)){
  # Extract time variables from date
  Date = SeqDates[day]
  Year = as.numeric(as.character(Date, "%Y"))
  Jday = as.numeric(as.character(Date, "%j"))
  Combfile = sprintf("%sCombMAIACCloudNLDASGC_Text_%d%03d_%s.csv", CombLoc, Year, Jday, TAflag)
  CombDat = try(read.csv(Combfile, stringsAsFactors = F))
  if (is.data.frame(CombDat)){
    VisDat = try(read.csv(sprintf("%sInterpVis_%d_%02d.csv", VisLoc, Year, Jday), stringsAsFactors=F))
    if (is.data.frame(VisDat)){
      VisDat = VisDat[,c("FID", "InterpVis")]
      colnames(VisDat) <- c("Input_FID", "InterpVis")
      Vis = aggregate(InterpVis~Input_FID, VisDat, max)
      CombDat = merge(CombDat, Vis, all.x=T, by="Input_FID")
    } else {
      CombDat$InterpVis = rep(NA, nrow(CombDat))
    }
    write.csv(CombDat, Combfile, row.names = F)
  }
}
