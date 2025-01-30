close all

answer = input('Do you want to use all events (Y) or just those before 2007 (N)?: ','s');
if isempty(answer)
    disp("Will take that as a yes.")
    load('empirical_fit_20031026_20170908.mat')
elseif upper(answer) == 'Y'
    load('empirical_fit_20031026_20170908.mat')
elseif upper(answer) == 'N'
    load('empirical_fit_20031026_20061206.mat')
else
    disp("That's not a valid answer. The program will now break (apparently I can't just stop the code without terminating the whole MATLAB session, which is the dumbest thing since using index-1 counting like a normal language).")
end

dst_attempt = @(p,xm)exp(p(1).*xm(1,:)+p(2))+p(3).*xm(2,:);%xm(2,:)+p(4);

dst_gen_p6 = nlinfit([cutoff_dst_p6;cutoff_delta_dst_p6],cutoff_invariant_lat_p6,dst_attempt,[0,0,0]);
dst_night_p6 = nlinfit([cutoff_dst_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270);cutoff_delta_dst_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270)],cutoff_invariant_lat_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),dst_attempt,[0,0,0]);
dst_day_p6 = nlinfit([cutoff_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270);cutoff_delta_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270)],cutoff_invariant_lat_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),dst_attempt,[0,0,0]);
kp_gen_p6 = nlinfit(cutoff_kp_p6,cutoff_invariant_lat_p6,quadratic,[0,0,0]);
kp_night_p6 = nlinfit(cutoff_kp_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_invariant_lat_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),quadratic,[0,0,0]);
kp_day_p6 = nlinfit(cutoff_kp_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_invariant_lat_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),quadratic,[0,0,0]);

combined_equa = @(p,xn) (p(1).*quadratic(kp_gen_p6,xn(1,:))+p(2).*exponential(dst_gen_p6,xn(2,:)));
combined = @(p,xm)(p(1).*xm(1,:).^2)+(p(2).*xm(1,:))+sin(((xm(3,:)./24).*pi)+p(3)).*exp(p(4).*xm(2,:)+p(5))+p(6);

combined_form_params = nlinfit([cutoff_kp_p6;cutoff_dst_p6;cutoff_MLT_p6./15],cutoff_invariant_lat_p6,combined,[0,0,0,0,0,0]);
combined_equa_params = nlinfit([cutoff_kp_p6;cutoff_dst_p6],cutoff_invariant_lat_p6,combined_equa,[0,0]);
dst_range = -400:1:50;
kp_range = linspace(0,9,451);

kp_interp = NaN.*ones(size(dst_20120123_event));
for i = 1:length(kp_20120123_event)
    kp_interp(3*(i-1)+1) = kp_20120123_event(i);
end

