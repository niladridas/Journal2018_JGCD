% Author: Niladri Das
% Email: niladri@tamu.edu
% Affiliation: Laboratory for Uncertainty Quantification
%              Aerospace Engineering Department, TAMU, TX, USA
% Date: 25nd Nov 2017

% This is a test file which calculates the difference between the mee
% implementation of the code and the already implemented code in HPOP. 
% This is to make sure that the mee implementation is correct


clc
clear 
format long g % Best of fixed or floating point format with 15 digits.
close all

global Cnm Snm AuxParam eopdata SOLdata DTCdata APdata n_eqn PC

%--------------------------------------------------------------------------
%
% SAT_Const: Definition of astronomical and mathematical constants
%
% Last modified:   2015/08/12   M. Mahooti
% 
%--------------------------------------------------------------------------

% Mathematical constants
pi2       = 2*pi;                % 2pi
Rad       = pi/180;              % Radians per degree
Deg       = 180/pi;              % Degrees per radian
Arcs      = 3600*180/pi;         % Arcseconds per radian

% General
MJD_J2000 = 51544.5;             % Modified Julian Date of J2000
T_B1950   = -0.500002108;        % Epoch B1950
c_light   = 299792457.999999984; % Speed of light  [m/s]; DE405
AU        = 149597870691.000015; % Astronomical unit [m]; DE405

% Physical parameters of the Earth, Sun and Moon

% Equatorial radius and flattening
R_Earth   = 6378.137e3;          % Earth's radius [m]; WGS-84
f_Earth   = 1/298.257223563;     % Flattening; WGS-84   
R_Sun     = 696000e3;            % Sun's radius [m]; DE405
R_Moon    = 1738e3;              % Moon's radius [m]; DE405

% Earth rotation (derivative of GMST at J2000; differs from inertial period by precession)
omega_Earth = 15.04106717866910/3600*Rad;  % [rad/s]; WGS-84

% Gravitational coefficients
GM_Earth   = 398600.4418e9;                % [m^3/s^2]; WGS-84
GM_Sun     = 132712440017.9870e9;          % [m^3/s^2]; DE405
GM_Moon    = GM_Earth/81.3005600000000044; % [m^3/s^2]; DE405
GM_Mercury = 22032.08048641792e9;          % [m^3/s^2]; DE405
GM_Venus   = 324858.5988264596e9;          % [m^3/s^2]; DE405
GM_Mars    = 42828.31425806710e9;          % [m^3/s^2]; DE405
GM_Jupiter = 126712767.8577960e9;          % [m^3/s^2]; DE405
GM_Saturn  = 37940626.06113726e9;          % [m^3/s^2]; DE405
GM_Uranus  = 5794549.007071872e9;          % [m^3/s^2]; DE405
GM_Neptune = 6836534.063879259e9;          % [m^3/s^2]; DE405
GM_Pluto   = 981.6008877070042e9;          % [m^3/s^2]; DE405
              
% Solar radiation pressure at 1 AU 
P_Sol      = 1367/c_light;       % [N/m^2] (1367 W/m^2); IERS 96
%
%-----------------------------------------------------------------------------
%
% Eath Gravitational Model 1996: is a geopotential model of the Earth consisting
% of spherical harmonic coefficients complete to degree and order 360
load DE405Coeff.mat
PC = DE405Coeff;

Cnm = zeros(71,71);
Snm = zeros(71,71);
fid = fopen('egm96','r');
for n=0:70
    for m=0:n
        temp = fscanf(fid,'%d %d %f %f %f %f',[6 1]);        
        Cnm(n+1,m+1) = temp(3);
        Snm(n+1,m+1) = temp(4);
    end
