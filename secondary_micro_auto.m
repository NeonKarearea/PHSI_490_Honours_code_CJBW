clear all %#ok<CLALL>
close all
load("POES data PHSI 490\NOAA19\poes_n19_20120123.mat")

%This will make the relevant fluxes and L shells into the necessary forms
P6_flux = Omni_directional_P6(1:8:end);
L_shell = McIlwain_L_value(1:8:end);

bad_locations = find(L_shell(:)==-999);
L_shell_localise = L_shell;
L_shell_localise(bad_locations) = 0;

transitions = zeros(1,(length(L_shell_localise)-1));
for i = 1:length(L_shell_localise)-1
    transitions(i) = ~isequal(sign(L_shell_localise(i)),sign(L_shell_localise(i+1)));
end

trans_loc = find(transitions);

%Below splits the given data into the number of passes needed
check = 0; %This makes the first one go from one
P6_flux_pass = {};
L_shell_pass = {};
for i = 1:length(trans_loc)
    if check == 1
        start_pos = (check*trans_loc(i-1))+1;
    else
        start_pos = 1;
    end
    
    finish_pos = trans_loc(i);
    P6_flux_pass{i} = P6_flux(start_pos:finish_pos); %#ok<SAGROW>
    L_shell_pass{i} = L_shell(start_pos:finish_pos); %#ok<SAGROW>
    check = 1;
end

%This will split the passes into entrance and exit
for j = 1:length(L_shell_pass)
    L_shell_examine = L_shell_pass{j};
    P6_flux_examine = P6_flux_pass{j};
    
    if ~isempty(find(L_shell_examine==-999,1))
        del_L_loc = (find(L_shell_examine == -999,1)-1);
        L_shell_examine = L_shell_examine(L_shell_examine~=-999);
        P6_flux_examine = P6_flux_examine(L_shell_examine~=-999);
    else
        del_L_loc = find(L_shell_examine == max(L_shell_examine));
    end
    
    L_shell_pass_directional{((j-1)*2)+1} = L_shell_examine(1:del_L_loc); %#ok<SAGROW>
    L_shell_pass_directional{2*j} = L_shell_examine(del_L_loc+1:end); %#ok<SAGROW>
    P6_flux_pass_directional{((j-1)*2)+1} = P6_flux_examine(1:del_L_loc); %#ok<SAGROW>
    P6_flux_pass_directional{2*j} = P6_flux_examine(del_L_loc+1:end); %#ok<SAGROW>
end

%Now we can find the cutoff L_shells
m = 0; %This starts it as entry
for k = 1:length(P6_flux_pass_directional)
    [cut_flux, cut_L] = cutoff_determine(L_shell_pass_directional{k},...
        P6_flux_pass_directional{k},0.3,m);
    cut_Ls(k) = cut_L; %#ok<SAGROW>
    cut_fluxes(k) = cut_flux; %#ok<SAGROW>
    m = mod(m+1,2);
end


%This will find the cutoff L_shells in time
plot(cut_Ls)