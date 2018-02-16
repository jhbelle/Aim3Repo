## ----------
## Name: AggZipCodes.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Aggregate the Terra and Aqua predictions together and then take the mean 24-hr PM2.5 concentration at each GA zip code for each day
## ----------

# Set up time stepping
StartDate = as.Date("2003-01-01", "%Y-%m-%d")
EndDate = as.Date("2003-01-01", "%Y-%m-%d")
SeqDates = seq(StartDate, EndDate, by="day")

# Set up AT loop
ATflags = c("A", "T")
ATDirs = c("/terra/PredictedValuesGA_Aqua/", "/terra/PredictedValuesGA_Terra")

# MAIAC input_fid to zip code file

# Output location

# Loop over time
for (day in seq_along(SeqDates)){
  Date = SeqDates[day]
  Year = as.numeric(as.character(Date, "%Y"))
  DOJ = as.numeric(as.character(Date, "%j"))
  # Loop over T/A
  for (flag in seq_along(ATflags)){
    PredVals = try(read.csv(sprintf("%sPredictedValues_%d%03d_%s.csv", ATDirs[flag], Year, DOJ, ATflags[flag])))
    if (is.data.frame(PredVals)){
      PredVals = merge()
      if (exists("DaysPred")){ DaysPred=rbind.data.frame(DaysPred, PredVals)} else DaysPred=PredVals
    }
  }
  if (exists("DaysPred")){
    UnGapFill = aggregate(UnGapFill ~ ZipCode, DaysPred, mean, na.rm=T)
    CloudGapFill = aggregate(CloudGapFill ~ ZipCode, DaysPred, mean, na.rm=T)
    GapFill = merge(UnGapFill, CloudGapFill, by="ZipCode")
    NoCldGapFill = aggregate(NoCldGapFill ~ ZipCode, DaysPred, mean, na.rm=T)
    GapFill = merge(GapFill, NoCldGapFill, by="ZipCode")
    Temperature = aggregate(TempC ~ ZipCode, DaysPred, mean, na.rm=T)
    GapFill = merge(GapFill, Temperature, by="ZipCode")
    WindSpeed = aggregate(WindSpeed ~ ZipCode, DaysPred, mean, na.rm=T)
    GapFill = merge(GapFill, WindSpeed, by="ZipCode")
    RH = aggregate(RHday ~ ZipCode, DaysPred, mean, na.rm=T)
    GapFill = merge(GapFill, RH, by="ZipCode")
    IndicatorFire = aggregate(IndicatorFire ~ ZipCode, DaysPred, max, na.rm=T)
    GapFill = merge(GapFill, IndicatorFire, by="ZipCode")
    write.csv(GapFill, sprintf("%s"))
  }
  rm(DaysPred)
}