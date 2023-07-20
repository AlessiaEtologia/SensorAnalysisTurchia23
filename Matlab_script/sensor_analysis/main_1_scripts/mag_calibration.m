% mag_calibration
% This script handles the calibration procedure that has to be performed
% over magnetic field data, since hard and soft iron distortions can
% generate a change in the real magnetic field value that is present in a 
% certain space and temporal point. 
%
% Usually, there is a procedure that has to be performed in order to
% collect a proper session, needed for the obtainment of the correction
% factors (procedure that consists in a series of movements to be executed
% with the sensor so as to cover all the possible direction, this will
% allow to see and measure the local magnetic field vector, that is a 
% constant vector, under all possible sensor orientation).
%
% For more information about the calibration procedure, refers to the user
% guide "divid_manual" attached to this code.
%
% This calibration session is usually at the beginning of the main dataset
% (since it is better not to switch off the sensor in between the
% calibration session collection and the data collection to be then
% corrected), but it may happens that the two sessions are in two different
% .csv files. For that reason, you have to specify it at the beginning:
%
%	a. Calibration set is at the beginning of the dataset?
%		1. Yes (recommended)
%		2. No
%
% In case of "no", it will be used as calibration dataset the one specified
% into "main_1_raw_data" script, at the very beginning in the "file load" 
% session, as:
%
%	data_calib	= readtable('calib_session_name.csv')
%
% Be sure to substitute "calib_session_name" with the correct name.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% After that, it is required to hand-self insert the start and stop time of
% the calibration section inside the dataset, including year, month, day,
% hour, minute and second.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Finally, it is called the function that execute the calibration over the
% reoriented magnetic field data. In particular, this function, called
% "mag_calib_main", executes the following main steps:
%	- compute correction indeces
%	- apply indices over the entire main dataset (the one relative to the
%		turtle swimming phase)
%
% For more details, refers directly to mag_calib_main function by calling
% the help procedure followed by its name (help mag_calib_main).
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% At the end, there is a call to the script "mag_calibration_plot", which
% will show magnetic field (mf) dataset before and after calibration 
% correction (data are those relative to the main turtle movement, also if 
% the calibration session is in a different file):
%
% 1. plot: Uncalibrated vs Calibrated mf data best fitting (ellips - sphere)
%				ellips - Uncalibrated mf
%				sphere - Calibrated mf
%
% 2. plot: Uncalibrated mf data and best fitting ellips
%
% 3. plot: Calibrated mf data and best fitting sphere

%% select calibration section
same_dataset = 0;

while same_dataset ~= 1 && same_dataset ~= 2
	fprintf('Calibration set is at the beginning of the dataset?\n')
	fprintf('1 = yes \n')
	fprintf('2 = no \n')
	
	same_dataset = input('');
end

% hand-self insertion of start and stop time of the calibration section
fprintf('Calibration session: \n')
fprintf('Start year: \n')
Yi = input('');
fprintf('Start month: \n')
Mi = input('');
fprintf('Start day: \n')
Di = input('');
fprintf('Start hour: \n')
Hi = input('');
fprintf('Start minute: \n')
MIi = input('');
fprintf('Start second: \n')
Si = input('');
MSi = 000;

fprintf('Stop year: \n')
Yf = input('');
fprintf('Stop month: \n')
Mf = input('');
fprintf('Stop day: \n')
Df = input('');
fprintf('Stop hour: \n')
Hf = input('');
fprintf('Stop minute: \n')
MIf = input('');
fprintf('Stop second: \n')
Sf = input('');
MSf = 000;

%% Calibration perform
if same_dataset == 1	% Yes
	[start_id_calib, stop_id_calib] = time_id(datetime_mag, Yi, Mi, Di, Hi, MIi, Si, MSi, Yf, Mf, Df, Hf, MIf, Sf, MSf);
	mag_reor_calib = mag_reor(start_id_calib:stop_id_calib, :);
else					% no
	datetime_acc_calib	= table2array(data_calib(:, 2));
	data_accx_calib		= table2array(data_calib(:, 3));
	data_accy_calib		= table2array(data_calib(:, 4));
	data_accz_calib		= table2array(data_calib(:, 5));
	acc_sens_calib		= [data_accx_calib, data_accy_calib, data_accz_calib];
	
	if sensor == 2		% axy
		datetime_mag_calib	= table2array(data_calib(1:10:end, 2));
		data_magx_calib		= table2array(data_calib(1:10:end, 6));
		data_magy_calib		= table2array(data_calib(1:10:end, 7));
		data_magz_calib		= table2array(data_calib(1:10:end, 8));
	elseif sensor == 1	% AGM
		datetime_mag_calib	= table2array(data_calib(:, 2));
		data_magx_calib		= table2array(data_calib(:, 9));        
		data_magy_calib		= table2array(data_calib(:, 10));
		data_magz_calib		= table2array(data_calib(:, 11));
		data_gyrox_calib	= table2array(data_calib(:, 6));
		data_gyroy_calib	= table2array(data_calib(:, 7));
		data_gyroz_calib	= table2array(data_calib(:, 8));
		gyro_sens_calib		= [data_gyrox_calib, data_gyroy_calib, data_gyroz_calib];
	end
	mag_calib = [data_magx_calib, data_magy_calib, data_magz_calib];
	
	% reorient data
	if sensor == 1			% AGM
		[acc_reor_calib, mag_reor_calib, gyro_reor_calib]	= file_data_reor(acc_sens_calib, mag_sens_calib, gyro_sens_calib, sensor);
	elseif sensor == 2		% axy
		[acc_reor_calib, mag_reor_calib, unused_calib]		= file_data_reor(acc_sens_calib, mag_sens_calib, acc_sens_calib, sensor);
	end
	
end

% function that execute the calibration:
%	compute correction indeces
%	apply indices over the entire dataset
[mag_postcalib, soft_iron, hard_iron, exp_mag_strength, sphere_fit, ellips_fit] = mag_calib_main(mag_reor, mag_reor_calib);
norma_mag_postcalib = norm(mag_postcalib);

%% plot
mag_calibration_plot