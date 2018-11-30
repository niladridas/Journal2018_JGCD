% Author: Niladri Das
% Affiliation: UQLab, Aerospace Enginnering, TAMU
% Date: 11th Feb 2017
% Email-ID: niladridas@tamu.edu
% This is the Scheme 3 implementation from "Nonlinear Measurement Function in the Ensemble Kalman Filter"

function a_samples = EnKF_filter(b_samples, obs, b_obs, R)
    % b_obs: broadcasted observations
    % R: measurement co-variance matrix 
    % First read the number of samples
    % b_samples dimension: n_states * sample_size
    L = size(b_samples,2);
    nx = size(b_samples,1);
    ny = size(obs,1);
    % Just a sanity check
    if (size(b_samples,2)~=size(b_obs,2))
        error('Dimension mismatch');
    end
    % Calculate P_xy
    if L == 1
        error('There is only one sample');
    end
    % Sample mean
    x_mean = mean(b_samples,2);
    % broadcasted observations
    if ny == 1 
        eta_t = normrnd(0,R);
        eta_all = normrnd(0,R,1,L);
    else
        eta_t = mvnrnd(zeros(1,ny),R,1)';
        eta_all = mvnrnd(zeros(1,ny),R,ny)';
    end
    temp_pxyb = zeros(nx,ny,L);
    temp_pyy = zeros(ny,ny,L);
    temp_pxxb = zeros(nx,nx,L);
    for i =1:L
        temp_pxyb(:,:,i) = (b_samples(:,i)-x_mean)*(b_obs(:,i)-obs-eta_t)';
        temp_pyy(:,:,i) = (b_obs(:,i)-obs-eta_t)*(b_obs(:,i)-obs-eta_t)';
        temp_pxxb(:,:,i) = (b_samples(:,i)-x_mean)*(b_samples(:,i)-x_mean)';
    end
    P_xyb = (1/(L-1))*sum(temp_pxyb,3);
    P_yy = (1/(L-1))*sum(temp_pyy,3);
    P_xxb = (1/(L-1))*sum(temp_pxxb,3);
    K = P_xyb/P_yy;
    a_samples = b_samples + K*(obs.*ones(ny,L)-b_obs-eta_all);
%     P_a = P_xxb - K*P_xyb;
end