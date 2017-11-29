% -----------------------------
% Name: RadialMatch_Extract10km_2011.m
% Date Created: 6/15/14
% Program version: Matlab R2014a
% Author: J.H. Belle
% Depends: 
% Purpose: Extract Lat/Long, AOD and QA values for gridding to CMAQ grid.
%   - Note, this script is designed to split the output files into 9
%   section files for each day. To do this each output file will need to be
%   opened as append and points put into each section accordingly -
%   sections overlap
% -----------------------------

% -----------------------
% Change these parameters!!!!
% -----------------------
yr = 2006;
IPath1 = '/aura/Jess_MOYD06_MOYD03_Georgia/MOYD06/2006/';
IPath2 = '/aura/Jess_MOYD06_MOYD03_Georgia/MOYD03/2006/';
Opath ='/aura/Jess_MOYD06_MOYD03_Georgia/MOYD03_Extr/2006/';
SectionCoors = {[35.1, -85.7, -80.7, 30.3]};

% Cycle through each day in year, and get list of files for each
for day=4:365
    filelist1 = dir(sprintf('%sMOD06_L2.A%u%03d.*.hdf', IPath1, yr, day));
    filelist2 = dir(sprintf('%sMOD03.A%u%03d.*.hdf', IPath2, yr, day));
    if length(filelist1) == length(filelist2)
        % Initialize output structure for section data
        Varnames = {'Lat', 'Long', 'CloudAOD', 'CloudWaterPath', 'CloudEffRad', 'hr', 'min'};
        SectionCell = cell(1,1);
        for f=1:length(filelist1)
            % Open each file in list and read in data
            filen1 = strcat(IPath1, filelist1(f).name);
            filen2 = strcat(IPath2, filelist2(f).name);
            Hr = str2num(filelist2(f).name(16:17));
            Min = str2num(filelist2(f).name(18:19));
            fileinfo03=hdfinfo(filen2, 'eos');
            swathname03 = fileinfo03.Swath.Name();
            Lat=hdfread(filen2, swathname03, 'Fields', 'Latitude');
            Long=hdfread(filen2, swathname03, 'Fields', 'Longitude');
            fileinfo06=hdfinfo(filen1, 'eos');
            swathname06 = fileinfo06.Swath.Name();
            CldAOD = hdfread(filen1, swathname06, 'Fields', 'Cloud_Optical_Thickness');
            CldWatP = hdfread(filen1, swathname06, 'Fields', 'Cloud_Water_Path');
            CldER = hdfread(filen1, swathname06, 'Fields', 'Cloud_Effective_Radius');
            for section=1:1
                Coords = SectionCoors{section};
                Long1 = Long>=Coords(2);
                Long2 = Long<=Coords(3);
                LongMask = Long1.*Long2;
                Lat1 = Lat>=Coords(4);
                Lat2 = Lat<=Coords(1);
                LatMask = Lat1.*Lat2;
                Mask = find(int16(LongMask.*LatMask));
                CAOD = CldAOD(Mask);
                CWP = CldWatP(Mask); 
                CER = CldER(Mask);
                LatPt = Lat(Mask);
                LongPt = Long(Mask);
                HrS = ones(length(Mask),1).*Hr;
                MinS = ones(length(Mask),1).*Min;
                Sectiontable = table(LatPt, LongPt, CAOD, CWP, CER, HrS, MinS, 'VariableNames', Varnames);
                SectionCell{1,section} = [SectionCell{1,section};Sectiontable];
            end;  
        end;
        for section=1:1
            try
                writetable(SectionCell{1,section}, sprintf('%sExtr_%i_%03d_S%i.csv', Opath, yr, day, section))
            end
        end;
    end;
end;

