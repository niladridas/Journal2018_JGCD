% All units must be degrees for worldmap!!
clc;clear;close
load('cpfdata_compiled.mat');
format long g
start_var

[lat,lon] = getLatLon(cpfdata_compiled.xeci,cpfdata_compiled.yeci,cpfdata_compiled.zeci,cpfdata_compiled.mjdutc,...
    eopdata, Arcs, MJD_J2000, R_Earth,  f_Earth);

minLat = min(lat); maxLat = max(lat);
minLon = min(lon); maxLon = max(lon);

if minLat < -85
    minLat = -90;
else
    minLat = minLat -5;
end

if maxLat > 85
    maxLat = 90;
else
    maxLat = maxLat +5;
end

if minLon < -175
    minLon = -180;
else
    minLon = minLon -5;
end

if maxLon > 175
    maxLon = 180;
else
    maxLon = maxLon +5;
end

figure;
% worldmap('World') ; % OR
worldmap([minLat maxLat],[minLon maxLon])

% plot lat lon
plotm(lat,lon); drawnow;

% plot station on map
plotm(st_lat,st_lon,'ro'); drawnow;

% show coastlines
load coastlines
geoshow(coastlat,coastlon); drawnow;