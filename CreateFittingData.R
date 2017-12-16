## ---------------
## Name: CreateFittingData.R
## Program version: R 3.3.3
## Dependencies: plyr
## Function File: Functions_CreateFittingData.R
## Author: J.H. Belle
## Purpose: Creates a fitting dataset from the product of CombCloudMAIACNLDASGC.R and the EPA observations currently located at T:\eohprojs\CDC_climatechange\Jess\Dissertation\Paper3_Data\GAFRM_EPAobs.csv
## --------------

# Load libraries
library(plyr)
source("/home/jhbelle/Aim3Repo/Functions_CreateFittingData.R")
# -----
# Read in EPA data
# -----

EPAdat <- read.csv("/home/jhbelle/Data/GAFRM_EPAobs.csv", stringsAsFactors = F)
# Subset to 2003
EPAdat = subset(EPAdat, substr(EPAdat$Date.Local, 1, 4) == "2003")

# -----
# Read in join to MAIAC
# -----

EPAtoMAIAC <- read.csv("/home/jhbelle/Data/GAFRM_Monitors_JoinedMAIAC.csv", stringsAsFactors = F)[c("State_Code", "County_Cod", "Site_Num", "Input_FID")]
EPAdat <- merge(EPAdat, EPAtoMAIAC, by.x=c("State.Code", "County.Code", "Site.Num"), by.y=c("State_Code", "County_Cod", "Site_Num"))

# ----
# Create fitting data
# ----

FittingData = ddply(EPAdat, .(Date.Local), GetOtherVars, ATflag="A")

# ----
# Write fitting dataset
# ----

write.csv(FittingData, "/home/jhbelle/Data/FittingData_GA_Aqua.csv")
