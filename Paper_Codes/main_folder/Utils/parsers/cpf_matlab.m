% Author: Vedang Deshpande
% Email: vedang.deshpande@tamu.edu
% Affiliation: Laboratory for Uncertainty Quantification
%              Aerospace Engineering Department, TAMU, TX, USA
% Date: 24 Nov 2017

% Input: A CPF data file to read
% Output: 
% This is just a parser. All outputs are strings.

% This program reads the Consolidated Prediction Format
% The file extensions usually tells us the source of ephemerides

% Note: 
% 1. The first two characters tell what is in that line
% 2. List of these first two characters:
%    [h1,h2,h3,h4,c0,c1,c2,c3,60,20,40,30,12,10]

% Load the data file and read them
function [source, prodyear, prodmonth, prodday, prodhour, target,...
    cosparid, sicid, noradid,...
    startyear, startmonth, startday, starthour, startmin, startsec, ...
    endyear, endmonth, endday, endhour, endmin, endsec,...
    timestep, targettype, rf, cmcorrection,...
    cmoffset,...
    predicts] = cpf_matlab(fid)

source = 'empty';
predicts = [];
rfid = -1;

% set read flag to first line
frewind(fid);
% start reading the file
line = fgetl(fid);
while ischar(line)
    %disp(line);
    if strcmp(line(1:2),'h1')==1|| strcmp(line(1:2),'H1')==1
        % ephemeris source
        source = strtrim(line(12:14));
        
        % cpf production year month day hour (UTC)
        prodyear = strtrim(line(16:19));
        prodmonth = strtrim(line(21:22));
        prodday = strtrim(line(24:25));
        prodhour = strtrim(line(27:28));
        
        % target satellite name
        target = strtrim(line(36:45));
    elseif strcmp(line(1:2),'h2')==1|| strcmp(line(1:2),'H2')==1
        % different ids for the target
        cosparid = strtrim(line(4:11));
        sicid = strtrim(line(13:16));
        noradid = strtrim(line(18:25));
        
        % start time of the ephemeris
        startyear = strtrim(line(27:30));
        startmonth = strtrim(line(32:33));
        startday = strtrim(line(35:36));
        starthour = strtrim(line(38:39));
        startmin = strtrim(line(41:42));
        startsec = strtrim(line(44:45));
        
        % start time of the ephemeris
        endyear = strtrim(line(47:50));
        endmonth = strtrim(line(52:53));
        endday = strtrim(line(55:56));
        endhour = strtrim(line(58:59));
        endmin = strtrim(line(61:62));
        endsec = strtrim(line(64:65));
        
        % time step
        timestep = strtrim(line(67:71));
        
        % target type
        targettype = strtrim(line(75:75));
%         if strcmp(line(75:75),'1')==1
%             targettype = '1 Retro Reflector Satellite';
%         elseif strcmp(line(75:75),'2')==1
%             targettype = '2 Retro Reflector Lunar';
%         elseif strcmp(line(75:75),'3')==1
%             targettype = '3 Sync Transponder';
%         elseif strcmp(line(75:75),'4')==1
%             targettype = '4 ASync Transponder';
%         end
       
        % reference frame of the ephemeris
        rf =  strtrim(line(77:78));
        
        % CoM correction
        cmcorrection = strtrim(line(82:82));
        
    elseif strcmp(line(1:2),'h5')==1|| strcmp(line(1:2),'H5')==1
        % CoM offset from retro reflectors for spherical satellites
        cmoffset = strtrim(line(4:10));
        
    elseif strcmp(line(1:2),'10')==1
        C = strsplit(line(4:end));
        
        % direction flag
        dirflag = C(1);
        
        % Modified Julian Date
        mjd = C(2);
        
        % seconds of day
        secofday = C(3);
        
        % leap sec flag
        leapsflag = C(4);
        
        % X Y Z coordinates
        x = C(5); y = C(6); z = C(7);
        
        % store in one structure
        predicts = [predicts; [mjd, secofday, x, y, z]];
        
    end % if - record type
    line = fgetl(fid);
end % while
end % function
