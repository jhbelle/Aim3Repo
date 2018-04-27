## -----------
## Name: FitData_Harbin_Aqua.R
## Program version: R 3.3.3
## Dependencies: randomForest, MASS, ggplot2, dplyr
## Author: J.H. Belle
## Purpose: Analyze the fitting dataset for Aqua overpass at the Harbin site
## ------------

# load libraries
library(randomForest)
library(MASS)
library(ggplot2, lib.loc = "H:/R/")
library(dplyr, lib.loc="H:/R/")

# Load fitting dataset
Aqua <- read.csv("T://eohprojs/CDC_climatechange/Jess/HarbinProj/FittingDataHarbin_Terra.csv", stringsAsFactors = F)
Aqua$AOT550 = ifelse(Aqua$AOT550 < 0, NA, Aqua$AOT550)
AquaDynamic = unique(Aqua[,c("Input_FID", "Date", "PM25", "AOT550", "U10M", "V10M", "T2M", "TOX", "QV2M", "PS", "NIRDF", "NIRDR", "PBLH", "FireCount", "GapFilledAOD")])
AquaDynamic2 <- AquaDynamic %>%
  group_by(Input_FID, Date) %>%
  summarise_all(funs(mean(.,na.rm=T)))

AquaSpatial = unique(Aqua[,c("Input_FID", "POINT_X", "POINT_Y", "DistHighways", "PImperv", "Elev", "PForest")])
Aqua2 = merge(AquaDynamic2, AquaSpatial, by="Input_FID")
Aqua3 = subset(Aqua2, !is.na(Aqua2$AOT550) | !is.na(Aqua2$GapFilledAOD))

Aqua3$HasGapFilled = ifelse(is.na(Aqua3$AOT550), 1, 0)
Aqua3$AOD = ifelse(is.na(Aqua3$AOT550), Aqua3$GapFilledAOD, Aqua3$AOT550)
Aqua3$month = as.numeric(as.character(as.Date(Aqua3$Date, "%Y-%m-%d"), "%m"))
aggregate(HasGapFilled ~ month, Aqua3, mean)

Aqua3$WindSpeed = sqrt(Aqua3$U10M^2 + Aqua3$V10M^2)
Aqua3$DistHighwaysCat = cut(Aqua3$DistHighways, c(-1, 1000, 5000, 500000))
Aqua3$TOX_NIRDR = Aqua3$TOX*Aqua3$NIRDR
Aqua3$T2Msq = Aqua3$T2M^2
Aqua3$RH = 0.263*Aqua3$PS*Aqua3$QV2M*(exp((17.67*(Aqua3$T2M - 273.16))/(Aqua3$T2M - 29.65))^(-1))

#testmod = randomForest(PM25 ~ AOD + PImperv + Elev + T2M + NIRDR + NIRDF + PBLH + FireCount + TOX + TOX_NIRDR + T2Msq + RH, data=Aqua3, importance=T, ntree = 250)
#varImpPlot(testmod)
#print(testmod)

Aqua3$CrossValSet = sample(1:10, nrow(Aqua3), replace = T)
uniquedates = as.data.frame(unique(Aqua3$Date))
colnames(uniquedates) <- c("Date")
uniquedates$CrossValSet2 = sample(1:10, nrow(uniquedates), replace=T)
Aqua3 = merge(Aqua3, uniquedates, by="Date")
Aqua3$rownames = rownames(Aqua3)
for (i in 1:10){
  mod = randomForest(PM25 ~ AOD + PImperv + Elev + T2M + NIRDR + NIRDF + PBLH + FireCount + TOX + TOX_NIRDR + DistHighwaysCat + RH, data=Aqua3[Aqua3$CrossValSet2 != i,], importance=T, ntree = 250)
  predict = predict(mod, data=Aqua3[Aqua3$CrossValSet2 == i,])
  if (exists("Preds")) { Preds = c(Preds, predict)} else Preds = predict
}

Preds = cbind.data.frame(names(Preds), Preds)
colnames(Preds) <- c("rownames", "Pred")
CombDat = merge(Aqua3, Preds, by="rownames")
summary(lm(PM25 ~ Pred, CombDat))
rm(Preds)

hist(CombDat$Pred, breaks=50, xlab = "Predictions", main="")
ggplot(CombDat, aes(x=PM25, y=Pred)) + geom_bin2d(bins=75) + geom_abline(aes(intercept=0, slope=1)) + geom_abline(aes(intercept=-1.90, slope=1.03), linetype = 3)+ ylim(c(0,1200)) + ylab("Predictions") + xlab("Ground truth PM2.5") + theme_classic()

TerraMod = randomForest(PM25 ~ AOD + PImperv + Elev + T2M + NIRDR + NIRDF + PBLH + FireCount + TOX + TOX_NIRDR + DistHighwaysCat + RH, data=Aqua3, importance=T, ntree = 250)
varImpPlot(mod1)
print(mod1)
#saveRDS(mod1, "D:/Aquamodel.rds")
