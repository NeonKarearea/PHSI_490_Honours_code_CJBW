function MLT_convert(satellite,satellite_prefix)
    %This fucntion turns the MLT into degrees.
    dates = ["20170905","20170906","20170907","20170908"];
    path = convertStringsToChars(strcat('POES data PHSI 490\',satellite));
    folder = struct2table(dir(path));
    for i = 1:(length(folder.name)-2)
        file_names{i} = folder.name{i+2};
    end
    
    for j = 1:length(dates)
        file_location = strcat(path,"\poes_",satellite_prefix,"_",dates(j),".mat");
        data = matfile(file_location);
        data.Properties.Writable = true;
        MLT = data.fofl_magnetic_local_time;
        MLT_deg = MLT.*15;
        data.fofl_magnetic_local_time = MLT_deg;
    end
end