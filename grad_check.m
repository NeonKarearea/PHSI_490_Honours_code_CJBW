function [a,b] = grad_check(del_flux,L_shell,i,operation,num_grad)
    if operation == 1
        for j = 1:num_grad
            grad(j) = (del_flux(i+(operation*j))-del_flux(i))/...
            (L_shell(i+(operation*j))-L_shell(i));
        end
    else
        for j = 1:num_grad
            grad(j) = (del_flux(i)-del_flux(i+(operation*j)))/...
            (L_shell(i)-L_shell(i+(operation*j)));
        end
    end
    
    avg_grad = median(grad,'omitnan');
    avg_std = std(grad,'omitnan');
    a = avg_grad;
    b = avg_std;
end