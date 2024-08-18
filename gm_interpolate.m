function [a,b] = gm_interpolate(start_datenum, end_datenum,data)
    seconds_offset = int64((start_datenum - floor(start_datenum))/datenum(00,00,00,00,00,01));
    dstdata = csvread(data,9,2);
    datenums = (start_datenum:datenum(00,00,00,00,00,01):end_datenum)';
    dst_proto = NaN*ones(size(datenums));
    dst_non_interp = NaN*ones(size(datenums));
    
    displace = 0;
    for i = 1:length(dstdata)
        dst_proto((3600*(i-1))+1-(displace*seconds_offset)) = dstdata(i);
        displace = 1;
    end
    x = 1:length(datenums);
    idx = ~isnan(dst_proto);
    dst_interp = (interp1(x(idx),dst_proto(idx),x,'spline')');

    loc = find(~isnan(dst_proto));

    for j = 1:(length(loc)-1)
        dst_non_interp(loc(j):(loc(j+1)-1)) = dst_proto(loc(j));
    end
    dst_non_interp((loc(end)):end) = dst_proto(loc(end));
    
    a = dst_interp;
    b = dst_non_interp;
end