## ----------
## Name: AnalyzeFittingData.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Analyze the fitting dataset
## ----------

# Load libraries
library(lme4)
library(mgcv)


# Read in fitting dataset
#FittingDat <- read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/FittingData_GA_Aqua.csv", stringsAsFactors = F)
FittingDat <- read.csv("/terra/Data/FittingData_GA_Aqua.csv", stringsAsFactors = F)
#FittingDat <- read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/FittingData_GA_Terra.csv", stringsAsFactors = F)

# Clean up
FittingDat$WindSpeed = sqrt(FittingDat$var33.x^2 + FittingDat$var34.x^2) 
FittingDat$AOD55 = 0.001*FittingDat$AOD55
FittingDat$TempC = FittingDat$var11.x - 273.15
FittingDat$DistRds = cut(FittingDat$NEAR_DIST, c(-1,500,5000, 100000))
FittingDat$IndicatorFire = ifelse(FittingDat$FireCount > 0, 1, 0)
FittingDat$CatPMEmiss = cut(FittingDat$Count_, c(0,750, 2000))
FittingDat$IndicatorPM = ifelse(FittingDat$Count_ > 0, 1, 0)
FittingDat = subset(FittingDat, FittingDat$Arithmetic.Mean > 2)
XYpoints = read.csv("/terra/Data/FinGrid/XYpoints_MAIACgrid.csv")[,c("FID", "POINT_X", "POINT_Y")]
FittingDat = merge(FittingDat, XYpoints, by.x="Input_FID", by.y="FID")
FittingDat$CrossValSet = sample(1:10, length(FittingDat$Input_FID), replace=T)
FittingDat$Date.Local=as.Date(FittingDat$Date.Local, "%Y-%m-%d")
FittingDat$DOY = as.numeric(as.character(FittingDat$Date.Local, "%j"))
FittingDat$Month = as.numeric(as.character(FittingDat$Date.Local, "%m"))
FittingDat$Year = as.numeric(as.character(FittingDat$Date.Local, "%Y"))
FittingDat$Season = ifelse(FittingDat$Month == 1 | FittingDat$Month == 12 | FittingDat$Month == 2, 1, ifelse(FittingDat$Month == 3 | FittingDat$Month == 4 | FittingDat$Month == 5, 2, ifelse(FittingDat$Month == 6 | FittingDat$Month == 7 | FittingDat$Month == 8, 3, 4)))
DailyMean = aggregate(Arithmetic.Mean ~ Date.Local, FittingDat, mean)
colnames(DailyMean) <- c("Date.Local", "DailyMean")
DailyMean$DailyMean = sqrt(DailyMean$DailyMean)
FittingDat = merge(FittingDat, DailyMean, by="Date.Local", all.x=T)
FittingDat$sqrtPM = sqrt(FittingDat$Arithmetic.Mean)

# Center variables
FittingDat$RatioXYZSulfCent = (FittingDat$RatioXYZSulf - 0.59)/0.21
FittingDat$RatioXYZNitCent = (FittingDat$RatioXYZNit - 0.52)/0.32
FittingDat$TempCCent = (FittingDat$TempC-22.3)/8.6
FittingDat$RHdayCent = (FittingDat$RHday - 58.1)/14.2
FittingDat$WindSpeedCent = (FittingDat$WindSpeed - 4.2)/2.2
FittingDat$PBLdayCent = (FittingDat$PBLday - 1406.7)/478.6
FittingDat$ElevCent = (FittingDat$Elev - 171.3)/121.1
FittingDat$LocRdLenCent = (FittingDat$LocRdLen - 20137.8)/10880.4
FittingDat$rownames = rownames(FittingDat)
FittingDat$POINT_XCent = (FittingDat$POINT_X - 1175211)
FittingDat$POINT_YCent = FittingDat$POINT_Y - -551296.6
FittingDat$VisCent = (FittingDat$InterpVis - 8.15)/1.37
FittingDat$Arithmetic.Mean = ifelse(FittingDat$Arithmetic.Mean > 75, NA, FittingDat$Arithmetic.Mean)
# Fit models

