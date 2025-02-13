clear all %#ok<CLALL>
close all

%This one makes the figures that directly relate to MLT. Note that there is
%an extra one in here.

load('MLT_data.mat')

lat_answer = input('Would you like to use invariant latitude (Y) or L-shell (N)? ','s');
if upper(lat_answer) == 'Y'
    cutoff_latitude20120123 = cutoff_invariant_lat20120123;
    lat_label = "Invariant latitude (\lambda)";
    delta_lat_label = "Delta invariant latitude (\Delta\lambda)";
    lat_name = "invariant latitudes";
elseif upper(lat_answer) == 'N'
    cutoff_latitude20120123 = cutoff_L_shells20120123;
    lat_label = "L-shells (L-values)";
    delta_lat_label = "Delta L-shells (\Delta L-value)";
    lat_name = "L-shells";
else
    error("Not a valid input. Please use either Y or N (Note that it isn't case sensitive)")
end

%FIGURE 1
figure(1)
cutoff_MLT20120123 = floor(cutoff_MLT20120123./45);
hold on
for i = 0:7
    if i ~=7
        scatter(cutoff_datenums20120123(cutoff_MLT20120123==i),cutoff_latitude20120123(cutoff_MLT20120123==i),'Linewidth',1.5)
    else
        scatter(cutoff_datenums20120123(cutoff_MLT20120123==i),cutoff_latitude20120123(cutoff_MLT20120123==i),'k','Linewidth',1.5)
    end
end
ytick = get(gca,'YTick');
plot(datenum(2012,01,24,0,907,0).*ones(1,length(ytick)),ytick,'--k','Linewidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
datetick('x',20,'keepticks')
text(datenum(2012,01,23,6,0,0),57,"From 23/01/2012",'FontSize',15)
title(strcat("Cutoff ",lat_name," against time for various MLTs"))
xlabel("Date (UT)")
ylabel(lat_label)
xlim([datenum(2012,01,23,0,0,0),datenum(2012,01,27,0,0,0)])
legend("0-3 MLT","3-6 MLT","6-9 MLT","9-12 MLT","12-15 MLT","15-18 MLT","18-21 MLT","21-24 MLT","CME impacts")

%FIGURE 2
figure(2)
hold on
scatter(cutoff_datenums20120123(cutoff_MLT20120123==1|cutoff_MLT20120123==2),cutoff_latitude20120123(cutoff_MLT20120123==1|cutoff_MLT20120123==2),'LineWidth',2.0)
scatter(cutoff_datenums20120123(cutoff_MLT20120123==3|cutoff_MLT20120123==4),cutoff_latitude20120123(cutoff_MLT20120123==3|cutoff_MLT20120123==4),'LineWidth',2.0)
scatter(cutoff_datenums20120123(cutoff_MLT20120123==5|cutoff_MLT20120123==6),cutoff_latitude20120123(cutoff_MLT20120123==5|cutoff_MLT20120123==6),'LineWidth',2.0)
scatter(cutoff_datenums20120123(cutoff_MLT20120123==7|cutoff_MLT20120123==0),cutoff_latitude20120123(cutoff_MLT20120123==7|cutoff_MLT20120123==0),'LineWidth',2.0)
ytick = get(gca,'YTick');
plot(datenum(2012,01,24,0,907,0).*ones(1,length(ytick)),ytick,'--k','Linewidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
text(datenum(2012,01,23,6,0,0),57,"From 23/01/2012",'FontSize',15)
xlim([datenum(2012,01,23),datenum(2012,01,27)])
datetick('x','dd/mm HH:MM','keepticks')
title(strcat("Cutoff ",lat_name," against time for various MLT ranges"))
xlabel("Date (UT, dd/mm HH:MM)")
ylabel(lat_label)
legend("Dawn MLT","Dayside MLT","Dusk MLT","Nightside MLT","CME impact")

%FIGURE 3
for i = 1:4
    cutoff_datenums_quadrant = cutoff_datenums20120123(cutoff_MLT20120123==mod(2*i-1,8)|cutoff_MLT20120123==mod(2*i,8));
    cutoff_lat_quadrant = cutoff_invariant_lat20120123(cutoff_MLT20120123==mod(2*i-1,8)|cutoff_MLT20120123==mod(2*i,8));
    cutoff_datenums_bins = floor((cutoff_datenums_quadrant-datenum(2012,01,23))./0.0208);
    half_hour_bins = datenum(2012,01,23):datenum(0,0,0,0,30,0):datenum(2012,01,27);
    cutoff_lat_bin = NaN.*ones(1,length(half_hour_bins));
    for j = 1:length(half_hour_bins)
        median_indicies = find(cutoff_datenums_bins==j);
        cutoff_lat_bin(j) = median(cutoff_lat_quadrant(median_indicies));
    end
    first_point = find(~isnan(cutoff_lat_bin(:)),1);
    last_point = find(~isnan(cutoff_lat_bin(:)),1,'last');
    cutoff_lat_interp = cutoff_lat_bin(first_point:last_point);
    
    idx = ~isnan(cutoff_lat_interp);
    x = 1:length(cutoff_lat_interp);
    cutoff_lat_interp = interp1(x(idx),cutoff_lat_interp(idx),x,'makima');
    cutoff_lat_bin(first_point:last_point) = cutoff_lat_interp;
    
    cutoff_lat_binned(i,:) = cutoff_lat_bin; %#ok<SAGROW>
end

delta_cutoff_lat = cutoff_lat_binned - cutoff_lat_binned(end,:);
figure(3)
plot(half_hour_bins,delta_cutoff_lat,'LineWidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
text(datenum(2012,01,23,6,0,0),-1,"From 23/01/2012",'FontSize',15)
datetick('x','dd/mm HH:MM')
title(strcat("Difference in ",lat_name," against time"))
xlabel("Date (UT, dd/mm HH:MM)")
ylabel(delta_lat_label)
legend("Dawn MLT","Dayside MLT","Dusk MLT","Nightside MLT")