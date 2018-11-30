start_var;choose_jb2008;simulation_inputs % Necessary data for simulation
% point_cloud_post: saves all point cloud updated data after each observation
% Taking two consecutive passes
pass_numbers = [1 2];
Nobs_set = [size(passes(pass_numbers(1)).mjdutc,1) size(passes(pass_numbers(2)).mjdutc,1)];
% Observations
observation = join_obs(pass_numbers,passes);
Nobs= size(observation.mjdutc,1); 
%%
[mee_start,fulleci_state,obs_states,Mjd_UTC,del_t] = ...
    before_filtering(observation,cpfdata_compiled,AuxParam,GM_Earth,eopdata,...
    MJD_J2000,Arcs,PC,Cnm, Snm);
% Checks:-----------------------------
% 1. Difference in secs between the closest cpf data and first observation and
% del_t;
% [lat,lon] = getLatLon(fulleci_state(1,1),fulleci_state(2,1),fulleci_state(3,1),...
%     mee_start.mjdutc,eopdata,Arcs,MJD_J2000,R_Earth,f_Earth);
station_ecistart = recef2eci(mee_start.mjdutc, station_ecefxyz,MJD_J2000,eopdata,Arcs);
% [lat_sta,lon_sta] = getLatLon(station_ecistart(1,1),station_ecistart(2,1),station_ecistart(3,1),...
%     mee_start.mjdutc,eopdata,Arcs,MJD_J2000,R_Earth,f_Earth);
% range_sat = norm(fulleci_state(1:3,1)-station_ecistart);range_obs_near = obs_states(1,2);
% error_range = range_sat-range_obs_near;
%-------------------------------------
AuxParam.Mjd_UTC = Mjd_UTC; % The day the observation was taken. This serves as the reference starting time
accel_meenew = @(x,Y1) accel_mee(x,Y1,sysfun,eopdata,AuxParam,MJD_J2000,AU,GM_Earth, GM_Sun,GM_Moon,GM_Mercury,...
    GM_Venus, GM_Mars,GM_Jupiter, GM_Saturn, GM_Uranus, GM_Neptune,GM_Pluto, P_Sol,jb2008_path,Arcs,PC,Cnm,Snm,...
    R_Earth, f_Earth,c_light,R_Sun, R_Moon);
est_eci_OT = zeros(Nobs,6); % Save the mean 
est_eci_var_OT = zeros(Nobs,6); % Save the variance in each state variable

point_cloud_OT = zeros(6*Nobs,samples,no_of_repeat);
point_cloud_EnKF = point_cloud_OT;