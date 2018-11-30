% Author: Niladri Das
% Affiliation: Texas A&M Univeristy
clc;clear;close; format long g;
load('./data1/OT100.mat');load('./data1/EnKF100.mat');
% Calculating statistics
OT_points = OT.point_cloud_OT;
OT_mjd = OT.mjdutc;
EnKF_points = EnKF.point_cloud_EnKF;
EnKF_mjd = EnKF.mjdutc;
samples = size(OT_points,2);
Nobs = size(OT_mjd,1);
repeat = size(OT_points,3);
% OT
est_OT = zeros(Nobs,6,repeat);
var_OT = zeros(Nobs,6,repeat);
for r = 1:repeat
    for i = 1:Nobs
        tmp_samples = OT_points(6*(i-1)+1:6*i,:,r);
        est_OT(i,:,r) = mean(tmp_samples,2)';
        var_OT(i,:,r) = var(tmp_samples,0,2)';
    end
end
% EnKF
est_EnKF = zeros(Nobs,6,repeat);
var_EnKF = zeros(Nobs,6,repeat);
for r = 1:repeat
    for i = 1:Nobs
        tmp_samples = EnKF_points(6*(i-1)+1:6*i,:,r);
        est_EnKF(i,:,r) = mean(tmp_samples,2)';
        var_EnKF(i,:,r) = var(tmp_samples,0,2)';
    end
end
% % Mean and variance of estimates over repititions and mean and varianec of variance over repititions
% if size(est_OT,3)==1
%     OT_stat.mean_est_OT = est_OT;
%     OT_stat.var_est_OT = zeros(size(est_OT,1),size(est_OT,2));
%     OT_stat.mean_var_OT = var_OT;
%     OT_stat.var_var_OT = zeros(size(var_OT,1),size(var_OT,2));
%     EnKF_stat.mean_est_EnKF = est_EnKF;
%     EnKF_stat.var_est_EnKF = zeros(size(est_EnKF,1),size(est_EnKF,2));
%     EnKF_stat.mean_var_EnKF = var_EnKF;
%     EnKF_stat.var_var_EnKF = zeros(size(var_EnKF,1),size(var_EnKF,2));
% else
OT_stat.mean_est_OT = mean(est_OT,3);
OT_stat.var_est_OT = var(est_OT,0,3);
OT_stat.mean_var_OT = mean(var_OT,3);
OT_stat.var_var_OT = var(var_OT,0,3);
EnKF_stat.mean_est_EnKF = mean(est_EnKF,3);
EnKF_stat.var_est_EnKF = var(est_EnKF,0,3);
EnKF_stat.mean_var_EnKF = mean(var_EnKF,3);
EnKF_stat.var_var_EnKF = var(var_EnKF,0,3);
% end
% Saving all the initial data
OT_stat.point_cloud_OT = OT.point_cloud_OT;
OT_stat.mjdutc = OT.mjdutc;
OT_stat.pass_numbers = OT.pass_numbers;
OT_stat.Nobs_set = OT.Nobs_set;
file1 = sprintf('./data1/OT_stat%i.mat',samples);
save(file1,'OT_stat');

EnKF_stat.point_cloud_EnKF = EnKF.point_cloud_EnKF;
EnKF_stat.mjdutc = EnKF.mjdutc;
EnKF_stat.pass_numbers = EnKF.pass_numbers;
EnKF_stat.Nobs_set = EnKF.Nobs_set;
file2 = sprintf('./data1/EnKF_stat%i.mat',samples);
save(file2,'EnKF_stat');
%% Calcuating the difference in the states at the end of filtering btwn OT and EnKF
% Evolution of the difference in the posterior mean of the estimates over
% repititions

diff_states = OT_stat.mean_est_OT -EnKF_stat.mean_est_EnKF; 





