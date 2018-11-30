% Author: Niladri Das
% Description:
% The OD module gives the best estimate of full ECI states along with the
% mjd_utc time for that state vector. Using this initial state we propagate
% and read state values at certain intervals. The point at which the
% propagted states are calculated matches with the time point at which
% range observations are available from a certain ground station. Here we
% compare how well the original acceleration module of HPOP performs with
% respect to the mee based acceleration module of ours.

clc;clear;close all;format long g % Best of fixed or floating point format with 15 digits.
%%
SAT_Const;
%%
global eopdata
% read Earth orientation parameters
fid = fopen('eop19620101.txt','r'); % Has a specific format. Before updating check the format
eopdata = fscanf(fid,'%i %d %d %i %f %f %f %f %f %f %f %f %i',[13 inf]);
fclose(fid);
%% Read the observation file 
crd_source = 'starlette_20170401_MONL.npt';
% Extracted from Dataset No. 1568624
if strcmp(crd_source((end-3):end),'.frd')~=1 && strcmp(crd_source((end-3):end),'.npt')~=1
    error('This file does not have a CRD data file extension');
else
    disp('The file extension looks good but the CRD file needs checking');
end
% CRD checking at this point
% Perliminary check passed 
fidcrd = fopen(crd_source);
[station,stationepochtimescale,target,cosparid,sicid,...
    noradid,spaceepochtimescale,targettype,datatype,...
    year,month,day,hour,minute,sec,endyear,endmonth,...
    endday,endhour,endminute,endsec, refcorrect, cmcorrect,...
    recampcorrect,stsysdelcorrect,satsysdelcorrect,...
    rngtypeind,dataqual,endofsession,endoffile,...
    rangerecord,normrecord,metdata,usedwavelngth,pointing_data] = crd_parse(fidcrd);
fclose(fidcrd);
%% Read the referece states from CPF file
cpf_source = 'starlette_cpf_20170401.hts';
fidcpf = fopen(cpf_source);
% extract postion vectors
cpfdata = getcpf(fidcpf);
fclose(fidcpf);
% %%
% global eopdata
% % read Earth orientation parameters
% fid = fopen('eop19620101.txt','r'); % Has a specific format. Before updating check the format
% eopdata = fscanf(fid,'%i %d %d %i %f %f %f %f %f %f %f %f %i',[13 inf]);
% fclose(fid);


