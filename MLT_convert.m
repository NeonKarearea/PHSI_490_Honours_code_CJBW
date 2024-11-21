function MLT_convert (satellite,satellite_prefix,date_string)
    files = matfile(strcat("POES data PHSI 490\",satellite,"\poes_",satellite_prefix,"_",date_string,".mat"));
    files.Properties.Writable = true;
    MLT = 15.*files.fofl_magnetic_local_time;
    files.fofl_magnetic_local_time = MLT;
end