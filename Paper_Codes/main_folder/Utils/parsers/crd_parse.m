% Author: Niladri Das
% Email: niladri@tamu.edu
% Affiliation: Laboratory for Uncertainty Quantification
%              Aerospace Engineering Department, TAMU, TX, USA
% Date: 22nd Nov 2017

% Input: A CDR data file to read
% Output: 


% This program reads the Consolidated Laser Ranging Data
% The CRD data can be of two types: Full-rate data and Normal Point Data
% The file extensions usually tells us the type of data
% The data structure in both type of data formats are the same
% We donot need seperate parser for each of them

% Note: 
% 1. The first two characters tell what is in that line
% 2. List of these first two characters:
%    [h1,h2,h3,h4,c0,c1,c2,c3,60,20,40,30,12,10]

% Load the data file and read them
function [station,stationepochtimescale,target,cosparid,sicid,...
    noradid,spaceepochtimescale,targettype,datatype,...
    year,month,day,hour,minute,sec,endyear,endmonth,...
    endday,endhour,endminute,endsec, refcorrect, cmcorrect,...
    recampcorrect,stsysdelcorrect,satsysdelcorrect,...
    rngtypeind,dataqual,endofsession,endoffile,...
    rangerecord,normrecord,metdata,usedwavelngth,pointing_data] = crd_parse(fid)
format long g
stationepochtimescale='empty';
target='empty';
cosparid='empty';
sicid='empty';
noradid='empty';
spaceepochtimescale='empty';
targettype='empty';
datatype = 'empty';
year = 'empty';
month= 'empty';
day= 'empty';
hour= 'empty';
minute= 'empty';
sec= 'empty';
endyear = 'empty';
endmonth= 'empty';
endday= 'empty';
endhour= 'empty';
endminute= 'empty';
endsec= 'empty';
refcorrect = 'empty';
cmcorrect = 'empty';
recampcorrect = 'empty';
stsysdelcorrect = 'empty';
satsysdelcorrect = 'empty';
rngtypeind = 'empty';
dataqual = 'empty';
endofsession = 'empty';
endoffile = 'empty';
rangerecord = [];
normrecord = [];
metdata = [];
usedwavelngth='empty';
station = 'empty';
pointing_data = 'empty';

