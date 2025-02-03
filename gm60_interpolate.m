function [a,b] = gm60_interpolate(start_datenum,end_datenum,data)
    seconds_offset = int64((start_datenum - floor(start_datenum))/datenum(00,00,00,00,00,01));
    symhdata = csvread(strcat("sym-h_",data),1,6);
    aedata = csvread(strcat("ae_",data),1,3);
    aedata = aedata(:,1);
    datenums = (start_datenum:datenum(00,00,00,00,00,01):end_datenum)';
    symh_proto = NaN.*ones(size(datenums));
    ae_proto = NaN.*ones(size(datenums));
    
    displace = 0;
    for i = 1:length(symhdata)
        symh_proto((60*(i-1))+1-(displace*seconds_offset)) = symhdata(i);
        ae_proto((60*(i-1))+1-(displace*seconds_offset)) = aedata(i);
        displace = 1;
    end
    
    x = 1:length(datenums);
    idx = ~isnan(symh_proto);
    idy = ~isnan(ae_proto);
    sym_interp = (interp1(x(idx),symh_proto(idx),x,'spline')');
    ae_interp = (interp1(x(idy),ae_proto(idx),x,'spline')');
    
    a = sym_interp;
    b = ae_interp;
end