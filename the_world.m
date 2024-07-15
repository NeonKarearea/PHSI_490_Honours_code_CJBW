close all
load coastlines
satlat = sub_satellite_latitude(1:8:end);
satlon = sub_satellite_longitude(1:8:end);
flux_p6 = Omni_directional_P6(1:8:end);
%{
fig = figure(1);
hold on
plot(satlat,flux_p6)
hold off

fig = figure(2);
hold on
plot(satlon,flux_p6)
hold off
%}
%fig = figure(3);
%hold on
%worldmap("World")
%geoshow(log10(flux_p6),R)
%hold off
gb = geobubble(satlat,satlon,log10(flux_p6));
gb.Basemap = "grayland";


