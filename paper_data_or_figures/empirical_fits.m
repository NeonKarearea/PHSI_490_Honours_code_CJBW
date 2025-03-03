clear all %#ok<CLALL>
close all
%This file makes figures that involve the fitting. Once run, the
%coefficients can be found in the workspace with format indice_regime_p6,
%where regime is gen (general), night, and day. The first part of the code
%requires a date string input (format: yyyymmdd) for the first day of the
%test event.

[datestr,year,month,day] = data_obtainer;
load(strcat("empirical_fit_training_data_and_",datestr,"_event.mat"))

%Just a quick note about the data that needs to be used: To make sure that
%the Kp doesn't blow up when interpolating, the previous Kp value needs to
%be put in as well. The code will take care of the rest. You also need to
%manually add in the delta Dst from the previous datapoint.

lat_answer = input('Do you want to use invariant latitude (Y) or L-shell (N)? ','s');
if isempty(lat_answer)
    disp("Will take that as a yes.")
    cutoff_latitude_p6 = cutoff_invariant_lat_p6;
    cutoff_latitude = cutoff_invariant_lat;
    lat_type = "invariant latitudes";
    lat_label = "Invariant latitude (\lambda)";
elseif upper(lat_answer) == 'Y'
    cutoff_latitude_p6 = cutoff_invariant_lat_p6;
    cutoff_latitude = cutoff_invariant_lat;
    lat_type = "invariant latitudes";
    lat_label = "Invariant latitude (\lambda)";
elseif upper(lat_answer) == 'N'
    cutoff_latitude_p6 = cutoff_L_shells_p6;
    cutoff_latitude = cutoff_L_shells;
    lat_type = "L-shells";
    lat_label = "L-shell (L-value)";
else
    disp("That's not a valid answer. The program will now break (apparently I can't just stop the code without terminating the whole MATLAB session, which is the dumbest thing since using index-1 counting unlike a normal language).")
end

%These are the 'normal' equations.
exponential = @(p,x)exp(p(1).*x+p(2))+p(3);
quadratic = @(p,x)(p(1).*(x.^2))+(p(2).*x)+p(3);
dst_temporal = @(p,xm)exp(p(1).*xm(1,:)+p(2))+p(3).*xm(2,:)+p(4);
opts = statset('MaxIter',1e5);

%This is for the 'normal' fits. To find R^2 use r_square_finder.m
ae_gen_p6 = nlinfit(cutoff_ae_p6,cutoff_latitude_p6,quadratic,[0,0,0]);
ae_night_p6 = nlinfit(cutoff_ae_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_latitude_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),quadratic,[0,0,0]);
ae_day_p6 = nlinfit(cutoff_ae_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_latitude_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),quadratic,[0,0,0]);

dst_gen_p6 = nlinfit(cutoff_dst_p6,cutoff_latitude_p6,exponential,[0,0,0]);
dst_night_p6 = nlinfit(cutoff_dst_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_latitude_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),exponential,[0,0,0]);
dst_day_p6 = nlinfit(cutoff_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_latitude_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),exponential,[0,0,0]);

dst_temporal_gen_p6 = nlinfit([cutoff_dst_p6;cutoff_delta_dst_p6],cutoff_latitude_p6,dst_temporal,[0,0,0,0]);
dst_temporal_night_p6 = nlinfit([cutoff_dst_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270);cutoff_delta_dst_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270)],cutoff_latitude_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),dst_temporal,[0,0,0,0]);
dst_temporal_day_p6 = nlinfit([cutoff_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270);cutoff_delta_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270)],cutoff_latitude_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),dst_temporal,[0,0,0,0]);

kp_gen_p6 = nlinfit(cutoff_kp_p6,cutoff_latitude_p6,quadratic,[0,0,0]);
kp_night_p6 = nlinfit(cutoff_kp_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_latitude_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),quadratic,[0,0,0]);
kp_day_p6 = nlinfit(cutoff_kp_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_latitude_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),quadratic,[0,0,0]);

