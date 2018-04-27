##################################################################################
#  by Zongwei Ma. EH/RSPH, Emory Univ.
#  *This program is to create Thiessen Polygons for AOD Raw pixels (all pixels, including those pixels without AOD values)
#  *Then over the Thiessen Polygons with the China Point One Degree Grid.
# Edited by J.H. Belle to work over U.S. CMAQ grid (12 by 12 km)
# Dependencies: gdal, rgdal, sp, rgeos, plyr, deldir
# Note: Comments/notes start with ##, while code pieces left over from testing start with #
# Note: All rm() statements are just cleaning up workspace and removing files that are no longer needed
# Note: This script must be run after GriddingExtractMODIS10km.m and before LinkMODdat_Grid.r
##################################################################################
rm(list = ls(all=TRUE))  #start clean
gc()
library(rgdal) #Also loads sp
library(rgeos)
library(plyr)
## ---------------
## Change these parameters
## ---------------
## Section, Startday, and Ndays are included in the script submission line - see SubThiessen_Sx.sh files. commandArgs returns a vector of the arguments passed down from submission
#args = commandArgs(trailingOnly=TRUE)
#Section = as.numeric(args[1])
#Startday = as.numeric(args[2])
#Ndays = as.numeric(args[3])
Section = 1
Startday=354
Ndays=365
AT="T"
#Section = 8 #Ndays =365
#Startday=1 ## Year to grid
data.year = 2009
## Location of grid polygon layer
MAIACGrid = "/terra/Data/FinGrid/H04v04.shp"
MAIAClayer = "H04v04"
## Folder containing section-specific csv files with raw data in them -  GriddingExtractMODIS10km.m needs to be run first to pull the raw data from the hdf into section-specific csvs
aquaDir <-  "/aura/Jess_MOYD06_MOYD03_Georgia/MOD06_Extr/2009/"
## Directory to put output in
OutDir <- "/gc_runs/Gridded_GA_MOD06_5km/"
## Directory with GeoMetadata files downloaded from NASA ftp site
GeoMetaDir <- "/gc_runs/MODIS_GeoMeta/TERRA/2009/"
GeoMetaPrefix <- "MOD03_"
## ---------------
# Load function file
## ---------------

source("/home/jhbelle/Aim3Repo/Functions_ThiessenPolygons.R")

