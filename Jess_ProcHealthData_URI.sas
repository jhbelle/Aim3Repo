****************
ATLANTA 
Asthma Wheeze ANY

Creating the Case-crossover dtaset. 
	A case-control is created for each ED visit
********************;

*Subsetting the full ED dataset for ATLANTA;
*ANY as_whz_any;
Libname data "T:\eohprojs\SCAPE\Project 3\Analysis\Georgia Satellite ED visits\Jess dissertation\";


data One;
set data.uri; /*[insert your health dataset]*/
where mdy(1,1,2003)<=admitdate<=mdy(12,31,2005); /*[insert your time period]*/
keep admitdate zip5 uri_any;
proc contents;
run;

proc sort data=one;
by  zip5 admitdate;
run;

*Creating day-of-week, month, and year variables which may be useful later;
data two;
set one;
weekday = weekday(admitdate);
day_of_month = day(admitdate);
month = month(admitdate);
year = year(admitdate);
run;

proc sort data=two;
by  zip5 admitdate;
run;

*creating duplicate lines for the outcome up to the number of observations
	in a given zip on a given day;
data three;
    set two;
    do i=0 to uri_any;
        output;
    end;
run;

*deleting duplicate counts;
data four;
set three;
if uri_any ge 1 and i=0 then delete;
run; 

*creating the DATE variables on which to match cases and controls;
*Setting control dates to missing if they don't fit our criteria for matching
*Criteris for matching: matched on day-of-week, month, and year;

data five;
set four;
format date2 mmddyy10. date3 mmddyy10.
date4 mmddyy10. date5 mmddyy10.
date6 mmddyy10. date7 mmddyy10.
date8 mmddyy10. date9 mmddyy10.;
group =_n_;
date2=admitdate+7;
date3=admitdate+14;
date4=admitdate+21;
date5=admitdate+28;
date6=admitdate-7;
date7=admitdate-14;
date8=admitdate-21;
date9=admitdate-28;

if month(date2)ne month then date2=.;
if year(date2) ne year then date2=.;
if month(date3)ne month then date3=.;
if year(date3) ne year then date3=.;
if month(date4)ne month then date4=.;
if year(date4) ne year then date4=.;
if month(date5)ne month then date5=.;
if year(date5) ne year then date5=.;
if month(date6)ne month then date6=.;
if year(date6) ne year then date6=.;
if month(date7)ne month then date7=.;
if year(date7) ne year then date7=.;
if month(date8)ne month then date8=.;
if year(date8) ne year then date8=.;
if month(date9)ne month then date9=.;
if year(date9) ne year then date9=.;
run;

*Subsetting for dates with "cases";
data sixA sixB;
set five;
if uri_any ge 1 then output sixA;
else output sixB;
run;

*Taking the subset dataset with cases only and adding lines for the control dates;
*Creating outcome variable which designates cases or controls;
*Not creating lines if our matching criteria is not met;
*variable count describes the number and order of controls per case;
*the date of the control is recorded;
*cases and controls are grouped by the variable GROUP;
data sixA2;
set sixA;
array dt[8] date2-date9;
count=.;
outcome=1;
time=1;
output;
do j=1 to 8;
if j=1 then count=0;
retain count;
if dt(j) ne . then do;
	count=count+1;
	outcome=0;
	time=2;
	date=dt(j);
	output;
	end;
end;
run;

*Cleaning up the dataset;
data seven;
set sixA2;
retain datenew zip5 outcome;
drop date2-date9 uri_any;
format date YYMMDD10.;
if date = . then datenew = admitdate;
else datenew = date;
run;

*sorting the dataset by GROUP which also should sort the dataset by date and zip;
proc sort data=seven;
by datenew group;
run;

*viewing the finalized case-crossover dataset (look and admire this team effort!);

proc sort data=Exposuredat;
by Date ZipCode;
*proc contents;
run;

data ExposureDat2 (rename=(Date=datenew ZipCode=zip5));
set ExposureDat;
run;

data eight;
merge ExposureDat2 seven;
by datenew zip5;
run;


data nine;
retain admitdate zip5 outcome group count time j;
set eight;
if outcome = . then delete;
*drop AS_WHZ as_whz_any EDALL RESP_WHZ; /*drop all health variables because your new health outcome variable is called "outcome")*/
run;

proc sort data=nine;
by group count;
run;

data CCO_dataset;
set nine;
run;

proc contents data=CCO_dataset;
run;
***data check;
proc sort data=CCO_dataset;
by group datenew;
run;

*check counts;
PROC SQL;
	SELECT  SUM(outcome)
	FROM CCO_dataset
QUIT;

proc means data=CCO_dataset P25 P75;
var CloudGapFill NoCldGapFill UnGapFill;
run;

data analysisdataset;
set CCO_dataset;
DOYsquared = DOY**2;
DOYcubed = DOY**3;
CloudGapFilld10 = CloudGapFill/10;
NoCldGapFilld10 = NoCldGapFill/10;
UnGapFilld10 = UnGapFill/10;
CloudGapFillIQR = CloudGapFill/6.765357;
NoCldGapFillIQR = NoCldGapFill/6.903342;
UnGapFillIQR = UnGapFill/6.902763;
if IndicatorCloud GT 0.7 then UnGapFillFiltered = .;
else UnGapFillFiltered = UnGapFilld10;
*proc contents;
run;


