## --------
## Name: AnalyzeORs.R
## Program version: R 3.3.3
## Dependencies:
## Author: J.H. Belle
## Purpose: Analyze the OR values put into a table for all 6 outcomes
## Planned plot: 
## Planeed table:
## ---------



ORs = read.csv("T:/eohprojs/SCAPE/Project 3/Analysis/Georgia Satellite ED visits/Jess dissertation/OddsRatiosDissertation.csv", stringsAsFactors = F)
Lag0 = subset(ORs, ORs$Lag == 0)

library(ggplot2, lib.loc = "H://R/")

ggplot(Lag0[Lag0$ExposureLayer != "Matt",], aes(x=ExposureLayer, color=ExposureLayer, y=OR, ymin=Ormin, ymax=Ormax)) + 
  geom_pointrange() + 
  geom_hline(yintercept = 1) + 
  xlab("") + 
  ylab(expression(paste("Odds ratio per 10",mu,"g/",m^3," increase in ",PM[2.5]), parse=T)) + 
  facet_grid(.~Outcome) + 
  scale_color_discrete("Exposure Model") +
  theme_classic() + theme(axis.text.x=element_text(color="white"), axis.ticks.x=element_line(NA))


