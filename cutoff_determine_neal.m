function [a,b,c,d,e,f,g] = cutoff_determine_neal(L_shell,flux,MLT,dst,kp,lat,lon,diff,m)
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
        %This makes sure that it has the right flux
        for i = 1:length(val_del_flux)
            %For our tests, index 1 and end index cannot be considered so 
            %this makes sure that val_del_flux != 4 or end-3 (This is important for the 3rd check).
            if val_del_flux(i) >= 6 && val_del_flux(i) <= (length(val_del_flux)-5)
                L_closest = L_shell(int64(val_del_flux(i)));
                L_2_closest = L_shell((int64(val_del_flux(i)))+1);
                
                %First Check: dL is small
                if abs(L_closest - L_2_closest) <= diff
                    dL = L_2_closest - L_closest;
                    dPhi = flux(int64(val_del_flux(i))+1) - flux(int64(val_del_flux(i)));
                    
                    dL2 = L_closest-L_shell((int64(val_del_flux(i)))-1);
                    dPhi2 = flux(int64(val_del_flux(i))) - flux(int64(val_del_flux(i))-1);
                    
                    %Second Check: dL/dPhi and dL2/dPhi2 are positive.
                    if dPhi/dL >= 0 && dPhi2/dL2 >= 0
                        true_flux = flux(int64(val_del_flux(i)));
                        true_L = L_closest;
                        true_MLT = MLT(int64(val_del_flux(i)));
                        true_dst = dst(int64(val_del_flux(i)));
                        true_kp = kp(int64(val_del_flux(i)));
                        true_lat = lat(int64(val_del_flux(i)));
                        true_lon = lon(int64(val_del_flux(i)));
                        break
                    else
                        continue
                    end
                else
                    continue
                end
            else
                continue
            end
        end
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