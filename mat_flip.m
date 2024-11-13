function mat_flip(location,filename)
    disp(strcat("flipping matrices in ",filename,".mat..."))
    data = matfile(strcat(location,filename,".mat"));
    information = whos(data);
    data.Properties.Writable = true;
    for i = 1:length(information)
        %While not recommened, I believe that this is the only way that
        %this can be done.
        eval(['data.',getfield(information,{i},'name'),' = permute(data.',...
            getfield(information,{i},'name'),',[2,1]);']);
    end
end