%These 
%symh_gen_p6 = nlinfit(cutoff_symh_p6,cutoff_latitude_p6,quadratic,[0,0,0],'Options',opts);
%symh_night_p6 = nlinfit(cutoff_symh_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_latitude_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),quadratic,[0,0,0],'Options',opts);
%symh_day_p6 = nlinfit(cutoff_symh_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_latitude_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),quadratic,[0,0,0],'Options',opts);

%These are the equations that use multiple variables.
combined_gen_equa = @(p,xn) (p(1).*quadratic(kp_gen_p6,xn(1,:))+p(2).*dst_temporal(dst_temporal_gen_p6,xn(2:3,:)));
combined_night_equa = @(p,xn) (p(1).*quadratic(kp_night_p6,xn(1,:))+p(2).*dst_temporal(dst_temporal_night_p6,xn(2:3,:)));
combined_day_equa = @(p,xn) (p(1).*quadratic(kp_day_p6,xn(1,:))+p(2).*dst_temporal(dst_temporal_day_p6,xn(2:3,:)));
combined = @(p,xm)(p(1).*xm(1,:).^2)+(p(2).*xm(1,:))+(p(3).*xm(2,:).^2)+p(4).*xm(2,:)+p(5).*xm(3,:)+p(6);

%These are the fits. To find R^2 for these ones, use
%adjusted_r_square_finder.
combined_form_gen_p6 = nlinfit([cutoff_kp_p6;cutoff_dst_p6;cutoff_delta_dst_p6],cutoff_latitude_p6,combined,[0,0,0,0,0,0],'Options',opts);
combined_form_night_p6 = nlinfit([cutoff_kp_p6(cutoff_MLT_p6<=90|cutoff_MLT_p6>=270);cutoff_dst_p6(cutoff_MLT_p6<=90|cutoff_MLT_p6>=270);cutoff_delta_dst_p6(cutoff_MLT_p6<=90|cutoff_MLT_p6>=270)],cutoff_latitude_p6(cutoff_MLT_p6<=90|cutoff_MLT_p6>=270),combined,[0,0,0,0,0,0],'Options',opts);
combined_form_day_p6 = nlinfit([cutoff_kp_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<=270);cutoff_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<=270);cutoff_delta_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<=270)],cutoff_latitude_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<=270),combined,[0,0,0,0,0,0],'Options',opts);

combined_equa_gen_p6 = nlinfit([cutoff_kp_p6;cutoff_dst_p6;cutoff_delta_dst_p6],cutoff_latitude_p6,combined_gen_equa,[0,0],'Options',opts);
combined_equa_night_p6 = nlinfit([cutoff_kp_p6(cutoff_MLT_p6<=90|cutoff_MLT_p6>=270);cutoff_dst_p6(cutoff_MLT_p6<=90|cutoff_MLT_p6>=270);cutoff_delta_dst_p6(cutoff_MLT_p6<=90|cutoff_MLT_p6>=270)],cutoff_latitude_p6(cutoff_MLT_p6<=90|cutoff_MLT_p6>=270),combined_night_equa,[0,0],'Options',opts);
combined_equa_day_p6 = nlinfit([cutoff_kp_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<=270);cutoff_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<=270);cutoff_delta_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<=270)],cutoff_latitude_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<=270),combined_day_equa,[0,0],'Options',opts);

%This does the Kp interpolation so we can plot the functions that use Kp,
%Dst, and Delta Dst.
dst_range = -400:1:50;
ae_range = linspace(0,3500,451);
kp_range = linspace(0,9,451);

kp_interp = NaN.*ones(1,(length(dst_20120123_event)+3));
for i = 1:length(kp_20120123_event)
    kp_interp(3*(i-1)+1) = kp_20120123_event(i);
end

x = 1:length(kp_interp);
idx = ~isnan(kp_interp);
kp_interp = (interp1(x(idx),kp_interp(idx),x,'spline'));

