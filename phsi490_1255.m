load('POES data PHSI 490\NOAA19\poes_n19_20120123.mat')

%plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),McIlwain_L_value(1:8:end));%Omni_directional_P6(1:8:end),'r','LineWidth',1.25)
McIlwain = McIlwain_L_value(46181:2:47681);
Flux = Omni_directional_P6(46181:2:47681);

turning_point = find(McIlwain == max(McIlwain));
McIlwain_forward = McIlwain(1:turning_point);
McIlwain_backward = McIlwain(turning_point+1:end);
pf_for = Flux(1:turning_point);
pf_back = Flux(turning_point+1:end);

%Ths finds the averages and then the cutoff flux
[for_flux_better_jason, for_L_better_jason] = cutoff_determine_jason(McIlwain_forward,pf_for,0.2,0);
[back_flux_better_jason, back_L_better_jason] = cutoff_determine_jason(McIlwain_backward,pf_back,0.2,1);

fforlabel = strcat("Flux cutoff = ",num2str(for_flux_better_jason));
fbacklabel = strcat("Flux cutoff = ",num2str(back_flux_better_jason));
lforlabel = strcat("L shell cutoff = ",num2str(for_L_better_jason));
lbacklabel = strcat("L shell cutoff = ",num2str(back_L_better_jason));

figure(1);
hold on
plot(McIlwain_forward,pf_for,'b-')
plot(McIlwain_backward,pf_back,'r-')
plot(0:1:40,for_flux_better_jason*ones(1,41),'b--')
plot(0:1:40,back_flux_better_jason*ones(1,41),'r--')
plot(for_L_better_jason*ones(1,2501),0:1:2500,'b-.')
plot(back_L_better_jason*ones(1,2501),0:1:2500,'r-.')
text(10,10,fforlabel,"FontSize",10)
text(10,10,fbacklabel,"FontSize",10)
text(10,10,lforlabel,"FontSize",10)
text(10,10,lbacklabel,"FontSize",10)
set(gca,'FontSize',20,'FontWeight','demi')
title("The polar pass up for the time period 12:50 to 13:15 on the 23^{rd} of January, 2012");
xlabel("L-shell (L)");
ylabel("Proton flux (protons cm^{-2} s^{-1} ster^{-1})");
legend('P6_o_m_n_i entrance','P6_o_m_n_i exit','Cutoff flux entrance','Cutoff flux exit','Cutoff L-shell entrance', 'Cutoff L-shell exit')
hold off

%The P6, P7, and P8 over the pole
figure(2);
hold on
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P6(1:8:end),'r','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P7(1:8:end),'b','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P8(1:8:end),'g','LineWidth',1.25)
scale=axis;
axis([datenum(2012,1,23,12,50,0) datenum(2012,1,23,13,15,0) 0 scale(4)])
datetick('x',15,'keeplimits')
set(gca,'FontSize',20,'FontWeight','demi')
title("Proton flux for the P6, P7, and P8 omnidirectional telescopes over a polar pass")
xlabel("Time (UTC, January 23^{th}, 2012)")
ylabel("Proton flux (protons cm^{-2} s^{-1} ster^{-1})")
legend('P6_o_m_n_i','P7_o_m_n_i','P8_o_m_n_i')
hold off