function plot_repeat(OT_stat50,OT_stat50)
%     OT_stat.mean_est_OT = mean(est_OT,3);
%     OT_stat.var_est_OT = var(est_OT,0,3);
%     OT_stat.mean_var_OT = mean(var_OT,3);
%     OT_stat.var_var_OT = var(var_OT,3);
%     EnKF_stat.mean_est_OT = mean(est_EnKF,3);
%     EnKF_stat.var_est_OT = var(est_EnKF,0,3);
%     EnKF_stat.mean_var_OT = mean(var_EnKF,3);
%     EnKF_stat.var_var_OT = var(var_EnKF,3);
%     OT_stat.point_cloud_OT = OT.point_cloud_OT;
%     OT_stat.mjdutc = OT.mjdutc;
%     OT_stat.pass_numbers = OT.pass_numbers;
%     OT_stat.Nobs_set = OT.Nobs_set;

% Plots:
% 1. Mean of estimate and sigma as error plot (6 plots i.e. 3 times 2)
% 2. Mean of the sigma and sigma of sigma as error plot (6 plots)

%% Mean plots
figure(1)
for i = 1:6
    subplot(3,2,i)
    % data:
    D11 = OT_stat.mean_est_OT;
    D12 = OT_stat.var_est_OT;
    D21 = EnKF_stat.mean_est_EnKF;
    D22 = EnKF_stat.var_est_EnKF;
    
end