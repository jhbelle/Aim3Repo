## ----------
## Name: AnalyzeFittingData.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Analyze the fitting dataset
## ----------

# Load libraries
library(lme4)
library(piecewiseSEM)
library(MuMIn)

# Read in fitting dataset
FittingDat <- read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/FittingData_GA_Aqua.csv", stringsAsFactors = F)
summary(FittingDat)

# Clean up
FittingDat$WindSpeed = sqrt(FittingDat$var33.x^2 + FittingDat$var34.x^2) 
#FittingDat$AOD55 = ifelse(FittingDat$AOD55 == -28672, NA, ifelse(FittingDat$AOD55 < 0, 0.001*(FittingDat$AOD55*2 - -28672), FittingDat$AOD55*0.001))
FittingDat$AOD55 = 0.001*FittingDat$AOD55

FittingDat = subset(FittingDat, FittingDat$Arithmetic.Mean > 2)
# Fit models
mod = lmer(Arithmetic.Mean ~ AOD55 + var11.x + var51.x + WindSpeed + Elev + PImperv + PSecRdLen + LocRdLen + PForst + RatioXYZSulf + PBLheight + (1+AOD55|Date.Local), FittingDat)
#mod = lmer(Arithmetic.Mean ~ AOD55 + PImperv + (1+AOD55|Date.Local), FittingDat)
summary(mod)
confint(mod)
r.squaredGLMM(mod)

modcloud = lmer(Arithmetic.Mean ~ PM25 + CE + var11.x + var153 + var51.x + var204.x + WindSpeed + Elev + PImperv + RatioXYZSulf + (1+PM25|Date.Local), FittingDat)
summary(modcloud)
confint(modcloud)
r.squaredGLMM(modcloud)


# Save model definitions
saveRDS(mod, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/mainmodela.rds")
saveRDS(modcloud, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/cloudmodela.rds")


# Fit GAM's to model residuals
# Add in XY point values
XYpoints = read.csv("T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_StudyDefs/FinGrid/XYpoints_MAIACgrid.csv")[,c("FID", "POINT_X", "POINT_Y")]
FittingDat = merge(FittingDat, XYpoints, by.x="Input_FID", by.y="FID")

library(mgcv)
ResidualsAOD = resid(mod)
Rowname = as.numeric(names(ResidualsAOD))
ResidualsAOD = cbind.data.frame(ResidualsAOD, Rowname)

FittingDatRowname = as.numeric(rownames(FittingDat))
FittingDat = cbind.data.frame(FittingDat, FittingDatRowname)
FittingDat = merge(FittingDat, ResidualsAOD, by.x="FittingDatRowname", by.y="Rowname")

ResidualsCloud = resid(modcloud)
Rowname = as.numeric(names(ResidualsCloud))
ResidualsCloud = cbind.data.frame(ResidualsCloud, Rowname)

FittingDat = merge(FittingDat, ResidualsCloud, by.x="FittingDatRowname", by.y="Rowname")
FittingDat$Month = as.numeric(as.character(as.Date(FittingDat$Date.Local, "%Y-%m-%d"), "%m"))

ResidModelAODWinter = gam(ResidualsAOD ~ s(POINT_X, POINT_Y) + s(PImperv), data=FittingDat[FittingDat$Month == 1 | FittingDat$Month == 2 | FittingDat$Month == 12,])
summary(ResidModelAODWinter)
saveRDS(ResidModelAODWinter, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/ResidModelAODWinter.rds")


ResidModelAODSpring = gam(ResidualsAOD ~ s(POINT_X, POINT_Y) + s(PImperv), data=FittingDat[FittingDat$Month == 3 | FittingDat$Month == 4 | FittingDat$Month == 5,])
summary(ResidModelAODSpring)
saveRDS(ResidModelAODSpring, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/ResidModelAODSpring.rds")

ResidModelAODSummer = gam(ResidualsAOD ~ s(POINT_X, POINT_Y) + s(PImperv), data=FittingDat[FittingDat$Month == 6 | FittingDat$Month == 7 | FittingDat$Month == 8,])
summary(ResidModelAODSummer)
saveRDS(ResidModelAODSummer, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/ResidModelAODSummer.rds")

ResidModelAODFall = gam(ResidualsAOD ~ s(POINT_X, POINT_Y) + s(PImperv), data=FittingDat[FittingDat$Month == 9 | FittingDat$Month == 10 | FittingDat$Month == 11,])
summary(ResidModelAODFall)
saveRDS(ResidModelAODFall, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/ResidModelAODFall.rds")

ResidModelCloudWinter = gam(ResidualsCloud ~ s(POINT_X, POINT_Y) + s(PImperv), data=FittingDat[FittingDat$Month== 1 | FittingDat$Month == 2 | FittingDat$Month==12,])
summary(ResidModelCloudWinter)
saveRDS(ResidModelCloudWinter, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/ResidModelCloudWinter.rds")

ResidModelCloudSpring = gam(ResidualsCloud ~ s(POINT_X, POINT_Y) + s(PImperv), data=FittingDat[FittingDat$Month== 3 | FittingDat$Month == 4 | FittingDat$Month == 5,])
summary(ResidModelCloudSpring)
saveRDS(ResidModelCloudSpring, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/ResidModelCloudSpring.rds")

ResidModelCloudSummer = gam(ResidualsCloud ~ s(POINT_X, POINT_Y) + s(PImperv), data=FittingDat[FittingDat$Month== 6 | FittingDat$Month == 7 | FittingDat$Month == 8,])
summary(ResidModelCloudSummer)
saveRDS(ResidModelCloudSummer, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/ResidModelCloudSummer.rds")

ResidModelCloudFall = gam(ResidualsCloud ~ s(POINT_X, POINT_Y) + s(PImperv), data=FittingDat[FittingDat$Month== 9 | FittingDat$Month == 10 | FittingDat$Month == 11,])
summary(ResidModelCloudFall)
saveRDS(ResidModelCloudFall, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/ResidModelCloudFall.rds")


## ---------
# 10 fold cross-validation
## ---------