%These makre the figures.

%FIGURE 1
figure(1)
hold on
scatter(cutoff_dst_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_latitude_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),'LineWidth',2.0)
scatter(cutoff_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_latitude_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),'LineWidth',2.0)
plot(dst_range,exponential(dst_gen_p6,dst_range),'LineWidth',2.0)
plot(dst_range,exponential(dst_day_p6,dst_range),'LineWidth',2.0)
plot(dst_range,exponential(dst_night_p6,dst_range),'LineWidth',2.0)
if upper(lat_answer) == 'Y'
    plot(dst_range,((0.031679.*dst_range)+62.5344),'k','LineWidth',2.0)
else
    plot(dst_range,r./((cosd((0.031679.*dst_range)+62.5344)).^2),'k','LineWidth',2.0)
end
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'))
set(gca,'FontSize',18,'FontWeight','Demi')
title(strcat("D_{st} against cutoff ",lat_type," for the training data"))
xlabel("D_{st} (nT)")
ylabel(lat_label)
legend("Nightside cutoff latitudes","Dayside cutoff latitude","General fit","Dayside fit","Nightside fit","Location","northwest")

%FIGURE 2
figure(2)
hold on
scatter(cutoff_kp_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_latitude_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),'LineWidth',2.0)
scatter(cutoff_kp_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_latitude_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),'LineWidth',2.0)
plot(kp_range,quadratic(kp_gen_p6,kp_range),'LineWidth',2.0)
plot(kp_range,quadratic(kp_day_p6,kp_range),'LineWidth',2.0)
plot(kp_range,quadratic(kp_night_p6,kp_range),'LineWidth',2.0)
if upper(lat_answer) == 'Y'
    plot(kp_range,((-0.057912.*((kp_range).^2))-0.38237.*kp_range+63.1626),'k','LineWidth',2.0)
else
    plot(kp_range,(r./((cosd((-0.057912.*((kp_range).^2))-0.38237.*kp_range+63.1626)).^2)),'k','LineWidth',2.0)
end
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'))
set(gca,'FontSize',18,'FontWeight','Demi')
title(strcat("K_{p} against cutoff ",lat_type," for the training data"))
xlabel("K_{p} (nT)")
ylabel(lat_label)
legend("Nightside cutoff latitudes","Dayside cutoff latitudes","General fit","Dayside fit","Nightside fit","Neal K_{p} fit","Location","northwest")

%FIGURE 3
figure(3)
hold on
scatter(cutoff_datenums(cutoff_MLT<=90 | cutoff_MLT>=270),cutoff_latitude(cutoff_MLT<=90 | cutoff_MLT>=270),'LineWidth',2.0)
scatter(cutoff_datenums(cutoff_MLT>=90 & cutoff_MLT<=270),cutoff_latitude(cutoff_MLT>=90 & cutoff_MLT<=270),'LineWidth',2.0)
plot(dst_time_range,exponential(dst_day_p6,dst_20120123_event),'LineWidth',2.0)
plot(dst_time_range,exponential(dst_gen_p6,dst_20120123_event),'LineWidth',2.0)
plot(dst_time_range,exponential(dst_night_p6,dst_20120123_event),'LineWidth',2.0)
if upper(lat_answer) == 'Y'
    plot(dst_time_range,((0.031679.*dst_20120123_event)+62.5344),'k','LineWidth',2.0)
else
    plot(dst_time_range,(r./((cosd((0.031679.*dst_20120123_event)+62.5344)).^2)),'k','LineWidth',2.0)
