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
JanOut = subset(JanOut, !(is.na(JanOut$JanCloudPred) & is.na(JanOut$JanAODPred)))
JanOut$JanAODPred = ifelse(is.na(JanOut$JanAODPred), -1300, JanOut$JanAODPred)
JanOut$AbsDiff = ifelse(is.na(JanOut$AbsDiff), -1300, JanOut$AbsDiff)
JanOut$RelDiff = ifelse(is.na(JanOut$RelDiff), -1300, JanOut$RelDiff)
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
FebOut = subset(FebOut, !(is.na(FebOut$FebCloudPred) & is.na(FebOut$FebAODPred)))
FebOut$FebAODPred = ifelse(is.na(FebOut$FebAODPred), -1300, FebOut$FebAODPred)
FebOut$AbsDiff = ifelse(is.na(FebOut$AbsDiff), -1300, FebOut$AbsDiff)
FebOut$RelDiff = ifelse(is.na(FebOut$RelDiff), -1300, FebOut$RelDiff)
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
MarOut = subset(MarOut, !(is.na(MarOut$MarCloudPred) & is.na(MarOut$MarAODPred)))
MarOut$MarAODPred = ifelse(is.na(MarOut$MarAODPred), -1300, MarOut$MarAODPred)
MarOut$AbsDiff = ifelse(is.na(MarOut$AbsDiff), -1300, MarOut$AbsDiff)
MarOut$RelDiff = ifelse(is.na(MarOut$RelDiff), -1300, MarOut$RelDiff)
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
AprOut = subset(AprOut, !(is.na(AprOut$AprCloudPred) & is.na(AprOut$AprAODPred)))
AprOut$AprAODPred = ifelse(is.na(AprOut$AprAODPred), -1300, AprOut$AprAODPred)
AprOut$AbsDiff = ifelse(is.na(AprOut$AbsDiff), -1300, AprOut$AbsDiff)
AprOut$RelDiff = ifelse(is.na(AprOut$RelDiff), -1300, AprOut$RelDiff)
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
MayOut = subset(MayOut, !(is.na(MayOut$MayCloudPred) & is.na(MayOut$MayAODPred)))
MayOut$MayAODPred = ifelse(is.na(MayOut$MayAODPred), -1300, MayOut$MayAODPred)
MayOut$AbsDiff = ifelse(is.na(MayOut$AbsDiff), -1300, MayOut$AbsDiff)
MayOut$RelDiff = ifelse(is.na(MayOut$RelDiff), -1300, MayOut$RelDiff)
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
JunOut = subset(JunOut, !(is.na(JunOut$JunCloudPred) & is.na(JunOut$JunAODPred)))
JunOut$JunAODPred = ifelse(is.na(JunOut$JunAODPred), -1300, JunOut$JunAODPred)
JunOut$AbsDiff = ifelse(is.na(JunOut$AbsDiff), -1300, JunOut$AbsDiff)
JunOut$RelDiff = ifelse(is.na(JunOut$RelDiff), -1300, JunOut$RelDiff)
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
JulOut = subset(JulOut, !(is.na(JulOut$JulCloudPred) & is.na(JulOut$JulAODPred)))
JulOut$JulAODPred = ifelse(is.na(JulOut$JulAODPred), -1300, JulOut$JulAODPred)
JulOut$AbsDiff = ifelse(is.na(JulOut$AbsDiff), -1300, JulOut$AbsDiff)
JulOut$RelDiff = ifelse(is.na(JulOut$RelDiff), -1300, JulOut$RelDiff)
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
AugOut = subset(AugOut, !(is.na(AugOut$AugCloudPred) & is.na(AugOut$AugAODPred)))
AugOut$AugAODPred = ifelse(is.na(AugOut$AugAODPred), -1300, AugOut$AugAODPred)
AugOut$AbsDiff = ifelse(is.na(AugOut$AbsDiff), -1300, AugOut$AbsDiff)
AugOut$RelDiff = ifelse(is.na(AugOut$RelDiff), -1300, AugOut$RelDiff)
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
SepOut = subset(SepOut, !(is.na(SepOut$SepCloudPred) & is.na(SepOut$SepAODPred)))
SepOut$SepAODPred = ifelse(is.na(SepOut$SepAODPred), -1300, SepOut$SepAODPred)
SepOut$AbsDiff = ifelse(is.na(SepOut$AbsDiff), -1300, SepOut$AbsDiff)
SepOut$RelDiff = ifelse(is.na(SepOut$RelDiff), -1300, SepOut$RelDiff)
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
OctOut = subset(OctOut, !(is.na(OctOut$OctCloudPred) & is.na(OctOut$OctAODPred)))
OctOut$OctAODPred = ifelse(is.na(OctOut$OctAODPred), -1300, OctOut$OctAODPred)
OctOut$AbsDiff = ifelse(is.na(OctOut$AbsDiff), -1300, OctOut$AbsDiff)
OctOut$RelDiff = ifelse(is.na(OctOut$RelDiff), -1300, OctOut$RelDiff)
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
NovOut = subset(NovOut, !(is.na(NovOut$NovCloudPred) & is.na(NovOut$NovAODPred)))
NovOut$NovAODPred = ifelse(is.na(NovOut$NovAODPred), -1300, NovOut$NovAODPred)
NovOut$AbsDiff = ifelse(is.na(NovOut$AbsDiff), -1300, NovOut$AbsDiff)
NovOut$RelDiff = ifelse(is.na(NovOut$RelDiff), -1300, NovOut$RelDiff)

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
DecOut = subset(DecOut, !(is.na(DecOut$DecCloudPred) & is.na(DecOut$DecAODPred)))
DecOut$DecAODPred = ifelse(is.na(DecOut$DecAODPred), -1300, DecOut$DecAODPred)
DecOut$AbsDiff = ifelse(is.na(DecOut$AbsDiff), -1300, DecOut$AbsDiff)
DecOut$RelDiff = ifelse(is.na(DecOut$RelDiff), -1300, DecOut$RelDiff)
write.csv(DecOut, "T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/Decout_2003_GA.csv", row.names = F)
