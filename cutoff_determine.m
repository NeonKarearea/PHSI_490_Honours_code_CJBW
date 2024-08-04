function [a,b] = cutoff_determine(L_shell, flux, n, m)
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
    else
        true_flux = flux(int64(val_del_flux(1)));
        true_L = L_shell(int64(val_del_flux(1)));
    end
    
    %This is a final catch incase something (like a 1 long flux list) comes
    %through.
    if ~exist('true_flux','var') || ~exist('true_L','var')
        true_flux = NaN;
        true_L = NaN;
    end
    a = true_flux;
    b = true_L;
end