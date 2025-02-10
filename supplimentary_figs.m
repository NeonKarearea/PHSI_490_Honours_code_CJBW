addpath(fullfile('paper_data_or_figures','Supplimentary'))
current_location = pwd;
lat_type = upper(input('Would you like to use invariant latitude (Y) or L-shells (N)? ','s'));
if lat_type ~= 'Y' && lat_type ~= 'N'
    error("Please only use Y or N (N.B: This is case insensitive")
end

event_timings = csvread("event_timings.csv",1);

for i = 1:length(event_timings(:,1))
    [~,~,~,~,~,cutoff_L_shells,cutoff_datenums,cutoff_MLT] = data_analyser(event_timings(i,1),...
        event_timings(i,2),event_timings(i,3),event_timings(i,4),event_timings(i,5),...
        event_timings(i,6),2,2,9,15,"P6",0);
    
    switch lat_type
        case 'Y'
            r = ((6.371e6+(850e3))/(6.371e6));
        	cutoff_latitude = acosd(sqrt(r./cutoff_L_shells));
            lat_label = "Invariant latitude (/lambda)";
            lat_name = "invariant_latitude";
        case 'N'
            cutoff_latitude = cutoff_L_shells;
            lat_label = "L-shell (L-value)";
            lat_name = "L_shell";
        otherwise
    end
    
    figure(i)
    hold on
    scatter(cutoff_datenums(cutoff_MLT<=90|cutoff_MLT>=270),cutoff_latitude(cutoff_MLT<=90|cutoff_MLT>=270),'LineWidth',2.0)
    scatter(cutoff_datenums(cutoff_MLT>=90&cutoff_MLT<=270),cutoff_latitude(cutoff_MLT>=90&cutoff_MLT<=270),'LineWidth',2.0)
    grid on
    grid minor
    set(gcf, 'Position', get(0, 'Screensize'))
    set(gca,'FontSize',18,'FontWeight','demi')
    datetick('x','dd/mm HH:MM','keepticks')
    xlabel("Date (UT, dd/mm HH:MM)")
    ylabel(lat_label)
    filename = strcat(num2str(event_timings(i,1)),num2str(event_timings(i,2)),num2str(event_timings(i,3)),lat_name);
    saveas(gcf,fullfile('paper_data_or_figures','Supplimentary',convertStringsToChars(filename)),'fig');
    saveas(gcf,fullfile('paper_data_or_figures','Supplimentary',convertStringsToChars(filename)),'png');
end