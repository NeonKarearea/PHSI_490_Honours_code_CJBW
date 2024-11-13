close all
satlat = sub_satellite_latitude(1:8:end);
satlon = sub_satellite_longitude(1:8:end);
flux_p6 = Omni_directional_P6(1:8:end);
flux_p6((satlat>=-60&satlat<=20&(satlon>=240|satlon<=40))) = NaN;%|...
    %(satlat>=-65&satlat<=20&satlon>=260)|(satlat>=-20&satlat<=20)) = NaN;
gb = geobubble(satlat,satlon,flux_p6);
gb.Basemap = "grayland";
title("Measured flux from NOAA 15 on 06/11/2003 with the SAMA removed");
gb.SizeLegendTitle = "Flux";
gb.FontSize = 16;
geolimits([-90,90],[270,90])