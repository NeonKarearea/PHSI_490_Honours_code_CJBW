function [a,b,c,d,e,f,g,h] = L_finder(flux,L_shell,datenum,sat_lat,sat_lon,MLT,num_grad,min_flux,min_avg_flux)
%This function determines the cutoff L and flux over an event. This will return 6 things; the flux, L_shell, and datenum information used in the determining of the cutoffs (for plotting reasons) and the cutoff flux, L-shell, and datenum for each event.
    
    sat_lat_plus = sat_lat(2:end);
    sat_lat_minus = sat_lat(1:end-1);
    
    idx = sat_lat;
    jdx = sat_lon;
    
    %This removes the effect of the SAMA (mostly) and removes points that
    %are clearly non-physical (i.e. negative points)
    flux((idx>=-55&idx<=15&(jdx>=250|jdx<=40))|(idx>=-20&idx<=20)|(flux<0)) = NaN;

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
        MLT_pass{i} = MLT(start_pos:finish_pos);
        check = 1;
        
        if sat_lat(trans_loc(i)) < 0
            hemisphere(i) = 2;
        else
            hemisphere(i) = 0;
        end
        
    end

    %This will split the passes into entrance and exit
    for j = 1:length(L_shell_pass)
        quadrant((2*j)-1) = hemisphere(j);
        quadrant(2*j) = hemisphere(j) + 1;
        
        L_shell_examine = L_shell_pass{j};
        flux_examine = flux_pass{j};
        datenum_examine = datenum_pass{j};
        MLT_examine = MLT_pass{j};
    
        del_L_loc = find(L_shell_examine == max(L_shell_examine));
    
        L_shell_pass_directional{(2*j)-1} = L_shell_examine(1:del_L_loc);
        L_shell_pass_directional{2*j} = L_shell_examine(del_L_loc+1:end);
        flux_pass_directional{(2*j)-1} = flux_examine(1:del_L_loc);
        flux_pass_directional{2*j} = flux_examine(del_L_loc+1:end);
        datenum_pass_directional{(2*j)-1} = datenum_examine(1:del_L_loc);
        datenum_pass_directional{2*j} = datenum_examine(del_L_loc+1:end);
        MLT_pass_directional{(2*j)-1} = MLT_examine(1:del_L_loc);
        MLT_pass_directional{2*j} = MLT_examine(del_L_loc+1:end);
    end

    %Now we can find the cutoff L_shells
    m = 0; %This starts it as entry
    for k = 1:length(flux_pass_directional)
        [cut_flux, cut_L, cut_MLT] = cutoff_determine_cjbw(L_shell_pass_directional{k},...
            flux_pass_directional{k},MLT_pass_directional{k},m,num_grad,min_flux,min_avg_flux);
        cutoff_L(k) = cut_L;
        cutoff_flux(k) = cut_flux;
        cutoff_MLTs(k) = cut_MLT;
        m = mod(m+1,2);
    end


    %This will find the cutoff L_shells in time
    for l = 1:length(L_shell_pass_directional)
        if ~isnan(cutoff_L(l))
            cutoff_loc = find(L_shell_pass_directional{l} == cutoff_L(l),1);
            cutoff_datenum(l) = datenum_pass_directional{l}(cutoff_loc);
        else
            cutoff_datenum(l) = mean(datenum_pass_directional{l});
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
    g = quadrant;
    h = noon;
end