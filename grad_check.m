function [a,b] = grad_check(del_flux,L_shell,i,operation,num_grad)
    if operation == 1
        position = 1;
    else
        position = 0;
    end
    
    for j = 1:num_grad
        grad(j) = (del_flux(i+(operation*j)+position)-del_flux(i+position))/...
            (L_shell(i+(operation*j)+position)-L_shell(i+position));
    end
    
    avg_grad = mean(grad,'omitnan');
    avg_std = std(grad,'omitnan');
    a = avg_grad;
    b = avg_std;
end