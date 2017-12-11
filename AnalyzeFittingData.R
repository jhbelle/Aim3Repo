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
FittingDat$AOD55 = FittingDat$AOD55*0.001


FittingDat = subset(FittingDat, FittingDat$Arithmetic.Mean > 2)
# Fit models
mod = lmer(Arithmetic.Mean ~ AOD55 + var11.x + WindSpeed + NEI2011 + Elev + PImperv + LocRdLen + RatioXYZSulf + PBLheight + RatioXYZSulf*AOD55 + (1|Date.Local), FittingDat)
summary(mod)
confint(mod)
r.squaredGLMM(mod)

modcloud = lmer(Arithmetic.Mean ~ PM25 + CE + var11.x + var153 + WindSpeed + NEI2011 + Elev + PImperv + PSecRdLen + RatioXYZSulf + (1+PM25|Date.Local), FittingDat)
summary(modcloud)
confint(modcloud)
r.squaredGLMM(modcloud)


# Save model definitions
saveRDS(mod, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/mainmodela.rds")
saveRDS(modcloud, "T:/eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/cloudmodela.rds")
