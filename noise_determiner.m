delete(gcp('nocreate'))
pools = parpool()  %#ok<NOPTS>
files = {'data_analyser.m','event_determine_true.m','L_finder.m','alternative_cutoff_determine.m','grad_check'};
addAttachedFiles(pools,files);

cut_flux = 5:1:15;
cut_avg_flux = 10:2:30;

cutoff_fluxes = cell(length(cut_flux),length(cut_avg_flux));
cutoff_L_shells = cell(length(cut_flux),length(cut_avg_flux));
cutoff_datenums = cell(length(cut_flux),length(cut_avg_flux));

parfor i = 1:length(cut_flux)
    cutoff_fluxes_row = cell(1,length(cut_avg_flux));
    cutoff_L_shells_row = cell(1,length(cut_avg_flux));
    cutoff_datenums_row = cell(1,length(cut_avg_flux));
    for j = 1:length(cut_avg_flux)
        [flux,L_shell,datenum,cutoff_flux,cutoff_L_shell,cutoff_datenum]=...
            data_analyser(2012,01,23,2012,01,31,2,5,'P6',cut_flux(i),cut_avg_flux(j));
        
        cutoff_fluxes_row{j} = cutoff_flux;
        cutoff_L_shells_row{j} = cutoff_L_shell;
        cutoff_datenums_row{j} = cutoff_datenum;
    end
    cutoff_fluxes_column{i} = cutoff_fluxes_row;
    cutoff_L_shells_column{i} = cutoff_L_shells_row;
    cutoff_datenums_column{i} = cutoff_datenums_row;
    disp(strcat("Found the cutoffs for min_cutoff_flux = ",num2str(i+4)))
end

for i = 1:11
    cutoff_fluxes_part = cutoff_fluxes_column{i};
    cutoff_L_shells_part = cutoff_L_shells_column{i};
    cutoff_datenums_part = cutoff_datenums_column{i};
    for j = 1:11
        cutoff_fluxes{i,j} = cutoff_fluxes_part{j};
        cutoff_L_shells{i,j} = cutoff_L_shells_part{j};
        cutoff_datenums{i,j} = cutoff_datenums_part{j};
    end
end
delete(gcp('nocreate'))