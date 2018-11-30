% Author: Niladri Das
% Affiliation: Texas A&M Univeristy
clc;clear;close;format long g
load('plot_alldata/OT_stat500.mat');load('plot_alldata/EnKF_stat500.mat');
% Check if repitition is there
if size(OT_stat.point_cloud_OT,3)==1
    flag_repreat = 0;
else
    flag_repreat = 1;
end
%%
nobs = OT_stat.Nobs_set'; % no of observations in each pass
data_OT = sqrt(OT_stat.mean_var_OT(:,1:6));
data_ENKF = sqrt(EnKF_stat.mean_var_EnKF(:,1:6));
if flag_repreat == 0 % Just plotting the variance in 6 states
    plot_norepeat(data_OT,data_ENKF, nobs);
end
%%
% if flag_repeat == 1
%     plot_repeat
% end

