## -----------
## Name: CombCldSnowMAIACMERRA2.R
## Program version: R 3.3.3
## Dependencies: ncdf4
## Author: J.H. Belle
## Purpose: Combine MAIAC with the corresponding cloud, snow, and Merra2 values. Also add in distance to roads and percent impervious surface
## -----------

# Load libraries
library(ncdf4)

## -----
# Function 1: GetField - Gets a field's worth of data from a netcdf, formatted as a data frame and returns it
## -----

GetField <- function(ncdat, latvec, lonvec, varname, timeslice){
  require(ncdf4)
  field <- ncvar_get(ncdat, varname)
  field = field[,,timeslice]
  dimnames(field) <- list(lonvec, latvec)
  field_df <- as.data.frame(as.table(field))
  return(field_df)
}

## ----
# Define parameters
## ----

# Time
StartDate = as.Date("2013-01-01", "%Y-%m-%d")
EndDate = as.Date("2013-01-05", "%Y-%m-%d")
SeqDates = seq(StartDate, EndDate, by="day")

# TA flag
TAflag="A"
TA = "Aqua"

# MAIAC location
MAIACLoc = "T://eohprojs/CDC_climatechange/Jess/HarbinProj/MAIACproc/"
MAIACtiles = c("h04v00", "h04v01")

# MAIAC grid
MAIACgrid = read.csv("T://eohprojs/CDC_climatechange/Jess/HarbinProj/MAIACproc/CreateGridFin/MAIACpolys_XYpoints.csv", stringsAsFactors = F)[,c("Input_FID", "POINT_X", "POINT_Y", "lat", "lon")]

# Distance to roads
DistHighways = read.csv("T://eohprojs/CDC_climatechange/Jess/HarbinProj/MAIACproc/CreateGridFin/DistHighways.csv", stringsAsFactors = F)[,c("Input_FID", "NEAR_DIST")]

# Percent Impervious surface
PImperv = read.csv("T://eohprojs/CDC_climatechange/Jess/HarbinProj/MAIACproc/CreateGridFin/PImperv.csv")[,c("Input_FID", "MEAN")]
DistPImp = merge(DistHighways, PImperv, by="Input_FID")

# Percent forested area
PForst = read.csv("T://eohprojs/CDC_climatechange/Jess/HarbinProj/MAIACproc/CreateGridFin/PForest.csv")[,c("Input_FID", "MEAN")]
colnames(PForst) <- c("Input_FID", "PForest")

# Elevation
Elev = read.csv("T://eohprojs/CDC_climatechange/Jess/HarbinProj/MAIACproc/CreateGridFin/Elev.csv")[,c("Input_FID", "MEDIAN")]
DistPImpElev = merge(DistPImp, Elev, by="Input_FID")
colnames(DistPImpElev) <- c("Input_FID", "DistHighways", "PImperv", "Elev")
MAIACDistPImpElev = merge(MAIACgrid, DistPImpElev, by="Input_FID")
MAIACFin = merge(MAIACDistPImpElev, PForst, by="Input_FID")
rm(MAIACgrid, DistHighways, PImperv, DistPImp, Elev, DistPImpElev, MAIACDistPImpElev, PForst)

# Cloud location
CloudLoc = "T://eohprojs/CDC_climatechange/Jess/HarbinProj/Cloud/"

# Snow location
SnowLoc = "T://eohprojs/CDC_climatechange/Jess/HarbinProj/Snow/"
# Snow to MAIAC matching
SnowToMAIAC = read.csv("T://eohprojs/CDC_climatechange/Jess/HarbinProj/Snow/GIS/SnowJoin.csv")[,c("Input_FID", "Lon_1", "Lat_1")]

# MERRA2 location
MERRALoc = "T://eohprojs/CDC_climatechange/Jess/HarbinProj/MERRA2/"
# MERRA 2 tiles to add
MERRA2Files = c("MERRA2_400.inst1_2d_asm_Nx.", "MERRA2_400.inst3_2d_gas_Nx.", "MERRA2_400.tavg1_2d_flx_Nx.")
MERRA2Vars = list(c("U10M", "V10M", "TOX", "T2M", "QV2M", "PS"), c("AODANA"), c("FRCAN", "FRCCN", "HLML", "NIRDF", "NIRDR", "PBLH", "PGENTOT", "PRECANV", "PRECCON", "PRECTOT"))
# MERRA2 to MAIAC matching
MERRAToMAIAC = read.csv("T://eohprojs/CDC_climatechange/Jess/HarbinProj/MAIACtoMERRA2.csv")[,c("Input_FID", "Lat_1", "Lon_1")]