end
%--------------------------------------------------------------------------
%
% read Earth orientation parameters
fid = fopen('eop19620101.txt','r');
%  ----------------------------------------------------------------------------------------------------
% |  Date    MJD      x         y       UT1-UTC      LOD       dPsi    dEpsilon     dX        dY    DAT
% |(0h UTC)           "         "          s          s          "        "          "         "     s 
%  ----------------------------------------------------------------------------------------------------
eopdata = fscanf(fid,'%i %d %d %i %f %f %f %f %f %f %f %f %i',[13 inf]);
fclose(fid);
%
%
%-------------------------------------------------------------------------
%
% Satellite parameters
AuxParam = struct('Mjd_UTC',0,'area_solar',0,'area_drag',0,'mass',0,'Cr',0,...
                  'Cd',0,'n',0,'m',0,'sun',0,'moon',0,'sRad',0,'drag',0,...
                  'planets',0,'SolidEarthTides',0,'OceanTides',0,'Relativity',0);

% epoch state (Envisat)
fid = fopen('InitialState.txt','r');

tline = fgetl(fid);
if ~ischar(tline)
    exit
end
year = str2double(tline(1:4));
mon = str2double(tline(6:7));
day = str2double(tline(9:10));
hour = str2double(tline(12:13));
min = str2double(tline(15:16));
sec = str2double(tline(18:23));
Y0(1) = str2double(tline(29:40));
Y0(2) = str2double(tline(42:53));
Y0(3) = str2double(tline(55:66));
Y0(4) = str2double(tline(68:79));
Y0(5) = str2double(tline(81:92));
Y0(6) = str2double(tline(94:105));

