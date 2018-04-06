# Aim3Repo
Repository for Aim 3 of dissertation

I. Data processing
	a. MAIAC
		1) procmaiac.pro - extracts maiac values within study area from tiled files
		2) qsub_ProcMAIAC.pro - record of calls to procmaiac.pro. Includes examples of procmaiac.pro usage
		3) qsub_extrmaiac - bash script to call and run qsub_ProcMAIAC.pro through qsub on the cluster. Submitted to cluster using syntax - 'qsub -cwd -q long.q qsub_extrmaiac.sh'

	b. Cloud product - 5x5 km fields (Cloud top height, Cloud fraction, Cloud phase infrared, cloud top temperature, and cloud effective radius)
		1) GriddingExtractMODIS5km.m - extracts 5x5 km fields from the M*D06_L2 files
		2) qsub_5kmExtr.sh - Bash submission script to qsub on cluster for GriddingExtractMODIS5km.m. Submitted to cluster using syntax 'qsub -cwd -q long.q qsub_5kmExtr.sh'
		3) ThiessenPolygons.R; ThiessenPolygons_Aqua.R, ThiessenPolygons_AquaS2.R, ThiessenPolygons_Terra.R, ThiessenPolygons_TerraS2.R - Runs thiessen polygon gridding on data extracted by GriddingExtractMODIS5km.m. Separate scripts exist for Terra and Aqua and for the two sections (maiac tiles)
		4) SubThiessen5km.sh, SubThiessen5kmAqua.sh SubThiessen5kmAquaS2.sh, SubThiessen5kmTerra.sh, SubThiessen5kmTerraS2.sh - Submits, respectively, ThiessenPolygons.R, ThiessenPolygons_Aqua.R, ThiessenPolygons_AquaS2.R, ThiessenPolygons_Terra.R, ThiessenPolygons_TerraS2.R, to the cluster under qsub using the syntax 'qsub -cwd -q long.q SubThiessen5km.sh'
		5) LinkMODdat.R, LinkMODdat2004.R, LinkMODdat2005.R, LinkMODdatAqua.R - 
