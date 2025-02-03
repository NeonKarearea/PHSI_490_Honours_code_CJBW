function [a] = pearson(x,y)
    x_resids = x(~isnan(x))-mean(x,'omitnan');
    y_resids = y(~isnan(y))-mean(y,'omitnan');
    x_rsm = sqrt(sum(x_resids.^2));
    y_rsm = sqrt(sum(y_resids.^2));
    
    pearson = (sum(x_resids.*y_resids))./(x_rsm.*y_rsm);
    a = pearson;
end