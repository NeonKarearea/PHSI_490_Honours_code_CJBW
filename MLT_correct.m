function MLT_correct(satellite)
%This corrects the magnetic local time from hours to degrees for the 2017
%events.
    path = convertStringsToChars(strcat('POES data PHSI 490\',satellite));
    file = struct2table(dir(path));
    offset = 0;
    for i = 1:(length(file.name)-2)
        test_file = convertCharsToStrings(file.name{i+2});
        year_check = regexp(test_file,"2017","ONCE");
        if isempty(year_check)
            offset = offset + 1;
        else
            file_names{i-offset} = file.name{i+2};
        end
    end
    
    if ~exist('file_names','var')
        disp("No 2017 files are in here")
    else
        for i = 1:length(file_names)
            file_name = regexprep(convertCharsToStrings(file_names{i}),'"','');
            data = struct2table(load(strcat('POES data PHSI 490\',satellite,'\',file_name)));
            mlt = 15.*data.fofl_magnetic_local_time;
            real_data = matfile(strcat('POES data PHSI 490\',satellite,'\',file_name));
            real_data.Properties.Writable = true;
            real_data.fofl_magnetic_local_time = mlt;
        end
    end
end