%This makes the figures found in Figure 5.3. Unfortunately, to get each figure you have to manually load the relevant data file in and then comment out certain parts of like 7 to get what you want.
close all
satlat = sub_satellite_latitude(1:8:end);
satlon = sub_satellite_longitude(1:8:end);
flux_p6 = Omni_directional_P6(1:8:end);
flux_p6((satlat>=-66&satlat<=20&(satlon>=240|satlon<=40))|...
    (satlat>=-71&satlat<=20&satlon>=260)|(satlat>=-20&satlat<=20)|...
    (satlat>=-55&satlat<=-40&(satlon>=40&satlon<=50))|(flux_p6<0)) = NaN;
gb = geobubble(satlat,satlon,flux_p6);
gb.Basemap = "grayland";
