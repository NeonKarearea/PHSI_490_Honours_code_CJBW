function [a,b,c,d,e,f,g,h,i,j,k] = L_finder(flux,L_shell,datenums,sat_lat,sat_lon,MLT,dst,kp,method)
%This function determines the cutoff L and flux over an event. This will return 6 things; the flux, L_shell, and datenum information used in the determining of the cutoffs (for plotting reasons) and the cutoff flux, L-shell, and datenum for each event.
    sat_lat_plus = sat_lat(2:end);
    sat_lat_minus = sat_lat(1:end-1);
    
    idx = sat_lat;
    jdx = sat_lon;
    
    %This removes the effect of the SAMA (mostly) and removes points that
    %are clearly non-physical (i.e. negative points)
    flux((idx>=-60&idx<=20&(jdx>=240|jdx<=50))|...
        (idx>=-65&idx<=20&jdx>=275)|...
        (idx>=-20&idx<=20)|(flux<0)) = NaN;
    
    %This finds where the satellite passes over the equator.
    transitions = zeros(size(sat_lat_minus));
    for i = 1:length(sat_lat_minus)
        transitions(i) = ~isequal(sign(sat_lat_plus(i)),sign(sat_lat_minus(i)));
    end
    trans_loc = find(transitions);
    
    %Below splits the given data into the number of passes needed
    check = 0; %This makes the first one go from one
    for i = 1:length(trans_loc)
        if check == 1
            start_pos = (check*trans_loc(i-1))+1;
        else
            start_pos = 1;
        end
        finish_pos = trans_loc(i);
        flux_pass{i} = flux(start_pos:finish_pos);
        L_shell_pass{i} = L_shell(start_pos:finish_pos);
        datenum_pass{i} = datenums(start_pos:finish_pos);
        MLT_pass{i} = MLT(start_pos:finish_pos);
        dst_pass{i} = dst(start_pos:finish_pos);
        kp_pass{i} = kp(start_pos:finish_pos);
        sat_lat_pass{i} = sat_lat(start_pos:finish_pos);
        sat_lon_pass{i} = sat_lon(start_pos:finish_pos);
        check = 1;
    end

    %This will split the passes into entrance and exit
    for j = 1:length(L_shell_pass)   
        L_shell_examine = L_shell_pass{j};
        flux_examine = flux_pass{j};
        datenum_examine = datenum_pass{j};
        MLT_examine = MLT_pass{j};
        dst_examine = dst_pass{j};
        kp_examine = kp_pass{j};
        sat_lat_examine = sat_lat_pass{j};
        sat_lon_examine = sat_lon_pass{j};
    
        del_L_loc = find(L_shell_examine == max(L_shell_examine));
    
        L_shell_pass_directional{(2*j)-1} = L_shell_examine(1:del_L_loc);
        L_shell_pass_directional{2*j} = L_shell_examine(del_L_loc+1:end);
        flux_pass_directional{(2*j)-1} = flux_examine(1:del_L_loc);
        flux_pass_directional{2*j} = flux_examine(del_L_loc+1:end);
        datenum_pass_directional{(2*j)-1} = datenum_examine(1:del_L_loc);
        datenum_pass_directional{2*j} = datenum_examine(del_L_loc+1:end);
        MLT_pass_directional{(2*j)-1} = MLT_examine(1:del_L_loc);
        MLT_pass_directional{2*j} = MLT_examine(del_L_loc+1:end);
        dst_pass_directional{(2*j)-1} = dst_examine(1:del_L_loc);
        dst_pass_directional{2*j} = dst_examine(del_L_loc+1:end);
        kp_pass_directional{(2*j)-1} = kp_examine(1:del_L_loc);
        kp_pass_directional{2*j} = kp_examine(del_L_loc+1:end);
        sat_lat_directional{(2*j)-1} = sat_lat_examine(1:del_L_loc);
        sat_lat_directional{2*j} = sat_lat_examine(del_L_loc+1:end);
        sat_lon_directional{(2*j)-1} = sat_lon_examine(1:del_L_loc);
        sat_lon_directional{2*j} = sat_lon_examine(del_L_loc+1:end);
    end

    %Now we can find the cutoff L_shells
    m = 0; %This starts it as entry
    for k = 1:length(flux_pass_directional)
        if method == "LESKE"
            [cut_flux,cut_L,cut_MLT,cut_dst,cut_kp,cut_lat,cut_lon] = cutoff_determine_leske(L_shell_pass_directional{k},...
                flux_pass_directional{k},MLT_pass_directional{k},dst_pass_directional{k},...
                kp_pass_directional{k},sat_lat_directional{k},sat_lon_directional{k},k);
        elseif method == "NEAL"
            [cut_flux, cut_L, cut_MLT,cut_dst,cut_kp,cut_lat,cut_lon] = cutoff_determine_neal(L_shell_pass_directional{k},...
                flux_pass_directional{k},MLT_pass_directional{k},dst_pass_directional{k},...
                kp_pass_directional{k},sat_lat_directional{k},sat_lon_directional{k},0.2,k);
        end
        cutoff_L(k) = cut_L;
        cutoff_flux(k) = cut_flux;
        cutoff_MLTs(k) = cut_MLT;
        cutoff_dst(k) = cut_dst;
        cutoff_kp(k) = cut_kp;
        cutoff_lat(k) = cut_lat;
        cutoff_lon(k) = cut_lon;
        m = mod(m+1,2);
    end


    %This will find the cutoff L_shells in time
    for l = 1:length(L_shell_pass_directional)
        if isempty(datenum_pass_directional{l})
            final_pass_time = NaN;
        else
            final_pass_time = datenum_pass_directional{l}(end);
        end
        
        if l == length(L_shell_pass_directional) || isempty(datenum_pass_directional{l+1})
            start_next_pass_time = NaN;
        else
            start_next_pass_time = datenum_pass_directional{l+1}(1);
        end
        
        del_time = datevec(start_next_pass_time - final_pass_time);
        
        if isnan(cutoff_L(l)) || del_time(6) > 2
            cutoff_datenum(l) = mean(datenum_pass_directional{l});
            cutoff_L(l) = NaN;
            cutoff_flux(l) = NaN;
            cutoff_MLTs(l) = NaN;
        else
            cutoff_loc = find(L_shell_pass_directional{l} == cutoff_L(l),1);
            cutoff_datenum(l) = datenum_pass_directional{l}(cutoff_loc);
        end
    end
    
    for m = 1:length(cutoff_MLTs)
        if cutoff_MLTs(m) > 90 && cutoff_MLTs(m) < 270
            noon(m) = 1;
        elseif isnan(cutoff_MLTs(m))
            noon(m) = NaN;
        else
            noon(m) = 0;
        end
    end

    a = flux_pass_directional;
    b = L_shell_pass_directional;
    c = datenum_pass_directional;
    d = cutoff_flux;
    e = cutoff_L;
    f = cutoff_datenum;
    g = noon;
    h = cutoff_dst;
    i = cutoff_kp;
    j = cutoff_lat;
    k = cutoff_lon;
end