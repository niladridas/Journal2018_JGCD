clc
clear
crddata_compiled.mjdutc = [];
crddata_compiled.range = [];
crddata_compiled.P = [];
crddata_compiled.T = [];
crddata_compiled.Rh = []; 

  file_names = ['starlette_apr1_pass1.npt'; 'starlette_apr1_pass2.npt';'starlette_apr3_pass1.npt'; 'starlette_apr3_pass2.npt'; 'starlette_apr3_pass3.npt'; 'starlette_apr4_pass1.npt';...
      'starlette_apr5_pass1.npt'; 'starlette_apr5_pass2.npt';'starlette_apr5_pass3.npt';'starlette_apr5_pass4.npt'; 'starlette_apr6_pass1.npt';'starlette_apr7_pass1.npt'; 'starlette_apr8_pass1.npt'; ...
      'starlete_apr10_pass1.npt'; 'starlete_apr10_pass2.npt'; 'starlete_apr10_pass3.npt'];
  
  
  for i = 1:size(file_names,1)
    fid = fopen(file_names(i,:),'r');
    crddata_temp = getcrd(fid);
    fclose(fid);
    crddata_compiled.mjdutc = [crddata_compiled.mjdutc; crddata_temp.mjdutc];
    crddata_compiled.range = [crddata_compiled.range; crddata_temp.range];
    crddata_compiled.P = [crddata_compiled.P; crddata_temp.P];
    crddata_compiled.T = [crddata_compiled.T; crddata_temp.T];
    crddata_compiled.Rh = [crddata_compiled.Rh; crddata_temp.Rh];
  end
  

  fid = fopen('starlette_cpf_best_data_apr1_apr10.hts','r');
  cpfdata_compiled = getcpf(fid);
  fclose(fid);
  