model_times = csvread("model_event_times.csv",1);

r = (6.371e6+(850e3))/(6.371e6);

for i = 1:length(model_times(:,1))
    if i == 1
        [fluxes_p6,L_shells_p6,datenums_p6,original_cutoff_fluxes_p6,...
            cutoff_fluxes_p6,cutoff_L_shells_p6,cutoff_datenums_p6,...
            cutoff_MLT_p6,cutoff_dst_p6,cutoff_delta_dst_p6,cutoff_kp_p6,...
            cutoff_symh_p6,cutoff_ae_p6,cutoff_entrance_p6,...
            cutoff_geograph_lat_p6,cutoff_geograph_lon_p6,cutoff_geomag_lat_p6,cutoff_geomag_lon_p6]...
            = data_analyser(model_times(i,1),model_times(i,2),model_times(i,3),model_times(i,4),model_times(i,5),model_times(i,6),2,2,9,15,"P6",0);
    else
        [fluxes_p6_2,L_shells_p6_2,datenums_p6_2,original_cutoff_fluxes_p6_2,...
            cutoff_fluxes_p6_2,cutoff_L_shells_p6_2,cutoff_datenums_p6_2,...
            cutoff_MLT_p6_2,cutoff_dst_p6_2,cutoff_delta_dst_p6_2,cutoff_kp_p6_2,cutoff_symh_p6_2,...
            cutoff_ae_p6_2,cutoff_entrance_p6_2,cutoff_geograph_lat_p6_2,...
            cutoff_geograph_lon_p6_2,cutoff_geomag_lat_p6_2,cutoff_geomag_lon_p6_2]...
            = data_analyser(model_times(i,1),model_times(i,2),model_times(i,3),model_times(i,4),model_times(i,5),model_times(i,6),2,2,9,15,"P6",0);
        
        fluxes_p6 = [fluxes_p6,fluxes_p6_2];
        L_shells_p6 = [L_shells_p6,L_shells_p6_2];
        datenums_p6 = [datenums_p6,datenums_p6_2];
        original_cutoff_fluxes_p6 = [original_cutoff_fluxes_p6,original_cutoff_fluxes_p6_2];
        cutoff_fluxes_p6 = [cutoff_fluxes_p6,cutoff_fluxes_p6_2];
        cutoff_L_shells_p6 = [cutoff_L_shells_p6,cutoff_L_shells_p6_2];
        cutoff_datenums_p6 = [cutoff_datenums_p6,cutoff_datenums_p6_2];
        cutoff_MLT_p6 = [cutoff_MLT_p6,cutoff_MLT_p6_2];
        cutoff_dst_p6 = [cutoff_dst_p6,cutoff_dst_p6_2];
        cutoff_delta_dst_p6 = [cutoff_delta_dst_p6,cutoff_delta_dst_p6_2];
        cutoff_kp_p6 = [cutoff_kp_p6,cutoff_kp_p6_2];
        cutoff_symh_p6 = [cutoff_symh_p6,cutoff_symh_p6_2];
        cutoff_ae_p6 = [cutoff_ae_p6,cutoff_ae_p6_2];
        cutoff_entrance_p6 = [cutoff_entrance_p6,cutoff_entrance_p6_2];
        cutoff_geograph_lat_p6 = [cutoff_geograph_lat_p6,cutoff_geograph_lat_p6_2];
        cutoff_geograph_lon_p6 = [cutoff_geograph_lon_p6,cutoff_geograph_lon_p6_2];
        cutoff_geomag_lat_p6 = [cutoff_geomag_lat_p6,cutoff_geomag_lat_p6_2];
        cutoff_geomag_lon_p6 = [cutoff_geomag_lon_p6,cutoff_geomag_lon_p6_2];
    end
end

cutoff_invariant_lat_p6 = acosd(sqrt(r./cutoff_L_shells_p6));
clear -regexp \S+_2$