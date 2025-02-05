function [a] = adjusted_r_square_finder(func,x,y,p)
    dof_res = length(y)-length(x(:,1))-1;
    dof_tot = length(y)-1;
    R_square = r_square_finder(func,x,y,p);

    a = 1-((1-R_square)*(dof_tot/dof_res));
end