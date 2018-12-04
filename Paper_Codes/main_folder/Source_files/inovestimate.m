function W_tmp = inovestimate(eci_states,z, PTRh,MJD_UTCtime,MJD_J2000,eopdata,Arcs,lambda,  station_ecefxyz, st_latlongalt,R_Earth ,f_Earth)
    M = size(eci_states,2); % number of samples
    W_tmp = zeros(1,M); % Sample innovation 
    station_ecixyz = recef2eci(MJD_UTCtime, station_ecefxyz,MJD_J2000,eopdata,Arcs);
    sat_rvec = eci_states(1:3,:)-repmat(station_ecixyz,1,M);
    sat_rnorm = sqrt(sum(sat_rvec.^2, 1));
    r_delr = zeros(1,M);
    for i = 1:M
        E = elevation(MJD_UTCtime,st_latlongalt(2),st_latlongalt(1),...
            st_latlongalt(3)*1000,eci_states(1:3,i),eopdata,R_Earth ,f_Earth);
        r_delay_OT = atms_delay(lambda/1000,st_latlongalt(1), st_latlongalt(3),PTRh(1),PTRh(2),E);
        r_delr(1,i) = sat_rnorm(1,i) + r_delay_OT;
    end
    for i = 1:M 
        W_tmp(1,i) = (z-r_delr(1,i)); 
    end
end