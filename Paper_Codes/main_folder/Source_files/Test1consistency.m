% Innovation magnitude bound test
% Date: 4th Dec 2018
clc; clear; close;
load('./plot_alldata/EnKF_stat50.mat');
load('./plot_alldata/OT_stat50.mat');

% Calculating the innovations
% True measurement & Estimated measurement
no_obs = size(EnKF_stat.mean_est_EnKF,1);
for i = 1:no_obs
inov_terms = inovestimate(x_state,z, PTRh,MJD_UTCtime,MJD_J2000,eopdata,Arcs,lambda,  station_ecefxyz, st_latlongalt, GM_Earth,R_Earth ,f_Earth);
end

