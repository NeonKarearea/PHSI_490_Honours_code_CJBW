function [a] = symh_interpolate(start_datenum,end_datenum,data)
    seconds_offset = int64((start_datenum - floor(start_datenum))/datenum(00,00,00,00,00,01));
    symhdata = csvread(strcat("sym-h_",data),1,6);
    datenums = (start_datenum:datenum(00,00,00,00,00,01):end_datenum)';
    symh_proto = NaN*ones(size(datenums));
    
    displace = 0;
    for i = 1:length(symhdata)
        symh_proto((60*(i-1))+1-(displace*seconds_offset)) = symhdata(i);
        displace = 1;
    end
    
    x = 1:length(datenums);
    idx = ~isnan(symh_proto);
    sym_interp = (interp1(x(idx),symh_proto(idx),x,'spline')');
    
    a = sym_interp;
end