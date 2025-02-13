clear all %#ok<CLALL>
close all

%This makes the first two figures.

load('poes_n19_20120123.mat')
%FIGURE 1
figure(1)
hold on
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P6(1:8:end),'r','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P7(1:8:end),'b','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P8(1:8:end),'g','LineWidth',1.25)
xlim([datenum(2012,01,23,00,00,00),datenum(2012,01,23,24,00,00)])
datetick('x',15,'keeplimits')
annotation('textarrow',[0.458854166666667 0.303125],...
    [0.724242424242425 0.615151515151516],'String',{'SAMA peaks'},...
    'FontWeight','bold',...
    'FontSize',15);
annotation('arrow',[0.54375 0.690625],...
    [0.722222222222222 0.662626262626263]);
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','demi')
title("Measured proton flux from NOAA 19")
xlabel("Time on 23/01/2012 (UT)")
ylabel("Proton flux (protons cm^{-2} s^{-1} sr^{-1})")
legend("Omnidirection P6 detector","Omnidirectional P7 detector","Omnidirectional P8 detector")

%FIGURE 2
figure(2)
hold on
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P6(1:8:end),'r','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P7(1:8:end),'b','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P8(1:8:end),'g','LineWidth',1.25)
xlim([datenum(2012,01,23,17,00,00),datenum(2012,01,23,17,50,00)])
datetick('x',15,'keeplimits')
annotation('textbox',...
    [0.284895833333333 0.555565655795011 0.0963541688087086 0.0449494957201408],...
    'String',{'Actual event'},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',15);
annotation('textbox',...
    [0.656510416666666 0.552030302259658 0.0838541685106854 0.0449494957201408],...
    'String',{'The SAMA'},...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',15);
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','demi','YScale','log')
title("Measured log_{10} proton flux from NOAA 19")
xlabel("Time on 23/02/2012 (UT)")
ylabel("log_{10} Proton flux (protons cm^{-2} s^{-1} sr^{-1})")
legend("P6_{Omni}","P7_{Omni}","P8_{Omni}")