# Aim3Repo
Repository for Aim 3 of dissertation

This readme file contains an accounting of all scripts in  the repository

I. Data processing
	a. MAIAC
		1) procmaiac.pro - extracts maiac values within study area from tiled files
		2) qsub_ProcMAIAC.pro - record of calls to procmaiac.pro. Includes examples of procmaiac.pro usage
		3) qsub_extrmaiac.sh - bash script to call and run qsub_ProcMAIAC.pro through qsub on the cluster. Submitted to cluster using syntax - 'qsub -cwd -q long.q qsub_extrmaiac.sh'

	b. Cloud product - 5x5 km fields (Cloud top height, Cloud fraction, Cloud phase infrared, cloud top temperature, and cloud effective radius)
		1) GriddingExtractMODIS5km.m - extracts 5x5 km fields from the M*D06_L2 files
		2) qsub_5kmExtr.sh - Bash submission script to qsub on cluster for GriddingExtractMODIS5km.m. Submitted to cluster using syntax 'qsub -cwd -q long.q qsub_5kmExtr.sh'
		3) ThiessenPolygons.R; ThiessenPolygons_Aqua.R, ThiessenPolygons_AquaS2.R, ThiessenPolygons_Terra.R, ThiessenPolygons_TerraS2.R - Runs thiessen polygon gridding on data extracted by GriddingExtractMODIS5km.m. Separate scripts exist for Terra and Aqua and for the two sections (maiac tiles)
		4) SubThiessen5km.sh, SubThiessen5kmAqua.sh SubThiessen5kmAquaS2.sh, SubThiessen5kmTerra.sh, SubThiessen5kmTerraS2.sh - Submits, respectively, ThiessenPolygons.R, ThiessenPolygons_Aqua.R, ThiessenPolygons_AquaS2.R, ThiessenPolygons_Terra.R, ThiessenPolygons_TerraS2.R, to the cluster under qsub using the syntax 'qsub -cwd -q long.q SubThiessen5km.sh'
		5) LinkMODdat.R, LinkMODdat2004.R, LinkMODdat2005.R, LinkMODdat2007.R, LinkMODdat2009.R LinkMODdatAqua.R. LinkMODdatAqua2007.R, LinkMODdatAqua2009.R - Links the thiessen polygon grid output files with the extracted values from GriddingExtractMODIS5km.m
		6) qsub_Links5km.sh, qsub_2004Links5km.sh, qsub_2005Links5km.sh, qsub_Links5km2007.sh, qsub_Links5km2009, qsub_Links5kmAqua.sh, qsub_Links5kmAqua2007.sh, qsub_Links5kmAqua2009.sh - Bash submission scripts for the LinkMODdat.R series of files
	
	c. GEOS-Chem
		1) calcnmolecpblnmoelccolumnlayer1pm25exportvals.pro - extracts the number of sulfate and nitrate molecules within the planetary boundary layer and the estimated PM2.5 concentration, including SOA species, in first vertical layer of the model at each grid cell and exports these values to a csv. 
		2) qsub_calcmanythings.pro - record of calls to calcnmolecpblnmoelccolumnlayer1pm25exportvals.pro
		3) qsub_calcmanythings.sh - bash script to call and run qsub_calcmanythings.pro

	d. Combine MAIAC, cloud product (5x5 km), GEOS-Chem and NLDAS with spatial parameters calculated in ArcGIS
		1) CombCloudMAIACNLDASGC.R, CombCloudMAIACNLDASGC_Aqua.R - Scripts to combine paramters from MAIAC, NLDAS, GEOS-Chem, and the MODIS cloud product (5x5 km fields) for, respectively, Terra and Aqua satellite overpasses. Calls Functions_ProcNLDAS.R. Requires the datasets output from procmaiac.pro, LinkMODdat.R and calcnmolecpblnmoelccolumnlayer1pm25exportvals.pro. Additionally requires Comp_H04v04.csv, Comp_H04v05.csv, and GCmatched.csv from the FinGrid folder located at /terra/Data/. Comp_H04v04.csv and CompH04v05.csv should contain the lat/lon values of the MAIAC grid as well as the grid ID value.
		2) Functions_ProcNLDAS.R - Function file containing a function to open and extract a dataset from a netcdf file as a data frame
		3) qsub_Comb.sh, qsub_Comb_Aqua.sh - Scripts to submit, respectively, CombCloudMAIACNLDASGC.R and CombCloudMAIACNLDASGC_Aqua.R to the cluster
	
	e. NARR - Add NARR fields RH and PBL height to Combined files
		1) AddNARR.R - requires 3-hourly NARR netcdf files downloaded from: https://www.esrl.noaa.gov/psd/data/gridded/data.narr.monolevel.html, the combined files output by CombCloudMAIACNLDASGC.R, and the file MAIACto_NEI2008_NARR_DistRds.csv which contains the mapping between the NARR lat/lon values and the MAIAC grid cells. Adds NARR values and any spatial parameters calculated in ArcGIS and included in the file MAIACto_NEI2008_NARR_DistRds.csv. 
		2) qsub_AddNARR.sh - bash submission script for AddNARR.R
	
	f. Cloud product - 1x1 km fields (Cloud OD)
		1) GriddingExtractMODIS1km.m - Extracts 1x1 km fields from both the M*D06_L2 and M*D03 files, since the lat/lon information for the 1x1 grid is only in the M*D03 files
		2) qsub_1kmExtr.sh - Bash submission script for GriddingExtractMODIS1km.m
		3) IDW_COD.R - Interpolates Cloud OD to MAIAC grid centerpoints. Calls Functions_IDW.R and requires the output of GriddingExtractMODIS1km.m, additionally requires the MAIAC grid file, XYpoints_MAIACgrid.csv with both the maiac grid ids and the X and Y coordinates of the midpoints (projected)
		4) Functions_IDW.R - Contains inverse distance weighting interpolation function
		5) qsub_IDW.sh - Bash submission script for IDW_COD.R
		6) AddCOD.R - Adds the interpolated COD values to the combined files containing MAIAC, 5x5 cloud products, GEOS-Chem, NLDAS, and NARR fields
		7) qsub_AddCOD.sh - Bash submission script for AddCOD.R
	
	g. Fire product - M*D14
		1) extractfirespots.pro - Extracts fire spots from the M*D14 files
		2) qsub_extractfirespots.pro - IDL submission script for extractfirespots.pro
		3) qsub_extractfirespots.sh - bash submission script for qsub_extractfirespots.pro
		4) BuffJoinFire.R, BuffJoinFire_Terra.R - Buffers and joins the fire spots to the MAIAC grid, adding the values to the combined files
		5) qsub_BuffJoinFire.sh, qsub_BuffJoinFire_Terra.sh - bash submission scripts for BuffJoinFire.R and BuffJoinFire_Terra.R

	h. Visibility - from NCDC point observations stored on big4_12TB_2
		1) Vis_IDW.R - Aggregates visibility files from all stations within study area to daily station means, and interpolates daily means over the study area to the MAIAC grid cells. Calls Functions_IDW.R from section f above

