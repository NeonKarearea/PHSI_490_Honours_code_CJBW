for i = 1:length(cutoff_L_shells_all_grads)
    cutoff_L_shells(i,:) = cutoff_L_shells_all_grads{i}{5,6};  %#ok<SAGROW>
    cutoff_datenums(i,:) = cutoff_datenums_all_grads{i}{5,6}; %#ok<SAGROW>
end

for j = 2:(length(cutoff_L_shells(:,1))-1)
    mean_cutoff_L_shells((j-1),:) = mean([cutoff_L_shells(j-1,:);cutoff_L_shells(j,:);cutoff_L_shells(j+1,:)],'omitnan'); %#ok<SAGROW>
    mean_cutoff_datenums((j-1),:) = mean([cutoff_datenums(j-1,:);cutoff_datenums(j,:);cutoff_datenums(j+1,:)],'omitnan'); %#ok<SAGROW>
    std_cutoff_L_shells((j-1),:) = std([cutoff_L_shells(j-1,:);cutoff_L_shells(j,:);cutoff_L_shells(j+1,:)],'omitnan'); %#ok<SAGROW>
    std_cutoff_datenums((j-1),:) = std([cutoff_datenums(j-1,:);cutoff_datenums(j,:);cutoff_datenums(j+1,:)],'omitnan'); %#ok<SAGROW> 
end

for k = 1:(length(cutoff_L_shells(:,1))-1)
    mean_cutoff_L_shells_duo(k,:) = mean([cutoff_L_shells(k,:);cutoff_L_shells(k+1,:)],'omitnan'); %#ok<SAGROW>
    mean_cutoff_datenums_duo(k,:) = mean([cutoff_datenums(k,:);cutoff_datenums(k+1,:)],'omitnan'); %#ok<SAGROW>
    std_cutoff_L_shells_duo(k,:) = std([cutoff_L_shells(k,:);cutoff_L_shells(k+1,:)],'omitnan'); %#ok<SAGROW>
    std_cutoff_datenums_duo(k,:) = std([cutoff_datenums(k,:);cutoff_datenums(k+1,:)],'omitnan');  %#ok<SAGROW>
end