x = 1:length(kp_interp);
idx = ~isnan(kp_interp);
kp_interp = (interp1(x(idx),kp_interp(idx),x,'spline')');

figure(1)
hold on
scatter(cutoff_dst_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_invariant_lat_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),'LineWidth',2.0)
scatter(cutoff_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_invariant_lat_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),'LineWidth',2.0)
plot(dst_range,exponential(dst_gen_p6,dst_range),'LineWidth',2.0)
plot(dst_range,exponential(dst_day_p6,dst_range),'LineWidth',2.0)
plot(dst_range,exponential(dst_night_p6,dst_range),'LineWidth',2.0)
plot(dst_range,((0.031679.*dst_range)+62.5344),'k','LineWidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
title("D_{st} against Cutoff invariant latitude for all events")
xlabel("D_{st} (nT)")
ylabel("Invariant latitude (\lambda)")
legend("Nightside cutoff latitudes","Dayside cutoff latitude","General fit","Dayside fit","Nightside fit","Neal D_{st} fit","Location","northwest")


figure(2)
hold on
scatter(cutoff_kp_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_invariant_lat_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),'LineWidth',2.0)
scatter(cutoff_kp_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_invariant_lat_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),'LineWidth',2.0)
plot(kp_range,quadratic(kp_gen_p6,kp_range),'LineWidth',2.0)
plot(kp_range,quadratic(kp_day_p6,kp_range),'LineWidth',2.0)
plot(kp_range,quadratic(kp_night_p6,kp_range),'LineWidth',2.0)
plot(kp_range,((-0.057912.*((kp_range).^2))-0.38237.*kp_range+63.1626),'k','LineWidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
title("K_{p} against Cutoff invariant latitude for all events")
xlabel("K_{p} (nT)")
ylabel("Invariant latitude (\lambda)")
legend("Nightside cutoff latitudes","Dayside cutoff latitudes","General fit","Dayside fit","Nightside fit","Neal K_{p} fit","Location","northwest")

figure(3)
hold on
scatter(cutoff_datenums(cutoff_MLT<=90 | cutoff_MLT>=270),cutoff_invariant_lat(cutoff_MLT<=90 | cutoff_MLT>=270),'LineWidth',2.0)
scatter(cutoff_datenums(cutoff_MLT>=90 & cutoff_MLT<=270),cutoff_invariant_lat(cutoff_MLT>=90 & cutoff_MLT<=270),'LineWidth',2.0)
plot(dst_time_range,1.01.*exponential(dst_day_p6,dst_20120123_event),'LineWidth',2.0)
plot(dst_time_range,1.01.*exponential(dst_gen_p6,dst_20120123_event),'LineWidth',2.0)
plot(dst_time_range,1.01.*exponential(dst_night_p6,dst_20120123_event),'LineWidth',2.0)
plot(dst_time_range,((0.031679.*dst_20120123_event)+62.5344),'k','LineWidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
datetick('x',20,'keepticks')
xlim([datenum(2012,01,23),datenum(2012,01,27)])
title("Cutoff invariant latitudes for the event from 23/10/2012 to 31/01/2012")
xlabel("Date (UT)")
ylabel("Invariant latitude (\lambda)")
legend("Empirically derived nightside cutoff latitudes","Empirically derived dayside cutoff latitudes","Dayside D_{st} fit","General D_{st} fit","Nightside D_{st} fit","Neal D_{st} fit")

figure(4)
hold on
scatter(cutoff_datenums,cutoff_invariant_lat,'LineWidth',2.0)
plot(dst_time_range,1.01.*combined(combined_form_params,[kp_interp';dst_20120123_event';zeros(size(dst_20120123_event))']),'LineWidth',2.0)
plot(dst_time_range,1.01.*combined(combined_form_params,[kp_interp';dst_20120123_event';6.*ones(size(dst_20120123_event))']),'LineWidth',2.0)
plot(dst_time_range,1.01.*combined(combined_form_params,[kp_interp';dst_20120123_event';12.*ones(size(dst_20120123_event))']),'LineWidth',2.0)
plot(dst_time_range,1.01.*combined(combined_form_params,[kp_interp';dst_20120123_event';18.*ones(size(dst_20120123_event))']),'LineWidth',2.0)
plot(dst_time_range,((0.031679.*dst_20120123_event)+62.5344),'k','LineWidth',2.0)
plot(datenum(2012,01,24,0,907,0).*ones(1,15),56:70,"k--",'LineWidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
datetick('x',20,'keepticks')
%xlim([datenum(2012,01,23),datenum(2012,01,27)])
title("Cutoff invariant latitudes for the event from 23/10/2012 to 31/01/2012")
xlabel("Date (UT)")
ylabel("Invariant latitude (\lambda)")
legend("Epmirically derived cutoff latitudes","Combined model midnight (MLT = 0)","Combined model dawn (MLT = 6)","Combined model midday (MLT = 12)","Combined model dusk (MLT = 18)","Neal D_{st} fit","CME impact")

figure(5)
hold on
scatter(cutoff_datenums,cutoff_invariant_lat,'LineWidth',2.0)
plot(kp_time_range,quadratic(kp_day_p6,kp_20120123_event),'LineWidth',2.0)
plot(kp_time_range,quadratic(kp_gen_p6,kp_20120123_event),'LineWidth',2.0)
plot(kp_time_range,quadratic(kp_night_p6,kp_20120123_event),'LineWidth',2.0)
plot(kp_time_range,((-0.057912.*((kp_20120123_event).^2))-0.38237.*kp_20120123_event+63.1626),'k','LineWidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
datetick('x',20,'keepticks')
title("Cutoff invariant latitudes for the event from 23/10/2012 to 31/01/2012")
xlabel("Date (UT)")
ylabel("Invariant latitude (\lambda)")
legend("Empirically derived cutoff latitudes","Dayside K_{p} fit","General K_{p}fit","Nightside K_{p} fit","Neal K_{p} fit")

figure(6)
hold on
grid on
grid minor
scatter3(cutoff_dst_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_kp_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),cutoff_invariant_lat_p6(cutoff_MLT_p6<90|cutoff_MLT_p6>=270),'LineWidth',2.0)
scatter3(cutoff_dst_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_kp_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),cutoff_invariant_lat_p6(cutoff_MLT_p6>=90&cutoff_MLT_p6<270),'LineWidth',2.0)
xlabel("D_{st} (nT)")
ylabel("K_{p} (K-value)")
zlabel("Invariant latitude (\lambda)")
title("Cutoff D_{st} and Cutoff K_{p} against Cutoff invariant latitudes")
legend("Nightside cutoffs","Dayside cutoffs")
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')