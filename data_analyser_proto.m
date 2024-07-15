%This is the names and the file prefixes for the different satellites
satellite_names = {'MetOp1','MetOp2','NOAA15','NOAA16','NOAA17','NOAA18','NOAA19'};
satellite_prefix = {'m01','m02','n15','n16','n17','n18','n19'};

skipped_file = 0;
for i = 1:length(satellite_names)
    file = strcat(satellite_names{i},"\poes_",satellite_prefix{i});
    if isfile(strcat('E:\PHSI 490\POES data PHSI 490\',file,"_20120123.mat"))
        relevant_file{i-skipped_file} = file; %#ok<SAGROW>
    else
        skipped_file = skipped_file + 1;
        skipped_satellite{i} = satellite_names{i}; %#ok<SAGROW>
    end
end

disp(strcat(num2str(skipped_file)," satellite(s) didn't have the data. These satellites were:"))
disp(skipped_satellite)

for j = 1:length(relevant_file)
    if j == 1
        [fluxes,L_shells,datenums,cutoff_fluxes,cutoff_L_shells,cutoff_datenums]...
            = event_determine(2012,01,23,00,00,2012,01,23,23,59,relevant_file{j});
    else
        [fluxes_2,L_shells_2,datenums_2,cutoff_fluxes_2,cutoff_L_shells_2,cutoff_datenums_2]...
            = event_determine(2012,01,23,00,00,2012,01,23,23,59,relevant_file{j});
            
        fluxes = [fluxes,fluxes_2];
        L_shells = [L_shells,L_shells_2];
        datenums = [datenums,datenums_2];
        cutoff_fluxes = [cutoff_fluxes,cutoff_fluxes_2];
        cutoff_L_shells = [cutoff_L_shells,cutoff_L_shells_2];
        cutoff_datenums = [cutoff_datenums,cutoff_datenums_2];
        
            %{
            %Now we want to sort this in time. 
            sorted_cutoff_datenums = sort(cutoff_datenums);
            for i = 1:length(sorted_cutoff_datenums)
                if isnan(sorted_cutoff_datenums(i))
                    break
                end
            
                if ismember(sorted_cutoff_datenums(i),cutoff_datenums_2)
                    loc = find(cutoff_datenums_2 == sorted_cutoff_datenums(i));
                
                    fluxes{i} = fluxes_2{loc};
                    L_shells{i} = L_shells_2{loc};
                    datenums{i} = datenums_2{loc};
                    cutoff_fluxes(i) = cutoff_fluxes_2(loc);
                    cutoff_L_shells(i) = cutoff_L_shells_2(loc);
                    cutoff_datenums(i) = cutoff_datenums_2(loc);
                else
                    loc = find(cutoff_datenums == sorted_cutoff_datenums(i));
                
                    fluxes{i} = fluxes{loc};
                    L_shells{i} = L_shells{loc};
                    datenums{i} = datenums{loc};
                    cutoff_fluxes(i) = cutoff_fluxes(loc);
                    cutoff_L_shells(i) = cutoff_L_shells(loc);
                    cutoff_datenums(i) = cutoff_datenums(loc);
                end
            end
            %}
        
        fluxes = [fluxes,fluxes_2];
        L_shells = [L_shells,L_shells_2];
        datenums = [datenums,datenums_2];
        cutoff_fluxes = [cutoff_fluxes,cutoff_fluxes_2];
        cutoff_L_shells = [cutoff_L_shells,cutoff_L_shells_2];
        cutoff_datenums = [cutoff_datenums,cutoff_datenums_2];
    
    end
end