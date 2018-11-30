% Author: Niladri Das
% Affiliation: Texas A&M Univeristy
clc;clear;close;format long g
load('OT_stat50.mat');load('EnKF_stat50.mat');
load('prop_data_OT');
Nobs_set = OT_stat.Nobs_set;
mjdutc = OT_stat.mjdutc;
point_cloud_all = OT_stat.point_cloud;

% CPF and OT comparison data

save()



