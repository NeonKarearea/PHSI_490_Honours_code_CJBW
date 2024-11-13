function [a] = mse(func,X,Y,p)
    y_fit = func(p,X);
    err = Y-y_fit;
    mse = mean(err.^2,'omitnan');
    a = mse;
end