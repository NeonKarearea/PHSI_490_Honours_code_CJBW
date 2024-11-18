function [a,b,c,d,e,f,g,h,i] = cutoff_determine_cjbw(L_shell,flux,MLT,dst,kp,...
    geograph_lat,geograph_lon,geomag_lat,geomag_lon,...
    m,num_grad,min_flux,min_avg_flux)
    %This will determine the cutoff flux and the difference between the cutoff and actual flux, and attemps to find the correct cutoff latitiudes and fluxes.
    if m == 1
        L_shell = L_shell(end:-1:1);
        flux = flux(end:-1:1);
    end
    cutoff_location=1;
    
    r_earth = 6.371e6; %meters, radius of Earth
    r_sat = 8.50e5; %meters, average orbital height of the POES satellites
    
    r = (r_earth+r_sat)/r_earth;
    
    L_crit = r/((cosd(70))^2);
    L_70 = find(L_shell>=L_crit, 1);
    avg_flux = mean(flux(L_70:end));
    
    cutoff_flux = avg_flux/2;
    del_flux = flux-cutoff_flux*ones(size(flux));

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
        
        for i = 1:length(sign_change_loc)
            if sign_change_loc(i) <= num_grad || sign_change_loc(i) >= length(del_flux)-num_grad
                continue
            else
                [avg_grad_in(i),avg_del_flux_in(i)] = grad_check(del_flux,L_shell,sign_change_loc(i),-1,num_grad);
                [avg_grad_out(i),avg_del_flux_out(i)] = grad_check(del_flux,L_shell,sign_change_loc(i),1,num_grad);
            end
        end
        
        if exist("avg_grad_in","var")
            avg_grads_and_fluxes = ([avg_grad_in;avg_grad_out;avg_del_flux_in;avg_del_flux_out])';
            point_validity = double((avg_grads_and_fluxes(:,1)<0 & avg_grads_and_fluxes(:,2)>0)&(avg_grads_and_fluxes(:,3)<0 & avg_grads_and_fluxes(:,4)>0));
            idx = find(point_validity == 0);
            point_validity(idx) = -1.*idx;
            point_difference = diff(point_validity);
            attempted_location = find(point_validity(1:end-1) == 1 & point_difference == 0,1);
            if isempty(find(point_validity == 1,1))
                cutoff_location = 1;
            elseif isempty(attempted_location)
                cutoff_location = int64(sign_change_loc(find(point_validity==1,1)));
            else
                cutoff_location = int64(sign_change_loc(point_validity(attempted_location)));
            end
            
            true_flux = flux(cutoff_location);
            true_L = L_shell(cutoff_location);
            true_MLT = MLT(cutoff_location);
            true_dst = dst(cutoff_location);
            true_kp = kp(cutoff_location);
            true_geograph_lat = geograph_lat(cutoff_location);
            true_geograph_lon = geograph_lon(cutoff_location);
            true_geomag_lat = geomag_lat(cutoff_location);
            true_geomag_lon = geomag_lon(cutoff_location);
        end
    end
    
    %This is a final catch in case the cutoff flux isn't found and removes
    %passes that at any point touch the SAMA
    front_half_flux = flux(1:floor(length(flux)/2));
    if ~exist('true_flux','var')||~exist('true_L','var')||true_flux<=min_flux||avg_flux<=min_avg_flux||(length(find(front_half_flux<=min_flux))<num_grad)||cutoff_location==1
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