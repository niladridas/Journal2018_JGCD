function b_obs = est_obs(X_init_EnKF,PTRh,MJD_UTCtime,eopdata,R_Earth ,f_Earth,MJD_J2000,Arcs,lambda ,station_ecefxyz,st_latlongalt, GM_Earth)
%     global lambda  station_ecefxyz st_latlongalt GM_Earth
    M = size(X_init_EnKF,2);
    eci_states = zeros(6,M);
    for j = 1:M
        eci_states(:,j) = coe2eci(mee2coe(X_init_EnKF(:,j)),GM_Earth)';
    end
    station_ecixyz = recef2eci(MJD_UTCtime, station_ecefxyz,MJD_J2000,eopdata,Arcs);
    sat_rvec = eci_states(1:3,:)-repmat(station_ecixyz,1,M);
    sat_rnorm = sqrt(sum(sat_rvec.^2, 1));
    b_obs = zeros(1,M);
    for i = 1:M
        E = elevation(MJD_UTCtime,st_latlongalt(2),st_latlongalt(1),st_latlongalt(3)*1000,eci_states(1:3,i),...
            eopdata,R_Earth ,f_Earth);
        b_obs(1,i) = sat_rnorm(1,i) + atms_delay(lambda/1000,st_latlongalt(1), st_latlongalt(3),PTRh(1),PTRh(2),E);
    end
end