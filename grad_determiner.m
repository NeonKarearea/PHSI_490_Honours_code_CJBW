function [a,b,c,d,e,f,g] = grad_determiner
    delete(gcp('nocreate'))
    parpool();

    num_grad = 1:1:30;
    
    parfor i = 1:length(num_grad)
        [~,~,~,cutoff_flux,cutoff_L_shell,cutoff_datenum]=...
            data_analyser(2012,01,23,2012,01,31,2,i,'P6',9,15);
        
        cutoff_flux_all_grads_set_noise(i,:) = cutoff_flux;
        cutoff_L_shell_all_grads_set_noise(i,:) = cutoff_L_shell;
        cutoff_datenum_all_grads_set_noise(i,:) = cutoff_datenum;
        disp(strcat("Finished the cutoffs for ",num2str(i)," gradients"))
    end
    
    for j = 2:(length(cutoff_flux_all_grads_set_noise(:,1))-1)
        figure(j-1);
        mean_cutoff_datenums((j-1),:) = mean([cutoff_datenum_all_grads_set_noise(j-1,:);cutoff_datenum_all_grads_set_noise(j,:);cutoff_datenum_all_grads_set_noise(j+1,:)],'omitnan');
        std_cutoff_L_shells((j-1),:) = std([cutoff_L_shell_all_grads_set_noise(j-1,:);cutoff_L_shell_all_grads_set_noise(j,:);cutoff_L_shell_all_grads_set_noise(j+1,:)],'omitnan');
        plot(mean_cutoff_datenums(j-1,:),std_cutoff_L_shells(j-1,:))
    end
    
    for k = 1:(length(cutoff_flux_all_grads_set_noise(:,1))-1)
        mean_cutoff_datenums_duo(k,:) = mean([cutoff_datenum_all_grads_set_noise(k,:);cutoff_datenum_all_grads_set_noise(k+1,:)],'omitnan');
        std_cutoff_L_shells_duo(k,:) = std([cutoff_L_shell_all_grads_set_noise(k,:);cutoff_L_shell_all_grads_set_noise(k+1,:)],'omitnan');
    end
    
    a = cutoff_flux_all_grads_set_noise;
    b = cutoff_L_shell_all_grads_set_noise;
    c = cutoff_datenum_all_grads_set_noise;
    d = mean_cutoff_datenums;
    e = std_cutoff_L_shells;
    f = mean_cutoff_datenums_duo;
    g = std_cutoff_L_shells_duo;
    delete(gcp('nocreate'))
end