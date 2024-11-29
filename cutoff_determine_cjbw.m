function [a,b,c,d,e,f,g,h,i] = cutoff_determine_cjbw(L_shell,flux,MLT,dst,kp,...
    geograph_lat,geograph_lon,geomag_lat,geomag_lon,...
    m,num_grad,min_flux,min_avg_flux)
    %This will determine the cutoff flux and the difference between the cutoff and actual flux, and attemps to find the correct cutoff latitiudes and fluxes.
    if m == 1
        L_shell = L_shell(end:-1:1);
        flux = flux(end:-1:1);
    end
    r_earth = 6.371e6; %meters, radius of Earth
    r_sat = 8.50e5; %meters, average orbital height of the POES satellites
    
    r = (r_earth+r_sat)/r_earth;
    
    L_crit = r/((cosd(70))^2);
    L_70 = find(L_shell>=L_crit, 1);
    avg_flux = mean(flux(L_70:end));
    
    cutoff_flux = avg_flux/2;
    del_flux = flux-cutoff_flux*ones(size(flux));

    smoothed_flux = movmean(flux,17,'omitnan');
    local_maxima = find(islocalmax(smoothed_flux)&flux>=min_flux);
    
    try
        del_smooth_flux = smoothed_flux(local_maxima(1)+7)-smoothed_flux(local_maxima(1));
        del_L_shell = L_shell(local_maxima(1)+7)-L_shell(local_maxima(1));
        grad_out_1 = del_smooth_flux/del_L_shell;
        grad_out_1 = ceil(grad_out_1/10)*10;
    catch
        grad_out_1 = -1;
    end
    
    if isempty(local_maxima)
        avg_flux = NaN;
    elseif flux(local_maxima(1)) < cutoff_flux && flux(local_maxima(1))>cutoff_flux/2
        avg_flux = NaN;
    elseif flux(local_maxima(1))<cutoff_flux/2 && grad_out_1 == 0
        avg_flux = NaN;
    end
    
    %This is to catch any instances where there is no L-shell above
    %the defined L
    if isnan(avg_flux) == 1
        true_flux = NaN;
        true_L = NaN;
        true_MLT = NaN;
        true_dst = NaN;
        true_kp = NaN;
        true_geograph_lat = NaN;
        true_geograph_lon = NaN;
        true_geomag_lat = NaN;
        true_geomag_lon = NaN;
    else
        %This will find all the points where the difference in cutoff and
        %measured flux changes sign
        sign_del_flux_plus = sign(del_flux(1:end-1));
        sign_del_flux_minus = sign(del_flux(2:end));
        sign_change = sign_del_flux_plus ~= sign_del_flux_minus & (~isnan(sign_del_flux_plus) & ~isnan(sign_del_flux_minus));
        sign_change_loc = find(sign_change == 1);
        sign_change_loc_grouped = grouper(sign_change_loc,8);

        for i = 1:length(sign_change_loc_grouped)
            maxima_delta = abs(local_maxima - sign_change_loc_grouped(i).*ones(length(local_maxima),1));
            maxima_delta_location = find(maxima_delta == min(maxima_delta),1);
            if isempty(maxima_delta_location)||sign_change_loc_grouped(i) <= num_grad || sign_change_loc_grouped(i) >= length(del_flux)-num_grad
                continue
            elseif maxima_delta(maxima_delta_location) <= 14 && L_shell(sign_change_loc_grouped(i)) < 4
                [avg_grad_omni_in] = grad_check(flux,L_shell,local_maxima(maxima_delta_location),-1,num_grad);
                [avg_grad_omni_out] = grad_check(flux,L_shell,local_maxima(maxima_delta_location),1,num_grad);
                
                if sign(avg_grad_omni_in) ~= sign(avg_grad_omni_out) || (sign(avg_grad_omni_in) ~= 0 && sign(avg_grad_omni_out) < 0)
                    continue
                else
                    true_flux = flux(int64(sign_change_loc_grouped(i)));
                    true_L = L_shell(int64(sign_change_loc_grouped(i)));
                    true_MLT = MLT(int64(sign_change_loc_grouped(i)));
                    true_dst = dst(int64(sign_change_loc_grouped(i)));
                    true_kp = kp(int64(sign_change_loc_grouped(i)));
                    true_geograph_lat = geograph_lat(int64(sign_change_loc_grouped(i)));
                    true_geograph_lon = geograph_lon(int64(sign_change_loc_grouped(i)));
                    true_geomag_lat = geomag_lat(int64(sign_change_loc_grouped(i)));
                    true_geomag_lon = geomag_lon(int64(sign_change_loc_grouped(i)));
                    break
                end
            else
                [avg_grad_omni_in,avg_del_flux_in] = grad_check(del_flux,L_shell,sign_change_loc_grouped(i),-1,num_grad);
                [avg_grad_omni_out,avg_del_flux_out] = grad_check(del_flux,L_shell,sign_change_loc_grouped(i),1,num_grad);
                
                if ((avg_grad_omni_in < 0 && avg_grad_omni_out > 0)||(avg_del_flux_in < 0 && avg_del_flux_out > 0))%&&(sign(avg_grad_E3_in) <= 0 && sign(avg_grad_E3_in) == sign(avg_grad_E3_out))
                    true_flux = flux(int64(sign_change_loc_grouped(i)));
                    true_L = L_shell(int64(sign_change_loc_grouped(i)));
                    true_MLT = MLT(int64(sign_change_loc_grouped(i)));
                    true_dst = dst(int64(sign_change_loc_grouped(i)));
                    true_kp = kp(int64(sign_change_loc_grouped(i)));
                    true_geograph_lat = geograph_lat(int64(sign_change_loc_grouped(i)));
                    true_geograph_lon = geograph_lon(int64(sign_change_loc_grouped(i)));
                    true_geomag_lat = geomag_lat(int64(sign_change_loc_grouped(i)));
                    true_geomag_lon = geomag_lon(int64(sign_change_loc_grouped(i)));
                    break
                else
                    continue
                end
            end
        end
    end
    
    %This is a final catch in case the cutoff flux isn't found and removes
    %passes that at any point touch the SAMA and removes clearly bullshit
    %points (i.e. a cutoff L > 20 is clearly wrong)
    front_half_flux = flux(1:floor(length(flux)/2));
    if ~exist('true_flux','var')||~exist('true_L','var')||true_flux<=min_flux||avg_flux<=min_avg_flux||true_L>20||(length(find(front_half_flux<=min_flux))<num_grad)
        true_flux = NaN;
        true_L = NaN;
        true_MLT = NaN;
        true_dst = NaN;
        true_kp = NaN;
        true_geograph_lat = NaN;
        true_geograph_lon = NaN;
        true_geomag_lat = NaN;
        true_geomag_lon = NaN;
    end
    a = true_flux;
    b = true_L;
    c = true_MLT;
    d = true_dst;
    e = true_kp;
    f = true_geograph_lat;
    g = true_geograph_lon;
    h = true_geomag_lat;
    i = true_geomag_lon;
end