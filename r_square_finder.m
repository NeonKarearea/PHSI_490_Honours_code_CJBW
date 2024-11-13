function [a] = r_square_finder(func,x,y,p)
    y_fit = func(p,x);
    resids = y-y_fit;
    SSresid = sum(resids.^2,'omitnan');
    SStot = (length(y)-1)*var(y,'omitnan');
    
    a = 1-(SSresid/SStot);
end