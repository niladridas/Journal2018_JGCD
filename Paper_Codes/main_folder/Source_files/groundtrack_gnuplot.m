clc;clear;close
load('prop_data_EnKF100.mat');
format long g
start_var

% propeci = prop_data_OT.prop_eci_OT(:,1:3);
% %propeci = downsample(propeci,3); % Downsampling
% propeci_mjdutc = prop_data_OT.prop_eci_OT_time;
% %propeci_mjdutc = downsample(propeci_mjdutc,3);% Downsampling
% cpfeci = prop_data_OT.cpf_eci;
% cpfeci_mjdutc = prop_data_OT.cpf_eci_time;


propeci = prop_data_EnKF.prop_eci_EnKF(:,1:3);
propeci_mjdutc = prop_data_EnKF.prop_eci_EnKF_time;



[latprop,lonprop] = getLatLon(propeci(:,1),propeci(:,2),propeci(:,3),propeci_mjdutc);
% Break down into segments spanning -180 to 180 
% Logic: No consecutive longitude values are of oppotice sign 
k = 1;
seg(k).latlong = [lonprop(1,1),latprop(1,1)];
for i = 2:size(latprop,1)
    if abs(lonprop(i,1)-lonprop(i-1,1)) < 180
        seg(k).latlong = [seg(k).latlong;[lonprop(i,1),latprop(i,1)]];
    else
        k = k+1;
        seg(k).latlong = [lonprop(i,1),latprop(i,1)];
    end
end
for i = 1:size(seg,2)
    filename = sprintf('./data1/latlongpropEnKF%i.dat',i);
    x = seg(i).latlong;
    save(filename,'x','-ascii');
end


% [latcpf,loncpf] = getLatLon(cpfeci(:,1),cpfeci(:,2),cpfeci(:,3),cpfeci_mjdutc);
% k = 1;
% segcpf(k).latlong = [loncpf(1,1),latcpf(1,1)];
% for i = 2:size(latcpf,1)
%     if abs(loncpf(i,1)-loncpf(i-1,1)) < 180
%         segcpf(k).latlong = [segcpf(k).latlong;[loncpf(i,1),latcpf(i,1)]];
%     else
%         k = k+1;
%         segcpf(k).latlong = [loncpf(i,1),latcpf(i,1)];
%     end
% end
% for i = 1:size(segcpf,2)
%     filename = sprintf('./data1/latlongcpf%i.dat',i);
%     x = segcpf(i).latlong;
%     save(filename,'x','-ascii');
% end
