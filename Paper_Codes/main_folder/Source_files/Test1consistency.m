% Innovation magnitude bound test
% Date: 4th Dec 2018
clc; clear; close;
% load('./plot_alldata/EnKF_stat50.mat');
% load('./plot_alldata/OT_stat50.mat');

load('./data2_old/EnKF_stat50.mat');
load('./data2_old/OT_stat50.mat');


% Observations
start_var;choose_jb2008;simulation_inputs 
pass_numbers = EnKF_stat.pass_numbers;
Nobs_set = [size(passes(pass_numbers(1)).mjdutc,1) size(passes(pass_numbers(2)).mjdutc,1)];
% Observations
observation = join_obs(pass_numbers,passes);
% Nobs= size(observation.mjdutc,1); 
[mee_start,fulleci_state,obs_states,Mjd_UTC,del_t] = ...
    before_filtering(observation,cpfdata_compiled,AuxParam,GM_Earth,eopdata,...
    MJD_J2000,Arcs,PC,Cnm, Snm);
range_observations =  obs_states(:,2);
weather_observations = obs_states(:,3:5);
% Averaged point cloud data for EnKF
EnKF_avgdata = mean(EnKF_stat.point_cloud_EnKF,3);

% Calculating the innovations for EnKF
% True measurement & Estimated measurement
no_obs = size(EnKF_stat.mean_est_EnKF,1);
no_samples = size(EnKF_stat.point_cloud_EnKF,2);

innovationEnKF = zeros(no_obs,no_samples);
for i = 1:no_obs
    z = range_observations(i);
    % x_state is in ECI  
    eci_states = EnKF_avgdata((i-1)*6+1:i*6,:);
    inov_terms = inovestimate(eci_states,z, weather_observations(i,:),EnKF_stat.mjdutc(i),MJD_J2000,eopdata,Arcs,lambda,  station_ecefxyz, st_latlongalt,R_Earth ,f_Earth);
    innovationEnKF(i,:) = inov_terms;
end
% Calculate covariance of innovation for each observation 
cov_inovEnKF = zeros(no_obs,1); 
for i = 1:no_obs
    cov_inovEnKF(i,1) =  (1/(no_samples))*sum(innovationEnKF(i,:).*innovationEnKF(i,:));
end
sig_inovEnKF= sqrt(cov_inovEnKF);
% Variation of inovation estimate. We use the sample estimates to
% calculate this
enkf_investimate = zeros(no_obs,1);
for i = 1:no_obs
    z = range_observations(i);
    eci_statestmp = mean(EnKF_avgdata,2);
    eci_states = eci_statestmp((i-1)*6+1:i*6,:);
    enkf_investimate(i,1) = inovestimate(eci_states,z, weather_observations(i,:),EnKF_stat.mjdutc(i),MJD_J2000,eopdata,Arcs,lambda,  station_ecefxyz, st_latlongalt,R_Earth ,f_Earth);
end


% Averaged point cloud data for OT
OT_avgdata = mean(OT_stat.point_cloud_OT,3);
% Calculating the innovations for OT
% True measurement & Estimated measurement
innovationOT = zeros(no_obs,no_samples);
for i = 1:no_obs
     z = range_observations(i);
    % x_state is in ECI  
    eci_states = OT_avgdata((i-1)*6+1:i*6,:);
    inov_terms = inovestimate(eci_states,z, weather_observations(i,:),OT_stat.mjdutc(i),MJD_J2000,eopdata,Arcs,lambda,  station_ecefxyz, st_latlongalt,R_Earth ,f_Earth);
    innovationOT(i,:) = inov_terms;
end
% Calculate covariance of innovation for each observation 
cov_inovOT = zeros(no_obs,1); 
for i = 1:no_obs
    cov_inovOT(i,1) =  (1/(no_samples))*sum(innovationOT(i,:).*innovationOT(i,:));
end
sig_inovOT = sqrt(cov_inovOT);
% Variation of inovation estimate. We use the sample estimates to
% calculate this
ot_investimate = zeros(no_obs,1);
for i = 1:no_obs
    z = range_observations(i);
    eci_statestmp = mean(OT_avgdata,2);
    eci_states = eci_statestmp((i-1)*6+1:i*6,:);
    ot_investimate(i,1) = inovestimate(eci_states,z, weather_observations(i,:),EnKF_stat.mjdutc(i),MJD_J2000,eopdata,Arcs,lambda,  station_ecefxyz, st_latlongalt,R_Earth ,f_Earth);
end

%% Plot
figure(1);
% set(gcf,'position', [ 123    90   946   768]);

a1 = subplot(2,2,1);
h1 = plot(1:no_obs,2*sig_inovOT,'blue'); % +2 sig bound;
h1.LineWidth = 1;
hold on; h2 = plot(1:no_obs,-2*sig_inovOT,'blue'); % - 2 sig bound;
h2.LineWidth = 1;
hold on; h5 = plot(1:no_obs,ot_investimate,'black'); h5.LineWidth = 1;
set(gca,'FontWeight','bold');
set(gca,'linewidth',1)
ylabel('r_{obs} - m(x) [m]','FontSize',8,'FontWeight','bold');
ax = gca;
ax.XTick = 1:3:no_obs;
xlim([1 no_obs]);
ylim([-73 73]);
title('OT','FontSize',12,'FontWeight','bold');
xlabel('Time Steps','FontSize',8,'FontWeight','bold');


a2 = subplot(2,2,2);
h3 = plot(1:no_obs,2*sig_inovEnKF,'blue'); % +2 sig bound;
h3.LineWidth = 1;
hold on; h4 = plot(1:no_obs,-2*sig_inovEnKF,'blue'); % - 2 sig bound;
h4.LineWidth = 1;
hold on; h6 = plot(1:no_obs,enkf_investimate,'red'); h6.LineWidth = 1;
set(gca,'FontWeight','bold');
set(gca,'linewidth',1)
ylabel('r_{obs} - m(x) [m]','FontSize',8,'FontWeight','bold');
ax = gca;
ax.XTick = 1:3:no_obs;
xlim([1 no_obs]);
ylim([-73 73]);
title('EnKF','FontSize',12,'FontWeight','bold');
xlabel('Time Steps','FontSize',8,'FontWeight','bold');


hL = subplot(2,2,3.5);
poshL = get(hL,'position'); % Getting its position
poshL(2) = poshL(2)+ poshL(4)/2;
lgd = legend(hL,[h5;h6;h1],'OT innovation','EnKF innovation','\pm 2\sigma');
set(lgd,'position',poshL,'Orientation','horizontal','FontSize',8,'FontWeight','bold');      % Adjusting legend's position
axis(hL,'off');


linkaxes([a1,a2],'xy');

fig = gcf;
fig.PaperPositionMode = 'auto';
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig, '-dpdf', './consist50.pdf');