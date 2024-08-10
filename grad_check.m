function [a,b] = grad_check(del_flux,L_shell,i,operation,num_grad)
    abs_del_flux = abs(del_flux);
    if operation == 1
        for j = 1:num_grad
            grad(j) = (abs_del_flux(i+(operation*j))-abs_del_flux(i))/...
            (L_shell(i+(operation*j))-L_shell(i));
            flux(j) = del_flux(i+(operation*j));
        end
    else
        for j = 1:num_grad
            grad(j) = (abs_del_flux(i)-abs_del_flux(i+(operation*j)))/...
            (L_shell(i)-L_shell(i+(operation*j)));
            flux(j) = del_flux(i+(operation*j));
        end
    end
    
    a = median(grad,'omitnan');
    b = median(flux,'omitnan');
end