end
x_ticks = get(gca,'XTick');
y_ticks = get(gca,'YTick');
plot(datenum(2012,01,24,0,907,0).*ones(1,length(y_ticks)),y_ticks,"k--",'LineWidth',2.0)
text(mean(x_ticks(1:2)),mean(y_ticks(1:2)),strcat("From ",day,"/",month,"/",year),'FontSize',15)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'))
set(gca,'FontSize',18,'FontWeight','Demi')
datetick('x','dd/mm HH:MM','keepticks')
xlim([datenum(2012,01,23),datenum(2012,01,27)])
title(strcat("Cutoff ",lat_type," for the D_{st} fits"))
xlabel("Date (UT, dd/mm HH:MM)")
ylabel(lat_label)
legend("Empirically derived nightside cutoff latitudes","Empirically derived dayside cutoff latitudes","Dayside D_{st} fit","General D_{st} fit","Nightside D_{st} fit","Neal D_{st} fit")

%FIGURE 4
figure(4)
hold on
scatter(cutoff_datenums(cutoff_MLT<=90 | cutoff_MLT>=270),cutoff_latitude(cutoff_MLT<=90 | cutoff_MLT>=270),'LineWidth',2.0)
scatter(cutoff_datenums(cutoff_MLT>=90 & cutoff_MLT<=270),cutoff_latitude(cutoff_MLT>=90 & cutoff_MLT<=270),'LineWidth',2.0)
plot(kp_time_range,quadratic(kp_day_p6,kp_20120123_event(2:end)),'LineWidth',2.0)
plot(kp_time_range,quadratic(kp_gen_p6,kp_20120123_event(2:end)),'LineWidth',2.0)
plot(kp_time_range,quadratic(kp_night_p6,kp_20120123_event(2:end)),'LineWidth',2.0)
if upper(lat_answer) == 'Y'
    plot(kp_time_range,((-0.057912.*((kp_20120123_event(2:end)).^2))-0.38237.*kp_20120123_event(2:end)+63.1626),'k','LineWidth',2.0)
else
    plot(kp_time_range,(r./((cosd((-0.057912.*((kp_20120123_event(2:end)).^2))-0.38237.*kp_20120123_event(2:end)+63.1626)).^2)),'k','LineWidth',2.0)
end
x_ticks = get(gca,'XTick');
y_ticks = get(gca,'YTick');
plot(datenum(2012,01,24,0,907,0).*ones(1,length(y_ticks)),y_ticks,"k--",'LineWidth',2.0)
text(mean(x_ticks(1:2)),mean(y_ticks(1:2)),strcat("From ",day,"/",month,"/",year),'FontSize',15)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'))
set(gca,'FontSize',18,'FontWeight','Demi')
datetick('x','dd/mm HH:MM','keepticks')
xlim([datenum(2012,01,23),datenum(2012,01,27)])
title(strcat("Cutoff ",lat_type," for the K_{p} fits"))
xlabel("Date (UT, dd/mm HH:MM)")
ylabel(lat_label)
legend("Empirically derived nightside cutoff latitudes","Empirically derived dayside cutoff latitudes","Dayside K_{p} fit","General K_{p} fit","Nightside K_{p} fit","Neal K_{p} fit")

%FIGURE 5
figure(5)
hold on
plot(cutoff_dst((cutoff_MLT<=90|cutoff_MLT>=270)&cutoff_datenums<datenum(2012,01,27)),cutoff_latitude((cutoff_MLT<=90|cutoff_MLT>=270)&cutoff_datenums<datenum(2012,01,27)),'-o','LineWidth',2.0)
plot(cutoff_dst((cutoff_MLT>=90&cutoff_MLT<=270)&cutoff_datenums<datenum(2012,01,27)),cutoff_latitude((cutoff_MLT>=90&cutoff_MLT<=270)&cutoff_datenums<datenum(2012,01,27)),'-o','LineWidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'))
set(gca,'FontSize',18,'FontWeight','Demi')
xlabel("D_{st} (nT)")
ylabel(lat_label)
title(strcat("Cutoff ",lat_type," and D_{st} from 23/01/2012 to 27/01/2012"))
legend("Nightside cutoffs","Dayside cutoffs",'Location','northeastoutside')

