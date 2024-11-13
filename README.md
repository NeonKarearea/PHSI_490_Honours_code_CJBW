# PHSI 490 Dissertation code
## By Cole Jonathan Barnes-Wilkie, supervised by Craig Rodger.

The code in this repository was made for the PHSI 490 Dissertation as required to obtain a BSc(Hons). The project relates to solar proton events (SPEs) and the POES data was obtained from Craig Rodger (which unfortunately cannot be uploaded to GitHub).

This branch is the main code, which contains the New method.

If there are any questions, please email barcj210@student.otago.ac.nz or (if that email bounces back) cjbpx41@gmail.com.

## noise_determiner.m
noise_determiner.m runs data_analyser.m over a set range of minimum fluxes, minimum average fluxes, and gradients. There are no inputs. The outputs are:
- cutoff fluxes [Cell]
- cutoff L-shells [Cell]
- cutoff datenums [Cell]

## data_analyser.m
The main function that is used in this project. Inputs are:
- start date (start year, start month, start day) [Integer]
- end time (end year, end month, end day) [Integer]
- data resolution of the Omni directional detector [Integer]
- number of gradients to test (see Section 5.2 in the dissertation for more information regarding the gradient) [Integer]
- minimum cutoff flux [Integer]
- minimum average flux [Integer]
- which Omni directional detector to use (i.e. "P6") [String]
- a print toggle (0 for not final print, 1 for a final print) [Integer]

Outputs are:
- pass fluxes [Cell]
- pass L-shells [Cell]
- pass datenums [Cell]
- cutoff fluxes [Vector]
- cutoff L-shells [Vector]
- cutoff datenums [Vector]
- cutoff MLTs (Magnetic Local Time, grouped into groups of 3 i.e. 0, 1, and 2 are part of the same group) [Vector]
- cutoff Dst [Vector]
- cutoff Kp [Vector]
- cutoff geographic latitudes [Vector]
- cutoff geographic longitudes [Vector]
- cutoff geomagnetic latitudes [Vector]
- cutoff geomagnetic longtiudes [Vector]

## event_determine.m
event_determine.m is a function that find the same information as in data_analyser.m but only for one satellite. Inputs are:
- start time (MATLAB datenum) [Float]
- end time (NATLAB datenum) [Float]
- satellite string (for example, for MetOp2 the satellite string is "MetOp2\m02") [String]
- data_resolution for the Omni directional detector [Number]
- number of gradients to test [Number]
- minimum cutoff flux [Number]
- minimum average flux [Number]
- which Omni directional detector to use [String]

Outputs are:
- fluxes [Cell]
- L-shells [Cell]
- datenums [Cell]
- cutoff fluxes [Vector]
- cutoff L-shells [Vector]
- cutoff datenums [Vector]
- cutoff MLTs [Vector]
- cutoff Dst [Vector]
- cutoff Kp [Vector]
- cutoff geographic latitudes [Vector]
- cutoff geographic longitudes [Vector]
- cutoff geomagnetic latitudes [Vector]
- cutoff geomagnetic longtiudes [Vector]

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
- number of gradients [Integer]
- minimum cutoff flux [Integer]
- minimum average flux [Integer]

Outputs are:
- fluxes [Cell]
- L-shells [Cell]
- datenums [Cell]
- cutoff fluxes [Vector]
- cutoff L-shells [Vector]
- cutoff datenums [Vector]
- cutoff MLTs [Vector]
- cutoff Dst [Vector]
- cutoff Kp [Vector]
- cutoff geographic latitudes [Vector]
- cutoff geographic longitudes [Vector]
- cutoff geomagnetic latitudes [Vector]
- cutoff geomagnetic longitudes [Vector]

## cutoff_determine_new.m
cutoff_determine_new actually finds the cutoff flux, L-shell, MLT, Dst, Kp, geographic latitude, and geographic longitude. Inputs are:
- L-shell [Vector]
- flux [Vector]
- MLT [Vector]
- Dst [Vector]
- Kp [Vector]
- satellite latitude [Vector]
- satellite longitude [Vector]
- direction (0 if entering the pole, 1 if exiting the pole) [Number]
- number of gradients [Integer]
- minimum cutoff flux [Integer]
- minimum average flux [Integer]

Outputs are:
- cutoff flux [Float]
- cutoff L-shell [Float]
- cutoff MLT [Integer]
- cutoff Dst [Float]
- cutoff Kp [Float]
- cutoff geographic latitude [Float]
- cutoff geographic longitude [Float]
- cutoff geomagnetic latitude [Float]
- cutoff geomagnetic longitude [Float]

## grad_check.m
grad_check.m does the gradient check for cutoff_determine_new.m. The inputs are:
- delta flux (The difference between the measured flux and the theoretical flux found) [Vector]
- L-shell [Vector]
- location of sign change [Integer]
- operation (whether it is above or below the cutoff L shell) [Integer]
- number of gradients [Integer]

Outputs are:
- median gradient [Float]
- median delta flux [Float]

The other code is extra code used to help massage the data into the form needed to run in data_analyser.m
