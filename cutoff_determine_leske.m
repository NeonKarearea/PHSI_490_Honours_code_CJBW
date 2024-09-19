function [a,b,c,d,e,f,g] = cutoff_determine_leske(L_shell,flux,MLT,dst,kp,lat,lon,m)
%This will determine the cutoff flux and the difference between the cutoff and actual flux, and attemps to find the correct cutoff latitiudes and fluxes.
    if m == 1
        L_shell = L_shell(end:-1:1);
        flux = flux(end:-1:1);
    end
    
    L_crit = 1/((cosd(70))^2);
    L_70 = find(L_shell>=L_crit, 1);
    avg_flux = mean(flux(L_70:end));
    
    cutoff_flux = avg_flux/2;
    true_del_flux = cutoff_flux*ones(size(flux))-flux;
    del_flux = abs(true_del_flux);
    [~, val_del_flux] = sort(del_flux);
    
    %This is to catch any instances where there is no L-shell above
    %the defined L
    if isnan(avg_flux) == 1
        true_flux = NaN;
        true_L = NaN;
        true_MLT = NaN;
        true_dst = NaN;
        true_kp = NaN;
        true_lat = NaN;
        true_lon = NaN;
    else
        true_flux = flux(int64(val_del_flux(1)));
        true_L = L_shell(int64(val_del_flux(1)));
        true_MLT = MLT(int64(val_del_flux(1)));
        true_dst = dst(int64(val_del_flux(1)));
        true_kp = kp(int64(val_del_flux(1)));
        true_lat = lat(int64(val_del_flux(1)));
        true_lon = lon(int64(val_del_flux(1)));
    end
    
    %This is a final catch incase something (like a 1 long flux list) comes
    %through.
    if ~exist('true_flux','var') || ~exist('true_L','var')
        true_flux = NaN;
        true_L = NaN;
        true_MLT = NaN;
        true_dst = NaN;
        true_kp = NaN;
        true_lat = NaN;
        true_lon = NaN;
    end
    a = true_flux;
    b = true_L;
    c = true_MLT;
    d = true_dst;
    e = true_kp;
    f = true_lat;
    g = true_lon;
end