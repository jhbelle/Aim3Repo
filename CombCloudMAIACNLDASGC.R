## -----------
## Name: CombCloudMAIACNLDASGC.R
## Program verion: R 3.3.3
## Dependencies: stringr, ncdf4
## Author: J.H. Belle
## Purpose: Combine the cloud product (5x5 km fields), MAIAC, NLDAS, and Geos-Chem
## -----------

# Load libraries
library(stringr)
library(ncdf4)

# Source function file for NLDAS
source("/home/jhbelle/Aim3Repo/Functions_ProcNLDAS.R")

# ------
# Define variables
# ------

# Loop start/end dates
Startdate = as.Date("2003-12-01", "%Y-%m-%d")
Enddate = as.Date("2003-12-31", "%Y-%m-%d")
SeqDates = seq(Startdate, Enddate, "days")

# Tiles (maiac)/Section (Cloud)
Tiles=c("h04v04", "h04v05")

# Overpass
ATflag = "A"

# Complete list of locations - MAIAC tiles with all additional information including NLDAS matching
h04v04 = read.csv("/terra/Data/FinGrid/Comp_H04v04.csv", stringsAsFactors = F)[,c("Input_FID", "Sum_PM2_5_", "Sum_RdLenP", "MEAN", "MEAN_1", "MEAN_12", "Sum_RdLeng", "Lonchar", "Latchar")]
colnames(h04v04) <- c("Input_FID", "NEI2011", "PSecRdLen", "PForst", "Elev", "PImperv", "LocRdLen", "NLDASLon", "NLDASLat")
h04v05 = read.csv("/terra/Data/FinGrid/Comp_H04v05.csv", stringsAsFactors = F)[,c("Input_FID", "Sum_PM2_5_", "Sum_RdLen", "MEAN", "MEAN_1", "MEAN_12", "Sum_LocRdL", "Lonchar", "Latchar")]
colnames(h04v05) <- c("Input_FID", "NEI2011", "PSecRdLen", "PForst", "Elev", "PImperv", "LocRdLen", "NLDASLon", "NLDASLat")
MAIACPixels = rbind.data.frame(h04v04, h04v05)
str(MAIACPixels)
#MAIACPixels$NLDASLon = round(MAIACPixels$NLDASLon, digits=3)
#MAIACPixels$NLDASLat = round(MAIACPixels$NLDASLat, digits=3)

# Location of MAIAC data outputs
MAIACLocs <- c("/gc_runs/h04v04maiacout_Aqua/", "/gc_runs/h04v05maiacout_Aqua/")
# Location of cloud data outputs
CloudLoc <- "/terra/Linked_GA_MYD06_5k/"
# Location of NLDAS data files
NLDASloc = "/terra/NLDAS_2/"
# ForA variables
ForAvars = c("var11", "var51", "var1", "var33", "var34", "var205", "var153", "var157", "var228", "var61", "var204")
# ForB variables
ForBvars = c("var204", "var61", "var63", "var179", "var11", "var51", "var1", "var33", "var34", "var7")
# Location of GC output files
GCloc = "/terra/Jess_Merra2SOA_Outputs/"
# GC lat/lon information
longvec=c(-180.000, -177.500, -175.000, -172.500, -170.000, -167.500, -165.000, -162.500, -160.000, -157.500, -155.000, -152.500, -150.000, -147.500, -145.000, -142.500,-140.000, -137.500, -135.000, -132.500, -130.000, -127.500, -125.000, -122.500, -120.000, -117.500, -115.000, -112.500, -110.000, -107.500, -105.000, -102.500, -100.000,  -97.500,  -95.000,  -92.500,  -90.000,  -87.500,  -85.000, -82.500, -80.000,  -77.500,  -75.000,  -72.500,  -70.000,  -67.500,  -65.000,  -62.500, -60.000,  -57.500,  -55.000,  -52.500,  -50.000,  -47.500,  -45.000,  -42.500, -40.000,  -37.500,  -35.000,  -32.500,  -30.000,  -27.500,  -25.000,  -22.500, -20.000,  -17.500,  -15.000,  -12.500,  -10.000,   -7.500,   -5.000,   -2.500, 0.000,    2.500,    5.000,    7.500,   10.000,   12.500,   15.000,   17.500, 20.000,   22.500,   25.000,   27.500,   30.000,   32.500,   35.000,   37.500, 40.000,   42.500,   45.000,   47.500,   50.000,   52.500,   55.000,   57.500, 60.000,   62.500,   65.000,   67.500,   70.000,   72.500,   75.000,   77.500, 80.000,   82.500,   85.000,   87.500,   90.000,   92.500,   95.000,   97.500, 100.000,  102.500,  105.000,  107.500,  110.000,  112.500,  115.000,  117.500, 120.000,  122.500,  125.000,  127.500,  130.000,  132.500,  135.000,  137.500, 140.000,  142.500,  145.000,  147.500,  150.000,  152.500,  155.000,  157.500, 160.000,  162.500,  165.000,  167.500,  170.000,  172.500,  175.000,  177.500)
latvec=c(-89.500,  -88.000,  -86.000,  -84.000,  -82.000,  -80.000,  -78.000,  -76.000, -74.000,  -72.000,  -70.000,  -68.000,  -66.000,  -64.000,  -62.000,  -60.000, -58.000,  -56.000,  -54.000,  -52.000,  -50.000,  -48.000,  -46.000,  -44.000, -42.000,  -40.000,  -38.000,  -36.000,  -34.000,  -32.000,  -30.000,  -28.000, -26.000,  -24.000,  -22.000,  -20.000,  -18.000,  -16.000,  -14.000,  -12.000, -10.000,   -8.000,   -6.000,   -4.000,   -2.000,    0.000,    2.000,    4.000, 6.000,    8.000,   10.000,   12.000,   14.000,   16.000,   18.000,   20.000, 22.000,   24.000,   26.000,   28.000,   30.000,   32.000,   34.000,   36.000, 38.000,   40.000,   42.000,   44.000,   46.000,   48.000,   50.000,   52.000, 54.000,   56.000,   58.000,   60.000,   62.000,   64.000,   66.000,   68.000, 70.000,   72.000,   74.000,   76.000,   78.000,   80.000,   82.000,   84.000, 86.000,   88.000,   89.500)
GClat = rep(latvec, each=144)
GClon = rep(longvec, 91)
GClatlon = cbind.data.frame(GClat, GClon)
#write.csv(GClatlon, "C:/Users/jhbelle/Desktop/Testing_GC/LatLon.csv")
MAIACtoGC = read.csv("/terra/Data/FinGrid/GCmatched.csv", stringsAsFactors = F)[,c("Input_FID", "GClat", "GClon")]
MAIACtoGC$GClon = ifelse(MAIACtoGC$GClon == -82, -82.500, MAIACtoGC$GClon)
# Add GC lat/lon matches to MAIACpixels
MAIACPixels = merge(MAIACPixels, MAIACtoGC)

