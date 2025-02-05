clear all %#ok<CLALL>
close all

load('MLT_data.mat')

% figure(1)
% hold on
% for i = 0:7
%     if i ~=7
%         scatter(cutoff_datenums20031026(cutoff_MLT20031026==i),cutoff_invariant_lat20031026(cutoff_MLT20031026==i),'Linewidth',1.5)
%     else
%         scatter(cutoff_datenums20031026(cutoff_MLT20031026==i),cutoff_invariant_lat20031026(cutoff_MLT20031026==i),'k','Linewidth',1.5)
%     end
% end
% plot(datenum(2003,10,29,0,377,0).*ones(1,26),45:1:70,'--k','Linewidth',2.0)
% plot(datenum(2003,11,04,0,392,0).*ones(1,26),45:1:70,'--k','Linewidth',2.0)
% grid on
% grid minor
% set(gcf, 'Position', get(0, 'Screensize'));
% set(gca,'FontSize',18,'FontWeight','Demi')
% datetick('x',20,'keepticks')
% title("Cutoff invariant latitude for the time period from 26/10/2003 to 07/11/2003 for various MLTs")
% xlabel("Date (UT)")
% ylabel("Invariant latitude (\lambda)")
% legend("0-3 MLT","3-6 MLT","6-9 MLT","9-12 MLT","12-15 MLT","15-18 MLT","18-21 MLT","21-24 MLT","CME impacts")

figure(2)
cutoff_MLT20120123 = floor(cutoff_MLT20120123./45);
hold on
for i = 0:7
    if i ~=7
        scatter(cutoff_datenums20120123(cutoff_MLT20120123==i),cutoff_invariant_lat20120123(cutoff_MLT20120123==i),'Linewidth',1.5)
    else
        scatter(cutoff_datenums20120123(cutoff_MLT20120123==i),cutoff_invariant_lat20120123(cutoff_MLT20120123==i),'k','Linewidth',1.5)
    end
end
plot(datenum(2012,01,24,0,907,0).*ones(1,16),55:1:70,'--k','Linewidth',2.0)
grid on
grid minor
set(gcf, 'Position', get(0, 'Screensize'));
set(gca,'FontSize',18,'FontWeight','Demi')
datetick('x',20,'keepticks')
title("Cutoff invariant latitude for the time period from 23/01/2012 to 31/01/2012 for various MLTs")
xlabel("Date (UT)")
ylabel("Invariant latitude (\lambda)")
xlim([datenum(2012,01,23,0,0,0),datenum(2012,01,27,0,0,0)])
legend("0-3 MLT","3-6 MLT","6-9 MLT","9-12 MLT","12-15 MLT","15-18 MLT","18-21 MLT","21-24 MLT","CME impacts")

% figure(3)
% hold on
% for i = 0:7
%     if i ~=7
%         scatter(cutoff_datenums20120307(cutoff_MLT20120307==i),cutoff_invariant_lat20120307(cutoff_MLT20120307==i),'Linewidth',1.5)
%     else
%         scatter(cutoff_datenums20120307(cutoff_MLT20120307==i),cutoff_invariant_lat20120307(cutoff_MLT20120307==i),'k','Linewidth',1.5)
%     end
% end
% plot(datenum(2012,03,08,0,667,0).*ones(1,26),50:1:75,'--k','Linewidth',2.0)
% grid on
% grid minor
% set(gcf, 'Position', get(0, 'Screensize'));
% set(gca,'FontSize',18,'FontWeight','Demi')
% datetick('x',20,'keepticks')
% title("Cutoff invariant latitude for the time period from 07/03/2012 to 15/03/2012 for various MLTs")
% xlabel("Date (UT)")
% xlim([datenum(2012,03,07,0,0,0),datenum(2012,03,13,0,0,0)])
% ylabel("Invariant latitiude (\lambda)")
% legend("0-3 MLT","3-6 MLT","6-9 MLT","9-12 MLT","12-15 MLT","15-18 MLT","18-21 MLT","21-24 MLT","CME impacts")