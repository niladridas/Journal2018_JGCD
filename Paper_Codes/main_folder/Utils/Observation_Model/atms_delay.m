% Author: Niladri Das
% Affiliation: UQLab, Aerospace Enginnering, TAMU
% Date: 18th Jan 2017
% Email-ID: niladridas@tamu.edu
% Input: lambda in nanometers
%        P is the surface barometric pressure in milibar
%        phi is the latitude of the station
%        H is the height of the station in Km
%        t_s is the temperature of the station in Kelvin
%        a is a 3x4 matrix of data
%        GET THE DATA
% Paper: High-accuracy zenith delay prediction at optical wavelengths

% lambda,lat,H,P0,T0,Rh0,E
function delay_mts = atms_delay(lambda,phi, H,P,t_s,E)
P_s = P*100; % milibar to Pascal
% Hydrostatic Delay
x_c = 375; % ppm, C02 content
k_1s = 19990.975*(10^-6)^(-2);
k_0 = 238.0185*(10^-6)^(-2);
sig = 1/lambda;
k_3s = 579.55174*(10^-6)^(-2);
k_2 = 57.362*(10^-6)^(-2);
C_c02 = 1+0.534*(10^(-6))*(x_c-450);
f_hlam = (1/100)*(k_1s*(k_0+sig^2)/((k_0-sig^2)^2)+k_3s*(k_2+sig^2)/((k_2-sig^2)^2))*C_c02;
f_phiH = 1 - 0.00266*cos(2*phi)-0.00028*H;
d_h = 0.00002416579*f_hlam*P_s/f_phiH;
% Non-Hydrostatic Delay
% Using Buck Equation
T = t_s-273.15; % Kelin to C
e_s = 0.61121*exp((18.678-T/234.5)*(T/(257.14+T)))*10^(-3); % in Pa
w_0 = 295.235; w_1 = 2.6422*(10^-12); w_2 = -0.032380*(10^-24); w_3 = 0.004028*(10^-36);  
f_nhlam = 0.003101*(w_0 + 3*w_1*(sig^2) + 5*w_2*(sig^4)+7*w_3*(sig^6));
d_nh = (10^-6)*(5.316*f_nhlam - 3.759*f_hlam)*e_s/f_phiH;
% Total Zenith Delay
d = d_h + d_nh;
% Total mapping function
% Calculating a1,a2 and a3
% Using FCULa model and using corresponding 'a' matrix for that
a = [(12100.8*10^-7) , (1729.5*10^-9), (319.1*10^-7), (-1847.8*10^-11);
      (30496.5*10^-7), (234.6*10^-8), (-103.5*10^-6), (-185.6*10^-10);
       (6877.7*10^10^-5), (197.2*10^-7), (-345.8*10^-5), (106*10^-9)];
a1 = a(1,1)+a(1,2)*t_s + a(1,3)*cos(phi) + a(1,4)*H;
a2 = a(2,1)+a(2,2)*t_s + a(2,3)*cos(phi) + a(2,4)*H;
a3 = a(3,1)+a(3,2)*t_s + a(3,3)*cos(phi) + a(3,4)*H;
A = a2/(1+a3);
B = 1 + a1/(1+A);
D = a2/(sin(E)+a3);
C = sin(E) + (a1/(sin(E)+D));
m_epsilon = B/C;
% Total delay at a given elevation angle
delay_mts = d*m_epsilon;
end
 