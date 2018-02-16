## --------
## Name: AggPreds.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Aggregate and calculate statistics on Predicted values for both Terra and Aqua
## --------

# Set up time stepping
StartDate = as.Date("2003-01-01", "%Y-%m-%d")
EndDate = as.Date("2003-12-31", "%Y-%m-%d")
SeqDates = seq(StartDate, EndDate, by="day")
DayCount = 0

# Set up AT loop
ATflags = c("A", "T")
ATDirs = c("/terra/PredictedValuesGA_Aqua/", "/terra/PredictedValuesGA_Terra/")

# Loop over days
for (day in seq_along(SeqDates)){
  Date = SeqDates[day]
  Year = as.numeric(as.character(Date, "%Y"))
  DOJ = as.numeric(as.character(Date, "%j"))
  # Loop over Terra/Aqua
  for (flag in seq_along(ATflags)){
    # Read in data
    PredVals = try(read.csv(sprintf("%sPredictedValues_%d%03d_%s.csv", ATDirs[flag], Year, DOJ, ATflags[flag])))
    if (is.data.frame(PredVals)){
      PredVals$DiffGapFill = PredVals$CloudGapFill - PredVals$NoCldGapFill
      PredVals$RDiffGapFill = PredVals$DiffGapFill/PredVals$NoCldGapFill
      if (exists("DaysPred")){ DaysPred=rbind.data.frame(DaysPred, PredVals) } else DaysPred = PredVals
    }
  }
  if (exists("DaysPred")){
    UnGapFill = aggregate(UnGapFill ~ Input_FID, DaysPred, mean, na.rm=T)
    CloudGapFill = aggregate(CloudGapFill ~ Input_FID, DaysPred, mean, na.rm=T)
    GapFill = merge(UnGapFill, CloudGapFill, by="Input_FID")
    NoCloudGapFill = aggregate(NoCldGapFill ~ Input_FID, DaysPred, mean, na.rm=T)
    GapFill = merge(GapFill, NoCloudGapFill, by="Input_FID")
    DiffGapFill = aggregate(DiffGapFill ~ Input_FID, DaysPred, mean, na.rm=T)
    GapFill = merge(GapFill, DiffGapFill, by="Input_FID")
    RDiffGapFill = aggregate(RDiffGapFill ~ Input_FID, DaysPred, mean, na.rm=T)
    GapFill = merge(GapFill, RDiffGapFill, by="Input_FID")
    DayCount = DayCount + 1
    if (exists("SumGapFill")){
      SumGapFillInter = merge(SumGapFill, GapFill, by="Input_FID", all=T)
      SumGapFillInter$UnGapFill = rowSums(SumGapFillInter[,c("UnGapFill.x", "UnGapFill.y")], na.rm=T)
      SumGapFillInter$CloudGapFill = rowSums(SumGapFillInter[,c("CloudGapFill.x", "CloudGapFill.y")], na.rm=T)
      SumGapFillInter$NoCldGapFill = rowSums(SumGapFillInter[,c("NoCldGapFill.x", "NoCldGapFill.y")], na.rm=T)
      SumGapFillInter$DiffGapFill = rowSums(SumGapFillInter[,c("DiffGapFill.x", "DiffGapFill.y")], na.rm=T)
      SumGapFillInter$RDiffGapFill = rowSums(SumGapFillInter[,c("RDiffGapFill.x", "RDiffGapFill.y")], na.rm=T)
      SumGapFill = SumGapFillInter[,c("Input_FID", "UnGapFill", "CloudGapFill", "NoCldGapFill", "DiffGapFill", "RDiffGapFill")]
    } else SumGapFill = GapFill
  }
  rm(DaysPred)
}

SumGapFill$UnGapFill = SumGapFill$UnGapFill/DayCount
SumGapFill$CloudGapFill = SumGapFill$CloudGapFill/DayCount
SumGapFill$NoCldGapFill = SumGapFill$NoCldGapFill/DayCount
SumGapFill$DiffGapFill = SumGapFill$DiffGapFill/DayCount
SumGapFill$RDiffGapFill = SumGapFill$RDiffGapFill/DayCount

write.csv(SumGapFill, "/terra/Data/GapFillAggregateResults.csv")
