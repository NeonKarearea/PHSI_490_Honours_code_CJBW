function [a,b,c,d,e,f,g,h,i,j,k,l,m] = data_analyser(start_year,start_month,...
    start_day,end_year,end_month,end_day,n,num_grad,min_flux,min_avg_flux,P,varargin)
    %This function takes in a start and end time and will then find all relevant data from all satellites. start_year, start_month, and start_day defines when the event starts. end_year, end_month, and end_day defines when the event ends. n is the data resolution for the Omni-directional detector used, num_grad is the number of gradients used to find the cutoff flux, and P is the Omni-directional detector.
    
    if nargin < 11
        error("Not enough input arguments")
    elseif nargin > 12
        error("Too many input arguments")
    elseif nargin == 11
        print = 1;
    elseif ~isnumeric(varargin{1})
        error("Please set the print parameter to be on (1) or off (0)")
    else
        print = varargin{1};
    end
    
    %This is the names and the file prefixes for the different satellites
    satellite_names = {'MetOp1','MetOp2','NOAA15','NOAA16','NOAA17','NOAA18','NOAA19'};
    satellite_prefix = {'m01','m02','n15','n16','n17','n18','n19'};
    
    %This is the start day and end day
    start_date = datenum(start_year,start_month,start_day);
    end_date = datenum(end_year,end_month,end_day);
    
    %This will find the satellites that need to be looked at over the event
    %period.
    skipped_sat = 0;
    skipped_satellite = {};
    incomplete_sat = 0;
    used_sat = 0;
    incomplete_satellite = {};
    
    %This gets all of the satellites that have some data
    for i = 1:length(satellite_names)
        file = strcat(satellite_names{i},"\poes_",satellite_prefix{i});
        skipped_file = 0;
        for j = start_date:end_date
            date_string = datestr(datevec(j),'yyyymmdd');
            existence = isfile(strcat('POES data PHSI 490\',file,"_",date_string,".mat"));
            skipped_file = skipped_file - (existence - 1);
        end
        
        if skipped_file == (end_date-start_date)+1
            skipped_sat = skipped_sat + 1;
            skipped_satellite{i-incomplete_sat-used_sat} = satellite_names{i};
            
        elseif skipped_file ~= 0
            incomplete_sat = incomplete_sat + 1;
            incomplete_satellite{i-skipped_sat-used_sat} = satellite_names{i};
            relevant_satellite{i-skipped_sat} = file;
            
        else
            used_sat = used_sat + 1;
            relevant_satellite{i-skipped_sat} = file;
        end
    end
    
    %This will then do the event analysis for each satellite in the event.
    for k = 1:length(relevant_satellite)
        if k == 1
            [fluxes,L_shells,datenums,cutoff_fluxes,cutoff_L_shells,cutoff_datenums,MLT,dst,kp,geograph_lat,geograph_lon,geomag_lat,geomag_lon]...
                = event_determine(start_date,end_date,relevant_satellite{k},...
                n,num_grad,min_flux,min_avg_flux,P);

        else
            [fluxes_2,L_shells_2,datenums_2,cutoff_fluxes_2,cutoff_L_shells_2,cutoff_datenums_2,MLT_2,dst_2,kp_2,geograph_lat_2,geogeograph_lon_2,geomag_lat_2,geomag_lon_2]...
                = event_determine(start_date,end_date,relevant_satellite{k},...
                n,num_grad,min_flux,min_avg_flux,P);

            %This merges the previous data with the newly obtained data.
            fluxes = [fluxes,fluxes_2];
            L_shells = [L_shells,L_shells_2];
            datenums = [datenums,datenums_2];
            cutoff_fluxes = [cutoff_fluxes,cutoff_fluxes_2];
            cutoff_L_shells = [cutoff_L_shells,cutoff_L_shells_2];
            cutoff_datenums = [cutoff_datenums,cutoff_datenums_2];
            MLT = [MLT,MLT_2];
            dst = [dst,dst_2];
            kp = [kp,kp_2];
            geograph_lat = [geograph_lat,geograph_lat_2];
            geograph_lon = [geograph_lon,geogeograph_lon_2];
            geomag_lat = [geomag_lat,geomag_lat_2];
            geomag_lon = [geomag_lon,geomag_lon_2];
        end
    end
    
    %This section will find all of the datapoints that are NaN and remove
    %them, and will then sort the remaining data in time.
    non_nans = find(~isnan(cutoff_datenums));
    
    non_nan_fluxes = fluxes(non_nans);
    non_nan_L_shells = L_shells(non_nans);
    non_nan_datenums = datenums(non_nans);
    non_nan_cutoff_fluxes = cutoff_fluxes(non_nans);
    non_nan_cutoff_L_shells = cutoff_L_shells(non_nans);
    non_nan_cutoff_datenums = cutoff_datenums(non_nans);
    non_nan_sunside = MLT(non_nans);
    non_nan_dst = dst(non_nans);
    non_nan_kp = kp(non_nans);
    non_nan_geograph_lat = geograph_lat(non_nans);
    non_nan_geograph_lon = geograph_lon(non_nans);
    non_nan_geomag_lat = geomag_lat(non_nans);
    non_nan_geomag_lon = geomag_lon(non_nans);
    
    sorted_non_nan_cutoff_datenums = sort(non_nan_cutoff_datenums);
    sorted_non_nan_cutoff_datenums = [sorted_non_nan_cutoff_datenums(diff(sorted_non_nan_cutoff_datenums)~=0),...
        sorted_non_nan_cutoff_datenums(end)];
    offset = 0;
    
    for i = 1:length(sorted_non_nan_cutoff_datenums)
        loc = find(non_nan_cutoff_datenums == sorted_non_nan_cutoff_datenums(i));

        for j = 1:length(loc)
            sorted_fluxes{i+offset} = non_nan_fluxes{loc(j)};
            sorted_L_shells{i+offset} = non_nan_L_shells{loc(j)};
            sorted_datenums{i+offset} = non_nan_datenums{loc(j)};
            sorted_cutoff_fluxes(i+offset) = non_nan_cutoff_fluxes(loc(j));
            sorted_cutoff_L_shells(i+offset) = non_nan_cutoff_L_shells(loc(j));
            sorted_cutoff_datenums(i+offset) = non_nan_cutoff_datenums(loc(j));
            sorted_sunside(i+offset) = non_nan_sunside(loc(j));
            sorted_dst(i+offset) = non_nan_dst(loc(j));
            sorted_kp(i+offset) = non_nan_kp(loc(j));
            sorted_geograph_lat(i+offset) = non_nan_geograph_lat(loc(j));
            sorted_geograph_lon(i+offset) = non_nan_geograph_lon(loc(j));
            sorted_geomag_lat(i+offset) = non_nan_geomag_lat(loc(j));
            sorted_geomag_lon(i+offset) = non_nan_geomag_lon(loc(j));
            if length(loc) > 1 && j < length(loc)
                offset = offset + 1;
            end
        end
    end
    
    %This will let the user know a) which satellites have been skipped and
    %b) which ones have incomplete data.
    if print == 1
        disp(strcat(num2str(skipped_sat)," satellites didn't have the data. These satellites were:"))
        disp(skipped_satellite)
        disp(strcat(num2str(incomplete_sat)," satellites had incomplete data. These satellites were:"))
        disp(incomplete_satellite)
    end
        
    a = sorted_fluxes;
    b = sorted_L_shells;
    c = sorted_datenums;
    d = sorted_cutoff_fluxes;
    e = sorted_cutoff_L_shells;
    f = sorted_cutoff_datenums;
    g = sorted_sunside;
    h = sorted_dst;
    i = sorted_kp;
    j = sorted_geograph_lat;
    k = sorted_geograph_lon;
    l = sorted_geomag_lat;
    m = sorted_geomag_lon;
end
