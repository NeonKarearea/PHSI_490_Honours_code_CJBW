
function [a,b,c,d,e,f,g,h,i] = cutoff_determine_cjbw_masochism_tango(L_shell,flux,MLT,dst,kp,...
    geograph_lat,geograph_lon,geomag_lat,geomag_lon,...
    m,num_grad,min_flux,min_avg_flux)
    %This will determine the cutoff flux and the difference between the cutoff and actual flux, and attemps to find the correct cutoff latitiudes and fluxes.
    if m == 1
        L_shell = L_shell(end:-1:1);
        flux = flux(end:-1:1);
        MLT = MLT(end:-1:1);
        dst = dst(end:-1:1);
        kp = kp(end:-1:1);
        geograph_lat = geograph_lat(end:-1:1);
        geograph_lon = geograph_lon(end:-1:1);
        geomag_lat = geomag_lat(end:-1:1);
        geomag_lon = geomag_lon(end:-1:1);
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
    grads = gradient(smoothed_flux,L_shell);
    
    %This is where we group the local_maxima points and discard the first
    %point at that is always noise
    local_maxima = find(islocalmax(smoothed_flux));
    local_maxima_sections = find(abs(diff(smoothed_flux(local_maxima)))>=2.5);
    if length(local_maxima_sections) == 1
        local_maxima_sections = [0;local_maxima_sections];
    end
    
    for i = 2:length(local_maxima_sections)+1
        try
            median_local_maxima = floor(median(local_maxima(local_maxima_sections(i-1)+1:local_maxima_sections(i))));
        catch
            median_local_maxima = floor(median(local_maxima(local_maxima_sections(i-1)+1:end)));
        end
        delta_locals = abs(local_maxima-median_local_maxima.*ones(length(local_maxima),1));
        local_maxima_grouped(i-1,1) = local_maxima(find(delta_locals==min(delta_locals),1));
    end
    
    %This is to catch any instances where there is no L-shell above
    %the defined L
    if isnan(avg_flux) == 1 || ~exist('local_maxima_grouped','var')
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
        offset = 0;
        diff_flux_true = avg_flux-min(flux);

        for j = 1:length(local_maxima_grouped)
            max_loc = local_maxima_grouped(j);
            min_loc = offset+find(smoothed_flux(1+offset:max_loc) == min(smoothed_flux(1+offset:max_loc)),1,'last');
            offset = max_loc;
            diff_flux_local = smoothed_flux(max_loc)-smoothed_flux(min_loc);
            is_in = ismember(sign_change_loc_grouped,min_loc:1:max_loc);
            if (length(sign_change_loc_grouped) == 1 && length(local_maxima(local_maxima <= sign_change_loc_grouped)) == 1)
                test_point = sign_change_loc_grouped(1);
                tested_point = test_point;
            elseif isempty(find(is_in==1,1))
                test_point = 1;
            elseif diff_flux_local/diff_flux_true >= 0.6 && L_shell(sign_change_loc_grouped(find(is_in==1,1)))<4
                try
                    diff_flux_previous_max = smoothed_flux(local_maxima_grouped(j)) - min(smoothed_flux(local_maxima_grouped(j):local_maxima_grouped(j+1)));
                catch
                    diff_flux_previous_max = NaN;
                end
                if diff_flux_local/diff_flux_previous_max >= 0.5 && diff_flux_previous_max/diff_flux_local >= 0.5
                    tested_point = sign_change_loc_grouped(find(is_in==1,1,'last'));
                    continue
                else
                    test_point = sign_change_loc_grouped(is_in==1,1);
                    tested_point = test_point;
                end
                
            elseif diff_flux_local/diff_flux_true >= 0.6 && L_shell(sign_change_loc_grouped(find(is_in==1,1,'last')))>6
                try
                    diff_flux_previous_max = smoothed_flux(local_maxima_grouped(j-1));
                catch
                    diff_flux_previous_max = NaN;
                end
                %if (diff_flux_local/diff_flux_previous >= 0.01 && diff_flux_previous/diff_flux_local >= 0.01)
                %    continue
                if (exist('tested_point','var') && tested_point(end) ~= sign_change_loc_grouped(find(is_in==1,1)-1))||...
                        (~exist('tested_point','var') && sign_change_loc_grouped(find(is_in==1,1)) ~= sign_change_loc_grouped(1))||...
                        diff_flux_previous_max/cutoff_flux >= 0.5
                    continue
                else
                    test_point = sign_change_loc_grouped(is_in==1);
                    tested_point = test_point;
                end
                
            elseif diff_flux_local/diff_flux_true >= 0.6
                test_point = sign_change_loc_grouped(is_in==1);
                tested_point = test_point;
            else
                test_point = 1;
                tested_point = 1;
            end
            
            %This does the original test
            if (length(test_point) == 1 && test_point == 1) || test_point(1) <= num_grad || test_point(end) >= length(flux)-num_grad
                continue
            else
                [avg_grad_in,avg_del_flux_in] = grad_check(del_flux,L_shell,test_point,-1,num_grad);
                [avg_grad_out,avg_del_flux_out] = grad_check(del_flux,L_shell,test_point,1,num_grad);
                
                grads_and_dels = [avg_grad_in',avg_grad_out',avg_del_flux_in',avg_del_flux_out'];
                location_validity = (grads_and_dels(:,1)<0&grads_and_dels(:,2)>0)|(grads_and_dels(:,3)<0&grads_and_dels(:,4)>0);
                
                if ~isempty(find(location_validity==1,1))%((avg_grad_in < 0 && avg_grad_out > 0)||(avg_del_flux_in < 0 && avg_del_flux_out > 0))
                    location = test_point(find(location_validity==1,1));
                    true_flux = flux(int64(location));
                    true_L = L_shell(int64(location));
                    true_MLT = MLT(int64(location));
                    true_dst = dst(int64(location));
                    true_kp = kp(int64(location));
                    true_geograph_lat = geograph_lat(int64(location));
                    true_geograph_lon = geograph_lon(int64(location));
                    true_geomag_lat = geomag_lat(int64(location));
                    true_geomag_lon = geomag_lon(int64(location));
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
    if ~exist('true_flux','var')||~exist('true_L','var')||true_flux<=min_flux||avg_flux<=min_avg_flux||true_L>15||(length(find(front_half_flux<=min_flux))<num_grad)
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
