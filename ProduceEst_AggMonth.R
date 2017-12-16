## ----------
## Name: ProduceEst_AggMonth.R
## Program version: R 3.3.3
## Dependencies: lme4
## Author: J.H. Belle
## Purpose: Produce daily estimates of PM2.5 from either the AOD or cloud model, aggregate values over each month to get monthly estimates of average PM2.5 using AOD model only or AOD+cloud
## ----------

# Load libraries
library(lme4)

# load model definitions
AODmod <- readRDS("/home/jhbelle/Data/mainmodela.rds")
Cloudmod <- readRDS("/home/jhbelle/Data/cloudmodela.rds")
#AODmod <- readRDS("T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/mainmodela.rds")
#Cloudmod <- readRDS("T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/cloudmodela.rds")

# Create sequence of dates to loop over
Startdate = as.Date("2003-02-01", "%Y-%m-%d")
Enddate = as.Date("2003-12-31", "%Y-%m-%d")
Days2003 = seq(Startdate, Enddate, by="day")

# Create number of day variables so can divide monthly sums of modeled values by number of days at end

Jandays=0
Febdays=0
Mardays=0
Aprdays=0
Maydays=0
Jundays=0
Juldays=0
Augdays=0
Sepdays=0
Octdays=0
Novdays=0
Decdays=0

## -------
# Procedural code
## -------

