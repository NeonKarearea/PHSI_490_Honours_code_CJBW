function [a,b,c,d,e,f,g,h] = event_determine(start_year,start_month,...
    start_day,end_year,end_month,end_day,satellite,n,num_grad,P)
    %This function takes in a start time and end time and from there can
    %analyse a single event for a given satellite. The satellite data for
    %this project is in the 'POES data PHSI 490' folder and the satellite
    %variable should be written as
    %'{satellite_name}\poes_{satellite_prefix}' (i.e. MetOp1\poes_m01). 'n'
    %is the rate that the data is measured in (i.e. the P6 Omnidirectional
    %detector is sampled with n=2) and num_gradient is the number of
    %gradients that will be compared.

    %This first gets the start and end times into datenum.
    start_date = datenum(start_year,start_month,start_day);
    end_date = datenum(end_year,end_month,end_day);
    
    %This will concantenate the data over the event length.
    for i = start_date:1:end_date
        time = datevec(i);
        date_string = datestr(time,"yyyymmdd");
        if i == start_date
            try
                event = struct2table(load(strcat('POES data PHSI 490\',satellite,"_",date_string,".mat"))');
            catch
                warning("No file by the name " + strcat(satellite,"_",date_string,".mat") + " was found. This file has been skipped")
                time(3) = time(3)+1;
                start_date = datenum(time);
            end
        else
            try
                next_event = struct2table(load(strcat('POES data PHSI 490\',satellite,"_",date_string,".mat"))');
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
    %our data even more. There are 20 seconds from the previous dat in the
    %previous dataset so the start time and end times need 20 seconds added
    %for this to work.
    event_start_time = start_date + datenum(0,0,0,0,0,double(event.second(1)));
    event_end_time = end_date + datenum(0,0,0,double(event.hour),...
        double(event.minute),double(event.second(end)));

    start_loc = find(event_datenum == event_start_time);
    end_loc = find(event_datenum == event_end_time | event_datenum == max(event_datenum));
    
    if event.Omni_directional_P6(start_loc) == -999
        start_loc = find(event.Omni_directional_P6(start_loc:end) ~= -999, 1);
    end
    
    %This gets the data from the start and end of the event
    detector = strcat("Omni_directional_",P);
    event_flux = eval(strcat("event.",detector,"(start_loc:n:end_loc)"));
    event_L_shell = event.McIlwain_L_value(start_loc:n:end_loc);
    event_datenum = event_datenum(start_loc:n:end_loc);
    event_sat_lat = event.sub_satellite_latitude(start_loc:n:end_loc);
    event_sat_lon = event.sub_satellite_longitude(start_loc:n:end_loc);
    
    [a,b,c,d,e,f,g,h] = L_finder(event_flux,event_L_shell,event_datenum,...
        event_sat_lat,event_sat_lon,num_grad);
end