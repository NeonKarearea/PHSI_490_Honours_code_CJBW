function a = grouper(vec,n)
%This groups a vector based on a given number away from a starting
%point. vec is an arbitrary vector and n the sparation value.
    offset = 0;
    for i = 1:length(vec)
        delta_vec = vec - vec(i+offset)*ones(length(vec),1);
        first_val = find(delta_vec ==0, 1);
        last_val = find(delta_vec <= n, 1, 'last');
        grouped_vec(i) = floor(median(vec(first_val:last_val)));
        offset = last_val-i;
        if isempty(offset)
            offset = n*i;
        end
        if last_val == length(vec)
            break
        end
    end
    
    if ~exist('grouped_vec','var')
        grouped_vec = [];
    end
    
    a = grouped_vec';
end