close all
load coastlines
satlat = sub_satellite_latitude(1:8:end);
satlon = sub_satellite_longitude(1:8:end);
flux_p6 = Omni_directional_P6(1:8:end);
flux_p6((satlat>=-90&satlat<=15)|(satlat>=-20&satlat<=20)|(flux_p6<0)) = NaN;
gb = geobubble(satlat,satlon,log10(flux_p6));
gb.Basemap = "grayland";


