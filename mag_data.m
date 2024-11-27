function [a,b,c] = mag_data(station,datestring)
    %Station is a 3 letter ID (i.e. Eyrewell = EYR, Apia = API)
    file_id = fopen(strcat("Mag_data/",station,datestring,".json"));
    raw_info = fread(file_id,inf);
    string = char(raw_info');
    json_struct = jsondecode(string);
    
    a = json_struct.X;
    b = json_struct.Y;
    c = json_struct.Z;
end