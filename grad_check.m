function [a,b] = grad_check(del_flux,L_shell,locations,operation,num_grad)
    abs_del_flux = abs(del_flux);
    if num_grad == 0
        a = operation;
        b = operation;
    else
        if operation == 1
            for i = 1:num_grad
                grad(i,:) = (abs_del_flux(locations+(operation*i).*ones(size(locations)))-abs_del_flux(locations))./...
                (L_shell(locations+(operation*i).*ones(size(locations)))-L_shell(locations).*ones(size(locations)));
                flux(i,:) = del_flux(locations+((operation*i).*ones(size(locations))));
            end
        else
            for i = 1:num_grad
                grad(i,:) = (abs_del_flux(locations)-abs_del_flux(locations+(operation*i).*ones(size(i))))./...
                (L_shell(locations)-L_shell(locations+(operation*i).*ones(size(i))));
                flux(i,:) = del_flux(locations+((operation*i).*ones(size(i))));
            end
        end
        a = median(grad,'omitnan');
        b = median(flux,'omitnan'); 
    end
end