%FIGURE 6
figure(6)
hold on
scatter(cutoff_datenums(cutoff_MLT<=90 | cutoff_MLT>=270),cutoff_latitude(cutoff_MLT<=90 | cutoff_MLT>=270),'LineWidth',2.0)
scatter(cutoff_datenums(cutoff_MLT>=90 & cutoff_MLT<=270),cutoff_latitude(cutoff_MLT>=90 & cutoff_MLT<=270),'LineWidth',2.0)
plot(dst_time_range,combined(combined_form_day_p6,[kp_interp(3:end-1);dst_20120123_event;delta_dst_20120123_event]),'LineWidth',2.0)
plot(dst_time_range,combined(combined_form_gen_p6,[kp_interp(3:end-1);dst_20120123_event;delta_dst_20120123_event]),'LineWidth',2.0)
plot(dst_time_range,combined(combined_form_night_p6,[kp_interp(3:end-1);dst_20120123_event;delta_dst_20120123_event]),'LineWidth',2.0)
if upper(lat_answer) == 'Y'
    plot(dst_time_range,((0.031679.*dst_20120123_event)+62.5344),'k','LineWidth',2.0)
else
    plot(dst_time_range,(r./((cosd((0.031679.*dst_20120123_event)+62.5344)).^2)),'k','LineWidth',2.0)
end
x_ticks = get(gca,'XTick');
y_ticks = get(gca,'YTick');
plot(datenum(2012,01,24,0,907,0).*ones(1,length(y_ticks)),y_ticks,"k--",'LineWidth',2.0)
text(mean(x_ticks(1:2)),mean(y_ticks(1:2)),strcat("From ",day,"/",month,"/",year),'FontSize',15)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'))
set(gca,'FontSize',18,'FontWeight','Demi')
datetick('x','dd/mm HH:MM','keepticks')
xlim([datenum(2012,01,23),datenum(2012,01,27)])
title(strcat("Cutoff ",lat_type," for the new equation fits"))
xlabel("Date (UT)")
ylabel(lat_label)
legend("Empirically derived nightside cutoff latitudes","Empirically derived dayside cutoff latitudes","New equation dayside model","New equation general model","New equation nightside mode","Neal D_{st} fit","CME impact")

%FIGURE 7
figure(7)
hold on
scatter(cutoff_datenums(cutoff_MLT<=90 | cutoff_MLT>=270),cutoff_latitude(cutoff_MLT<=90 | cutoff_MLT>=270),'LineWidth',2.0)
scatter(cutoff_datenums(cutoff_MLT>=90 & cutoff_MLT<=270),cutoff_latitude(cutoff_MLT>=90 & cutoff_MLT<=270),'LineWidth',2.0)
plot(dst_time_range,combined_day_equa(combined_equa_day_p6,[kp_interp(3:end-1);dst_20120123_event;delta_dst_20120123_event]),'LineWidth',2.0)
plot(dst_time_range,combined_gen_equa(combined_equa_gen_p6,[kp_interp(3:end-1);dst_20120123_event;delta_dst_20120123_event]),'LineWidth',2.0)
plot(dst_time_range,combined_night_equa(combined_equa_night_p6,[kp_interp(3:end-1);dst_20120123_event;delta_dst_20120123_event]),'LineWidth',2.0)
if upper(lat_answer) == 'Y'
    plot(dst_time_range,((0.031679.*dst_20120123_event)+62.5344),'k','LineWidth',2.0)
else
    plot(dst_time_range,(r./((cosd((0.031679.*dst_20120123_event)+62.5344)).^2)),'k','LineWidth',2.0)
end
x_ticks = get(gca,'XTick');
y_ticks = get(gca,'YTick');
plot(datenum(2012,01,24,0,907,0).*ones(1,length(y_ticks)),y_ticks,"k--",'LineWidth',2.0)
text(mean(x_ticks(1:2)),mean(y_ticks(1:2)),strcat("From ",day,"/",month,"/",year),'FontSize',15)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'))
set(gca,'FontSize',18,'FontWeight','Demi')
datetick('x','dd/mm HH:MM','keepticks')
xlim([datenum(2012,01,23),datenum(2012,01,27)])
title(strcat("Cutoff ",lat_type," for the averaged fits"))
xlabel("Date (UT, dd/mm HH:MM)")
ylabel(lat_label)
legend("Empirically derived nightside cutoff latitudes","Empirically derived dayside cutoff latitudes","Averaged dayside model","Averaged general model","Averaged nightside mode","Neal D_{st} fit","CME impact")

