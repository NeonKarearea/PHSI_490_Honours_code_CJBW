%This code gets the cutoff flux and L-shell for the pass starting from 17:55 UT on the 25th of January 2012
clear all %#ok<CLALL>
close all
load('POES data PHSI 490\NOAA19\poes_n19_20120125.mat')

McIlwain = McIlwain_L_value(30281:2:31781);
Flux = Omni_directional_P6(30281:2:31781);

turning_point = find(McIlwain == max(McIlwain));
McIlwain_forward = McIlwain(1:turning_point);
McIlwain_backward = McIlwain(turning_point+1:end);
pf_for = Flux(1:turning_point);
pf_back = Flux(turning_point+1:end);

%Ths finds the averages and then the cutoff flux
[for_flux, for_L] = cutoff_determine(McIlwain_forward,pf_for,0.3,0);
[back_flux, back_L] = cutoff_determine(McIlwain_backward,pf_back,0.3,1);

fforlabel = strcat("Flux cutoff = ",num2str(for_flux));
fbacklabel = strcat("Flux cutoff = ",num2str(back_flux));
lforlabel = strcat("L shell cutoff = ",num2str(for_L));
lbacklabel = strcat("L shell cutoff = ",num2str(back_L));

figure(1);
hold on
plot(McIlwain_forward,pf_for,'b-')
plot(McIlwain_backward,pf_back,'r-')
plot(0:1:40,for_flux*ones(1,41),'b--')
plot(0:1:40,back_flux*ones(1,41),'r--')
plot(for_L*ones(1,401),0:1:400,'b-.')
plot(back_L*ones(1,401),0:1:400,'r-.')
text(10,10,fforlabel,"FontSize",10)
text(10,10,fbacklabel,"FontSize",10)
text(10,10,lforlabel,"FontSize",10)
text(10,10,lbacklabel,"FontSize",10)
set(gca,'FontSize',20,'FontWeight','demi')
title("The polar pass up for the time period 6:55 to 7:20 on the 23^{rd} of January, 2012");
xlabel("L-shell (L)");
ylabel("Proton flux (protons cm^{-2} s^{-1} ster^{-1})");
legend('P6_o_m_n_i entrance','P6_o_m_n_i exit','Cutoff flux entrance','Cutoff flux exit','Cutoff L-shell entrance', 'Cutoff L-shell exit')
hold off

%The P6, P7, and P8 over the pole
fig = figure(2);
hold on
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P6(1:8:end),'r','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P7(1:8:end),'b','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P8(1:8:end),'g','LineWidth',1.25)
scale=axis;
%axis([datenum(2012,1,24,8,25,0) datenum(2012,1,24,8,50,0) 0 scale(4)])
datetick('x',15,'keeplimits')
set(gca,'FontSize',20,'FontWeight','demi')
title("Proton flux for the P6, P7, and P8 omnidirectional telescopes over a polar pass")
xlabel("Time (UTC, January 23^{th}, 2012)")
ylabel("Proton flux (pfu)")
legend('P6_o_m_n_i','P7_o_m_n_i','P8_o_m_n_i')
hold off
