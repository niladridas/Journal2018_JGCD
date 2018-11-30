% Test distance between points in MEE representation
% Author: Niladri Das
% Affiliation: Texas A&M University
clc;clear;close all;format long g
main_part1;
for r = 1:1
    % Initial Samples generated
    X_init_OT = sample_init_eciv2(fulleci_state,samples, radius_limit,station_ecistart); % in ECI
    parfor j = 1:samples
        tmp_A = coe2mee(eci2coe(X_init_OT(:,j)',GM_Earth))'; 
        X_init_OT(:,j) = tmp_A;
    end 
    Tstart = (mee_start.mjdutc-AuxParam.Mjd_UTC)*86400;
    for m = 1:2
        Tend =  (obs_states(m,1)-AuxParam.Mjd_UTC)*86400;
        tmp_X_init_eci_OT = zeros(6,samples); 
        parfor n = 1:samples
            [~,x_temp] = radau(accel_meenew,[Tstart +Tstart],X_init_OT(:,n),options);
            X_init_OT(:,n) = x_temp(end,:)';
        end
    end
    testmat = X_init_OT;    
end      
save('testmat.mat','testmat');


%% Compute difference
for i = 1:50
    for j = 1:50
       for k=1:6
           D(k,i,j) = abs(testmat(k,i)-testmat(k,j));
       end
    end
end

dp = max(max(D(1,:,:)));
df = max(max(D(2,:,:)));
dg = max(max(D(3,:,:)));
dh = max(max(D(4,:,:)));
dk = max(max(D(5,:,:)));
dl = max(max(D(6,:,:)));

[dp df dg dh dk dl]';
