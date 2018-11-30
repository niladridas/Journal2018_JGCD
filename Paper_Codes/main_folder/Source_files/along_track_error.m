clc;clear;close;
A1 = load('./plot_alldata/prop_data_OT50.mat');
D1 = A1.prop_data_OT.index;
E1 = A1.prop_data_OT.prop_eci_OT;
E1 = E1(2:end-1,:);
T1 = A1.prop_data_OT.prop_eci_OT_time;
T1 = T1(2:end-1,1);

A2 = load('./plot_alldata/prop_data_EnKF50.mat');
D2 = A2.prop_data_EnKF.index;
E2 = A2.prop_data_EnKF.prop_eci_EnKF;
E2 = E2(2:end-1,:);
T2 = A2.prop_data_EnKF.prop_eci_EnKF_time;
T2 = T2(2:end-1,1);

B2 = load('cpfdata_compiled.mat');
C1 = B2.cpfdata_compiled;


[a1,a2] = size(E1);
along_trackOT = zeros(a1,1);

[b1,b2] = size(E2);

along_trackEnKF = zeros(b1,1);


parfor i = 1:a1
 [along_track1, cross_track_normal1, cross_track_inplane1]...
     = trackError(C1,D1-481+i,E1(i,1:3)');
 along_trackOT(i,1) = along_track1;
end

parfor i = 1:b1
  [along_track2, cross_track_normal2, cross_track_inplane2]...
     = trackError(C1,D2-481+i,E2(i,1:3)');
  along_trackEnKF(i,1) = along_track2;

end

% 
% B2 = load('cpfdata_compiled.mat');
% C1 = B2.cpfdata_compiled;
% 
% A1 = load('./plot_alldata/prop_data_OT100.mat');
% D1 = A1.prop_data_OT.index;
% E1 = A1.prop_data_OT.prop_eci_OT;
% 
% [along_track1, cross_track_normal1, cross_track_inplane1]...
%      = trackError(C1,D1-1,E1(end-1,1:3)');
% 
% A2 = load('./plot_alldata/prop_data_EnKF100.mat');
% D2 = A2.prop_data_EnKF.index;
% E2 = A2.prop_data_EnKF.prop_eci_EnKF;
% [along_track2, cross_track_normal2, cross_track_inplane2]...
%      = trackError(C1,D2-1,E2(end-1,1:3)');



