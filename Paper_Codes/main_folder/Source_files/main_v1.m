% Author: Niladri Das
% Affiliation: Texas A&M University
clc;clear;close all;format long g
main_part1
%% OT filtering function call

for r = 1:no_of_repeat
    % Initial Samples generated
    X_init_OT = sample_init_eciv2(fulleci_state,samples, radius_limit,station_ecistart); % in ECI
    parfor j = 1:samples
        tmp_A = coe2mee(eci2coe(X_init_OT(:,j)',GM_Earth))'; 
        X_init_OT(:,j) = tmp_A;
    end 
    X_init_EnKF = X_init_OT; % MEE / Same initial samples for OT and EnKF
    % OT
    Tstart = (mee_start.mjdutc-AuxParam.Mjd_UTC)*86400;
    for m = 1:Nobs
        tic
        Tend =  (obs_states(m,1)-AuxParam.Mjd_UTC)*86400;
        tmp_X_init_eci_OT = zeros(6,samples); 
        parfor n = 1:samples
            [~,x_temp] = radau(accel_meenew,[Tstart Tend],X_init_OT(:,n),options);
            X_init_OT(:,n) = x_temp(end,:)';
        end
        current_mjdutc = AuxParam.Mjd_UTC + Tend/86400;
        weight = @(x,y) weights_cal(x,y,obs_states(m,3:5)',current_mjdutc,R,MJD_J2000,eopdata,Arcs,lambda,...
            station_ecefxyz, st_latlongalt,GM_Earth,R_Earth ,f_Earth);
        X_init_OT = OT_filter(X_init_OT,obs_states(m,:)',cost,weight,OT_constantshdl);
        parfor k = 1:samples
            tmp_X_init_eci_OT(:,k) = coe2eci(mee2coe(X_init_OT(:,k)),GM_Earth); 
        end
        Tstart = Tend;
        point_cloud_OT(6*(m-1)+1:6*m,:,r)  = tmp_X_init_eci_OT; %6*Nobs times sample size
        fprintf('obs %i for OT: ',m);
        toc
    end
%     % EnKF
%     Tstart = (mee_start.mjdutc-AuxParam.Mjd_UTC)*86400;
%     for m = 1:Nobs
%         tic
%         Tend =  (obs_states(m,1)-AuxParam.Mjd_UTC)*86400;
%         tmp_X_init_eci_EnKF = zeros(6,samples); 
%         parfor n = 1:samples
%             [~,x_temp] = radau(accel_meenew,[Tstart Tend],X_init_EnKF(:,n),options);
%             X_init_EnKF(:,n) = x_temp(end,:)';
%         end
%         current_mjdutc = AuxParam.Mjd_UTC + Tend/86400;
%         b_obs = est_obs(X_init_EnKF,obs_states(m,3:5)',current_mjdutc,eopdata,R_Earth ,f_Earth,MJD_J2000,Arcs,...
%                          lambda ,station_ecefxyz,st_latlongalt, GM_Earth); 
%         X_init_EnKF = EnKF_filter(X_init_EnKF, obs_states(m,2)', b_obs, R);            
%         parfor k = 1:samples
%             tmp_X_init_eci_EnKF(:,k) = coe2eci(mee2coe(X_init_EnKF(:,k)),GM_Earth); 
%         end
%         Tstart = Tend;
%         point_cloud_EnKF(6*(m-1)+1:6*m,:,r)  = tmp_X_init_eci_EnKF; %6*Nobs times sample size
%         fprintf('obs %i for EnKF: ',m);
%         toc
%     end  
end
%%
OT.point_cloud_OT = point_cloud_OT;
OT.mjdutc = obs_states(:,1);
OT.pass_numbers = pass_numbers;
OT.Nobs_set = Nobs_set;
filenameOT = sprintf('D:\experiment\main_folder\Source_files\data1\OT%i.mat',samples);
save(filenameOT,'OT');
% EnKF.point_cloud_EnKF = point_cloud_EnKF;
% EnKF.mjdutc = obs_states(:,1);
% EnKF.pass_numbers = pass_numbers;
% EnKF.Nobs_set = Nobs_set;
% filenameEnKF = sprintf('./data1/EnKF%i.mat',samples);
% save(filenameEnKF,'EnKF');
 %%   
 
    
