function [a,b] = gm_interpolate(start_datenum,end_datenum,data)
    seconds_offset = int64((start_datenum - floor(start_datenum))/datenum(00,00,00,00,00,01));
    dstdata = csvread(strcat("Data_for_interpolation\dst_",data),9,2);
    kpdata = csvread(strcat("Data_for_interpolation\kp_",data),9,2)./10;
    datenums = (start_datenum:datenum(00,00,00,00,00,01):end_datenum)';
    dst_proto = NaN*ones(size(datenums));
    kp_proto = NaN*ones(size(datenums));
    
    displace = 0;
    for i = 1:length(dstdata)
        dst_proto((3600*(i-1))+1-(displace*seconds_offset)) = dstdata(i);
        displace = 1;
    end
    
    for j = 1:length(kpdata)
        kp_proto((10800*(j-1))+1-(displace*seconds_offset)) = kpdata(j,1);
        displace = 1;
    end
    x = 1:length(datenums);
    idx = ~isnan(dst_proto);
    idy = ~isnan(kp_proto);
    dst_interp = (interp1(x(idx),dst_proto(idx),x,'spline')');
    kp_interp = (interp1(x(idy),kp_proto(idy),x,'spline')');
    kp_interp(kp_interp >= 9.00) = 9.00;
    kp_interp(kp_interp <= 0.00) = 0.00;
    
    a = dst_interp;
    b = kp_interp;
end