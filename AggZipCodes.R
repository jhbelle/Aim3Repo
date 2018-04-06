## ----------
## Name: AggZipCodes.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Aggregate the Terra and Aqua predictions together and then take the mean 24-hr PM2.5 concentration at each GA zip code for each day
## ----------

# Set up time stepping
StartDate = as.Date("2005-12-18", "%Y-%m-%d")
EndDate = as.Date("2005-12-31", "%Y-%m-%d")
SeqDates = seq(StartDate, EndDate, by="day")

# Set up AT loop
ATflags = c("A", "T")
ATDirs = c("/terra/PredictedValuesGA_Aqua/", "/terra/PredictedValuesGA_Terra/")

# MAIAC input_fid to zip code file
InputFID_to_ZCTA <- read.csv("/terra/Data/InputFID_to_ZCTA.csv", stringsAsFactors = F)[,c("FID", "ZCTA5CE10")]
colnames(InputFID_to_ZCTA) <- c("Input_FID", "ZipCode")
InputFID_to_ZCTA <- subset(InputFID_to_ZCTA, !is.na(InputFID_to_ZCTA$ZipCode))

# Output location
OutpLoc = "/terra/AggregatedValuesGA/"

# Loop over time
for (day in seq_along(SeqDates)){
  Date = SeqDates[day]
  Year = as.numeric(as.character(Date, "%Y"))
  DOJ = as.numeric(as.character(Date, "%j"))
  # Loop over T/A
  for (flag in seq_along(ATflags)){
    PredVals = try(read.csv(sprintf("%sPredictedValues_%d%03d_%s.csv", ATDirs[flag], Year, DOJ, ATflags[flag])))
    if (is.data.frame(PredVals)){
      PredVals = merge(PredVals, InputFID_to_ZCTA, by="Input_FID")
      if (exists("DaysPred")){ DaysPred=rbind.data.frame(DaysPred, PredVals)} else DaysPred=PredVals
    }
  }
  if (exists("DaysPred")){
    if (nrow(DaysPred) > 0){
      UnGapFill = aggregate(UnGapFill ~ ZipCode, DaysPred, mean, na.rm=T)
      CloudGapFill = aggregate(CloudGapFill ~ ZipCode, DaysPred, mean, na.rm=T)
      GapFill = merge(UnGapFill, CloudGapFill, by="ZipCode", all=T)
      NoCldGapFill = aggregate(NoCldGapFill ~ ZipCode, DaysPred, mean, na.rm=T)
      GapFill = merge(GapFill, NoCldGapFill, by="ZipCode", all=T)
      Temperature = aggregate(TempC ~ ZipCode, DaysPred, mean, na.rm=T)
      GapFill = merge(GapFill, Temperature, by="ZipCode", all=T)
      WindSpeed = aggregate(WindSpeed ~ ZipCode, DaysPred, mean, na.rm=T)
      GapFill = merge(GapFill, WindSpeed, by="ZipCode", all=T)
      RH = aggregate(RHday ~ ZipCode, DaysPred, mean, na.rm=T)
      GapFill = merge(GapFill, RH, by="ZipCode", all=T)
      IndicatorFire = aggregate(IndicatorFire ~ ZipCode, DaysPred, max, na.rm=T)
      GapFill = merge(GapFill, IndicatorFire, by="ZipCode", all=T)
      DaysPred$IndicatorCloud = ifelse(is.na(DaysPred$UnGapFill), 1, 0)
      IndicatorCloudy = aggregate(IndicatorCloud ~ ZipCode, DaysPred, mean, na.rm=T)
      GapFill = merge(GapFill, IndicatorCloudy, by="ZipCode", all=T)
      write.csv(GapFill, sprintf("%sAggregatedPredictions_%d%03d.csv", OutpLoc, Year, DOJ))
  
    }
  }
  rm(DaysPred)
}