for (day in seq_along(Days2003)){
  # Get date as date
  date = Days2003[day]
  # Pull character date (%Y-%m-%d)
  chardate = as.character(date, "%Y-%m-%d")
  # Get year, month, and julian day
  Year = as.numeric(as.character(date, "%Y"))
  Month = as.character(date, "%b")
  DOY = as.numeric(as.character(date, "%j"))
  # Read data
  #CombDat = try(read.csv(sprintf("/terra/CombinedValues_Jess_GA/CombMAIACCloudNLDASGC_Text_%d%03d_A.csv", Year, DOY)))
  CombDat = try(read.csv(sprintf("/terra/CombinedValues_Jess_GA/CombMAIACCloudNLDASGC_Text_%d%03d_A.csv", Year, DOY)))
  if (is.data.frame(CombDat)){
    # Prep data for fitting
    CombDat$AOD55 = CombDat$AOD55*0.001
    CombDat$WindSpeed = sqrt(CombDat$var33.x^2 + CombDat$var34.x^2)
    CombDat$Date.Local = rep(chardate, length(CombDat$AOD55))
    # Fit AOD model
    AODpredvals = predict(AODmod, CombDat, allow.new.levels=T)
    Cloudpredvals = predict(Cloudmod, CombDat, allow.new.levels=T)
    AODCloudpred = rowMeans(cbind.data.frame(AODpredvals, Cloudpredvals), na.rm=T)
    AODpredvals = cbind.data.frame(CombDat$Input_FID, AODpredvals)
    AODCloudpred = cbind.data.frame(CombDat$Input_FID, AODCloudpred)
    # Monthly aggregations
    if (Month == "Jan"){
      Jandays=Jandays+1
      if (exists("JanAODonly") & exists("JanAODCloud")){
        JanAODonly = merge(JanAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        JanAODCloud = merge(JanAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        JanAODonly = AODpredvals
        JanAODCloud = AODCloudpred
      }
    }
    if (Month == "Feb"){
      Febdays=Febdays+1
      if (exists("FebAODonly") & exists("FebAODCloud")){
        FebAODonly = merge(FebAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        FebAODCloud = merge(FebAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        FebAODonly = AODpredvals
        FebAODCloud = AODCloudpred
      }
    }
    if (Month == "Mar"){
      Mardays=Mardays+1
      if (exists("MarAODonly") & exists("MarAODCloud")){
        MarAODonly = merge(MarAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        MarAODCloud = merge(MarAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        MarAODonly = AODpredvals
        MarAODCloud = AODCloudpred
      }
    }
    if (Month == "Apr"){
      Aprdays=Aprdays+1
      if (exists("AprAODonly") & exists("AprAODCloud")){
        AprAODonly = merge(AprAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        AprAODCloud = merge(AprAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        AprAODonly = AODpredvals
        AprAODCloud = AODCloudpred
      }
    }
    if (Month == "May"){
      Maydays=Maydays+1
      if (exists("MayAODonly") & exists("MayAODCloud")){
        MayAODonly = merge(MayAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        MayAODCloud = merge(MayAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        MayAODonly = AODpredvals
        MayAODCloud = AODCloudpred
      }
    }
    if (Month == "Jun"){
      Jundays=Jundays+1
      if (exists("JunAODonly") & exists("JunAODCloud")){
        JunAODonly = merge(JunAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        JunAODCloud = merge(JunAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        JunAODonly = AODpredvals
        JunAODCloud = AODCloudpred
      }
    }
    if (Month == "Jul"){
      Juldays=Juldays+1
      if (exists("JulAODonly") & exists("JulAODCloud")){
        JulAODonly = merge(JulAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        JulAODCloud = merge(JulAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        JulAODonly = AODpredvals
        JulAODCloud = AODCloudpred
      }
    }
    if (Month == "Aug"){
      Augdays=Augdays+1
      if (exists("AugAODonly") & exists("AugAODCloud")){
        AugAODonly = merge(AugAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        AugAODCloud = merge(AugAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        AugAODonly = AODpredvals
        AugAODCloud = AODCloudpred
      }
    }
    if (Month == "Sep"){
      Sepdays=Sepdays+1
      if (exists("SepAODonly") & exists("SepAODCloud")){
        SepAODonly = merge(SepAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        SepAODCloud = merge(SepAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        SepAODonly = AODpredvals
        SepAODCloud = AODCloudpred
      }
    }
    if (Month == "Oct"){
      Octdays=Octdays+1
      if (exists("OctAODonly") & exists("OctAODCloud")){
        OctAODonly = merge(OctAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        OctAODCloud = merge(OctAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        OctAODonly = AODpredvals
        OctAODCloud = AODCloudpred
      }
    }
    if (Month == "Nov"){
      Novdays=Novdays+1
      if (exists("NovAODonly") & exists("NovAODCloud")){
        NovAODonly = merge(NovAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        NovAODCloud = merge(NovAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        NovAODonly = AODpredvals
        NovAODCloud = AODCloudpred
      }
    }
    if (Month == "Dec"){
      Decdays=Decdays+1
      if (exists("DecAODonly") & exists("DecAODCloud")){
        DecAODonly = merge(DecAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        DecAODCloud = merge(DecAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
      } else {
        DecAODonly = AODpredvals
        DecAODCloud = AODCloudpred
      }
    }
  }
}

write.csv(JanAODonly, "/home/jhbelle/Data/JanPredVals_2003_GA.csv", row.names=F)
write.csv(JanAODCloud, "/home/jhbelle/Data/JanPredCloudVals_2003_GA.csv", row.names=F)
#JanAODonly2 = rowSums(JanAODonly[,2:Jandays+1], na.rm=T)
#JanAODCloud2 = rowSums(JanAODCloud[,2:Jandays+1], na.rm=T)
#JanAODonly2 = cbind.data.frame(JanAODonly$CombDat$Input_FID, JanAODonly2)
#colnames(JanAODonly2) <- c("Input_FID", "AODpredvals")
#JanAODCloud2 = cbind.data.frame(JanAODCloud$CombDat$InputFID, JanAODCloud2)
#colnames(JanAOCCloud2) <- c("Input_FID", "AODCloudpred")
#anOut = merge(JanAODonly2, JanAODCloud2, by="Input_FID")
#anOut$AODpredvals = JanOut$AODpredvals/Jandays
#JanOut$AODCloudpred = JanOut$AODCloudpred/Jandays
#JanOut$AbsDiff = JanOut$AODCloudpred - JanOut$AODpredvals
#JanOut$RelDiff = (2*(JanOut$AbsDiff))/(JanOut$AODpredvals + JanOut$AODCloudpred)
#summary(JanOut)
#write.csv(JanOut, "/home/jhbelle/Data/JanPredictedValues_2003_GA.csv", row.names=F)

write.csv(FebAODonly, "/home/jhbelle/Data/FebPredVals_2003_GA.csv", row.names=F)
write.csv(FebAODCloud, "/home/jhbelle/Data/FebPredCloudVals_2003_GA.csv", row.names=F)


write.csv(MarAODonly, "/home/jhbelle/Data/MarPredVals_2003_GA.csv", row.names=F)
write.csv(MarAODCloud, "/home/jhbelle/Data/MarPredCloudVals_2003_GA.csv", row.names=F)

write.csv(AprAODonly, "/home/jhbelle/Data/AprPredVals_2003_GA.csv", row.names=F)
write.csv(AprAODCloud, "/home/jhbelle/Data/AprPredCloudVals_2003_GA.csv", row.names=F)

write.csv(MayAODonly, "/home/jhbelle/Data/MayPredVals_2003_GA.csv", row.names=F)
write.csv(MayAODCloud, "/home/jhbelle/Data/MayPredCloudVals_2003_GA.csv", row.names=F)

write.csv(JunAODonly, "/home/jhbelle/Data/JunPredVals_2003_GA.csv", row.names=F)
write.csv(JunAODCloud, "/home/jhbelle/Data/JunPredCloudVals_2003_GA.csv", row.names=F)

write.csv(JulAODonly, "/home/jhbelle/Data/JulPredVals_2003_GA.csv", row.names=F)
write.csv(JulAODCloud, "/home/jhbelle/Data/JulPredCloudVals_2003_GA.csv", row.names=F)

write.csv(AugAODonly, "/home/jhbelle/Data/AugPredVals_2003_GA.csv", row.names=F)
write.csv(AugAODCloud, "/home/jhbelle/Data/AugPredCloudVals_2003_GA.csv", row.names=F)

write.csv(SepAODonly, "/home/jhbelle/Data/SepPredVals_2003_GA.csv", row.names=F)
write.csv(SepAODCloud, "/home/jhbelle/Data/SepPredCloudVals_2003_GA.csv", row.names=F)

write.csv(OctAODonly, "/home/jhbelle/Data/OctPredVals_2003_GA.csv", row.names=F)
write.csv(OctAODCloud, "/home/jhbelle/Data/OctPredCloudVals_2003_GA.csv", row.names=F)

write.csv(NovAODonly, "/home/jhbelle/Data/NovPredVals_2003_GA.csv", row.names=F)
write.csv(NovAODCloud, "/home/jhbelle/Data/NovPredCloudVals_2003_GA.csv", row.names=F)

write.csv(DecAODonly, "/home/jhbelle/Data/DecPredVals_2003_GA.csv", row.names=F)
write.csv(DecAODCloud, "/home/jhbelle/Data/DecPredCloudVals_2003_GA.csv", row.names=F)

summary(JanAODonly)
summary(JanAODCloud)
Jandays
summary(FebAODonly)
summary(FebAODCloud)
Febdays
summary(MarAODonly)
summary(MarAODCloud)
Mardays
summary(AprAODonly)
summary(AprAODCloud)
Aprdays
summary(MayAODonly)
summary(MayAODCloud)
Maydays
summary(JunAODonly)
summary(JunAODCloud)
Jundays
summary(JulAODonly)
summary(JulAODCloud)
Juldays
summary(AugAODonly)
summary(AugAODCloud)
Augdays
summary(SepAODonly)
summary(SepAODCloud)
Sepdays
summary(OctAODonly)
summary(OctAODCloud)
Octdays
summary(NovAODonly)
summary(NovAODCloud)
Novdays
summary(DecAODonly)
summary(DecAODCloud)
Decdays