% Hard Coding
    line = fgetl(fid);
    while ischar(line)
        if strcmp(line(1:2),'h1')==1|| strcmp(line(1:2),'H1')==1
            line = fgetl(fid);
        elseif strcmp(line(1:2),'h2')==1|| strcmp(line(1:2),'H2')==1
            h2len = length(line);
            if h2len>=4 && h2len>=13
                station = line(4:13);
                % Strip off the white spaces
                station = strtrim(station);
            end
            if h2len>=26 && h2len>=27
                stationepochtimescale = line(26:27);
            end
            line = fgetl(fid);
        elseif strcmp(line(1:2),'h3')==1||strcmp(line(1:2),'H3')==1
            h3len = length(line);
            if h3len>=4 && h3len>=13
                target = line(4:13); % name from official list
                % Strip off the white spaces
                target = strtrim(target);
            end
            if h3len>=5 && h3len>=22
                cosparid = line(15:22);
                % Strip off the white spaces
                cosparid = strtrim(cosparid);
            end
            if h3len>=24 && h3len>=27
                sicid = line(24:27);
                % Strip off the white spaces
                sicid = strtrim(sicid);
            end
            if h3len>=29 && h3len>=36
                noradid = line(29:36);
                % Strip off the white spaces
                noradid = strtrim(noradid);
            end
            if h3len==38
                spaceepochtimescale = line(38);
            end
            if h3len==40
                targettype = line(40);
            end
            line = fgetl(fid);
        elseif strcmp(line(1:2),'h4')==1||strcmp(line(1:2),'H4')==1
            h4len = length(line);
            if h4len>=4 && h4len>=5
                datatype = line(4:5); % name from official list
                % Strip off the white spaces
                datatype = strtrim(datatype);
            end
            if h4len>=7 && h4len>=10
                year = line(7:10); 
            end
            if h4len>=12 && h4len>=13
                month = line(12:13); 
                % Strip off the white spaces
                month = strtrim(month);
            end 
            if h4len>=15 && h4len>=16
                day = line(15:16); 
                % Strip off the white spaces
                day = strtrim(day);        
            end
            if h4len>=18 && h4len>=19
                hour = line(18:19); 
                % Strip off the white spaces
                hour = strtrim(hour);        
            end
            if h4len>=21 && h4len>=22
                minute = line(21:22); 
                % Strip off the white spaces
                minute = strtrim(minute);        
            end
            if h4len>=24 && h4len>=25
                sec = line(24:25); 
                % Strip off the white spaces
                sec = strtrim(sec);        
            end 

            if h4len>=27 && h4len>=30
                endyear = line(27:30); 
                % Strip off the white spaces
                endyear = strtrim(endyear);
            end
            if h4len>=32 && h4len>=33
                endmonth = line(32:33); 
                % Strip off the white spaces
                endmonth = strtrim(endmonth);
            end 
            if h4len>=35 && h4len>=36
                endday = line(35:36); 
                % Strip off the white spaces
                endday = strtrim(endday);        
            end
            if h4len>=38 && h4len>=39
                endhour = line(38:39); 
                % Strip off the white spaces
                endhour = strtrim(endhour);        
            end
            if h4len>=41 && h4len>=42
                endminute = line(41:42); 
                % Strip off the white spaces
                endminute = strtrim(endminute);        
            end
            if h4len>=44 && h4len>=45
                endsec = line(44:45); 
                % Strip off the white spaces
                endsec = strtrim(endsec);        
            end 
            if h4len>=50 && h4len>=50
                refcorrect = line(50);
            end
            if h4len>=52 && h4len>=52
                cmcorrect = line(52);
            end
            if h4len>=54 && h4len>=54
                recampcorrect = line(54);
            end 
            if h4len>=56 && h4len>=56
                stsysdelcorrect = line(56);
            end 
            if h4len>=58 && h4len>=58
                satsysdelcorrect = line(58);
            end
            if h4len>=60 && h4len>=60
                rngtypeind = line(60);
            end
            if h4len>=62 && h4len>=62
                dataqual = line(62);
            end         
            line = fgetl(fid);    
        elseif strcmp(line(1:2),'h8')==1||strcmp(line(1:2),'H8')==1
            endofsession = 'true';
            line = fgetl(fid);    
        elseif strcmp(line(1:2),'h9')==1||strcmp(line(1:2),'H9')==1
            endoffile = 'true';
            line = fgetl(fid);    
        elseif strcmp(line(1:2),'C0')==1||strcmp(line(1:2),'c0')==1
            line = fgetl(fid);    
        elseif strcmp(line(1:2),'C1')==1||strcmp(line(1:2),'c1')==1
            line = fgetl(fid);    
        elseif strcmp(line(1:2),'C2')==1||strcmp(line(1:2),'c2')==1
            C = strsplit(line(4:end));
            usedwavelngth = C(4);
            line = fgetl(fid);    
        elseif strcmp(line(1:2),'C3')==1||strcmp(line(1:2),'c3')==1
            line = fgetl(fid);    
        elseif strcmp(line(1:2),'C4')==1||strcmp(line(1:2),'c4')==1
            line = fgetl(fid);    
        elseif strcmp(line(1:2),'10')==1
            C = strsplit(line(1:end));
            secofday = C(2);
            timefltsec = C(3);
            sysconid = C(4);
            epochevent = C(5);
            filterflag = C(6);
            detectorchannel = C(7);
            stopnum = C(8) ;
            recamp = C(9);
            rangerecord = [rangerecord;[secofday,timefltsec,....
                sysconid,epochevent,filterflag,detectorchannel,...
                stopnum,recamp]];
            line = fgetl(fid);
        elseif strcmp(line(1:2),'11')==1
            C = strsplit(line(1:end));
            secofday = C(2);
            timefltsec = C(3);
            sysconid = C(4);
            epochevent = C(5);
            normptwindlen = C(6);
            noofrawrng = C(7);
            binrms = C(8) ;
            binskew = C(9);
            binkurtosis = C(10);
            binpeak = C(11);
            f51 = C(12);
            detechnl = C(13);
            normrecord = [normrecord;[secofday,timefltsec,....
                sysconid,epochevent,normptwindlen,noofrawrng,...
                binrms,binskew,binkurtosis,binpeak,f51,detechnl,]];
            line = fgetl(fid);                   
        elseif strcmp(line(1:2),'12')==1
            line = fgetl(fid);    
        elseif strcmp(line(1:2),'20')==1
            C = strsplit(line(1:end));
            secofday = C(2); % time measured
            surfpres = C(3); % mbar
            surftemp = C(4); % Kelvin
            relhum = C(5); % percent
            origin = C(6);
            metdata = [metdata;[secofday,surfpres,surftemp,relhum,...
            origin]];
            line = fgetl(fid); 
        elseif strcmp(line(1:2),'21')==1
            line = fgetl(fid); 
        elseif strcmp(line(1:2),'30')==1
            C = strsplit(line(1:end));
            secofday = C(2);
            azimuth = C(3); % in degrees
            elevation = C(4); % in degrees
            dirflag = C(5); % Origin Indicator .... This piece of data is important
            refcorrect = C(6); % This is important as it decides the confidence in the pointing angle
            pointing_data = [secofday;azimuth;elevation;dirflag;refcorrect];
            line = fgetl(fid); 
        elseif strcmp(line(1:2),'40')==1
            line = fgetl(fid); 
        elseif strcmp(line(1:2),'50')==1
            line = fgetl(fid); 
        elseif strcmp(line(1:2),'60')==1
            line = fgetl(fid); 
       end 
   end
end