for (i in seq(1,10)){
  mod = lmer(Arithmetic.Mean ~ AOD55 + RatioXYZSulfCent + RatioXYZNitCent + TempCCent + RHdayCent + WindSpeedCent + PBLdayCent + IndicatorPM + FireCount + LocRdLenCent + DistRds + VisCent + RHdayCent*TempCCent + DistRds*LocRdLenCent + (1+AOD55+TempCCent+RHdayCent+RatioXYZSulfCent+RatioXYZNitCent|Date.Local), FittingDat[FittingDat$CrossValSet!=i,])
  #mod = randomForest(Arithmetic.Mean ~ AOD55 + RatioXYZSulfCent + RatioXYZNit + TempCCent + RHdayCent + WindSpeedCent + PBLdayCent + IndicatorPM + FireCount + VisCent + Date.Local + DistRds + LocRdLenCent + ElevCent + PImperv, FittingDat[FittingDat$CrossValSet !=i,], na.action = na.omit, ntree = 200, importance=T)
  PredVals = predict(mod, FittingDat[FittingDat$CrossValSet==i,], allow.new.levels=T)
  #PredVals = predict(mod, FittingDat[FittingDat$CrossValSet==i,])
  ResidualsAOD = resid(mod)
  Rowname = as.numeric(names(ResidualsAOD))
  ResidualsAOD = cbind.data.frame(ResidualsAOD, Rowname)
  FitGAM = merge(FittingDat, ResidualsAOD, by.x="rownames", by.y="Rowname")
  #Cloud = lmer(Arithmetic.Mean ~ PM25 + InterpCOD + CE + TempCCent + var153 + RHdayCent + WindSpeedCent + ElevCent + PImperv + RatioXYZSulfCent + PBLdayCent + FireCount + IndicatorPM + DistRds + (1+TempCCent+RHdayCent+WindSpeedCent+PBLdayCent+RatioXYZSulfCent|Date.Local), FittingDat[FittingDat$CrossValSet != i,])
  Cloud = gam(sqrtPM~DailyMean + CE + InterpCOD + LocRdLenCent + PImperv + DistRds + IndicatorPM + PForst + var153 + ElevCent + TempCCent + RHdayCent + WindSpeedCent + PBLdayCent + PM25 + VisCent + DistRds*IndicatorPM + s(TempCCent, RHdayCent, bs="tp") + s(TempCCent, PBLdayCent, bs="tp") + s(POINT_XCent, POINT_YCent, bs="tp", k=15) + s(Input_FID, bs="re") + s(Input_FID, DailyMean, bs="re") + s(ElevCent, LocRdLenCent, bs="re") + s(CE, InterpCOD, bs="re") + s(PM25, VisCent) + s(var153, PForst) + s(VisCent), data=FittingDat[FittingDat$CrossValSet != i,])
  PredCloud = predict(Cloud, FittingDat[FittingDat$CrossValSet==i,])
  ResidualsCloud = resid(Cloud)
  Rowname = as.numeric(names(ResidualsCloud))
  ResidualsCloud = cbind.data.frame(ResidualsCloud, Rowname)
  FitGAM2 = merge(FittingDat, ResidualsCloud, by.x="rownames", by.y="Rowname")
  #harv = gam(sqrtPM~DailyMean + LocRdLenCent + PImperv + DistRds + IndicatorPM + ElevCent + DistRds*IndicatorPM + s(POINT_XCent, POINT_YCent, bs="tp") + s(Input_FID, bs="re") + s(Input_FID, DailyMean, bs="re") + s(ElevCent, LocRdLenCent), data=FittingDat[FittingDat$CrossValSet!=i,])
  #harv = gamm(sqrtPM~DailyMean + LocRdLenCent + DistRds + ElevCent + s(POINT_XCent, POINT_YCent, bs="tp") + s(Input_FID, bs="re") + s(Input_FID, DailyMean, bs="re"), data=FittingDat[FittingDat$CrossValSet!=i,], random=list(Year=~1, Season=~1))
 # harvpred = predict(harv$lme, FittingDat[FittingDat$CrossValSet==i,], level=0, type="response")
  if (exists("HarvardGap")){ HarvardGap = c(HarvardGap, harvpred)} else HarvardGap = harvpred
  for (year in seq(200
  for (month in seq(1,12)){
    residgam = gam(ResidualsAOD ~ s(POINT_XCent, POINT_YCent, k=25) + s(PImperv) + s(ElevCent), data=FitGAM[FitGAM$CrossValSet != i & FitGAM$Month == month,])
    predresidgam = predict(residgam, FittingDat[FittingDat$CrossValSet==i & FittingDat$Month == month,])
    if (exists("Resids")){ Resids = c(Resids, predresidgam)} else Resids = predresidgam
    #residgam2 = gam(ResidualsCloud ~ s(POINT_XCent, POINT_YCent) + s(PImperv) + s(ElevCent), data=FitGAM2[FitGAM2$CrossValSet != i & FitGAM2$Month == month,])
    #predresidgam2 = predict(residgam2, FittingDat[FittingDat$CrossValSet==i & FittingDat$Month==month,])
    #if (exists("Resids2")){ Resids2 = c(Resids2, predresidgam2)} else Resids2 = predresidgam2
    #harv = gam(sqrtPM~DailyMean + s(POINT_X, POINT_Y, bs="tp") + s(Input_FID, bs="re") + s(Input_FID, DailyMean, bs="re"), data=FittingDat[FittingDat$CrossValSet!=i && FittingDat$Month == month,])
    #harvpred = predict(harv, FittingDat[FittingDat$CrossValSet==i && FittingDat$Month == month,])
    #if (exists("HarvardGap")){ HarvardGap = c(HarvardGap, harvpred)} else HarvardGap = harvpred
  }
  if (exists("Pred")){Pred = c(Pred, PredVals)} else Pred = PredVals
  #for (season in seq(1,4)){
    #Cloud = gam(sqrtPM ~ PM25 + s(POINT_X, POINT_Y, bs="tp") + s(Input_FID, bs="re") + s(DailyMean, Input_FID) + s(InterpCOD) + CE + s(TempCCent) + s(var153) + s(RHdayCent) + s(WindSpeedCent) + s(ElevCent) + s(PImperv) + s(PBLdayCent) + FireCount + IndicatorPM + DistRds + s(TempCCent, RHdayCent) + s(InterpCOD, CE), data=FittingDat[FittingDat$CrossValSet != i && FittingDat$Season == season,])
    #PredCloud = predict(Cloud, FittingDat[FittingDat$CrossValSet==i && FittingDat$Season == season,], allow.new.levels=T)
    #if (exists("CloudGap")){CloudGap = c(CloudGap, PredCloud)} else CloudGap = PredCloud
    #harv = gam(sqrtPM~DailyMean + s(POINT_X, POINT_Y, bs="tp") + s(Input_FID, bs="re") + s(Input_FID, DailyMean, bs="re"), data=FittingDat[FittingDat$CrossValSet!=i && FittingDat$Season == season,])
    #harvpred = predict(harv, FittingDat[FittingDat$CrossValSet==i && FittingDat$Season == season,])
    #if (exists("HarvardGap")){ HarvardGap = c(HarvardGap, harvpred)} else HarvardGap = harvpred
  #}
  if (exists("CloudGap")){CloudGap = c(CloudGap, PredCloud)} else CloudGap = PredCloud
}

Pred = cbind.data.frame(names(Pred), Pred)
colnames(Pred) <- c("rownames", "Pred")
Resids = cbind.data.frame(names(Resids), Resids)
colnames(Resids) <- c("rownames", "Resids")
Pred2 = merge(Pred,Resids, by="rownames")
#Pred2$Combined = Pred2$Pred
Pred2$Combined = Pred2$Pred + Pred2$Resids
CloudPred = cbind.data.frame(names(CloudGap), CloudGap)
colnames(CloudPred) <- c("rownames", "CloudGap")
#CloudPred2 = cbind.data.frame(names(Resids2), Resids2)
#colnames(CloudPred2) <- c("rownames", "CloudResids")
#CloudPred3 = merge(CloudPred, CloudPred2, by="rownames")
#CloudPred3$CombinedCloud = CloudPred3$CloudGap + CloudPred3$CloudResids
Pred3 = merge(Pred2, CloudPred, by="rownames")
Pred3$CloudGap = Pred3$CloudGap^2
Pred3$CombinedCloud2 = rowMeans(Pred3[,c("Combined", "CloudGap")], na.rm=T)
HarvPred = cbind.data.frame(names(HarvardGap), HarvardGap)
colnames(HarvPred) <- c("rownames", "HarvardGap")
Pred4 = merge(Pred3, HarvPred, by="rownames")
Pred4$CombinedHarvard = ifelse(is.na(Pred4$Combined), Pred4$HarvardGap^2, Pred4$Combined)
CombDat = merge(FittingDat, Pred4, all.x=T)
print(summary(lm(Arithmetic.Mean ~ Combined, CombDat, na.action = "na.omit")))
print(summary(lm(Arithmetic.Mean ~ CombinedCloud2, CombDat, na.action = "na.omit")))
print(summary(lm(Arithmetic.Mean ~ CombinedHarvard, CombDat, na.action = "na.omit")))
rm(Pred, Resids, CloudGap, HarvardGap, Resids2)

# ----
# Make Plots
# ----

#library(ggplot2, lib.loc = "H://R/")

#ggplot(CombDat, aes(x=Arithmetic.Mean, y=CombinedCloud2)) + geom_bin2d(bins=50) + ylim(0,200) + xlim(0,200) + geom_abline(aes(intercept=0, slope=1), linetype=3) + geom_text(aes(x=10, y=60, label="y = -0.02 + 1.01 \n R^2=0.74")) + xlab("Ground measurement") + ylab("Predicted PM2.5 from cloud gap-filled model") + theme_classic()

#ggplot(CombDat, aes(x=Arithmetic.Mean, y=CombinedHarvard)) + geom_bin2d(bins=50) + ylim(0,200) + xlim(0,200) + geom_abline(aes(intercept=0, slope=1), linetype=3) + geom_text(aes(x=10, y=60, label="y = -0.07 + 1.02 \n R^2=0.70")) + xlab("Ground measurement") + ylab("Predicted PM2.5 from Harvard gap-filled model") + theme_classic()

# ----
# Export model definitions
# ----

#mod = lmer(Arithmetic.Mean ~ AOD55 + RatioXYZSulfCent + RatioXYZNitCent + TempCCent + RHdayCent + WindSpeedCent + PBLdayCent + IndicatorPM + FireCount + LocRdLenCent + DistRds + VisCent + RHdayCent*TempCCent + DistRds*LocRdLenCent + (1+AOD55+TempCCent+RHdayCent+RatioXYZSulfCent+RatioXYZNitCent|Date.Local), FittingDat)
#summary(mod)
#confint(mod)
#saveRDS(mod, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/AODmodAqua.rds")

#Cloud = gam(sqrtPM~DailyMean + CE + InterpCOD + LocRdLenCent + PImperv + DistRds + IndicatorPM + PForst + var153 + ElevCent + TempCCent + RHdayCent + WindSpeedCent + PBLdayCent + PM25 + VisCent + DistRds*IndicatorPM + s(TempCCent, RHdayCent, bs="tp") + s(TempCCent, PBLdayCent, bs="tp") + s(POINT_XCent, POINT_YCent, bs="tp", k=15) + s(Input_FID, bs="re") + s(Input_FID, DailyMean, bs="re") + s(ElevCent, LocRdLenCent, bs="re") + s(CE, InterpCOD, bs="re") + s(PM25, VisCent) + s(var153, PForst) + s(VisCent), data=FittingDat)
#summary(Cloud)
#saveRDS(Cloud, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/CloudmodAqua.rds")

#Harvard = gam(sqrtPM~DailyMean + LocRdLenCent + PImperv + DistRds + IndicatorPM + ElevCent + DistRds*IndicatorPM + s(POINT_XCent, POINT_YCent, bs="tp", k=15) + s(Input_FID, bs="re") + s(Input_FID, DailyMean, bs="re") + s(ElevCent, LocRdLenCent), data=FittingDat)
#summary(Harvard)
#saveRDS(Harvard, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/HarvmodAqua.rds")


#ResidualsAOD = resid(mod)
#Rowname = as.numeric(names(ResidualsAOD))
#ResidualsAOD = cbind.data.frame(ResidualsAOD, Rowname)
#FitGAM = merge(FittingDat, ResidualsAOD, by.x="rownames", by.y="Rowname")
#for (month in seq(1,12)){
#  Residuals = gam(ResidualsAOD ~ s(POINT_XCent, POINT_YCent, k=25) + s(PImperv) + s(ElevCent) + s(LocRdLenCent, NEAR_DIST), data=FitGAM[FitGAM$Month == month,])
#  print(summary(Residuals))
#  saveRDS(Residuals, sprintf("T:eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/ResidualmodAqua_Month%s.rds", month))
#}