proc logistic data=analysisdataset;
class group;
model outcome(event='1') = CloudGapFilld10
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;


proc logistic data=analysisdataset;
class group;
model outcome(event='1') = CloudGapFillIQR
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

proc logistic data=analysisdataset;
class group;
model outcome(event='1') = NoCldGapFilld10
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

proc logistic data=analysisdataset;
class group;
model outcome(event='1') = NoCldGapFillIQR
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

proc logistic data=analysisdataset;
class group;
model outcome(event='1') = UnGapFilld10
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

proc logistic data=analysisdataset;
class group;
model outcome(event='1') = UnGapFillIQR
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

proc logistic data=analysisdataset;
class group;
model outcome(event='1') = UnGapFillFiltered
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

* Adding additional analysis where we take the cloudy/not cloudy designation and use it to further categorize observations;
data ncloudycases;
set analysisdataset;
where IndicatorCloud LE 0.20 AND outcome=1;
run;
PROC SQL;
	SELECT  SUM(outcome)
	FROM ncloudycases
QUIT;
proc means data=ncloudycases n mean P25 P75 P50;
var UnGapFill CloudGapFill NoCldGapFill;
run;
proc means data=analysisdataset n mean P25 P75 P50;
var UnGapFill CloudGapFill NoCldGapFill;
run;

data cloudycases;
set analysisdataset;
where IndicatorCloud GE 0.80 AND outcome=1;
run;
proc SQL;
	SELECT SUM(outcome)
	FROM cloudycases;
QUIT;
proc means data=cloudycases n mean P25 P75 P50;
var UnGapFill CloudGapFill NoCldGapFill;
run;
data pcloudycases;
set analysisdataset;
where IndicatorCloud LT 0.80 AND IndicatorCloud GT 0.20 AND outcome=1;
run;
proc SQL;
	SELECT SUM(outcome)
	FROM pcloudycases;
QUIT;
proc means data=pcloudycases n mean P25 P75 P50;
var UnGapFill CloudGapFill NoCldGapFill;
run;

data ncloudygroups (keep=group);
set ncloudycases;
run;
data ncloudycontrols;
set analysisdataset;
where IndicatorCloud LE 0.20 AND outcome=0;
run;
proc sort data=ncloudycontrols;
by group;
run;
data ncloudycontrols2;
merge ncloudygroups (in=ingroups) ncloudycontrols;
by group;
if ingroups;
run;
data ncloudy;
set ncloudycases ncloudycontrols2;
run;


proc logistic data=ncloudy;
class group;
model outcome(event='1') = UnGapFilld10 
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday;
strata group;
run;

proc logistic data=ncloudy;
class group;
model outcome(event='1') = CloudGapFilld10
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

proc logistic data=ncloudy;
class group;
model outcome(event='1') = NoCldGapFilld10
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

data cloudygroups (keep=group);
set cloudycases;
run;
data cloudycontrols;
set analysisdataset;
where IndicatorCloud GE 0.80;
run;
proc sort data=cloudycontrols;
by group;
run;
data cloudycontrols2;
merge cloudygroups (in=ingroups) cloudycontrols;
by group;
if ingroups;
run;
data cloudy;
set cloudycases cloudycontrols2;
run;

proc logistic data=cloudy;
class group;
model outcome(event='1') = CloudGapFilld10
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

proc logistic data=cloudy;
class group;
model outcome(event='1') = NoCldGapFilld10
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

proc logistic data=cloudy;
class group;
model outcome(event='1') = UnGapFilld10
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

data pcloudygroups (keep=group);
set pcloudycases;
run;
data pcloudycontrols;
set analysisdataset;
where IndicatorCloud LT 0.80 AND IndicatorCloud GT 0.20;
run;
proc sort data=pcloudycontrols;
by group;
run;
data pcloudycontrols2;
merge pcloudygroups (in=ingroups) pcloudycontrols;
by group;
if ingroups;
run;
data pcloudy;
set pcloudycases pcloudycontrols2;
run;

proc logistic data=pcloudy;
class group;
model outcome(event='1') = UnGapFilld10 
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday;
strata group;
run;

proc logistic data=pcloudy;
class group;
model outcome(event='1') = CloudGapFilld10
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;

proc logistic data=pcloudy;
class group;
model outcome(event='1') = NoCldGapFilld10
  TempC TempCsqared TempCcubed 
  RHday RHsquared RHcubed 
  Holiday LagHoliday 
  DOY DOYsquared DOYcubed DOW WarmSeason
  WarmSeason*TempC WarmSeason*TempCsqared WarmSeason*TempCcubed
  WarmSeason*RHday WarmSeason*RHsquared WarmSeason*RHcubed
  WarmSeason*DOY WarmSeason*DOYsquared WarmSeason*DOYcubed
  WarmSeason*Holiday WarmSeason*LagHoliday / clparm=wald;
strata group;
run;