## --------------
## Procedural code
## --------------
## Read in grid section polygon layer
US.grid <- readOGR(dsn=MAIACGrid, layer=MAIAClayer)
#day=1
for(day in Startday:Ndays){
  ## read in data from MYD04_L2 files
  aquaRaw <- try(data.frame(read.csv(sprintf("%sExtr_%i_%03d_S%i.csv", aquaDir, data.year, day, Section),header=T,as.is=T)))
  if (is.data.frame(aquaRaw)){
    colnames(aquaRaw)[1:2] <- c("aqua_lat","aqua_lon")
    ## Convert aquaRaw into spatial points data frame and reattach data needed later
    ## Define point coordinate locations
    aquaRaw$point_x <- cbind(aquaRaw$aqua_lon,aquaRaw$aqua_lat)[,1]
    aquaRaw$point_y <- cbind(aquaRaw$aqua_lon,aquaRaw$aqua_lat)[,2]
    coordinates(aquaRaw) <- ~ point_x + point_y
    ## Define projection coordinates are in
    proj4string(aquaRaw) <- CRS("+proj=longlat +datum=WGS84")
    ## Create timestamp variable from hour and minute fields stored in csv files containing MODIS data
    aquaRaw@data$timestamp <- paste(sprintf("%02d:%02d", as.integer(aquaRaw@data$hr), as.integer(aquaRaw@data$min)))
    ## Create UID's for each MODIS pixel - just mashes together the year, day, time, lat, and long.
    aquaRaw@data$UID <-sprintf("G%i_%03d_%s_P%f_%f", data.year, day, aquaRaw@data$timestamp, aquaRaw@data[,1], aquaRaw@data[,2])
    ## Project point layer to projection used in grid polygon layer (Should be same as original CMAQ points)
    aquaProj <- spTransform(aquaRaw, CRS(proj4string(US.grid)))
    ## Get list of unique timestamps/granules in section on that day
    rm(aquaRaw)
    listtimes <- names(summary(as.factor(aquaProj@data$timestamp)))
    ## Read in geometa data file containing bounding polygons for each granule
    GeoMeta <- read.table(paste(GeoMetaDir, GeoMetaPrefix, strftime(strptime(paste(day, data.year, sep="_"), "%j_%Y"), "%Y-%m-%d"), ".txt", sep=""), header=F, skip=3, sep=",")[,c(2,10:17)]
    GeoMeta$Timepass <- substr(GeoMeta[,1], 12, 17)
    ## Cycle through each MODIS granule in section
    for (time in listtimes){
      #print(time)
      MODsub <- aquaProj[aquaProj@data$timestamp==time,]
      ## Only create voronoi polygons and go through merging process for granule if there is actual data in it
      if (length(MODsub) > 1){
	## Create voronoi polygons using granule points - function defined in function file - see source statement above
	voronoi_sub <- voronoipolygons(MODsub)
	## Reattach data to voronoi_sub
	voronoi_sub@data <- cbind(voronoi_sub@data, MODsub@data[,c("aqua_lat", "aqua_lon", "timestamp")])
	## Projection information is lost in output - reassign
	proj4string(voronoi_sub) <- CRS(proj4string(US.grid))
	## Create unique identfier each pixel in original
	voronoi_sub@data$UID <-sprintf("G%i_%03d_%s_P%f_%f", data.year, day, voronoi_sub@data$timestamp, voronoi_sub@data$aqua_lat, voronoi_sub@data$aqua_lon)
	## Create polygon of granule boundaries from information in GeoMetatdata, and project polygon to grid projection
	coords <- cbind.data.frame(as.numeric(GeoMeta[GeoMeta$Timepass==time,c(2:5,2)]), as.numeric(GeoMeta[GeoMeta$Timepass==time,c(6:9,6)]))
	granule <- spTransform(SpatialPolygons(list(Polygons(list(Polygon(coords, hole=F)),1)), proj4string=CRS("+proj=longlat +datum=WGS84")), CRS(proj4string(US.grid)))
	## Clip voronoi polygons using the granule boundaries
	voronoi_clipped <- gIntersection(voronoi_sub, granule, byid=T, id=rownames(voronoi_sub))
	## If polygons were removed when clipping, get intersection of two polygon layers before joining data back to polygon layer
	if (length(voronoi_clipped) != length(voronoi_sub)) {
	  RM <- gIntersects(voronoi_sub, granule, byid=T)[1,]
	  voronoi_clipped <- SpatialPolygonsDataFrame(voronoi_clipped, subset(voronoi_sub@data, RM==TRUE), match.ID=F)
      ## Otherwise just join data back in
	} else {
	  voronoi_clipped <- SpatialPolygonsDataFrame(voronoi_clipped, voronoi_sub@data, match.ID=F)
	}
	## Spatial join the voronoi polygons to the CMAQ grid section - occasionally get granules that weren't actually over grid layer (over ocean). Function returns a list of MODIS pixels that fall at least partially within each grid polygon
	OV.CMAQgrid <- try(over(US.grid, voronoi_clipped, returnList=TRUE))
	## Append lists of granule pixel UID's to grid polygon UIDs. LinkMODIS function definition is in function file - see source statement above
	#print(str(OV.CMAQgrid))
	if (is.list(OV.CMAQgrid)) {
	  UIDs <- llply(OV.CMAQgrid, LinkMODIS2)
	  if (exists("Outlist")) {
	    Outlist <- mapply(c, Outlist, UIDs)
	  } else {
	    Outlist <- UIDs
	  }
	}
	rm(voronoi_sub, voronoi_clipped, UIDs, OV.CMAQgrid, granule, coords)
	gc()
      }
     rm(MODsub)
    }
    ## If there was data for that section for that day, output daily csv containing pixel UIDs for each grid polygon in section - To get summarized data for each grid section, run the script LinkMODdat_Grid.r. Since the act of gridding is time consuming, this was done to make it possible to quickly go back and summarize the gridded data in different ways for different purposes.
    if (exists("Outlist")){
      US.id <- US.grid@data$Input_FID
      PixelUIDs <- as.character(Outlist)
      modis.dat <- cbind.data.frame(US.id, PixelUIDs)
      write.csv(modis.dat,file=sprintf("%sOutp_%i_%03d_S%i_%s.csv", OutDir, data.year, day, Section, AT))
    }
    rm(modis.dat, Outlist, PixelUIDs)
    gc()
  }	
}

