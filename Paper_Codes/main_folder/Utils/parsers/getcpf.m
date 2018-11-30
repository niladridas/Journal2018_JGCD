% Author: Vedang Deshpande
% Email: vedang.deshpande@tamu.edu
% Affiliation: Laboratory for Uncertainty Quantification
%              Aerospace Engineering Department, TAMU, TX, USA
%--------------------------------------------------------------------------
% Version  Date         Author      Mod History
%--------------------------------------------------------------------------
% 1        24 Nov 2017  Vedang D.   Inital version
% 2        26 Nov 2017  Vedang D.   Updated function to give coordinates in
%                                   ECI frame
%--------------------------------------------------------------------------

% Input: A CPF data file to read
% Output: position predictions(x, y, z) in ECI against calendar day and seconds of
% the day
%
% Note: This is not parser. This code converts the read data from cpf file to
% usable format. The parser cpf_matlab() is called to parse the cpf file.


function cpfdata = getcpf(fid)

[source, prodyear, prodmonth, prodday, prodhour, target,...
    cosparid, sicid, noradid,...
    startyear, startmonth, startday, starthour, startmin, startsec, ...
    endyear, endmonth, endday, endhour, endmin, endsec,...
    timestep, targettype, rf, cmcorrection,...
    cmoffset,...
    predicts] = cpf_matlab(fid);
% read Modified Julian Dates
temp_mjd = str2double(predicts(:,1));
% convert MJD to Julian Dates
temp_jd = temp_mjd + 2400000.5;
% convert MJD to calendar day

cpfdata.date = datestr(datetime(temp_jd,'convertfrom','juliandate'));
cpfdata.timestamp = str2double(predicts(:,2));
cpfdata.mjdutc = temp_mjd + cpfdata.timestamp/(24*3600);

if  str2double(cmcorrection) == 0
    % Do nothing: Prediction is for CoM
elseif str2double(cmcorrection) == 1
    str = ['WARNING: CPF data is provided for retro reflectors. Should be corrected for CoM.',' cmoffset = ', cmoffset,' m.'];
    disp(str);
end
        
% Convert cooedinates to ECI frame
if str2double(rf)==0
   % Data is in Geocentric True Body Fixed - ECEF. Convert to ECI.
    cpfdata.xecf = str2double(predicts(:,3));
    cpfdata.yecf = str2double(predicts(:,4));
    cpfdata.zecf = str2double(predicts(:,5));
    
   for i = 1:length(cpfdata.mjdutc)
       recf = [cpfdata.xecf(i), cpfdata.yecf(i), cpfdata.zecf(i)]; % position vector in ECEF
       reci = recef2eci(cpfdata.mjdutc(i), recf); % position vector in ECI
       cpfdata.xeci(i,1) = reci(1);
       cpfdata.yeci(i,1) = reci(2);
       cpfdata.zeci(i,1) = reci(3);
   end % for 
elseif str2double(rf)==1
    cpfdata.xeci = str2double(predicts(:,3));
    cpfdata.yeci = str2double(predicts(:,4));
    cpfdata.zeci = str2double(predicts(:,5));
    str1 = 'WARNING: CPF data is provided in Geocentric Space Fixed Inertial - True of Date frame.';
    disp(str1);
elseif str2double(rf)==2
    cpfdata.xeci = str2double(predicts(:,3));
    cpfdata.yeci = str2double(predicts(:,4));
    cpfdata.zeci = str2double(predicts(:,5));
    str1 = 'WARNING: CPF data is provided in Geocentric Space Fixed Inertial - Mean of Date J2000 frame.';
    disp(str1);
end % if rf

end % function