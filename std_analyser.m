load("values_for_10_grads.mat")

cutoff_L_shells = [cutoff_L_shells_1;cutoff_L_shells_2;cutoff_L_shells_3;cutoff_L_shells_4;cutoff_L_shells_5;cutoff_L_shells_6;cutoff_L_shells_7;cutoff_L_shells_8;cutoff_L_shells_9;cutoff_L_shells_10];
cutoff_datenums = [cutoff_datenums_1;cutoff_datenums_2;cutoff_datenums_3;cutoff_datenums_4;cutoff_datenums_5;cutoff_datenums_6;cutoff_datenums_7;cutoff_datenums_8;cutoff_datenums_9;cutoff_datenums_10];

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