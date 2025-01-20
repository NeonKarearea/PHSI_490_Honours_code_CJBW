function a = JSON(file_name)
    fid = fopen(convertStringsToChars(strcat('Intermag_data/',file_name,'.json')));
    raw = fread(fid,inf);
    str = char(raw');
    fclose(fid);
    a = jsondecode(str);
end