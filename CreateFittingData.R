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

# -----
# Read in EPA data
# -----

EPAdat <- read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/GAFRM_EPAobs.csv", stringsAsFactors = F)

# -----
# Read in join to MAIAC
# -----

EPAtoMAIAC <- read.csv("T://eohprojs/CDC_climatechange/Jess/Dissertation/Paper3_Data/GAFRM_Monitors_JoinedMAIAC.csv", stringsAsFactors = F)[c("State_Code", "County_Cod", "Site_Num", "Input_FID")]
EPAdat <- merge(EPAdat, EPAtoMAIAC, by.x=c("State.Code", "County.Code", "Site.Num"), by.y=c("State_Code", "County_Cod", "Site_Num"))

# ----
# Create fitting data
# ----

FittingData = ddply(EPAdat, .(Date.Local), GetOtherVars, TAflag="A")

# ----
# Write fitting dataset
# ----

write.csv(FittingData, "/home/jhbelle/Data/FittingData_GA_Aqua.csv")