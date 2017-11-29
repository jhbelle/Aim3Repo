## ---------------
## Functions - ThiessenPolygons.r
## ---------------

# Carson's Voronoi polygons function from http://www.carsonfarmer.com/?p=455
voronoipolygons <- function(x) {
  require(deldir)
  if (.hasSlot(x, 'coords')) {
    crds <- x@coords
  } else crds <- x
  z <- deldir(crds[,1], crds[,2])
  w <- tile.list(z)
  polys <- vector(mode='list', length=length(w))
  require(sp)
  for (i in seq(along=polys)) {
    pcrds <- cbind(w[[i]]$x, w[[i]]$y)
    pcrds <- rbind(pcrds, pcrds[1,])
    polys[[i]] <- Polygons(list(Polygon(pcrds)), ID=as.character(i))
  }
  SP <- SpatialPolygons(polys)
  voronoi <- SpatialPolygonsDataFrame(SP, data=data.frame(x=crds[,1],
                                                          y=crds[,2], row.names=sapply(slot(SP, 'polygons'),
                                                                                       function(x) slot(x, 'ID'))))
}

# Function to link MODIS data back in - appends list of UID's - var is a column number
LinkMODIS <- function(IndexList, ModDat) {
  attributes(IndexList) <- NULL
  IDval <- ModDat@data$UID[c(IndexList)]
  return(IDval)
}

LinkMODIS2 <- function(ListDD){
  return(ListDD$UID)
}
