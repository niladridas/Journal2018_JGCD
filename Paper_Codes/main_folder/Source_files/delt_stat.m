% Author: Niladri Das
% Affiliation: Texas A&M Univeristy
clc;clear;close; format long g;
enkf50 = load('delprop_data_EnKF50.mat');
enkf100 = load('delprop_data_EnKF100.mat');
enkf500 = load('delprop_data_EnKF500.mat');
ot50 = load('delprop_data_OT50.mat');
ot100 = load('delprop_data_OT100.mat');
ot500 = load('delprop_data_OT500.mat');

% Take one point cloud with repitition and find the mean and variance for
% each repitition
% TO-DO: We assume that we have same number of repititions in each data set
repeat = size(enkf50.delprop_data_EnKF.prop_pointcloud,3);
mean_enkf50 = zeros(6,1,repeat);
var_enkf50 = zeros(6,1,repeat);
mean_enkf100 = zeros(6,1,repeat);
var_enkf100 = zeros(6,1,repeat);
mean_enkf500 = zeros(6,1,repeat);
var_enkf500 = zeros(6,1,repeat);
mean_ot50 = zeros(6,1,repeat);
var_ot50 = zeros(6,1,repeat);
mean_ot100 = zeros(6,1,repeat);
var_ot100 = zeros(6,1,repeat);
mean_ot500 = zeros(6,1,repeat);
var_ot500 = zeros(6,1,repeat);

for r = 1:repeat
    mean_enkf50(:,:,r) = mean(enkf50.delprop_data_EnKF.prop_pointcloud(:,:,r),2);
    var_enkf50(:,:,r) = var(enkf50.delprop_data_EnKF.prop_pointcloud(:,:,r),0,2);
    mean_enkf100(:,:,r) = mean(enkf100.delprop_data_EnKF.prop_pointcloud(:,:,r),2);
    var_enkf100(:,:,r) = var(enkf100.delprop_data_EnKF.prop_pointcloud(:,:,r),0,2);
    mean_enkf500(:,:,r) = mean(enkf500.delprop_data_EnKF.prop_pointcloud(:,:,r),2);
    var_enkf500(:,:,r) = var(enkf500.delprop_data_EnKF.prop_pointcloud(:,:,r),0,2);
    mean_ot50(:,:,r) = mean(ot50.delprop_data_OT.prop_pointcloud(:,:,r),2);
    var_ot50(:,:,r) = var(ot50.delprop_data_OT.prop_pointcloud(:,:,r),0,2);
    mean_ot100(:,:,r) = mean(ot100.delprop_data_OT.prop_pointcloud(:,:,r),2);
    var_ot100(:,:,r) = var(ot100.delprop_data_OT.prop_pointcloud(:,:,r),0,2);
    mean_ot500(:,:,r) = mean(ot500.delprop_data_OT.prop_pointcloud(:,:,r),2);
    var_ot500(:,:,r) = var(ot500.delprop_data_OT.prop_pointcloud(:,:,r),0,2);   
end

% Mean and variance of estimates over repititions and mean and varianec of variance over repititions
dOT50_stat.mean_est_OT = mean(mean_ot50,3);
dOT50_stat.var_est_OT = var(mean_ot50,0,3);
dOT50_stat.mean_var_OT = mean(var_ot50,3);
dOT50_stat.var_var_OT = var(var_ot50,0,3);
dEnKF50_stat.mean_est_EnKF = mean(mean_enkf50,3);
dEnKF50_stat.var_est_EnKF = var(mean_enkf50,0,3);
dEnKF50_stat.mean_var_EnKF = mean(var_enkf50,3);
dEnKF50_stat.var_var_EnKF = var(var_enkf50,0,3);

dOT100_stat.mean_est_OT = mean(mean_ot100,3);
dOT100_stat.var_est_OT = var(mean_ot100,0,3);
dOT100_stat.mean_var_OT = mean(var_ot100,3);
dOT100_stat.var_var_OT = var(var_ot100,0,3);
dEnKF100_stat.mean_est_EnKF = mean(mean_enkf100,3);
dEnKF100_stat.var_est_EnKF = var(mean_enkf100,0,3);
dEnKF100_stat.mean_var_EnKF = mean(var_enkf100,3);
dEnKF100_stat.var_var_EnKF = var(var_enkf100,0,3);

dOT500_stat.mean_est_OT = mean(mean_ot500,3);
dOT500_stat.var_est_OT = var(mean_ot500,0,3);
dOT500_stat.mean_var_OT = mean(var_ot500,3);
dOT500_stat.var_var_OT = var(var_ot500,0,3);
dEnKF500_stat.mean_est_EnKF = mean(mean_enkf500,3);
dEnKF500_stat.var_est_EnKF = var(mean_enkf500,0,3);
dEnKF500_stat.mean_var_EnKF = mean(var_enkf500,3);
dEnKF500_stat.var_var_EnKF = var(var_enkf500,0,3);



ref_eci50 = ot50.delprop_data_OT.cpf_eci;
ref_eci100 = ot100.delprop_data_OT.cpf_eci;
ref_eci500 = ot500.delprop_data_OT.cpf_eci;

error50ot = dOT50_stat.mean_est_OT(1:3,1)'-ref_eci50;
error50ot = norm(error50ot);
error50enkf = dEnKF50_stat.mean_est_EnKF(1:3,1)'-ref_eci50;
error50enkf = norm(error50enkf);


error100ot = dOT100_stat.mean_est_OT(1:3,1)'-ref_eci100;
error100ot = norm(error100ot);
error100enkf = dEnKF100_stat.mean_est_EnKF(1:3,1)'-ref_eci100;
error100enkf = norm(error100enkf);

error500ot = dOT500_stat.mean_est_OT(1:3,1)'-ref_eci500;
error500ot = norm(error500ot);
error500enkf = dEnKF500_stat.mean_est_EnKF(1:3,1)'-ref_eci500;
error500enkf = norm(error500enkf);
% error100 = ot100.delprop_data_OT.cpf_eci-enkf100.delprop_data_EnKF.cpf_eci;
% error500 = ot500.delprop_data_OT.cpf_eci-enkf500.delprop_data_EnKF.cpf_eci;











