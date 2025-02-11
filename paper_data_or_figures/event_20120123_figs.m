clear all %#ok<CLALL>
close all
load('2012-01-23_event_dataset.mat')

lat_answer = input('Would you like to use invariant latitude (Y) or L-shell (N)? ','s');
if upper(lat_answer) == 'Y'
    cutoff_latitude = cutoff_invariant_lat;
    cutoff_latitude_neal = cutoff_invariant_lat_neal;
    cutoff_latitude_no_noise = cutoff_invariant_lat_no_noise;
    lat_label = "Invariant latitude (\lambda)";
    lat_name = "invariant latitudes";
    lat_lim = [50,80];
elseif upper(lat_answer) == 'N'
    cutoff_latitude = cutoff_L_shells;
    cutoff_latitude_neal = cutoff_L_shells_neal;
    cutoff_latitude_no_noise = cutoff_L_shells_no_noise;
    lat_label = "L-shells (L-value)";
    lat_name = "L-shells";
    lat_lim = [0,10];
else
    error("Please only use Y or N (Note that this is not case sensitive)")
end

figure(1)
plot(L_shells{125},abs(del_flux),'LineWidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','demi')
title("The absolute difference between measured flux and theoretical cutoff flux on 23/01/2012 from 6:46 to 7:11")
xlabel("L-shells (L-value)")
ylabel("|\Delta Proton flux| (protons cm^{-2} s^{-1} sr^{-1})")
legend("|\Delta Proton flux|",'Location','northeastoutside')
annotation('line',[0.460416666666667 0.441666666666667],...
    [0.14802807775378 0.219222462203024],'LineWidth',2);
annotation('line',[0.46484375 0.456770833333333],...
    [0.15936717062635 0.200863930885529],'LineWidth',2);
annotation('line',[0.465104166666667 0.479166666666667],...
    [0.154427645788337 0.225701943844492],'LineWidth',2);
annotation('line',[0.475520833333333 0.466145833333333],...
    [0.157667386609071 0.145788336933045],'LineWidth',2);
annotation('textbox',...
    [0.447916666666666 0.192304534916226 0.0348958340100944 0.0437365018008337],...
    'String',{'G_{-}(1)'},...
    'LineStyle','none',...
    'FontWeight','bold');
annotation('textbox',...
    [0.424479166666665 0.150187904246679 0.0348958340100944 0.0437365018008337],...
    'String',{'G_{-}(2)'},...
    'LineStyle','none',...
    'FontWeight','bold');
annotation('textbox',...
    [0.466927083333332 0.11725053923588 0.0364583340473473 0.0437365018008337],...
    'String',{'G_{+}(1)'},...
    'LineStyle','none',...
    'FontWeight','bold');
annotation('textbox',...
    [0.479427083333332 0.169086392367628 0.0364583340473473 0.0437365018008337],...
    'String',{'G_{+}(2)'},...
    'LineStyle','none',...
    'FontWeight','bold');
xlim([3.5,5.5])

figure(2)
hold on
plot(L_shells{125},fluxes{125},'LineWidth',2.0)
plot(0:1:35,cutoff_fluxes_neal(125).*ones(1,36),'--b','LineWidth',2.0);
plot(cutoff_L_shells_neal(125).*ones(1,801),0:1:800,'--b','LineWidth',2.0);
plot(0:1:35,cutoff_fluxes(125).*ones(1,36),'--k','LineWidth',2.0);
plot(cutoff_L_shells(125).*ones(1,801),0:1:800,'--k','LineWidth',2.0);
text(5,280,strcat('Neal cutoff fluxes = ',num2str(cutoff_fluxes_neal(125))),"FontSize",15)
text(24,400,strcat('Neal cutoff L-shell = ',num2str(cutoff_L_shells_neal(125))),"FontSize",15)
text(5,230,strcat('Cutoff flux = ',num2str(cutoff_fluxes(125))),"FontSize",15)
text(5,400,strcat('Cutoff L-shell = ',num2str(cutoff_L_shells(125))),"FontSize",15)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','demi')
title("Proton flux against L-shell on 23/01/2012 from 6:46 to 7:11")
xlabel("L-shells (L-value)")
ylabel("Proton flux (protons cm^{-2} s^{-1} sr^{-1})")
legend("Proton flux")

