function [a,b,c,d,e,f,g,h] = L_finder_true(flux,L_shell,datenum,sat_lat,sat_lon,num_grad,min_flux,min_avg_flux)
%This function determines the cutoff L and flux over an event. This
    %will return 6 things; the flux, L_shell, and datenum information used
    %in the determining of the cutoffs (for plotting reasons) and the
    %cutoff flux, L-shell, and datenum for each event.
    
    sat_lat_plus = sat_lat(2:end);
    sat_lat_minus = sat_lat(1:end-1);
    
    idx = sat_lat;
    jdx = sat_lon;

    flux(idx>=-60&idx<=10&(jdx>=270|jdx<=40)) = NaN;

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
        datenum_pass{i} = datenum(start_pos:finish_pos);
        
        L_shell_lower = L_shell_pass{i};
        L_shell_pass{i} = L_shell_pass{i}(L_shell_lower >= 2);
        flux_pass{i} = flux_pass{i}(L_shell_lower >= 2);
        datenum_pass{i} = datenum_pass{i}(L_shell_lower >= 2);
        check = 1;
    end

    %This will split the passes into entrance and exit
    for j = 1:length(L_shell_pass)
        L_shell_examine = L_shell_pass{j};
        flux_examine = flux_pass{j};
        datenum_examine = datenum_pass{j};
    
        del_L_loc = find(L_shell_examine == max(L_shell_examine));
    
        L_shell_pass_directional{(2*j)-1} = L_shell_examine(1:del_L_loc);
        L_shell_pass_directional{2*j} = L_shell_examine(del_L_loc+1:end);
        flux_pass_directional{(2*j)-1} = flux_examine(1:del_L_loc);
        flux_pass_directional{2*j} = flux_examine(del_L_loc+1:end);
        datenum_pass_directional{(2*j)-1} = datenum_examine(1:del_L_loc);
        datenum_pass_directional{2*j} = datenum_examine(del_L_loc+1:end);
    end

    %Now we can find the cutoff L_shells
    m = 0; %This starts it as entry
    for k = 1:length(flux_pass_directional)
        [cut_flux, cut_L, avg_std_in, avg_std_out] = alternative_cutoff_determine(L_shell_pass_directional{k},...
            flux_pass_directional{k},m,num_grad,min_flux,min_avg_flux);
        cutoff_L(k) = cut_L;
        cutoff_flux(k) = cut_flux;
        std_in(k) = avg_std_in;
        std_out(k) = avg_std_out;
        m = mod(m+1,2);
    end


    %This will find the cutoff L_shells in time
    for l = 1:length(L_shell_pass_directional)
        if ~isnan(cutoff_L(l))
            cutoff_loc = find(L_shell_pass_directional{l} == cutoff_L(l),1);
            cutoff_datenum(l) = datenum_pass_directional{l}(cutoff_loc);
        else
            cutoff_datenum(l) = NaN;
        end
    end

    a = flux_pass_directional;
    b = L_shell_pass_directional;
    c = datenum_pass_directional;
    d = cutoff_flux;
    e = cutoff_L;
    f = cutoff_datenum;
    g = std_in;
    h = std_out;
end