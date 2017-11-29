## -----------
## Function file associated with LinkMODdat_Grid.r
## -----------

ExtrUIDs <- function(colstrings){
  liststr <- strsplit(colstrings, ",")
  charvec <- str_trim(gsub("[[:punct:]]|c", "", liststr[[1]]))
  return(charvec)
}

CalcVals <- function(Griddat, MODdat, scale) {
  require(modeest)
  UIDframe <- cbind.data.frame(ExtrUIDs(Griddat[,3]))
  colnames(UIDframe) <- "UID"
  #UIDframe <- as.data.frame(UIDframe[which(!(substr(UIDframe$UID, 7, 15) %in% rmlist)),])
  #colnames(UIDframe) <- "UID"
  Tog <- merge(UIDframe, MODdat, by="UID")
  Tog$CloudPhase <- ifelse(Tog$CloudPhase == 0, NA, Tog$CloudPhase)
  Tog$CloudEmiss <- ifelse(Tog$CloudEmiss==127, NA, Tog$CloudEmiss)*scale
  Tog$CloudFrac <- ifelse(Tog$CloudFrac == 127, NA, Tog$CloudFrac)*scale
  CP <- mfv(Tog$CloudPhase)
  CE <- mean(Tog$CloudEmiss, na.rm=T)
  CF <- mean(Tog$CloudFrac, na.rm=T)
  Outp <- cbind.data.frame(CP, CE, CF)
  return(Outp)
}

CalcValsTime <- function(Griddat, MODdat){
  UIDframe <- cbind.data.frame(ExtrUIDs(Griddat[,3]))
  colnames(UIDframe) <- "UID"
  Tog <- merge(UIDframe, MODdat, by="UID")
  Time <- median(Tog$timestamp)
  Outp <- cbind.data.frame(Time)
  return(Outp)
}