figure(3)
hold on
scatter(cutoff_datenums_neal,cutoff_latitude_neal,'LineWidth',1.5)
scatter(cutoff_datenums_no_noise,cutoff_latitude_no_noise,'LineWidth',1.5)
ylabel(lat_label)
ylim(lat_lim)
text(datenum(2012,01,23,06,0,0),51,"From 23/01/2012",'FontSize',15)
yyaxis('right')
plot(cutoff_datenums,original_cutoff_fluxes,'LineWidth',2.0)
xlim([datenum(2012,01,23,0,0,0),datenum(2012,01,27,0,0,0)])
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi','YScale','log')
set(gca,'YColor','k')
datetick('x','dd/mm HH','keepticks')
title(strcat("Cutoff ",lat_name," and fluxes against time"))
xlabel("Date (UT, dd/mm HH)")
ylabel("Proton flux (protons cm^{-2} s^{-1} sr^{-1})")
legend("Neal cutoffs","New cutoffs","Cutoff flux",'Location','northeastoutside')

figure(4)
hold on
scatter(cutoff_datenums(cutoff_MLT<=90 | cutoff_MLT>=270),cutoff_latitude(cutoff_MLT<=90 | cutoff_MLT>=270),'LineWidth',1.5)
scatter(cutoff_datenums(cutoff_MLT>=90 & cutoff_MLT<=270),cutoff_latitude(cutoff_MLT>=90 & cutoff_MLT<=270),'LineWidth',1.5)
ylabel(lat_label)
text(datenum(2012,01,23,06,0,0),57,"From 23/01/2012",'FontSize',15)
yyaxis("right")
plot(cutoff_datenums,cutoff_dst,'-o','LineWidth',2.0)
plot(datenum(2012,01,24,0,907,0).*ones(1,201),-100:100,"k--",'LineWidth',2.0)
ylim([-100,100])
xlim([datenum(2012,01,23,0,0,0),datenum(2012,01,27,0,0,0)])
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
set(gca,'YColor','k')
datetick('x','dd/mm HH','keepticks')
title(strcat("Cutoff ",lat_name," and D_{st} against time"))
xlabel("Date (UT, dd/mm HH)")
ylabel("D_{st} (nT)",'Color',[0 0 0])
legend("Nightside cutoffs","Dayside cutoffs","D_{st}")

figure(5)
hold on
scatter(cutoff_datenums(cutoff_MLT<=90 | cutoff_MLT>=270),cutoff_latitude(cutoff_MLT<=90 | cutoff_MLT>=270),'LineWidth',1.5)
scatter(cutoff_datenums(cutoff_MLT>=90 & cutoff_MLT<=270),cutoff_latitude(cutoff_MLT>=90 & cutoff_MLT<=270),'LineWidth',1.5)
ylabel(lat_label)
text(datenum(2012,01,23,06,0,0),57,"From 23/01/2012",'FontSize',15)
yyaxis("right")
plot(cutoff_datenums,-1.*cutoff_kp,'-o','LineWidth',2.0)
plot(datenum(2012,01,24,0,907,0).*ones(1,13),-6:6,"k--",'LineWidth',2.0)
ylim([-6,6])
xlim([datenum(2012,01,23,0,0,0),datenum(2012,01,27,0,0,0)])
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
set(gca,'YColor','k')
datetick('x','dd/mm HH','keepticks')
title(strcat("Cutoff ",lat_name," and K_{p} against time"))
xlabel("Date (UT, dd/mm HH)")
ylabel("K_{p} (-K value)",'Color',[0 0 0])
legend("Dawn cutoffs","Dusk cutoffs","K_{p}","CME impact")