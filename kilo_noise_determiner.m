function [a,b,c] = kilo_noise_determiner
    delete(gcp('nocreate'))
    parpool();
    
    events = csvread('event_dates.csv',1);
    parfor i = 1:length(events(:,1))
        [cutoff_fluxes_all_events{i,1},cutoff_L_shells_all_events{i,1},...
            cutoff_datenums_all_events{i,1}] = noise_determiner(events(i,1),events(i,2),events(i,3),events(i,4),events(i,5),events(i,6));
    end
    for j = 1:length(events(:,1))
        for k = 1:31
            std_cutoff_fluxes(j,k) = std(cutoff_fluxes_all_events{j}{k}{1},'omitnan');
            std_cutoff_L_shells(j,k) = std(cutoff_L_shells_all_events{j}{k}{1},'omitnan');
            std_cutoff_datenums(j,k) = std(cutoff_datenums_all_events{j}{k}{1},'omitnan');
        end
    end
    a = median(std_cutoff_fluxes,'omitnan');
    b = median(std_cutoff_L_shells,'omitnan');
    c = median(std_cutoff_datenums,'omitnan');
    delete(gcp('nocreate'))
end