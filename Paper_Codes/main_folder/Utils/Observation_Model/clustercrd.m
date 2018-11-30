function pass = clustercrd(crddata_compiled)
% crd data has the following field
% 1. mjdutc
% 2. range in meters
% 3. P in millibar
% 4. T in Kelvin
% 5. Rh in percentage
% Threshold is set to 0.5 i.e. half a day
% Modification: 5th March 2018 Added noise the observed range
j = 1;
pass(1).mjdutc = crddata_compiled.mjdutc(1);
pass(1).range = crddata_compiled.range(1)+rand(1);
pass(1).P = crddata_compiled.P(1);
pass(1).T = crddata_compiled.T(1);
pass(1).Rh = crddata_compiled.Rh(1); 
for i = 2:length(crddata_compiled.mjdutc)
    if ((crddata_compiled.mjdutc(i)-crddata_compiled.mjdutc(i-1))<=0.06)
        % Using non-scalar structure
        pass(j).mjdutc = [pass(j).mjdutc;crddata_compiled.mjdutc(i)];
        pass(j).range = [pass(j).range;crddata_compiled.range(i)+rand(1)];
        pass(j).P = [pass(j).P;crddata_compiled.P(i)];
        pass(j).T = [pass(j).T;crddata_compiled.T(i)];
        pass(j).Rh = [pass(j).Rh;crddata_compiled.Rh(i)];
    else
        j = j+1;
        pass(j).mjdutc = crddata_compiled.mjdutc(i);
        pass(j).range = crddata_compiled.range(i)++rand(1);;
        pass(j).P = crddata_compiled.P(i);
        pass(j).T = crddata_compiled.T(i);
        pass(j).Rh = crddata_compiled.Rh(i); 
    end
end
end