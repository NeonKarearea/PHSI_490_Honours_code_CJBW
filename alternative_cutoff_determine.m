function [a,b,c,d] = alternative_cutoff_determine(L_shell,flux,m,num_grad,min_flux,min_avg_flux)
%This will determine the cutoff flux and the difference between the cutoff and actual flux, and attemps to find the correct cutoff latitiudes and fluxes.
    if m == 1
        L_shell = L_shell(end:-1:1);
        flux = flux(end:-1:1);
    end
    
    L_crit = 1/((cosd(70))^2);
    L_70 = find(L_shell>=L_crit, 1);
    avg_flux = mean(flux(L_70:end));
    
    cutoff_flux = avg_flux/2;
    del_flux = cutoff_flux*ones(size(flux))-flux;
    abs_del_flux = abs(del_flux);
    
    %This is to catch any instances where there is no L-shell above
    %the defined L
    if isnan(avg_flux) == 1
        true_flux = NaN;
        true_L = NaN;
        std_in = NaN;
        std_out = NaN;
    else
        %This will find all the points where the difference in cutoff and
        %measured flux changes sign
        sign_del_flux_plus = sign(del_flux(1:end-1));
        sign_del_flux_minus = sign(del_flux(2:end));
        sign_change = sign_del_flux_plus ~= sign_del_flux_minus;
        sign_change_loc = find(sign_change == 1);
        
        for i = 1:length(sign_change_loc)
            if sign_change_loc(i) <= num_grad || sign_change_loc(i) >= length(del_flux)-num_grad
                continue
            else
                [avg_grad_in,avg_std_in] = grad_check(abs_del_flux,L_shell,sign_change_loc(i),-1,num_grad);
                [avg_grad_out,avg_std_out] = grad_check(abs_del_flux,L_shell,sign_change_loc(i),1,num_grad);
                if avg_grad_in < 0 && avg_grad_out > 0
                    true_flux = flux(int64(sign_change_loc(i)));
                    true_L = L_shell(int64(sign_change_loc(i)));
                    std_in = avg_std_in;
                    std_out = avg_std_out;
                    break
                else
                    continue
                end
            end
        end
    end
    
    %This is a final catch in case the cutoff flux isn't found (This also
    %removes points below a cutoff flux value of 11 and an average flux of 
    %22 (this forms our noise floor))
    if ~exist('true_flux','var')||~exist('true_L','var')||true_flux<=min_flux||avg_flux<=min_avg_flux%||true_flux<=cut_flux||avg_flux<=cut_avg_flux
        true_flux = NaN;
        true_L = NaN;
        std_in = NaN;
        std_out = NaN;
    end
    a = true_flux;
    b = true_L;
    c = std_in;
    d = std_out;
end