# Output location
OutpLoc = "/terra/CombinedValues_Jess_GA/"

# -------
# Procedural code
# -------

for (day in seq_along(SeqDates)){
  # Process date
  date = SeqDates[day]
  year = as.numeric(as.character(date, "%Y"))
  jday = as.numeric(as.character(date, "%j"))
  daysTimestamps = c()
  for (tile in seq_along(Tiles)){
    # Get list of files to process
    ListMdat <- list.files(MAIACLocs[tile], sprintf("MAIACdat_%d%03d", year, jday), full.names = T)
    for (file in ListMdat){
      # Pull timestamp as decimal number
      Timestamp = as.numeric(str_sub(file, -8, -7)) + as.numeric(str_sub(file, -6, -5))/60
      daysTimestamps = c(daysTimestamps, Timestamp)
      # Read MAIAC file
      MAIACpart <- read.csv(file, stringsAsFactors = F)[,c("InputFID", "AOD55")]
      # Remove missing observations
      #MAIACpart = subset(MAIACpart, MAIACpart$AOD55 != -28672)
      # Move non-missing obs to dataset for all tiles/granules
      if (length(MAIACpart$AOD55) > 0){
        if (exists("MAIAC")){
          MAIAC = rbind.data.frame(MAIAC, MAIACpart)
        } else { MAIAC = MAIACpart }
      }
    }
  }
  if (length(daysTimestamps) > 0){
    # Read in and join cloud product to MAIAC observations
    Cloud = try(read.csv(sprintf("%sDailyGridAOD_%d_%03d.csv", CloudLoc, year, jday), stringsAsFactors = F)[,c("US.id", "CP", "CE", "CF")])
    # Clean up and join Cloud, MAIAC, and MAIACpixels
    if (exists("MAIAC") & is.data.frame(Cloud)){
      MAIACClean <- aggregate(AOD55~InputFID, MAIAC, mean)
      CPclean <- aggregate(CP~US.id, Cloud, min)
      CEclean <- aggregate(CE~US.id, Cloud, mean)
      CFclean <- aggregate(CF~US.id, Cloud, mean)
      CPCEclean <- merge(CPclean, CEclean, by="US.id")
      CPCECFclean <- merge(CPCEclean, CFclean, by="US.id")
      MAIACpixelsMAIAC = merge(MAIACPixels, MAIACClean, by.x="Input_FID", by.y="InputFID", all.x=T)
      MAIACCloud = merge(MAIACpixelsMAIAC, CPCECFclean, by.x="Input_FID", by.y="US.id", all.x=T)
      MAIACCloud$Timestamp = rep(mean(daysTimestamps), length(MAIACCloud$AOD55))
    } else if (exists("MAIAC") & !is.data.frame(Cloud)){
      MAIACClean <- aggregate(AOD55~InputFID, MAIAC, mean)
      MAIACCloud = merge(MAIACPixels, MAIACClean, by.x="Input_FID", by.y="InputFID", all.x=T)
      MAIACCloud$CP <- rep(NA, length(MAIACCloud$AOD55))
      MAIACCloud$CE <- rep(NA, length(MAIACCloud$AOD55))
      MAIACCloud$CF <- rep(NA, length(MAIACCloud$AOD55))
      MAIACCloud$Timestamp = rep(mean(daysTimestamps), length(MAIACCloud$AOD55))
    } else if (!exists("MAIAC") & is.data.frame(Cloud)){
      MAIACPixelsMAIAC = MAIACPixels
      MAIACPixelsMAIAC$AOD55 <- rep(NA, length(MAIACPixels$Input_FID))
      CPclean <- aggregate(CP~US.id, Cloud, min)
      CEclean <- aggregate(CE~US.id, Cloud, mean)
      CFclean <- aggregate(CF~US.id, Cloud, mean)
      CPCEclean <- merge(CPclean, CEclean, by="US.id")
      CPCECFclean <- merge(CPCEclean, CFclean, by="US.id")
      MAIACCloud = merge(MAIACpixelsMAIAC, CPCECFclean, by.x="Input_FID", by.y="US.id", all.x=T)
      MAIACCloud$Timestamp = rep(mean(daysTimestamps), length(MAIACCloud$AOD55))
    } else {
      MAIACCloud = MAIACPixels
      MAIACCloud$AOD55 = rep(NA, length(MAIACCloud$Input_FID))
      MAIACCloud$CP = rep(NA, length(MAIACCloud$Input_FID))
      MAIACCloud$CE = rep(NA, length(MAIACCloud$Input_FID))
      MAIACCloud$CF = rep(NA, length(MAIACCloud$Input_FID))
      MAIACCloud$Timestamp = rep(mean(daysTimestamps), length(MAIACCloud$AOD55))
    }
    # Remove days MAIAC file
    rm(MAIAC, ListMdat, MAIACpart, CloudMAIACClean, CPclean, CEclean, CFclean, CPCEclean, CPCECFclean, MAIACpixelsMAIAC)
    # Pull NLDAS values for each pixel/overpass
    NearestHour = round(MAIACCloud[1,"Timestamp"])
    # ForA file
    NLDASForA = nc_open(sprintf("%s/File_A/%d/NLDAS_FORA0125_H.A%d%02d%02d.%02d00.002.nc", NLDASloc, year, year, as.numeric(as.character(date, "%m")), as.numeric(as.character(date, "%d")), NearestHour))
    Lat = ncvar_get(NLDASForA, "lat")
    Lon = ncvar_get(NLDASForA, "lon")
    for (var in ForAvars){
      varval = GetField(NLDASForA, latvec=Lat, lonvec = Lon, varname = var)
      colnames(varval) <- c("Long", "Lat", var)
      varval$Lat = as.numeric(as.character(varval$Lat))
      varval$Long = as.numeric(as.character(varval$Long))
      MAIACCloud <- merge(MAIACCloud, varval, by.x=c("NLDASLon", "NLDASLat"), by.y=c("Long", "Lat"), all.x=T)
    }
    NLDASForB = nc_open(sprintf("%s/File_B/%d/NLDAS_FORB0125_H.A%d%02d%02d.%02d00.002.nc", NLDASloc, year, year, as.numeric(as.character(date, "%m")), as.numeric(as.character(date, "%d")), NearestHour))
    Lat = ncvar_get(NLDASForB, "lat")
    Lon = ncvar_get(NLDASForB, "lon")
    for (var in ForBvars){
      varval = GetField(NLDASForB, latvec=Lat, lonvec=Lon, varname=var)
      colnames(varval) <- c("Long", "Lat", var)
      varval$Lat = as.numeric(as.character(varval$Lat))
      varval$Long = as.numeric(as.character(varval$Long))
      MAIACCloud <- merge(MAIACCloud, varval, by.x=c("NLDASLon", "NLDASLat"), by.y=c("Long", "Lat"), all.x=T)
    }
    # Pull GC values for each pixel/overpass
    if (NearestHour %% 2 == 0){ GChour = NearestHour } else { GChour = NearestHour + 1 }
    print(GChour)
    GCvals <- read.csv(sprintf("%s/%d/tp%d%02d%02d%02d.csv", GCloc, year, year, as.numeric(as.character(date, "%m")), as.numeric(as.character(date, "%d")), GChour), stringsAsFactors = F)
    GCdat = cbind.data.frame(GClatlon, GCvals)
    summary(GCdat)
    summary(MAIACCloud)
    MAIACCloudNLDASGC <- merge(MAIACCloud, GCdat, all.x=T)
    # Export days data
    write.csv(MAIACCloudNLDASGC, sprintf("%s/CombMAIACCloudNLDASGC_Text_%d%03d_%s.csv", OutpLoc, year, jday, ATflag))
    
  }
}