# Output location
OutpLoc = "T://eohprojs/CDC_climatechange/Jess/HarbinProj/TestingOutput/"

## ----
# Loop over days
## ----
gc()
for (day in seq_along(SeqDates)){
  # Pull needed information from day/date
  Date = SeqDates[day]
  Year = as.numeric(as.character(Date, "%Y"))
  Jday = as.numeric(as.character(Date, "%j"))
  # Combine both MAIAC tiles
  for (tile in MAIACtiles){
    MAIAC = try(read.csv(sprintf("%s%s/MAIAC_%sAOT_%s_%d%03d.csv", MAIACLoc, tile, TAflag, tile, Year, Jday)))
    if (is.data.frame(MAIAC)){
      MAIAC = MAIAC[,c("Hour", "Minute", "Latitude", "Longitude", "AOT550")]
      if (exists("MAIACdat")){ MAIACdat = rbind.data.frame(MAIACdat, MAIAC)} else {MAIACdat = MAIAC}
    }
  }
  # Merge days MAIAC into spatial variables
  Outp = merge(MAIACFin, MAIACdat, by.x=c("lat", "lon"), by.y=c("Latitude", "Longitude"), all.x=T)
  Timestamp = mean(MAIACdat$Hour, na.rm=T) + mean(MAIACdat$Minute, na.rm=T)/60
  rm(MAIACdat)
  # Get cloud data
  Cloud = try(read.csv(sprintf("%sInterpolatedCOD_%d_%03d_%s.csv", CloudLoc, Year, Jday, TA)))
  if (is.data.frame(Cloud)){
    # Merge cloud data into MAIAC and spatial variables
    colnames(Cloud) <- c("Input_FID", "x", "y", "COD")
    Cloud = Cloud[,c("Input_FID", "COD")]
    Outp = merge(Outp, Cloud, all.x=T, by="Input_FID")
  } else Outp$COD = rep(NA, nrow(Outp))
  # Get snow data
  Snow = read.csv(sprintf("%sSnowDat_A%d%03d%s.csv", SnowLoc, Year, Jday, TAflag))
  Snow$Snow = ifelse(Snow$Snow > 100, 0, Snow$Snow)
  # Merge snow data into MAIAC and spatial variables
  SnowPart = merge(SnowToMAIAC, Snow, by.x=c("Lat_1", "Lon_1"), by.y=c("Lat", "Lon"))[,c("Input_FID", "Snow")]
  Outp = merge(Outp, SnowPart, all.x=T, by="Input_FID")
  # For each MERRA file type 
  for (file in seq_along(MERRA2Files)){
    Mfile = MERRA2Files[file]
    Mvars = MERRA2Vars[[file]]
    # Open data
    MERRA2 = nc_open(sprintf("%s%s%d%02d%02d.SUB.nc4", MERRALoc, Mfile, Year, as.numeric(as.character(Date, "%m")), as.numeric(as.character(Date, "%d"))))
    # Pull out lat/lon and time fields
    Lat = ncvar_get(MERRA2, "lat")
    Lon = ncvar_get(MERRA2, "lon")
    Time = ncvar_get(MERRA2, "time") /60
    # Select time slice
    TimeSlice = which.min(abs(Time - Timestamp))
    # Read out data fields
    for (var in Mvars){
      vardat = GetField(MERRA2, latvec = Lat, lonvec = Lon, varname=var, timeslice=TimeSlice)
      colnames(vardat) <- c("Lon", "Lat", var)
      vardat$Lon = as.numeric(as.character(vardat$Lon))
      vardat$Lat = as.numeric(as.character(vardat$Lat))
      # Join MERRA2 data fields to MAIAC, cloud, snow, and spatial variables
      MERRAPart = merge(MERRAToMAIAC, vardat, by.x=c("Lon_1", "Lat_1"), by.y=c("Lon", "Lat"))[,c("Input_FID", var)]
      Outp = merge(Outp, MERRAPart, by="Input_FID")
    }
    # Close file
    nc_close(MERRA2)
  }
  # Write output to days file
  summary(Outp)
  write.csv(Outp, sprintf("%sOutp_%d%03d_%s.csv", OutpLoc, Year, Jday, TAflag))
}
