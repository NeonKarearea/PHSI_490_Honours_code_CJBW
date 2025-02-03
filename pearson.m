function [a] = pearson(x,y)
    x_resids = x-mean(x,'omitnan');
    y_resids = y-mean(y,'omitnan');
    x_rsm = sqrt(sum(x_resids.^2,'omitnan'));
    y_rsm = sqrt(sum(y_resids.^2,'omitnan'));
    
    pearson = (sum(x_resids.*y_resids,'omitnan'))./(x_rsm.*y_rsm);
    a = pearson;
end