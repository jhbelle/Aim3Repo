## -----------
## Name: PrepPredVals.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Edit aggregated predited values - aggregate over month and produce difference statistics
## -----------

# January
JanPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/JanPredVals_2003_GA.csv", stringsAsFactors = F)
JanPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/JanPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = JanPredVals$CombDat.Input_FID
JanAODPred = rowMeans(JanPredVals[,2:32], na.rm=T)
JanCloudPred = rowMeans(JanPredCloud[,2:32], na.rm=T)

JanOut = cbind.data.frame(Input_FID, JanAODPred, JanCloudPred)
JanOut$AbsDiff = JanOut$JanCloudPred - JanOut$JanAODPred
JanOut$RelDiff = 2*(JanOut$AbsDiff)/(JanOut$JanCloudPred + JanOut$JanAODPred)
summary(JanOut)
write.csv(JanOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Janout_2003_GA.csv", row.names = F)

# February
FebPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/FebPredVals_2003_GA.csv", stringsAsFactors = F)
FebPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/FebPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = FebPredVals$CombDat.Input_FID
FebAODPred = rowMeans(FebPredVals[,2:length(FebPredVals)], na.rm=T)
FebCloudPred = rowMeans(FebPredCloud[,2:length(FebPredVals)], na.rm=T)

FebOut = cbind.data.frame(Input_FID, FebAODPred, FebCloudPred)
FebOut$AbsDiff = FebOut$FebCloudPred - FebOut$FebAODPred
FebOut$RelDiff = 2*(FebOut$AbsDiff)/(FebOut$FebCloudPred + FebOut$FebAODPred)
summary(FebOut)
write.csv(FebOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Febout_2003_GA.csv", row.names = F)


# March
MarPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/MarPredVals_2003_GA.csv", stringsAsFactors = F)
MarPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/MarPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = MarPredVals$CombDat.Input_FID
MarAODPred = rowMeans(MarPredVals[,2:length(MarPredVals)], na.rm=T)
MarCloudPred = rowMeans(MarPredCloud[,2:length(MarPredVals)], na.rm=T)

MarOut = cbind.data.frame(Input_FID, MarAODPred, MarCloudPred)
MarOut$AbsDiff = MarOut$MarCloudPred - MarOut$MarAODPred
MarOut$RelDiff = 2*(MarOut$AbsDiff)/(MarOut$MarCloudPred + MarOut$MarAODPred)
summary(MarOut)
write.csv(MarOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Marout_2003_GA.csv", row.names = F)

# April 

AprPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/AprPredVals_2003_GA.csv", stringsAsFactors = F)
AprPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/AprPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = AprPredVals$CombDat.Input_FID
AprAODPred = rowMeans(AprPredVals[,2:length(AprPredVals)], na.rm=T)
AprCloudPred = rowMeans(AprPredCloud[,2:length(AprPredVals)], na.rm=T)

AprOut = cbind.data.frame(Input_FID, AprAODPred, AprCloudPred)
AprOut$AbsDiff = AprOut$AprCloudPred - AprOut$AprAODPred
AprOut$RelDiff = 2*(AprOut$AbsDiff)/(AprOut$AprCloudPred + AprOut$AprAODPred)
summary(AprOut)
write.csv(AprOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Aprout_2003_GA.csv", row.names = F)


# May
MayPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/MayPredVals_2003_GA.csv", stringsAsFactors = F)
MayPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/MayPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = MayPredVals$CombDat.Input_FID
MayAODPred = rowMeans(MayPredVals[,2:length(MayPredVals)], na.rm=T)
MayCloudPred = rowMeans(MayPredCloud[,2:length(MayPredVals)], na.rm=T)

MayOut = cbind.data.frame(Input_FID, MayAODPred, MayCloudPred)
MayOut$AbsDiff = MayOut$MayCloudPred - MayOut$MayAODPred
MayOut$RelDiff = 2*(MayOut$AbsDiff)/(MayOut$MayCloudPred + MayOut$MayAODPred)
summary(MayOut)
write.csv(MayOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Mayout_2003_GA.csv", row.names = F)

# June
JunPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/JunPredVals_2003_GA.csv", stringsAsFactors = F)
JunPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/JunPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = JunPredVals$CombDat.Input_FID
JunAODPred = rowMeans(JunPredVals[,2:length(JunPredVals)], na.rm=T)
JunCloudPred = rowMeans(JunPredCloud[,2:length(JunPredVals)], na.rm=T)

JunOut = cbind.data.frame(Input_FID, JunAODPred, JunCloudPred)
JunOut$AbsDiff = JunOut$JunCloudPred - JunOut$JunAODPred
JunOut$RelDiff = 2*(JunOut$AbsDiff)/(JunOut$JunCloudPred + JunOut$JunAODPred)
summary(JunOut)
write.csv(JunOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Junout_2003_GA.csv", row.names = F)

# July
JulPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/JulPredVals_2003_GA.csv", stringsAsFactors = F)
JulPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/JulPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = JulPredVals$CombDat.Input_FID
JulAODPred = rowMeans(JulPredVals[,2:length(JulPredVals)], na.rm=T)
JulCloudPred = rowMeans(JulPredCloud[,2:length(JulPredVals)], na.rm=T)

JulOut = cbind.data.frame(Input_FID, JulAODPred, JulCloudPred)
JulOut$AbsDiff = JulOut$JulCloudPred - JulOut$JulAODPred
JulOut$RelDiff = 2*(JulOut$AbsDiff)/(JulOut$JulCloudPred + JulOut$JulAODPred)
summary(JulOut)
write.csv(JulOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Julout_2003_GA.csv", row.names = F)

# August
AugPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/AugPredVals_2003_GA.csv", stringsAsFactors = F)
AugPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/AugPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = AugPredVals$CombDat.Input_FID
AugAODPred = rowMeans(AugPredVals[,2:length(AugPredVals)], na.rm=T)
AugCloudPred = rowMeans(AugPredCloud[,2:length(AugPredVals)], na.rm=T)

AugOut = cbind.data.frame(Input_FID, AugAODPred, AugCloudPred)
AugOut$AbsDiff = AugOut$AugCloudPred - AugOut$AugAODPred
AugOut$RelDiff = 2*(AugOut$AbsDiff)/(AugOut$AugCloudPred + AugOut$AugAODPred)
summary(AugOut)
write.csv(AugOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Augout_2003_GA.csv", row.names = F)

# September 
SepPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/SepPredVals_2003_GA.csv", stringsAsFactors = F)
SepPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/SepPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = SepPredVals$CombDat.Input_FID
SepAODPred = rowMeans(SepPredVals[,2:length(SepPredVals)], na.rm=T)
SepCloudPred = rowMeans(SepPredCloud[,2:length(SepPredVals)], na.rm=T)

SepOut = cbind.data.frame(Input_FID, SepAODPred, SepCloudPred)
SepOut$AbsDiff = SepOut$SepCloudPred - SepOut$SepAODPred
SepOut$RelDiff = 2*(SepOut$AbsDiff)/(SepOut$SepCloudPred + SepOut$SepAODPred)
summary(SepOut)
write.csv(SepOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Sepout_2003_GA.csv", row.names = F)


# October
OctPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/OctPredVals_2003_GA.csv", stringsAsFactors = F)
OctPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/OctPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = OctPredVals$CombDat.Input_FID
OctAODPred = rowMeans(OctPredVals[,2:length(OctPredVals)], na.rm=T)
OctCloudPred = rowMeans(OctPredCloud[,2:length(OctPredVals)], na.rm=T)

OctOut = cbind.data.frame(Input_FID, OctAODPred, OctCloudPred)
OctOut$AbsDiff = OctOut$OctCloudPred - OctOut$OctAODPred
OctOut$RelDiff = 2*(OctOut$AbsDiff)/(OctOut$OctCloudPred + OctOut$OctAODPred)
summary(OctOut)
write.csv(OctOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Octout_2003_GA.csv", row.names = F)


# November
NovPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/NovPredVals_2003_GA.csv", stringsAsFactors = F)
NovPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/NovPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = NovPredVals$CombDat.Input_FID
NovAODPred = rowMeans(NovPredVals[,2:length(NovPredVals)], na.rm=T)
NovCloudPred = rowMeans(NovPredCloud[,2:length(NovPredVals)], na.rm=T)

NovOut = cbind.data.frame(Input_FID, NovAODPred, NovCloudPred)
NovOut$AbsDiff = NovOut$NovCloudPred - NovOut$NovAODPred
NovOut$RelDiff = 2*(NovOut$AbsDiff)/(NovOut$NovCloudPred + NovOut$NovAODPred)
summary(NovOut)
write.csv(NovOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Novout_2003_GA.csv", row.names = F)


# December
DecPredVals = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/DecPredVals_2003_GA.csv", stringsAsFactors = F)
DecPredCloud = read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/DecPredCloudVals_2003_GA.csv", stringsAsFactors = F)

Input_FID = DecPredVals$CombDat.Input_FID
DecAODPred = rowMeans(DecPredVals[,2:length(DecPredVals)], na.rm=T)
DecCloudPred = rowMeans(DecPredCloud[,2:length(DecPredVals)], na.rm=T)

DecOut = cbind.data.frame(Input_FID, DecAODPred, DecCloudPred)
DecOut$AbsDiff = DecOut$DecCloudPred - DecOut$DecAODPred
DecOut$RelDiff = 2*(DecOut$AbsDiff)/(DecOut$DecCloudPred + DecOut$DecAODPred)
summary(DecOut)
write.csv(DecOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Decout_2003_GA.csv", row.names = F)
