lenny = length(cutoff_datenums_all_grads{10}{1,1});

cutoff_L_shells = [cutoff_L_shells_all_grads{1}{5,4};cutoff_L_shells_all_grads{2}{5,4};cutoff_L_shells_all_grads{3}{5,4};cutoff_L_shells_all_grads{4}{5,4};cutoff_L_shells_all_grads{5}{5,4};cutoff_L_shells_all_grads{6}{5,4};cutoff_L_shells_all_grads{7}{5,4};cutoff_L_shells_all_grads{8}{5,4};cutoff_L_shells_all_grads{9}{5,4};cutoff_L_shells_all_grads{10}{5,4}];
cutoff_datenums = [cutoff_datenums_all_grads{1}{5,4};cutoff_datenums_all_grads{2}{5,4};cutoff_datenums_all_grads{3}{5,4};cutoff_datenums_all_grads{4}{5,4};cutoff_datenums_all_grads{5}{5,4};cutoff_datenums_all_grads{6}{5,4};cutoff_datenums_all_grads{7}{5,4};cutoff_datenums_all_grads{8}{5,4};cutoff_datenums_all_grads{9}{5,4};cutoff_datenums_all_grads{10}{5,4}];

for i = 2:9
    mean_cutoff_L_shells((i-1),:) = mean([cutoff_L_shells(i-1,:);cutoff_L_shells(i,:);cutoff_L_shells(i+1,:)],'omitnan'); %#ok<SAGROW>
    mean_cutoff_datenums((i-1),:) = mean([cutoff_datenums(i-1,:);cutoff_datenums(i,:);cutoff_datenums(i+1,:)],'omitnan'); %#ok<SAGROW>
    std_cutoff_L_shells((i-1),:) = std([cutoff_L_shells(i-1,:);cutoff_L_shells(i,:);cutoff_L_shells(i+1,:)],'omitnan'); %#ok<SAGROW>
    std_cutoff_datenums((i-1),:) = std([cutoff_datenums(i-1,:);cutoff_datenums(i,:);cutoff_datenums(i+1,:)],'omitnan'); %#ok<SAGROW> 
end

for j = 1:9
    mean_cutoff_L_shells_duo(j,:) = mean([cutoff_L_shells(j,:);cutoff_L_shells(j+1,:)],'omitnan'); %#ok<SAGROW>
    mean_cutoff_datenums_duo(j,:) = mean([cutoff_datenums(j,:);cutoff_datenums(j+1,:)],'omitnan'); %#ok<SAGROW>
    std_cutoff_L_shells_duo(j,:) = std([cutoff_L_shells(j,:);cutoff_L_shells(j+1,:)],'omitnan'); %#ok<SAGROW>
    std_cutoff_datenums_duo(j,:) = std([cutoff_datenums(j,:);cutoff_datenums(j+1,:)],'omitnan');  %#ok<SAGROW>
end