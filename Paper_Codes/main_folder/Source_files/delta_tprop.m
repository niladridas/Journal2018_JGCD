% Author: Niladri Das
clc;clear;close all;
format long g
start_var
choose_jb2008
options = rdpset('RelTol',1e-13,'AbsTol',1e-16); % RADAU options

load('./data1/OT_stat50.mat');load('./data1/EnKF_stat50.mat');
OT_pointcloud = OT_stat.point_cloud_OT(end-5:end,:,:);
OT_start_eci = OT_stat.mean_est_OT(end,:);
OT_start_mee = coe2mee(eci2coe(OT_start_eci,GM_Earth));
OT_start_mjdutc = OT_stat.mjdutc(end);
EnKF_pointcloud = EnKF_stat.point_cloud_EnKF(end-5:end,:,:);
EnKF_start_eci = EnKF_stat.mean_est_EnKF(end,:);
EnKF_start_mee = coe2mee(eci2coe(EnKF_start_eci,GM_Earth));
EnKF_start_mjdutc = EnKF_stat.mjdutc(end);

%% OT
start_val_meeOT = OT_start_mee; % MEE
start_time = OT_start_mjdutc; % Start time to start time propagation
AuxParam.Mjd_UTC = start_time; % start_time is the base time
accel_meenew = @(x,Y1) accel_mee(x,Y1,sysfun,eopdata,AuxParam,MJD_J2000,AU,GM_Earth,...
    GM_Sun, GM_Moon, GM_Mercury, GM_Venus, GM_Mars,GM_Jupiter, GM_Saturn, GM_Uranus,...
    GM_Neptune, GM_Pluto, P_Sol,jb2008_path,Arcs,PC,Cnm, Snm,R_Earth, f_Earth,c_light,...
    R_Sun, R_Moon); % Initializing the constructor module
c_i = findclosest(start_time,cpfdata_compiled.mjdutc)+1;
% for each repititions propagate all the samples
% Data OT: prop_pointcloud (6*Nobs x samples)x repeat
[~,samples,repeat] = size(OT_pointcloud);
prop_pointcloud = zeros(6,samples,repeat);
for r = 1:repeat
    data_pt_eci = OT_pointcloud(:,:,r);
    parfor j = 1:samples
        data_pt_mee = coe2mee(eci2coe(data_pt_eci(:,j)',GM_Earth));
        tic
        [tOT,x_tempOT] = radau(accel_meenew,[0 (cpfdata_compiled.mjdutc(c_i)-AuxParam.Mjd_UTC)*86400],...
                        data_pt_mee,options);            
        toc
        propdata_pt_eci = coe2eci(mee2coe(x_tempOT(end,:)),GM_Earth);
        prop_pointcloud(:,j,r) = propdata_pt_eci;
    end
end

delprop_data_OT.prop_pointcloud = prop_pointcloud;
delprop_data_OT.prop_eci_OT_time = cpfdata_compiled.mjdutc(c_i);
delprop_data_OT.cpf_eci = [cpfdata_compiled.xeci(c_i,1),cpfdata_compiled.yeci(c_i,1),cpfdata_compiled.zeci(c_i,1)];
delprop_data_OT.cpf_eci_time = cpfdata_compiled.mjdutc(c_i);

%%
file1 = sprintf('./data1/delprop_data_OT%i.mat',samples);
save(file1,'delprop_data_OT');
% EnKF
start_val_meeEnKF = EnKF_start_mee; % MEE
start_time = EnKF_start_mjdutc; % Start time to start time propagation
AuxParam.Mjd_UTC = start_time; % start_time is the base time
accel_meenew = @(x,Y1) accel_mee(x,Y1,sysfun,eopdata,AuxParam,MJD_J2000,AU,GM_Earth,...
    GM_Sun, GM_Moon, GM_Mercury, GM_Venus, GM_Mars,GM_Jupiter, GM_Saturn, GM_Uranus,...
    GM_Neptune, GM_Pluto, P_Sol,jb2008_path,Arcs,PC,Cnm, Snm,R_Earth, f_Earth,c_light,...
    R_Sun, R_Moon); % Initializing the constructor module
c_i = findclosest(start_time,cpfdata_compiled.mjdutc)+1; 
[~,samples,repeat] = size(EnKF_pointcloud);
prop_pointcloud = zeros(6,samples,repeat);
for r = 1:repeat
    data_pt_eci = EnKF_pointcloud(:,:,r);
     parfor j = 1:samples
        data_pt_mee = coe2mee(eci2coe(data_pt_eci(:,j)',GM_Earth));
        tic
        [tEnKF,x_tempEnKF] = radau(accel_meenew,[0 (cpfdata_compiled.mjdutc(c_i)-AuxParam.Mjd_UTC)*86400],...
                        data_pt_mee,options);            
        toc
        propdata_pt_eci = coe2eci(mee2coe(x_tempEnKF(end,:)),GM_Earth);
        prop_pointcloud(:,j,r) = propdata_pt_eci;
    end
end
%%

delprop_data_EnKF.prop_pointcloud = prop_pointcloud;
delprop_data_EnKF.prop_eci_OT_time = cpfdata_compiled.mjdutc(c_i);
delprop_data_EnKF.cpf_eci = [cpfdata_compiled.xeci(c_i,1),cpfdata_compiled.yeci(c_i,1),cpfdata_compiled.zeci(c_i,1)];
delprop_data_EnKF.cpf_eci_time = cpfdata_compiled.mjdutc(c_i);

file2 = sprintf('./data1/delprop_data_EnKF%i.mat',samples);
save(file2,'delprop_data_EnKF');% 