% epoch
Mjd_UTC = Mjday(year, mon, day, hour, min, sec);
Y0 = Y0';
Y0 = ECEF2ECI(Mjd_UTC, Y0');

tline = fgetl(fid);
AuxParam.area_solar = str2double(tline(49:53));
tline = fgetl(fid);
AuxParam.area_drag = str2double(tline(38:41));
tline = fgetl(fid);
AuxParam.mass = str2double(tline(19:24));
tline = fgetl(fid);
AuxParam.Cr = str2double(tline(5:7));
tline = fgetl(fid);
AuxParam.Cd = str2double(tline(5:7));

fclose(fid);

AuxParam.Mjd_UTC  = Mjd_UTC;
AuxParam.n       = 40;
AuxParam.m       = 40;
AuxParam.sun     = 1;
AuxParam.moon    = 1;
AuxParam.planets = 1;
AuxParam.sRad    = 1;
AuxParam.drag    = 1;
AuxParam.SolidEarthTides = 1;
AuxParam.OceanTides = 1;
AuxParam.Relativity = 1;


% read space weather data

fid = fopen('SOLFSMY.txt','r');
%  ------------------------------------------------------------------------
% | YYYY DDD   JulianDay  F10   F81c  S10   S81c  M10   M81c  Y10   Y81c
%  ------------------------------------------------------------------------
SOLdata = fscanf(fid,'%d %d %f %f %f %f %f %f %f %f %f',[11 inf]);
fclose(fid);

% READ GEOMAGNETIC STORM DTC VALUE
fid = fopen('DTCFILE.txt','r');
%  ------------------------------------------------------------------------
% | DTC YYYY DDD   DTC1 to DTC24
%  ------------------------------------------------------------------------
DTCdata = fscanf(fid,'%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d',[26 inf]);
fclose(fid);

% read space weather data
fid = fopen('SOLRESAP.txt','r');
%  ------------------------------------------------------------------------
% | YYYY DDD  F10 F10B Ap1 to Ap8
%  ------------------------------------------------------------------------
APdata = fscanf(fid,'%d %d %f %f %f %f %f %f %f %f %f',[12 inf]);
fclose(fid);


%-------------------------------------------------------------------------------------
% The size of the state is defined as a global variable
n_eqn = 6;
R = 60*24;
Step   = 60*R;   % [s]
%
%
% Read the truth states from a text file
Mjd0  = Mjd_UTC;
N_Step = 2; % 26.47 hours

Eph = Ephemeris(Y0, N_Step, Step);
% Just need the starting ECI element converted to the MEE element
Y0_init = coe2mee(eci2coe(Y0',GM_Earth)); 
Eph_mee = Ephemeris_mee(Y0_init, N_Step, Step);





% fid = fopen('SatelliteStates.txt','w');
% for i=1:N_Step+1
%     [year,mon,day,hr,min,sec] = invjday(Mjd0+Eph(i,1)/86400+2400000.5);
%     fprintf(fid,'  %4d/%2.2d/%2.2d  %2d:%2d:%6.3f',year,mon,day,hr,min,sec);
%     fprintf(fid,'  %14.3f%14.3f%14.3f%12.3f%12.3f%12.3f\n',...
%             Eph(i,2),Eph(i,3),Eph(i,4),Eph(i,5),Eph(i,6),Eph(i,7));
% end
% fclose(fid);
%
%--------------------------------------------------------------------------------------
%
% Plotting
[n, m] = size(Eph);
Eph_ecef = zeros(n,m);

for i=1:n
    Eph_ecef(i,1) = Eph(i,1);
    Eph_ecef(i,2:7) = ECI2ECEF(Mjd0+Eph_ecef(i,1)/86400, Eph(i,2:7));    
end

Eph_ecef2 = zeros(n,m);

for i=1:n
    Eph_ecef2(i,1) = Eph_mee(i,1);
    Eph2 = coe2eci(mee2coe(Eph_mee(i,2:7)),GM_Earth);
    Eph_ecef2(i,2:7) = ECI2ECEF(Mjd0+Eph_ecef2(i,1)/86400, Eph2);    
end

%%


True_EnvisatStates

True_Eph = True_Eph(1:R:R*N_Step+1,:);

dd = True_Eph(1:(N_Step+1),:)-Eph_ecef(:,2:7);

dd2 =  True_Eph(1:(N_Step+1),:)-Eph_ecef2(:,2:7);

% % Plot orbit in ECI reference
% figure(1)
% plot3(Eph(:,2),Eph(:,3),Eph(:,4),'o-r')
% grid;
% title('Orbit ECI (inertial) (m)')
% 
% % Plot orbit in ECEF reference
% figure(2)
% plot3(Eph_ecef(:,2),Eph_ecef(:,3),Eph_ecef(:,4),'-')
% title('Orbit ECEF (m)')
% xlabel('X');ylabel('Y');zlabel('Z');
% grid

% Plot Discrepancy of Precise and Propagated orbits
% figure(3)
% subplot(3,1,1);
% plot(dd(:,1));
% hold on;
% plot(dd2(:,1));
% legend('Hpop','Mee')
% title('Discrepancy of Precise and Propagated Envisat Positions');
% axis tight
% xlabel('Time')
% ylabel('dX[m]')
% hold on
% subplot(3,1,2);
% plot(dd(:,2));
% hold on;
% plot(dd2(:,2));
% legend('Hpop','Mee')
% axis tight
% xlabel('Time')
% ylabel('dY[m]')
% subplot(3,1,3);
% plot(dd(:,3));
% hold on;
% plot(dd2(:,3));
% legend('Hpop','Mee')
% axis tight
% xlabel('Time')
% ylabel('dZ[m]')

%
figure(4)
dda = dd(:,1:3);
ddb = dd2(:,1:3);

dda =  sqrt(sum(dda(:,1:3).* dda(:,1:3),2));
ddb =  sqrt(sum(ddb(:,1:3).* ddb(:,1:3),2));


stem(dda);
hold on
stem(ddb);
legend('HPOP','mee');

% figure(4)
% subplot(3,1,1);
% plot(dd2(:,1));
% title('Discrepancy of Precise and Propagated Envisat Positions');
% axis tight
% xlabel('Time')
% ylabel('dX[m]')
% hold on
% subplot(3,1,2);
% plot(dd2(:,2));
% axis tight
% xlabel('Time')
% ylabel('dY[m]')
% subplot(3,1,3);
% plot(dd2(:,3));
% axis tight
% xlabel('Time')
% ylabel('dZ[m]')

%