%FIGURE 8
figure(8)
hold on
scatter(cutoff_datenums(cutoff_MLT<=90 | cutoff_MLT>=270),cutoff_latitude(cutoff_MLT<=90 | cutoff_MLT>=270),'LineWidth',2.0)
scatter(cutoff_datenums(cutoff_MLT>=90 & cutoff_MLT<=270),cutoff_latitude(cutoff_MLT>=90 & cutoff_MLT<=270),'LineWidth',2.0)
plot(dst_time_range,dst_temporal(dst_temporal_day_p6,[dst_20120123_event;delta_dst_20120123_event]),'LineWidth',2.0)
plot(dst_time_range,dst_temporal(dst_temporal_gen_p6,[dst_20120123_event;delta_dst_20120123_event]),'LineWidth',2.0)
plot(dst_time_range,dst_temporal(dst_temporal_night_p6,[dst_20120123_event;delta_dst_20120123_event]),'LineWidth',2.0)
if upper(lat_answer) == 'Y'
    plot(dst_time_range,((0.031679.*dst_20120123_event)+62.5344),'k','LineWidth',2.0)
else
    plot(dst_time_range,(r./((cosd((0.031679.*dst_20120123_event)+62.5344)).^2)),'k','LineWidth',2.0)
end
x_ticks = get(gca,'XTick');
y_ticks = get(gca,'YTick');
plot(datenum(2012,01,24,0,907,0).*ones(1,length(y_ticks)),y_ticks,"k--",'LineWidth',2.0)
text(mean(x_ticks(1:2)),mean(y_ticks(1:2)),strcat("From ",day,"/",month,"/",year),'FontSize',15)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'))
set(gca,'FontSize',18,'FontWeight','Demi')
datetick('x','dd/mm HH:MM','keepticks')
xlim([datenum(2012,01,23),datenum(2012,01,27)])
title(strcat("Cutoff ",lat_type," for the D_{st} + Delta D_{st} fits"))
xlabel("Date (UT, dd/mm HH:MM)")
ylabel(lat_label)
legend("Empirically derived nightside cutoff latitudes","Empirically derived dayside cutoff latitudes","Dayside D_{st} fit","General D_{st} fit","Nightside D_{st} fit","Neal D_{st} fit")

%This is a very special figure that does a catter plot of Kp and Dst.
% figure(9)
% hold on
% grid on
% grid minor
% scatter3(cutoff_dst_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_kp_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_latitude_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),'LineWidth',2.0)
% scatter3(cutoff_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_kp_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_latitude_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),'LineWidth',2.0)
% xlabel("D_{st} (nT)")
% ylabel("K_{p} (K-value)")
% zlabel("Invariant latitude (\lambda)")
% title("Cutoff D_{st} and cutoff K_{p} against cutoff invariant latitudes")
% legend("Nightside cutoffs","Dayside cutoffs")
% set(gcf, 'Position', get(0, 'Screensize'))
%set(gca,'FontSize',18,'FontWeight','Demi')

function [a,b,c,d] = data_obtainer
    date = input('What is the event you wish to look at (only first day, format:yyyymmdd)? ','s');
    valid = isfile(strcat("empirical_fit_training_data_and_",date,"_event.mat"));
    switch valid
        case 0
            disp("That's not a valid start day, please enter another date.")
            [a,b,c,d] = data_obtainer;
        case 1
            a = date;
            b = date(1:4);
            c = date(5:6);
            d = date(7:8);
        otherwise
            error("How did you get here Desmond?")
    end
end