## ---------------
## Name: CreateImageORs.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Create image of OR values and exposure estimates
## ---------------

library(ggplot2, lib.loc = "H:/R/")
library(reshape2, lib.loc = "H:/R/")

ORs = read.csv("T:/eohprojs/SCAPE/Project 3/Analysis/Georgia Satellite ED visits/Jess dissertation/DissertationORs.csv", stringsAsFactors = F)
str(ORs)
colnames(ORs) <- c("Outcome", "CloudType", "N", "MeanExposure", "Exposure", "OR", "ORmin", "ORmax")
#ORs$CloudType2 = ifelse(ORs$CloudType == "Cloud" | ORs$CloudType == "CloudHasCloudGapFill", "Cloudy", ifelse(ORs$CloudType=="CloudHasUnGapFill", "Partially Cloudy", "Clear"))
#ggplot(ORs, aes(x=Outcome, y=MeanExposure)) + geom_point() 
#summary(as.factor(ORs$CloudType))
ORs$Outcome2 = ifelse(ORs$Outcome == "AS_WZ", "Asthma or Wheeze", ifelse(ORs$Outcome == "OM", "Otitis media", "URI"))
ORs$CloudType2 = ifelse(ORs$CloudType == "Cloudy", "Cloudy", ifelse(ORs$CloudType == "PartialCloud", "Partially cloudy", "Clear"))

ggplot(ORs, aes(y=OR, ymin=ORmin, ymax=ORmax, x=Exposure)) + geom_pointrange() + geom_hline(yintercept = 1.0, linetype=3) + xlab("Exposure Model") + facet_grid(CloudType2~Outcome2, scales="free") + theme_classic() + theme(axis.text.x=element_text(angle=-20, vjust=0.1))


