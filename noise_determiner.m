function [a,b,c] = noise_determiner    
    delete(gcp('nocreate'))
    pools = parpool() %#ok<NOPRT>
    files = {'data_analyser.m','event_determine_true.m','L_finder.m','alternative_cutoff_determine.m','grad_check'};
    addAttachedFiles(pools,files);

    cut_flux = 5:1:15;
    cut_avg_flux = 10:2:30;
    num_grad = 1:1:10;

    cutoff_fluxes = cell(length(cut_flux),length(cut_avg_flux));
    cutoff_L_shells = cell(length(cut_flux),length(cut_avg_flux));
    cutoff_datenums = cell(length(cut_flux),length(cut_avg_flux));

    cutoff_fluxes_all_grads = cell(1,length(num_grad));
    cutoff_L_shells_all_grads = cell(1,length(num_grad));
    cutoff_datenums_all_grads = cell(1,length(num_grad));

    for i = 1:length(num_grad)
        parfor j = 1:length(cut_flux)
            cutoff_fluxes_row = cell(1,length(cut_avg_flux));
            cutoff_L_shells_row = cell(1,length(cut_avg_flux));
            cutoff_datenums_row = cell(1,length(cut_avg_flux));
            for k = 1:length(cut_avg_flux)
                [~,~,~,cutoff_flux,cutoff_L_shell,cutoff_datenum]=...
                    data_analyser(2012,01,23,2012,01,31,2,5,'P6',cut_flux(j),cut_avg_flux(k));

                cutoff_fluxes_row{k} = cutoff_flux;
                cutoff_L_shells_row{k} = cutoff_L_shell;
                cutoff_datenums_row{k} = cutoff_datenum;
            end
            cutoff_fluxes_column{j} = cutoff_fluxes_row;
            cutoff_L_shells_column{j} = cutoff_L_shells_row;
            cutoff_datenums_column{j} = cutoff_datenums_row;
            disp(strcat("Found the cutoffs for min_cutoff_flux = ",num2str(j+4)," for ",num2str(i)," gradients around the cutoff point."))
        end

        for l = 1:11
            cutoff_fluxes_part = cutoff_fluxes_column{l};
            cutoff_L_shells_part = cutoff_L_shells_column{l};
            cutoff_datenums_part = cutoff_datenums_column{l};
            for m = 1:11
                cutoff_fluxes{l,m} = cutoff_fluxes_part{m};
                cutoff_L_shells{l,m} = cutoff_L_shells_part{m};
                cutoff_datenums{l,m} = cutoff_datenums_part{m};
            end
        end

        cutoff_fluxes_all_grads{i} = cutoff_fluxes;
        cutoff_L_shells_all_grads{i} = cutoff_fluxes;
        cutoff_datenums_all_grads{i} = cutoff_fluxes;
    end

    a = cutoff_fluxes_all_grads;
    b = cutoff_L_shells_all_grads;
    c = cutoff_datenums_all_grads;
    delete(gcp('nocreate'))
end