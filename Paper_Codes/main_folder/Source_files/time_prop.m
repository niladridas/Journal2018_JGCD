% Author: Niladri Das
clc;clear;close all;
format long g
start_var
choose_jb2008
options = rdpset('RelTol',1e-13,'AbsTol',1e-16); % RADAU options
datapath = 'D:\experiment\main_folder\Source_files\data1';
load('OT_stat100.mat');load('EnKF_stat100.mat');
OT_start_eci = OT_stat.mean_est_OT(end,:);
OT_start_mee = coe2mee(eci2coe(OT_start_eci,GM_Earth));
OT_start_mjdutc = OT_stat.mjdutc(end);
EnKF_start_eci = EnKF_stat.mean_est_EnKF(end,:);
EnKF_start_mee = coe2mee(eci2coe(EnKF_start_eci,GM_Earth));
EnKF_start_mjdutc = EnKF_stat.mjdutc(end);

t_inv = 1; % How long to time propagate forward in time for CPF comparison
%% OT
start_val_meeOT = OT_start_mee; % MEE
start_time = OT_start_mjdutc; % Start time to start time propagation
AuxParam.Mjd_UTC = start_time; % start_time is the base time
accel_meenew = @(x,Y1) accel_mee(x,Y1,sysfun,eopdata,AuxParam,MJD_J2000,AU,GM_Earth,...
    GM_Sun, GM_Moon, GM_Mercury, GM_Venus, GM_Mars,GM_Jupiter, GM_Saturn, GM_Uranus,...
    GM_Neptune, GM_Pluto, P_Sol,jb2008_path,Arcs,PC,Cnm, Snm,R_Earth, f_Earth,c_light,...
    R_Sun, R_Moon); % Initializing the constructor module
c_i = findclosest(start_time,cpfdata_compiled.mjdutc)+1; 
c_j = findclosest(start_time+t_inv,cpfdata_compiled.mjdutc)+1;
% tic
% [tOT,x_tempOT] = radau(accel_meenew,[0 (cpfdata_compiled.mjdutc(c_j)-AuxParam.Mjd_UTC)*86400],...
%                     start_val_meeOT,options);
% toc
% % Propagation type 2
tic
time_vec = [0;(cpfdata_compiled.mjdutc(c_i:c_j) -AuxParam.Mjd_UTC*ones(c_j-c_i+1,1))*86400]; 
[tOT,x_tempOT] = radau(accel_meenew,time_vec,start_val_meeOT,options);
toc
parfor j = 1:size(x_tempOT,1) % Saving all the time propagated states up-till t_inv time for OT
    prop_eci_OT(j,:) = coe2eci(mee2coe(x_tempOT(j,:)),GM_Earth);
end

prop_data_OT.prop_eci_OT = prop_eci_OT;
prop_data_OT.prop_eci_OT_time = AuxParam.Mjd_UTC*ones(size(tOT,1),1)+tOT./86400;
prop_data_OT.cpf_eci = [cpfdata_compiled.xeci(c_i:c_j,1),cpfdata_compiled.yeci(c_i:c_j,1),...
    cpfdata_compiled.zeci(c_i:c_j,1)];
prop_data_OT.cpf_eci_time = cpfdata_compiled.mjdutc(c_i:c_j);
prop_data_OT.error_end_eci = prop_data_OT.prop_eci_OT(end,1:3) -prop_data_OT.cpf_eci(end,:);
prop_data_OT.error_end_ecinorm = norm(prop_data_OT.error_end_eci);
prop_data_OT.index = c_j;
%%
save('prop_data_OT100.mat','prop_data_OT');
% % EnKF
start_val_meeEnKF = EnKF_start_mee; % MEE
start_time = EnKF_start_mjdutc; % Start time to start time propagation
AuxParam.Mjd_UTC = start_time; % start_time is the base time
accel_meenew = @(x,Y1) accel_mee(x,Y1,sysfun,eopdata,AuxParam,MJD_J2000,AU,GM_Earth,...
    GM_Sun, GM_Moon, GM_Mercury, GM_Venus, GM_Mars,GM_Jupiter, GM_Saturn, GM_Uranus,...
    GM_Neptune, GM_Pluto, P_Sol,jb2008_path,Arcs,PC,Cnm, Snm,R_Earth, f_Earth,c_light,...
    R_Sun, R_Moon); % Initializing the constructor module
c_i = findclosest(start_time,cpfdata_compiled.mjdutc)+1; 
c_j = findclosest(start_time+t_inv,cpfdata_compiled.mjdutc)+1;
% Propagation type 1
% tic
% [tEnKF,x_tempEnKF] = radau(accel_meenew,[0 (cpfdata_compiled.mjdutc(c_j)-AuxParam.Mjd_UTC)*86400],...
%                     start_val_meeEnKF,options);
% toc
% Propagation type 2
tic
time_vec = [0;(cpfdata_compiled.mjdutc(c_i:c_j) -AuxParam.Mjd_UTC*ones(c_j-c_i+1,1))*86400]; 
[tEnKF,x_tempEnKF] = radau(accel_meenew,time_vec,start_val_meeEnKF,options);
toc

parfor j = 1:size(x_tempEnKF,1) % Saving all the time propagated states up-till t_inv time for OT
    prop_eci_EnKF(j,:) = coe2eci(mee2coe(x_tempEnKF(j,:)),GM_Earth);
end
%%
prop_data_EnKF.prop_eci_EnKF = prop_eci_EnKF;
prop_data_EnKF.prop_eci_EnKF_time = AuxParam.Mjd_UTC*ones(size(tEnKF,1),1)+tEnKF/86400;
prop_data_EnKF.cpf_eci = [cpfdata_compiled.xeci(c_i:c_j,1),cpfdata_compiled.yeci(c_i:c_j,1),...
    cpfdata_compiled.zeci(c_i:c_j,1)];
prop_data_EnKF.cpf_eci_time = cpfdata_compiled.mjdutc(c_i:c_j);
prop_data_EnKF.error_end_eci = prop_data_EnKF.prop_eci_EnKF(end,1:3) -prop_data_EnKF.cpf_eci(end,:);
prop_data_EnKF.error_end_ecinorm = norm(prop_data_EnKF.error_end_eci);
prop_data_EnKF.index = c_j;

save('prop_data_EnKF100.mat','prop_data_EnKF');
% 
