clear all %#ok<CLALL>
close all
load('POES data PHSI 490\NOAA19\poes_n19_20120124.mat')

%plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),McIlwain_L_value(1:8:end));%Omni_directional_P6(1:8:end),'r','LineWidth',1.25)
scale=axis;
only_McIlwain = McIlwain_L_value(1:8:end);

i = 1;
while true
    McIlwain_forward(i) = only_McIlwain(7236+i); %#ok<SAGROW>
    del_McIlwain = only_McIlwain(7236+i)-only_McIlwain(7236+i-1);
    i = i + 1;
    if only_McIlwain(7236+i) < 1.2 || del_McIlwain <= 0
        break
    end
end

i = 1;
while true
   McIlwain_backward(i) = only_McIlwain(7331+i); %#ok<SAGROW>
   del_McIlwain = only_McIlwain(7331+i+1)-only_McIlwain(7331+i);
   i = i + 1;
   if only_McIlwain(7331+i) < 1.2 || del_McIlwain >= 0
       break
   end
    
end

%Now I am wanting to find the cutoff latitudes for this pass of the P6
%measurement. I am pretty sure the way .json found this is incorrect (i.e. 
%the height) but I will talk to Craig about this.

L = 1/((cosd(70))^2);
pf_for = Omni_directional_P6(57893:8:58197);
pf_back = Omni_directional_P6(58657:8:59601);

%Ths finds the averages and then the cutoff flux
[for_flux, for_L] = cutoff_determine(McIlwain_forward,pf_for,0.3,0);
[back_flux, back_L] = cutoff_determine(McIlwain_backward,pf_back,0.3,1);

invar_lat_for = (acosd(sqrt(1/for_L)));
invar_lat_back = (acosd(sqrt(1/back_L)));

fforlabel = "Cutoff flux = " + for_flux;
fbacklabel = "Cutoff flux = " + back_flux;
lforlabel = "Cutoff L-shell = " + for_L;
lbacklabel = "Cutoff L-shell = " + back_L;

%The cutoff flux w.r.t the L-shell
hold on
plot(McIlwain_forward,pf_for,'b-')
plot(McIlwain_backward,pf_back,'r-')
plot(0:1:20,for_flux*ones(1,21),'b--')
%text(0,double(for_flux),[fforlabel,''])
plot(0:1:20,back_flux*ones(1,21),'r--')
%text(0,double(back_flux),['',fbacklabel])
plot(for_L*ones(1,2001),0:1:2000,'b-.')
%text(double(for_L),1900,lforlabel)
plot(back_L*ones(1,2001),0:1:2000,'r-.')
%text(double(back_L)-2.3,1900,lbacklabel)
set(gca,'FontSize',20,'FontWeight','demi')
title("The polar pass up to L=20 against flux");
xlabel("L-shell (L)");
ylabel("Proton flux (pfu)");
legend('P6_o_m_n_i entrance','P6_o_m_n_i exit','Cutoff flux entrance','Cutoff flux exit','Cutoff L-shell entrance', 'Cutoff L-shell exit')
hold off

%The P6, P7, and P8 over the pole

fig = figure(2);
hold on
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P6(1:8:end),'r','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P7(1:8:end),'b','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P8(1:8:end),'g','LineWidth',1.25)
scale=axis;
axis([datenum(2012,1,24,16,05,0) datenum(2012,1,24,16,25,0) 0 scale(4)])
datetick('x',15,'keeplimits')
set(gca,'FontSize',20,'FontWeight','demi')
title("Proton flux for the P6, P7, and P8 omnidirectional telescopes over a polar pass")
xlabel("Time (UTC, January 23^{th}, 2012)")
ylabel("Proton flux (pfu)")
legend('P6_o_m_n_i','P7_o_m_n_i','P8_o_m_n_i')
hold off
%}

%The log P6, P7, and P8 over the pole

fig = figure(3);
hold on
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P6(1:8:end),'r','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P7(1:8:end),'b','LineWidth',1.25)
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),Omni_directional_P8(1:8:end),'g','LineWidth',1.25)
scale=axis;
axis([datenum(2012,1,24,16,5,0) datenum(2012,1,24,16,25,0) 0 scale(4)])
datetick('x',15,'keeplimits')
set(gca,'FontSize',20,'FontWeight','demi')
title("Log of the proton flux for the P6, P7, and P8 omnidirectional telescopes over a polar pass")
xlabel("Time (UTC, January 23^{th}, 2012)")
ylabel("Proton flux (log(pfu))")
legend('P6_o_m_n_i','P7_o_m_n_i','P8_o_m_n_i')
hold off
%}

%The L-Shell

fig = figure(4);
hold on
plot(datenum(year(1:8:end),1,day_of_year(1:8:end),hour(1:8:end),minute(1:8:end),second(1:8:end)),McIlwain_L_value(1:8:end),'k','LineWidth',1.25)
scale=axis;
axis([datenum(2012,1,24,16,5,0) datenum(2012,1,24,16,25,0) 0 25])
datetick('x',15,'keeplimits')
set(gca,'FontSize',20,'FontWeight','demi')
title("L-shell values over a polar pass")
xlabel("Time (UTC, January 23^{th}, 2012)")
ylabel("L-shell (L)")
hold off
