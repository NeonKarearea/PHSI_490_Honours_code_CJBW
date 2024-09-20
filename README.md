# PHSI 490 Dissertation code
## By Cole Jonathan Barnes-Wilkie, supervised by Craig Rodger.

The code in this repository was made for the PHSI 490 Dissertation as required to obtain a BSc(Hons). The project relates to solar proton events (SPEs) and the POES data was obtained from Craig Rodger (which unfortunately cannot be uploaded to GitHub).

This branch contains other code to help run the Leske method and the Neal method.

If there are any questions, please email barcj210@student.otago.ac.nz or (if that email bounces back) cjbpx41@gmail.com.

## data_analyser.m
The main function that is used in this project. Inputs are:
- start date (start year, start month, start day) [Integer]
- end time (end year, end month, end day) [Integer]
- data resolution of the Omni directional detector [Integer]
- which Omni directional detector to use (i.e. "P6") [String]
- a method toggle ("LESKE" to use the Leske method and "NEAL" to use the Neal method) [String]

Outputs are:
- pass fluxes [Cell]
- pass L-shells [Cell]
- pass datenums [Cell]
- cutoff fluxes [Vector]
- cutoff L-shells [Vector]
- cutoff datenums [Vector]
- cutoff MLTs (Magnetic Local Time, the cutoff L-shell is on the day side (1) or night side (0)) [Vector]
- cutoff Dsts [Vector]
- cutoff Kps [Vector]
- cutoff geographic latitudes [Vector]
- cutoff geographic longitudes [Vector

## event_determine.m
event_determine.m is a function that find the same information as in data_analyser.m but only for one satellite. Inputs are:
- start time (MATLAB datenum) [Float]
- end time (NATLAB datenum) [Float]
- satellite string (for example, for MetOp2 the satellite string is "MetOp2\m02") [String]
- data_resolution for the Omni directional detector [Number]
- which Omni directional detector to use [String]
- method [String]

Outputs are:
- fluxes [Cell]
- L-shells [Cell]
- datenums [Cell]
- cutoff fluxes [Vector]
- cutoff L-shells [Vector]
- cutoff datenums [Vector]
- cutoff MLTs [Vector]
- cutoff Dsts [Vector]
- cutoff Kps [Vector]
- cutoff geographic latitudes [Vector]
- cutoff geographic longitudes [Vector]

## L_finder.m
L_finder.m is a function that finds the same information as in event_determine.m but onle for one day of data. Inputs are:
- fluxes [Vector]
- L-shells [Vector]
- datenums [Vector]
- satellite latitude [Vector]
- satellite longitude [Vector]
- MLT [Vector]
- Dst [Vector]
- Kp [Vector]
- method [String]

Outputs are:
- fluxes [Cell]
- L-shells [Cell]
- datenums [Cell]
- cutoff fluxes [Vector]
- cutoff L-shells [Vector]
- cutoff datenums [Vector]
- cutoff MLTs [Vector]
- cutoff Dsts [Vector]
- cutoff Kps [Vector]
- cutoff geographic latitudes [Vector]
- cutoff geographic longitudes [Vector]

## cutoff_determine_leske.m
cutoff_determine_leske. actually finds the cutoff flux, L-shell, MLT, Dst, Kp, geographic latitude, and geographic longitude via the Leske method. Inputs are:
- L-shell [Vector]
- flux [Vector]
- MLT [Vector]
- Dst [Vector]
- Kp [Vector]
- satellite latitude [Vector]
- satellite longitude [Vector]
- direction (0 if entering the pole, 1 if exiting the pole) [Number]

Outputs are:
- cutoff flux [Float]
- cutoff L-shell [Float]
- cutoff MLT [Integer]
- cutoff Dst [Float]
- cutoff Kp [Float]
- cutoff geographic latitude [Float]
- cutoff geographic longitude [Float]

## cutoff_determine_neal.m
cutoff_determine_neal.m actually finds the cutoff flux, L-shell, MLT, Dst, Kp, geographic latitude, and geographic longitude via the Neal method. Inputs are:
- L-shell [Vector]
- flux [Vector]
- MLT [Vector]
- Dst [Vector]
- Kp [Vector]
- satellite latitude [Vector]
- satellite longitude [Vector]
- difference (The difference between the found cutoff L shell and a neighbouring cutoff L shell) [Float]
- direction (0 if entering the pole, 1 if exiting the pole) [Number]

Outputs are:
- cutoff flux [Float]
- cutoff L-shell [Float]
- cutoff MLT [Integer]
- cutoff Dst [Float]
- cutoff Kp [Float]
- cutoff geographic latitude [Float]
- cutoff geographic longitude [Float]

The other code is extra code used to help massage the data into the form needed to run in data_analyser.m