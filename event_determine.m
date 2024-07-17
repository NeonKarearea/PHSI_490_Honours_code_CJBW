function [a,b,c,d,e,f,g,h] = event_determine(start_date,end_date,...
    satellite,n,num_grad,P,min_flux,min_avg_flux)
    %This function takes in a start time and end time and from there can
    %analyse a single event for a given satellite. The satellite data for
    %this project is in the 'POES data PHSI 490' folder and the satellite
    %variable should be written as
    %'{satellite_name}\poes_{satellite_prefix}' (i.e. MetOp1\poes_m01). 'n'
    %is the rate that the data is measured in (i.e. the P6 Omnidirectional
    %detector is sampled with n=2) and num_gradient is the number of
    %gradients that will be compared.
    
    %This will concantenate the data over the event length.
    for i = start_date:end_date
        date_string = datestr(datevec(i),"yyyymmdd");
        %This section will try to load the file. If it cannot load it, it
        %will alert the user as sometimes the satellite it turned off for
        %various reasons.
        if i == start_date
            try
                event = struct2table(load(strcat('POES data PHSI 490\',satellite,"_",date_string,".mat"))');
            catch
                warning("No file by the name " + strcat(satellite,"_",date_string,".mat") + " was found. This file has been skipped")
                start_date = start_date+1;
            end
        else
            try
                next_event = struct2table(load(strcat('POES data PHSI 490\',satellite,"_",date_string,".mat")));
                event = [event;next_event];
            catch
                warning("No file by the name " + strcat(satellite,"_",date_string,".mat") + " was found. This file has been skipped")
            end
        end
    end
    
    %This formats the time into datenum.
    event_datenum = datenum(double(event.year),1,...
        double(event.day_of_year),double(event.hour),...
        double(event.minute),double(event.second));
    
    %As we are not interested at the start of the event, we can fine-tune
    %our data even more by adding the starting value to the overall time.
    
    event_start_time = start_date + datenum(0,0,0,0,0,double(event.second(1)));
    event_end_time = end_date + datenum(0,0,0,double(max(event.hour)),...
        double(max(event.minute)),double(max(event.second)));

    start_loc = find(event_datenum == event_start_time);
    end_loc = find(event_datenum == event_end_time | event_datenum == max(event_datenum));
    
    if event.Omni_directional_P6(start_loc) == -999
        start_loc = find(event.Omni_directional_P6(start_loc:end) ~= -999, 1);
    end
    
    %This gets the data from the start and end of the event.
    detector = strcat("Omni_directional_",P);
    event_flux = eval(strcat("event.",detector,"(start_loc:n:end_loc)"));
    event_L_shell = event.McIlwain_L_value(start_loc:n:end_loc);
    event_datenum = event_datenum(start_loc:n:end_loc);
    event_sat_lat = event.sub_satellite_latitude(start_loc:n:end_loc);
    event_sat_lon = event.sub_satellite_longitude(start_loc:n:end_loc);
    
    %Finally, we can find where the cutoffs are.
    [a,b,c,d,e,f,g,h] = L_finder(event_flux,event_L_shell,event_datenum,...
        event_sat_lat,event_sat_lon,num_grad,min_flux,min_avg_flux);
end