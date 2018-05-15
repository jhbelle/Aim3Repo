## -----------
## Functions_CreateFittingData.R
## Function file for CreateFittingData.R
## -----------

## ----------
# Function 1: GetOtherVars
# - A function that takes in a block of EPA observations for each date, reads the correct output from CombCloudMAIACNLDASGC.R, and joins this to the EPA data using the field Input_FID
## ----------

GetOtherVars <- function(datblock, ATflag){
  Date = as.Date(datblock$Date.Local[1], "%Y-%m-%d")
  SatDat = try(read.csv(sprintf("/terra/CombinedValues_Jess_GA_Aqua/CombMAIACCloudNLDASGC_Text_%d%03d_%s.csv", as.numeric(as.character(Date, "%Y")), as.numeric(as.character(Date, "%j")), ATflag)))
  if (is.data.frame(SatDat)){
    Outp = merge(datblock, SatDat, by="Input_FID", all.x=T)
    return(Outp)
  }
}
