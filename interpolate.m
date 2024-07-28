function interpolate(satellite)
%This function interpolates the McIlwain_L_value, sub_satellite_latitude, and sub_satellite longitude for all files in a given path.
    
    %This gets the relevant path and then stores all of the files in that
    %path, ready for later use.
    path = convertStringsToChars(strcat('POES data PHSI 490\',satellite));
    file = struct2table(dir(path));
    file_names = cell(1,(length(file.name)-2));
    for i = 1:length(file_names)
        file_names{i} = file.name{i+2};
    end
    
    %This will group the files into 'events'. Basically, any two datafiles
    %that are beside each other in terms of date will be considered part of
    %the same event.
    end_event_file = 0;
    loop = 0;
    for j = 1:length(file_names)
        if j <= end_event_file
            continue
        else
            clear event_set;
            event_set{j-end_event_file} = file_names{j};
            k = 1;
            while k>0
                start_date = split(file_names{j+k-1},'_');
                start_date = split(start_date{3},'.');
                start_date = datenum(start_date{1},'yyyymmdd');
                next_date = split(file_names{j+k},'_');
                next_date = split(next_date{3},'.');
                next_date = datenum(next_date{1},'yyyymmdd');
                
                if next_date - start_date ~= 1
                    events{loop+(j-end_event_file)} = event_set;
                    end_event_file = j+k-1;
                    k = 0;
                    loop = loop + 1;
                else
                    %This is a bit of extra logic to stop the loop
                    %correctly.
                    event_set{j+k-end_event_file} = file_names{j+k};
                    if j+k == length(file_names)
                        events{loop+(j-end_event_file)} = event_set;
                        end_event_file = j+k;
                        k = 0;
                    else
                        k = k + 1;
                    end
                end
            end
        end
    end
    
    disp(strcat("There are ",num2str(length(file_names))," files in ",num2str(length(events))," events to interpolate"))
    
    %This will interpolate for the latitude, longitude, and L-value
    for l = 1:length(events)
        %This gets the relevant data, and sets the indicies to be
        %interpolated over as all values that are not -999, -1, and 100
        %(because for some reason there seems to be 3 separate bad data
        %values
        disp(l)
        event = events{l};
        for m = 1:length(event)
            if m == 1
                event_data = struct2table(load(strcat(path,'\',event{m})));
            else
                next_data = struct2table(load(strcat(path,'\',event{m})));
                event_data = [event_data;next_data];
            end
        end
        
        MLT = event_data.fofl_magnetic_local_time;
        x = 1:length(MLT);
        idxMLT = MLT ~= -999 & MLT ~= -1 & MLT ~= 100;

        %And this interpolates the data.
        interp_MLT = interp1(x(idxMLT),MLT(idxMLT),x,'spline');
        
        %Now we need to break the event_data back into the date_data.
        for n = 1:length(event)
            if n == 1
                %This gets the data
                date_data = matfile(strcat(path,'\',event{n}));
                date_data.Properties.Writable = true;
                end_point = length(date_data.McIlwain_L_value);
                
                %This writes it in
                date_data.fofl_magnetic_local_time = (interp_MLT(1:end_point)');
            else
                %This gets the data
                date_data = matfile(strcat(path,'\',event{n}));
                date_data.Properties.Writable = true;
                start_point =  end_point+1;
                end_point = end_point+length(date_data.fofl_magnetic_local_time);
                
                %This writes it in
                date_data.fofl_magnetic_local_time = (interp_MLT(start_point:end_point)');
            end
        end        
    end
    disp(strcat(satellite," has been interpolated."))
end