II. Exposure modeling
	a. Process EPA data
		1) ProcEPA.R - Processes the EPA data to a file containing all observations in study area and an additional file unique monitor locations - script run locally
	b. Create fitting dataset from combined files and EPA data
		1) CreateFittingData.R - Creates fitting dataset from combined files and EPA data
		2) Functions_CreateFittingData.R - Function file called by CreateFittingData.R
		3) qsub_CreateFittingData.sh - Bash submission script for CreateFittingData.R
	c. Analyze fitting dataset, calculate R2 values, and settle on a final model
		1) AnalyzeFittingData.R - script run locally
	d. Predict new values
		1) PredictPM25.R, PredictPM25_Terra.R - Predict new values for Aqua and Terra, respectively 
		2) qsub_PredictPM25.sh, qsub_PredictPM25_Terra.sh - bash submission scripts for PredictPM25.R and PredictPM25_Terra.R
	e. Aggregate predictions to ZIP codes
		1) AggZipCodes.R - Aggregates predicted PM2.5 values to the ZIP code 
		2) qsub_AggZipCodes.sh - Bash submission script for AggZipCodes.R
	f. Create exposure dataset for use in health modeling
		1) CreateExposureData.R - Creates exposure dataset for health modeling from PM2.5 predictions output by PredictPM25.R or PredictPM25_Terra.R. Run locally

III. Health modeling - all three sas files are identical
	a. Asthma/Wheeze
		1) Jess_ProcHealthData_AQ.sas
	b. Otitis media
		1) Jess_ProcHealthData_OM.sas
	c. Upper respiratory infection
		1) Jess_ProcHealthData_URI.sas

IV. Additional scripts for specific figures and tables
	a. Monthly differences - used for decision document on health dataset to use - ProduceEst_AggMonth.R; PrepPredVals.R, qsub_ProduceExt_AggMonth.sh
	b. Figure 1 - Daily average differences - AggPreds.R
	c. Figure 2 - OR values by cloudiness category - AnalyzeORs.R

