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
#AODmod <- readRDS("/home/jhbelle/Data/mainmodela.rds")
#Cloudmod <- readRDS("/home/jhbelle/Data/cloudmodela.rds")
AODmod <- readRDS("T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/mainmodela.rds")
Cloudmod <- readRDS("T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/cloudmodela.rds")

# Create sequence of dates to loop over
Startdate = as.Date("2003-01-01", "%Y-%m-%d")
Enddate = as.Date("2003-01-05", "%Y-%m-%d")
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
  CombDat = try(read.csv(sprintf("T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/CombMAIACCloudNLDASGC_Text_%d%03d_A.csv", Year, DOY)))
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
        JanAODonly$AODpredvals = JanAODonly$AODpredvals.x + JanAODonly$AODpredvals.y
        JanAODonly$AODpredvals.x = NULL
        JanAODonly$AODpredvals.y = NULL
        JanAODCloud = merge(JanAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        JanAODCloud$AODCloudpred = JanAODCloud$AODCloudpred.x + JanAODCloud$AODCloudpred.y
        JanAODCloud$AODCloudpred.x = NULL
        JanAODCloud$AODCloudpred.y = NULL
      } else {
        JanAODonly = AODpredvals
        JanAODCloud = AODCloudpred
      }
    }
    if (Month == "Feb"){
      Febdays=Febdays+1
      if (exists("FebAODonly") & exists("FebAODCloud")){
        FebAODonly = merge(FebAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        FebAODonly$AODpredvals = FebAODonly$AODpredvals.x + FebAODonly$AODpredvals.y
        FebAODonly$AODpredvals.x = NULL
        FebAODonly$AODpredvals.y = NULL
        FebAODCloud = merge(FebAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        FebAODCloud$AODCloudpred = FebAODCloud$AODCloudpred.x + FebAODCloud$AODCloudpred.y
        FebAODCloud$AODCloudpred.x = NULL
        FebAODCloud$AODCloudpred.y = NULL
      } else {
        FebAODonly = AODpredvals
        FebAODCloud = AODCloudpred
      }
    }
    if (Month == "Mar"){
      Mardays=Mardays+1
      if (exists("MarAODonly") & exists("MarAODCloud")){
        MarAODonly = merge(MarAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        MarAODonly$AODpredvals = MarAODonly$AODpredvals.x + MarAODonly$AODpredvals.y
        MarAODonly$AODpredvals.x = NULL
        MarAODonly$AODpredvals.y = NULL
        MarAODCloud = merge(MarAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        MarAODCloud$AODCloudpred = MarAODCloud$AODCloudpred.x + MarAODCloud$AODCloudpred.y
        MarAODCloud$AODCloudpred.x = NULL
        MarAODCloud$AODCloudpred.y = NULL
      } else {
        MarAODonly = AODpredvals
        MarAODCloud = AODCloudpred
      }
    }
    if (Month == "Apr"){
      Aprdays=Aprdays+1
      if (exists("AprAODonly") & exists("AprAODCloud")){
        AprAODonly = merge(AprAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        AprAODonly$AODpredvals = AprAODonly$AODpredvals.x + AprAODonly$AODpredvals.y
        AprAODonly$AODpredvals.x = NULL
        AprAODonly$AODpredvals.y = NULL
        AprAODCloud = merge(AprAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        AprAODCloud$AODCloudpred = AprAODCloud$AODCloudpred.x + AprAODCloud$AODCloudpred.y
        AprAODCloud$AODCloudpred.x = NULL
        AprAODCloud$AODCloudpred.y = NULL
      } else {
        AprAODonly = AODpredvals
        AprAODCloud = AODCloudpred
      }
    }
    if (Month == "May"){
      Maydays=Maydays+1
      if (exists("MayAODonly") & exists("MayAODCloud")){
        MayAODonly = merge(MayAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        MayAODonly$AODpredvals = MayAODonly$AODpredvals.x + MayAODonly$AODpredvals.y
        MayAODonly$AODpredvals.x = NULL
        MayAODonly$AODpredvals.y = NULL
        MayAODCloud = merge(MayAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        MayAODCloud$AODCloudpred = MayAODCloud$AODCloudpred.x + MayAODCloud$AODCloudpred.y
        MayAODCloud$AODCloudpred.x = NULL
        MayAODCloud$AODCloudpred.y = NULL
      } else {
        MayAODonly = AODpredvals
        MayAODCloud = AODCloudpred
      }
    }
    if (Month == "Jun"){
      Jundays=Jundays+1
      if (exists("JunAODonly") & exists("JunAODCloud")){
        JunAODonly = merge(JunAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        JunAODonly$AODpredvals = JunAODonly$AODpredvals.x + JunAODonly$AODpredvals.y
        JunAODonly$AODpredvals.x = NULL
        JunAODonly$AODpredvals.y = NULL
        JunAODCloud = merge(JunAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        JunAODCloud$AODCloudpred = JunAODCloud$AODCloudpred.x + JunAODCloud$AODCloudpred.y
        JunAODCloud$AODCloudpred.x = NULL
        JunAODCloud$AODCloudpred.y = NULL
      } else {
        JunAODonly = AODpredvals
        JunAODCloud = AODCloudpred
      }
    }
    if (Month == "Jul"){
      Juldays=Juldays+1
      if (exists("JulAODonly") & exists("JulAODCloud")){
        JulAODonly = merge(JulAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        JulAODonly$AODpredvals = JulAODonly$AODpredvals.x + JulAODonly$AODpredvals.y
        JulAODonly$AODpredvals.x = NULL
        JulAODonly$AODpredvals.y = NULL
        JulAODCloud = merge(JulAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        JulAODCloud$AODCloudpred = JulAODCloud$AODCloudpred.x + JulAODCloud$AODCloudpred.y
        JulAODCloud$AODCloudpred.x = NULL
        JulAODCloud$AODCloudpred.y = NULL
      } else {
        JulAODonly = AODpredvals
        JulAODCloud = AODCloudpred
      }
    }
    if (Month == "Aug"){
      Augdays=Augdays+1
      if (exists("AugAODonly") & exists("AugAODCloud")){
        AugAODonly = merge(AugAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        AugAODonly$AODpredvals = AugAODonly$AODpredvals.x + AugAODonly$AODpredvals.y
        AugAODonly$AODpredvals.x = NULL
        AugAODonly$AODpredvals.y = NULL
        AugAODCloud = merge(AugAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        AugAODCloud$AODCloudpred = AugAODCloud$AODCloudpred.x + AugAODCloud$AODCloudpred.y
        AugAODCloud$AODCloudpred.x = NULL
        AugAODCloud$AODCloudpred.y = NULL
      } else {
        AugAODonly = AODpredvals
        AugAODCloud = AODCloudpred
      }
    }
    if (Month == "Sep"){
      Sepdays=Sepdays+1
      if (exists("SepAODonly") & exists("SepAODCloud")){
        SepAODonly = merge(SepAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        SepAODonly$AODpredvals = SepAODonly$AODpredvals.x + SepAODonly$AODpredvals.y
        SepAODonly$AODpredvals.x = NULL
        SepAODonly$AODpredvals.y = NULL
        SepAODCloud = merge(SepAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        SepAODCloud$AODCloudpred = SepAODCloud$AODCloudpred.x + SepAODCloud$AODCloudpred.y
        SepAODCloud$AODCloudpred.x = NULL
        SepAODCloud$AODCloudpred.y = NULL
      } else {
        SepAODonly = AODpredvals
        SepAODCloud = AODCloudpred
      }
    }
    if (Month == "Oct"){
      Octdays=Octdays+1
      if (exists("OctAODonly") & exists("OctAODCloud")){
        OctAODonly = merge(OctAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        OctAODonly$AODpredvals = OctAODonly$AODpredvals.x + OctAODonly$AODpredvals.y
        OctAODonly$AODpredvals.x = NULL
        OctAODonly$AODpredvals.y = NULL
        OctAODCloud = merge(OctAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        OctAODCloud$AODCloudpred = OctAODCloud$AODCloudpred.x + OctAODCloud$AODCloudpred.y
        OctAODCloud$AODCloudpred.x = NULL
        OctAODCloud$AODCloudpred.y = NULL
      } else {
        OctAODonly = AODpredvals
        OctAODCloud = AODCloudpred
      }
    }
    if (Month == "Nov"){
      Novdays=Novdays+1
      if (exists("NovAODonly") & exists("NovAODCloud")){
        NovAODonly = merge(NovAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        NovAODonly$AODpredvals = NovAODonly$AODpredvals.x + NovAODonly$AODpredvals.y
        NovAODonly$AODpredvals.x = NULL
        NovAODonly$AODpredvals.y = NULL
        NovAODCloud = merge(NovAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        NovAODCloud$AODCloudpred = NovAODCloud$AODCloudpred.x + NovAODCloud$AODCloudpred.y
        NovAODCloud$AODCloudpred.x = NULL
        NovAODCloud$AODCloudpred.y = NULL
      } else {
        NovAODonly = AODpredvals
        NovAODCloud = AODCloudpred
      }
    }
    if (Month == "Dec"){
      Decdays=Decdays+1
      if (exists("DecAODonly") & exists("DecAODCloud")){
        DecAODonly = merge(DecAODonly, AODpredvals, by="CombDat$Input_FID", all=T)
        DecAODonly$AODpredvals = DecAODonly$AODpredvals.x + DecAODonly$AODpredvals.y
        DecAODonly$AODpredvals.x = NULL
        DecAODonly$AODpredvals.y = NULL
        DecAODCloud = merge(DecAODCloud, AODCloudpred, by="CombDat$Input_FID", all=T)
        DecAODCloud$AODCloudpred = DecAODCloud$AODCloudpred.x + DecAODCloud$AODCloudpred.y
        DecAODCloud$AODCloudpred.x = NULL
        DecAODCloud$AODCloudpred.y = NULL
      } else {
        DecAODonly = AODpredvals
        DecAODCloud = AODCloudpred
      }
    }
  }
}

JanOut = merge(JanAODonly, JanAODCloud, by="CombDat$Input_FID")
JanOut$AODpredvals = JanOut$AODpredvals/Jandays
JanOut$AODCloudpred = JanOut$AODCloudpred/Jandays
JanOut$AbsDiff = JanOut$AODCloudpred = JanOut$AODpredvals
JanOut$RelDiff = (2*(JanOut$AbsDiff))/(JanOut$AODpredvals + JanOut$AODCloudpred)
summary(JanOut)
write.csv(JanOut, "/home/jhbelle/Data/JanPredictedValues_2003_GA.csv")

FebOut = merge(FebAODonly, FebAODCloud, by="CombDat$Input_FID")
FebOut$AODpredvals = FebOut$AODpredvals/Febdays
FebOut$AODCloudpred = FebOut$AODCloudpred/Febdays
FebOut$AbsDiff = FebOut$AODCloudpred = FebOut$AODpredvals
FebOut$RelDiff = (2*(FebOut$AbsDiff))/(FebOut$AODpredvals + FebOut$AODCloudpred)
summary(FebOut)
write.csv(FebOut, "/home/jhbelle/Data/FebPredictedValues_2003_GA.csv")

MarOut = merge(MarAODonly, MarAODCloud, by="CombDat$Input_FID")
MarOut$AODpredvals = MarOut$AODpredvals/Mardays
MarOut$AODCloudpred = MarOut$AODCloudpred/Mardays
MarOut$AbsDiff = MarOut$AODCloudpred = MarOut$AODpredvals
MarOut$RelDiff = (2*(MarOut$AbsDiff))/(MarOut$AODpredvals + MarOut$AODCloudpred)
summary(MarOut)
write.csv(MarOut, "/home/jhbelle/Data/MarPredictedValues_2003_GA.csv")

AprOut = merge(AprAODonly, AprAODCloud, by="CombDat$Input_FID")
AprOut$AODpredvals = AprOut$AODpredvals/Aprdays
AprOut$AODCloudpred = AprOut$AODCloudpred/Aprdays
AprOut$AbsDiff = AprOut$AODCloudpred = AprOut$AODpredvals
AprOut$RelDiff = (2*(AprOut$AbsDiff))/(AprOut$AODpredvals + AprOut$AODCloudpred)
summary(AprOut)
write.csv(AprOut, "/home/jhbelle/Data/AprPredictedValues_2003_GA.csv")

MayOut = merge(MayAODonly, MayAODCloud, by="CombDat$Input_FID")
MayOut$AODpredvals = MayOut$AODpredvals/Maydays
MayOut$AODCloudpred = MayOut$AODCloudpred/Maydays
MayOut$AbsDiff = MayOut$AODCloudpred = MayOut$AODpredvals
MayOut$RelDiff = (2*(MayOut$AbsDiff))/(MayOut$AODpredvals + MayOut$AODCloudpred)
summary(MayOut)
write.csv(MayOut, "/home/jhbelle/Data/MayPredictedValues_2003_GA.csv")

JunOut = merge(JunAODonly, JunAODCloud, by="CombDat$Input_FID")
JunOut$AODpredvals = JunOut$AODpredvals/Jundays
JunOut$AODCloudpred = JunOut$AODCloudpred/Jundays
JunOut$AbsDiff = JunOut$AODCloudpred = JunOut$AODpredvals
JunOut$RelDiff = (2*(JunOut$AbsDiff))/(JunOut$AODpredvals + JunOut$AODCloudpred)
summary(JunOut)
write.csv(JunOut, "/home/jhbelle/Data/JunPredictedValues_2003_GA.csv")

JulOut = merge(JulAODonly, JulAODCloud, by="CombDat$Input_FID")
JulOut$AODpredvals = JulOut$AODpredvals/Juldays
JulOut$AODCloudpred = JulOut$AODCloudpred/Juldays
JulOut$AbsDiff = JulOut$AODCloudpred = JulOut$AODpredvals
JulOut$RelDiff = (2*(JulOut$AbsDiff))/(JulOut$AODpredvals + JulOut$AODCloudpred)
summary(JulOut)
write.csv(JulOut, "/home/jhbelle/Data/JulPredictedValues_2003_GA.csv")

AugOut = merge(AugAODonly, AugAODCloud, by="CombDat$Input_FID")
AugOut$AODpredvals = AugOut$AODpredvals/Augdays
AugOut$AODCloudpred = AugOut$AODCloudpred/Augdays
AugOut$AbsDiff = AugOut$AODCloudpred = AugOut$AODpredvals
AugOut$RelDiff = (2*(AugOut$AbsDiff))/(AugOut$AODpredvals + AugOut$AODCloudpred)
summary(AugOut)
write.csv(AugOut, "/home/jhbelle/Data/AugPredictedValues_2003_GA.csv")

SepOut = merge(SepAODonly, SepAODCloud, by="CombDat$Input_FID")
SepOut$AODpredvals = SepOut$AODpredvals/Sepdays
SepOut$AODCloudpred = SepOut$AODCloudpred/Sepdays
SepOut$AbsDiff = SepOut$AODCloudpred = SepOut$AODpredvals
SepOut$RelDiff = (2*(SepOut$AbsDiff))/(SepOut$AODpredvals + SepOut$AODCloudpred)
summary(SepOut)
write.csv(SepOut, "/home/jhbelle/Data/SepPredictedValues_2003_GA.csv")

OctOut = merge(OctAODonly, OctAODCloud, by="CombDat$Input_FID")
OctOut$AODpredvals = OctOut$AODpredvals/Octdays
OctOut$AODCloudpred = OctOut$AODCloudpred/Octdays
OctOut$AbsDiff = OctOut$AODCloudpred = OctOut$AODpredvals
OctOut$RelDiff = (2*(OctOut$AbsDiff))/(OctOut$AODpredvals + OctOut$AODCloudpred)
summary(OctOut)
write.csv(OctOut, "/home/jhbelle/Data/OctPredictedValues_2003_GA.csv")

NovOut = merge(NovAODonly, NovAODCloud, by="CombDat$Input_FID")
NovOut$AODpredvals = NovOut$AODpredvals/Novdays
NovOut$AODCloudpred = NovOut$AODCloudpred/Novdays
NovOut$AbsDiff = NovOut$AODCloudpred = NovOut$AODpredvals
NovOut$RelDiff = (2*(NovOut$AbsDiff))/(NovOut$AODpredvals + NovOut$AODCloudpred)
summary(NovOut)
write.csv(NovOut, "/home/jhbelle/Data/NovPredictedValues_2003_GA.csv")

DecOut = merge(DecAODonly, DecAODCloud, by="CombDat$Input_FID")
DecOut$AODpredvals = DecOut$AODpredvals/Decdays
DecOut$AODCloudpred = DecOut$AODCloudpred/Decdays
DecOut$AbsDiff = DecOut$AODCloudpred = DecOut$AODpredvals
DecOut$RelDiff = (2*(DecOut$AbsDiff))/(DecOut$AODpredvals + DecOut$AODCloudpred)
summary(DecOut)
write.csv(DecOut, "/home/jhbelle/Data/DecPredictedValues_2003_GA.csv")
