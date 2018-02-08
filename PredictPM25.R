## ----------
## Name: PredictPM25.R
## Program version: R 3.3.3
## Dependencies: mgcv, lme4
## Author: J.H. Belle
## Purpose: Predict PM2.5 concentrations on each day/overpass
## ----------

# Load libraries
library(mgcv)
library(lme4)

## ----
# Set-up
## ----

# Time stepping
StartDate = as.Date("2003-01-01", "%Y-%m-%d")
EndDate = as.Date("2003-01-05", "%Y-%m-%d")
SeqDates = seq(StartDate, EndDate, by="day")

# Location Combined Files
LocComb = "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/"

TAflag = "T"

XYpoints = read.csv("T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_StudyDefs/FinGrid/XYpoints_MAIACgrid.csv")[,c("FID", "POINT_X", "POINT_Y")]

DailyMeans = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/DailyMeans.csv")[,c("Date.Local", "DailyMean")]
DailyMeans$Date.Local = as.Date(DailyMeans$Date.Local, "%Y-%m-%d")

# Read in model definitions
AODmod = readRDS("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/AODmodTerra.rds")
Cloudmod = readRDS("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/CloudmodTerra.rds")
Harvardmod = readRDS("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/HarvmodTerra.rds")

ResidModLoc = c("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/")

# Location to send output to
LocOutp = "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/"

## ----
# Loop over days
## ----

for (day in seq_along(SeqDates)){
  # Pull date variables out
  Date = SeqDates[day]
  Year = as.numeric(as.character(Date, "%Y"))
  DOJ = as.numeric(as.character(Date, "%j"))
  Month = as.numeric(as.character(Date, "%m"))
  # Read in data
  CombDat = try(read.csv(sprintf("%sCombMAIACCloudNLDASGC_Text_%d%03d_%s.csv", LocComb, Year, DOJ, TAflag)))
  if (is.data.frame(CombDat)){
    # Remove observations with NLDAS missing - won't be predicted and mess up joins later
    CombDat = subset(CombDat, !is.na(CombDat$var33.x))
    # Set up data for making predictions
    CombDat$WindSpeed = sqrt(CombDat$var33.x^2 + CombDat$var34.x^2) 
    CombDat$AOD55 = 0.001*CombDat$AOD55
    CombDat$TempC = CombDat$var11.x - 273.15
    CombDat$DistRds = cut(CombDat$NEAR_DIST, c(-1,500,5000, 100000))
    CombDat$IndicatorFire = ifelse(CombDat$FireCount > 0, 1, 0)
    CombDat$CatPMEmiss = cut(CombDat$Count_, c(0,750, 2000))
    CombDat$IndicatorPM = ifelse(CombDat$Count_ > 0, 1, 0)
    CombDat = merge(CombDat, XYpoints, by.x="Input_FID", by.y="FID")
    CombDat$Date.Local=rep(Date, length(CombDat$AOD55))
    CombDat = merge(CombDat, DailyMeans, by="Date.Local")
    CombDat$DOY = as.numeric(as.character(CombDat$Date.Local, "%j"))
    CombDat$Month = as.numeric(as.character(CombDat$Date.Local, "%m"))
    CombDat$Season = ifelse(CombDat$Month == 1 | CombDat$Month == 12 | CombDat$Month == 2, 1, ifelse(CombDat$Month == 3 | CombDat$Month == 4 | CombDat$Month == 5, 2, ifelse(CombDat$Month == 6 | CombDat$Month == 7 | CombDat$Month == 8, 3, 4)))
    # Center variables
    CombDat$RatioXYZSulfCent = (CombDat$RatioXYZSulf - 0.60)/0.22
    CombDat$TempCCent = (CombDat$TempC-21.2)/8.3
    CombDat$RHdayCent = (CombDat$RHday - 61.7)/12.7
    CombDat$WindSpeedCent = (CombDat$WindSpeed - 4.1)/2.1
    CombDat$PBLdayCent = (CombDat$PBLday - 1331.7)/420.9
    CombDat$ElevCent = (CombDat$Elev - 178.4)/120.2
    CombDat$LocRdLenCent = (CombDat$LocRdLen - 19917)/9908
    CombDat$POINT_XCent = (CombDat$POINT_X - 1203375)
    CombDat$POINT_YCent = CombDat$POINT_Y - -523675.9
    CombDat$SWRadCent = (CombDat$var204.x - 600)/210
    CombDat$LWRadCent = (CombDat$var205 - 360)/65
    CombDat$rownames = rownames(CombDat)
    # Fit models
    # AOD - PM model
    PredPMAOD = predict(AODmod, CombDat, allow.new.levels=T)
    PredPMAOD = cbind.data.frame(names(PredPMAOD), PredPMAOD)
    colnames(PredPMAOD) <- c("rownames", "PredPMAOD")
    # Cloud model
    PredPMCloud = predict(Cloudmod, CombDat)
    PredPMCloud = cbind.data.frame(names(PredPMCloud), PredPMCloud)
    colnames(PredPMCloud) <- c("rownames", "PredPMCloud")
    PredPMCloud$PredPMCloud  = ifelse(PredPMCloud$PredPMCloud < 0, 0, PredPMCloud$PredPMCloud)
    PredPMCloud$CloudPM = PredPMCloud$PredPMCloud^2
    PredPMCloud$CloudPM = ifelse(PredPMCloud$CloudPM < 2, 2, PredPMCloud$CloudPM)
    # No Cloud model
    PredPMHarv = predict(Harvardmod, CombDat)
    PredPMHarv = cbind.data.frame(names(PredPMHarv), PredPMHarv)
    colnames(PredPMHarv) <- c("rownames", "PredPMHarv")
    PredPMHarv$PredPMHarv = ifelse(PredPMHarv$PredPMHarv < 0, 0, PredPMHarv$PredPMHarv)
    PredPMHarv$HarvPM = PredPMHarv$PredPMHarv^2
    PredPMHarv$HarvPM = ifelse(PredPMHarv$HarvPM < 2, 2, PredPMHarv$HarvPM)
    PredPM = merge(PredPMAOD, PredPMCloud)
    PredPM = merge(PredPM, PredPMHarv)
    # Load residuals model
    ResidMod = readRDS(sprintf("%sResidualmodTerra_Month%d.rds", ResidModLoc, Month))
    PredResids = predict(ResidMod, CombDat)
    PredResids = cbind.data.frame(names(PredResids), PredResids)
    colnames(PredResids) <- c("rownames", "PredResidsAOD")
    PredPM = merge(PredPM, PredResids)
    PredPM$UnGapFill = PredPM$PredPMAOD + PredPM$PredResidsAOD
    PredPM$UnGapFill = ifelse(PredPM$UnGapFill < 2, 2, PredPM$UnGapFill)
    PredPM$CloudGapFill = rowMeans(PredPM[,c("UnGapFill", "CloudPM")], na.rm=T)
    PredPM$NoCldGapFill = ifelse(is.na(PredPM$UnGapFill), PredPM$HarvPM, PredPM$UnGapFill)
    Outp = merge(CombDat, PredPM, by="rownames")
    Outp = Outp[,c("Input_FID", "TempC", "RHday", "WindSpeed", "UnGapFill", "CloudGapFill", "NoCldGapFill", "IndicatorFire")]
    write.csv(Outp, sprintf("%sPredictedValues_%d%03d_%s.csv", LocOutp, Year, DOJ, TAflag), row.names = F)
  }
}
