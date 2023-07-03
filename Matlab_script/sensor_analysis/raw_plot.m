% sensor = 1	for agm
% sensor = 2	for axy
% type = 1		for acc
% type = 2		for mag
% type = 3      for gyro (available only for agm)

% note: for agm, mag e gyro are acc linked (10 Hz)
%       for axy, acc is 10 Hz while mag is 2 Hz (1/5 of acc)
clear
clc
close all

id_plot = 1;

addpath("csv_file");
addpath("csv_file\Turchia2023");
addpath("csv_file\Turchia2023\Banu-C");
addpath("csv_file\Turchia2023\Banu-C\axy");
addpath("csv_file\Turchia2023\Didar-F");
addpath("csv_file\Turchia2023\Emine-D");
addpath("csv_file\Turchia2023\Emine-D\axy");
addpath("csv_file\Turchia2023\Fati-E");
addpath("csv_file\Turchia2023\Fati-E\axy");
addpath("csv_file\Turchia2023\Melis-B");
addpath("csv_file\Turchia2023\Melis-B\axy");

datetime_column = 0;
sensor = 0;

data = readtable('melis_axy4_S4.csv');

fprintf("Datetime or Date - time information? \n")
fprintf("1. Date and Time columns together \n")
fprintf("2. Date and Time columns divided divided \n")

while datetime_column <= 0 || datetime_column > 2
    datetime_column = input('');
end

fprintf("Choose the logger model: \n")
fprintf("1. AGM \n")
fprintf("2. Axy-5 \n")

while sensor <= 0 || sensor > 2
    sensor = input('');
end

%% load data
if datetime_column == 1
	datetime_acc = table2array(data(1:end, 2));
	data_accx = table2array(data(1:end, 3));
	data_accy = table2array(data(1:end, 4));
	data_accz = table2array(data(1:end, 5));
	acc_sens = [data_accx, data_accy, data_accz];
	
	if sensor == 2
		datetime_mag = table2array(data(1:10:end, 2));
		data_magx = table2array(data(1:10:end, 6));    % acc = 10Hz, mag = 2 Hz
		data_magy = table2array(data(1:10:end, 7));
		data_magz = table2array(data(1:10:end, 8));
	elseif sensor == 1
		datetime_mag = table2array(data(1:10:end, 2));
		data_magx = table2array(data(1:10:end, 9));           % mag = acc linked
		data_magy = table2array(data(1:10:end, 10));
		data_magz = table2array(data(1:10:end, 11));
		datetime_gyro = datetime_acc;
		data_gyrox = table2array(data(:, 6));
		data_gyroy = table2array(data(:, 7));
		data_gyroz = table2array(data(:, 8));
		gyro_sens = [data_gyrox, data_gyroy, data_gyroz];
	end	
elseif datetime_column == 2 % not working for now
	date_acc = table2array(data(:, 2));
	time_acc = table2array(data(:, 3));
	datetime_acc = date_acc + time_acc;
	data_accx = table2array(data(:, 4));
	data_accy = table2array(data(:, 5));
	data_accz = table2array(data(:, 6));
	acc_sens = [data_accx, data_accy, data_accz];
	if sensor == 2
		date_mag = table2array(data(1:10:end, 2));
		time_mag = table2array(data(1:10:end, 3));
		datetime_mag = datetime([date_mag, time_mag], 'InputFormat', 'GG/MM/YY HH:mm:ss.sss');
		data_magx = table2array(data(1:10:end, 7));    % acc = 10Hz, mag = 2 Hz
		data_magy = table2array(data(1:10:end, 8));
		data_magz = table2array(data(1:10:end, 9));
	elseif sensor == 1
		date_mag = table2array(data(1:10:end, 2));
		time_mag = table2array(data(1:10:end, 3));
		datetime_mag = datetime([date_mag, time_mag], 'InputFormat', 'GG/MM/YY HH:mm:ss.sss');
		data_magx = table2array(data(1:10:end, 10));           % mag = acc linked
		data_magy = table2array(data(1:10:end, 11));
		data_magz = table2array(data(1:10:end, 12));
		data_gyrox = table2array(data(:, 7));
		data_gyroy = table2array(data(:, 8));
		data_gyroz = table2array(data(:, 9));
		gyro_sens = [data_gyrox, data_gyroy, data_gyroz];
	end
end
mag_sens = [data_magx, data_magy, data_magz];
%% show

type = 0;

fprintf("Choose the veriable to be shown: \n")
fprintf("1. accelerometer (acc) \n")
fprintf("2. compass (mag) \n")

if sensor == 1
    fprintf("3. gyroscope (gyro) \n")
end

while type <= 0 || (type > 2 && sensor == 2) || (type > 3 && sensor == 1)
    type = input('');
end

if sensor == 1
    [acc_reor, mag_reor, gyro_reor]=file_data_reor(acc_sens, mag_sens, gyro_sens, sensor);
elseif sensor == 2
    [acc_reor, mag_reor, unused]=file_data_reor(acc_sens, mag_sens, acc_sens, sensor);
end

if type == 2
	end_sample = length(data_magx);

	% plot: Uncalibrated vs Calibrated magnetic field fitting ellipsoids/sphere

	figure(id_plot); id_plot = id_plot + 1;
		clf
		plot3(mag_sens(:, 1), mag_sens(:, 2), mag_sens(:, 3), 'LineStyle','none','Marker', 'o','MarkerSize', 3)
		grid on
		box on
		axis equal
		xlabel('x uT','FontSize', 20)
		ylabel('y uT','FontSize', 20)
		zlabel('z uT','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Not reoriented axes")
		hold off

    figure(id_plot); id_plot = id_plot + 1;
		clf
		plot3(mag_reor(:, 1), mag_reor(:, 2), mag_reor(:, 3), 'LineStyle','none','Marker', 'o','MarkerSize', 3)
		grid on
		box on
		axis equal
		xlabel('x uT','FontSize', 20)
		ylabel('y uT','FontSize', 20)
		zlabel('z uT','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Reoriented axes")
		hold off
		
		%{
		sample_tot = length(mag_sens);	
		figure(id_plot); id_plot = id_plot + 1;
		clf
		plot(1:sample_tot, mag_sens(:, 1), 'Marker', 'o','MarkerSize', 3)
		hold on
		plot(1:sample_tot, mag_sens(:, 2), 'Marker', 'o','MarkerSize', 3)
		plot(1:sample_tot, mag_sens(:, 3), 'Marker', 'o','MarkerSize', 3)
		grid on
		box on
		axis tight
		xlabel('x','FontSize', 20)
		ylabel('y','FontSize', 20)
		zlabel('z','FontSize', 20)
		legend('x mag', 'y mag', 'z mag','Location', 'southoutside','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Mag axes not reoriented")
		hold off
		%}
		
	figure(id_plot); id_plot = id_plot + 1;
		clf
		plot(datetime_mag, mag_sens(:, 1), 'Marker', 'o','MarkerSize', 3)
		hold on
		plot(datetime_mag, mag_sens(:, 2), 'Marker', 'o','MarkerSize', 3)
		plot(datetime_mag, mag_sens(:, 3), 'Marker', 'o','MarkerSize', 3)
		grid on
		box on
		axis tight
		xlabel('x','FontSize', 20)
		ylabel('y','FontSize', 20)
		zlabel('z','FontSize', 20)
		legend('x mag', 'y mag', 'z mag','Location', 'southoutside','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Mag axes not reoriented")
		hold off

    figure(id_plot); id_plot = id_plot + 1;
		clf
		plot(datetime_mag, mag_reor(:, 1), 'Marker', 'o','MarkerSize', 3)
		hold on
		plot(datetime_mag, mag_reor(:, 2), 'Marker', 'o','MarkerSize', 3)
		plot(datetime_mag, mag_reor(:, 3), 'Marker', 'o','MarkerSize', 3)
		grid on
		box on
		axis tight
		xlabel('x','FontSize', 20)
		ylabel('y','FontSize', 20)
		zlabel('z','FontSize', 20)
		legend('x mag', 'y mag', 'z mag','Location', 'southoutside','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Mag axes reoriented")
		hold off
		
    %% calibration
    calib_perf = 0;
    fprintf("Perform calibration? \n")
    fprintf("1. Yes \n")
    fprintf("2. no \n")

	while calib_perf < 1 || calib_perf > 2
        calib_perf = input('');
	end

	if calib_perf == 1
		
		separated = 0;

		while separated ~= 1 && separated ~= 2
			fprintf('Calibration set is at the beginning of the dataset?\n')
			fprintf('1 = yes \n')
			fprintf('2 = no \n')

			separated = input('');
		end
		
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
			
		if separated == 1
			[start_id_calib, stop_id_calib] = time_id(datetime_mag, Yi, Mi, Di, Hi, MIi, Si, MSi, Yf, Mf, Df, Hf, MIf, Sf, MSf);
			mag_reor_calib = mag_reor(start_id_calib:stop_id_calib, :);
		else
			data_calib = readtable('03_S1.csv'); % calib session
			
			datetime_acc_calib = table2array(data_calib(:, 2));
			data_accx_calib = table2array(data_calib(:, 3));
			data_accy_calib = table2array(data_calib(:, 4));
			data_accz_calib = table2array(data_calib(:, 5));
			acc_sens_calib = [data_accx_calib, data_accy_calib, data_accz_calib];
	
			if sensor == 2	
				datetime_mag_calib = table2array(data_calib(1:10:end, 2));
				data_magx_calib = table2array(data_calib(1:10:end, 6));    % acc = 10Hz, mag = 2 Hz
				data_magy_calib = table2array(data_calib(1:10:end, 7));
				data_magz_calib = table2array(data_calib(1:10:end, 8));
			elseif sensor == 1
				datetime_mag_calib = table2array(data_calib(:, 2));
				data_magx_calib = table2array(data_calib(:, 9));           % mag = acc linked
				data_magy_calib = table2array(data_calib(:, 10));
				data_magz_calib = table2array(data_calib(:, 11));
				data_gyrox_calib = table2array(data_calib(:, 6));
				data_gyroy_calib = table2array(data_calib(:, 7));
				data_gyroz_calib = table2array(data_calib(:, 8));
				gyro_sens_calib = [data_gyrox_calib, data_gyroy_calib, data_gyroz_calib];
			end
			mag_calib = [data_magx_calib, data_magy_calib, data_magz_calib];
			
			if sensor == 1
				[acc_reor_calib, mag_reor_calib, gyro_reor_calib]=file_data_reor(acc_sens_calib, mag_sens_calib, gyro_sens_calib, sensor);
			elseif sensor == 2
				[acc_reor_calib, mag_reor_calib, unused_calib]=file_data_reor(acc_sens_calib, mag_sens_calib, acc_sens_calib, sensor);
			end

		end	
        [mag_postcalib, soft_iron, hard_iron, exp_mag_strength, sphere_fit, ellips_fit] = mag_calib_main(mag_reor, mag_reor_calib);
	    norma_mag_postcalib = norm(mag_postcalib);
	
	figure(id_plot); id_plot = id_plot + 1;
		clf
		plot3(ellips_fit(:, 1), ellips_fit(:, 2), ellips_fit(:, 3), 'LineStyle','none','Marker', 'o','MarkerSize',1,'MarkerEdgeColor','g', 'MarkerFaceColor','g')
		hold on
		plot3(sphere_fit(:, 1), sphere_fit(:, 2), sphere_fit(:, 3), 'LineStyle','none','Marker', 'o','MarkerSize',1, 'MarkerEdgeColor','r', 'MarkerFaceColor','r')
		grid on
		box on
		axis equal
		xlabel('x uT','FontSize', 20)
		ylabel('y uT','FontSize', 20)
		zlabel('z uT','FontSize', 20)
		legend('Uncalibrated best fitting', 'Calibrated best fitting','Location', 'southoutside','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Uncalibrated vs Calibrated" + newline + "magnetic field fitting")
		hold off
    
    figure(id_plot); id_plot = id_plot + 1;
		clf
		plot3(ellips_fit(:, 1), ellips_fit(:, 2), ellips_fit(:, 3), 'LineStyle','none','Marker', 'o','MarkerSize',1,'MarkerEdgeColor','g', 'MarkerFaceColor','g')
		hold on
		plot3(mag_reor(:, 1), mag_reor(:, 2), mag_reor(:, 3), 'LineStyle','none','Marker', 'o','MarkerSize', 3)
		grid on
		box on
		axis equal
		xlabel('x uT','FontSize', 20)
		ylabel('y uT','FontSize', 20)
		zlabel('z uT','FontSize', 20)
		legend('Uncalibrated best fitting', 'magnetic field','Location', 'southoutside','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Uncalibrated magnetic field fitting")
		hold off
    
    figure(id_plot); id_plot = id_plot + 1;
		clf
		plot3(sphere_fit(:, 1), sphere_fit(:, 2), sphere_fit(:, 3), 'LineStyle','none','Marker', 'o','MarkerSize',1,'MarkerEdgeColor','g', 'MarkerFaceColor','g')
		hold on
		plot3(mag_postcalib(:, 1), mag_postcalib(:, 2), mag_postcalib(:, 3), 'LineStyle','none','Marker', 'o','MarkerSize', 3)
		grid on
		box on
		axis equal
		xlabel('x uT','FontSize', 20)
		ylabel('y uT','FontSize', 20)
		zlabel('z uT','FontSize', 20)
		legend('Calibrated best fitting', 'Calibrated magnetic field','Location', 'southoutside','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Calibrated magnetic field fitting")
		hold off
	end
	
elseif type == 1
	end_sample = length(data_accx);
	% Plot section
	figure(id_plot); id_plot = id_plot + 1;
		clf
		plot(1:end_sample, acc_sens(:, 1), 'Marker', 'o','MarkerSize', 3)
		hold on
		plot(1:end_sample, acc_sens(:, 2), 'Marker', 'o','MarkerSize', 3)
		plot(1:end_sample, acc_sens(:, 3), 'Marker', 'o','MarkerSize', 3)
		grid on
		box on
		axis tight
		xlabel('x','FontSize', 20)
		ylabel('y','FontSize', 20)
		zlabel('z','FontSize', 20)
		legend('x acc', 'y acc', 'z acc','Location', 'southoutside','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Acc axes not reor")
		hold off

       figure(id_plot); id_plot = id_plot + 1;
		clf
		plot(1:end_sample, acc_reor(:, 1), 'Marker', 'o','MarkerSize', 3)
		hold on
		plot(1:end_sample, acc_reor(:, 2), 'Marker', 'o','MarkerSize', 3)
		plot(1:end_sample, acc_reor(:, 3), 'Marker', 'o','MarkerSize', 3)
		grid on
		box on
		axis tight
		xlabel('x','FontSize', 20)
		ylabel('y','FontSize', 20)
		zlabel('z','FontSize', 20)
		legend('x acc', 'y acc', 'z acc','Location', 'southoutside','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Acc axes reor")
		hold off

			% Plot section
	figure(id_plot); id_plot = id_plot + 1;
		clf
		plot(datetime_acc, acc_sens(:, 1), 'Marker', 'o','MarkerSize', 3)
		hold on
		plot(datetime_acc, acc_sens(:, 2), 'Marker', 'o','MarkerSize', 3)
		plot(datetime_acc, acc_sens(:, 3), 'Marker', 'o','MarkerSize', 3)
		grid on
		box on
		axis tight
		xlabel('x','FontSize', 20)
		ylabel('y','FontSize', 20)
		zlabel('z','FontSize', 20)
		legend('x acc', 'y acc', 'z acc','Location', 'southoutside','FontSize', 20)
		set(gca,'FontSize', 20)
		title("Acc axes not reor")
		hold off

		
elseif type == 3
    end_sample = length(data_gyrox);
	
	figure(id_plot); id_plot = id_plot + 1;
	    clf
	    plot3(gyro_sens(:, 1), gyro_sens(:, 2), gyro_sens(:, 3), 'LineStyle','none','Marker', 'o','MarkerSize', 3)
	    grid on
	    box on
	    axis equal
	    xlabel('x','FontSize', 20)
	    ylabel('y','FontSize', 20)
	    zlabel('z','FontSize', 20)
	    legend('x gyro', 'y gyro', 'z gyro','Location', 'southoutside','FontSize', 20)
	    set(gca,'FontSize', 20)
	    title("gyro axes not reoriented")
	    hold off
	
	figure(id_plot); id_plot = id_plot + 1;
	    clf
	    plot(1:end_sample, gyro_sens(:, 1), 'Marker', 'o','MarkerSize', 3)
	    hold on
	    plot(1:end_sample, gyro_sens(:, 2), 'Marker', 'o','MarkerSize', 3)
	    plot(1:end_sample, gyro_sens(:, 3), 'Marker', 'o','MarkerSize', 3)
	    grid on
	    box on
	    axis equal
	    xlabel('x','FontSize', 20)
	    ylabel('y','FontSize', 20)
	    zlabel('z','FontSize', 20)
	    legend('x gyro', 'y gyro', 'z gyro','Location', 'southoutside','FontSize', 20)
	    set(gca,'FontSize', 20)
	    title("gyro axes not reoriented")
	    hold off

    figure(id_plot); id_plot = id_plot + 1;
	    clf
	    plot3(gyro_reor(:, 1), gyro_reor(:, 2), gyro_reor(:, 3), 'LineStyle','none','Marker', 'o','MarkerSize', 3)
	    grid on
	    box on
	    axis equal
	    xlabel('x','FontSize', 20)
	    ylabel('y','FontSize', 20)
	    zlabel('z','FontSize', 20)
	    legend('x gyro', 'y gyro', 'z gyro','Location', 'southoutside','FontSize', 20)
	    set(gca,'FontSize', 20)
	    title("gyro axes reoriented")
	    hold off
	
	figure(id_plot); id_plot = id_plot + 1;
	    clf
	    plot(1:end_sample, gyro_reor(:, 1), 'Marker', 'o','MarkerSize', 3)
	    hold on
	    plot(1:end_sample, gyro_reor(:, 2), 'Marker', 'o','MarkerSize', 3)
	    plot(1:end_sample, gyro_reor(:, 3), 'Marker', 'o','MarkerSize', 3)
	    grid on
	    box on
	    axis equal
	    xlabel('x','FontSize', 20)
	    ylabel('y','FontSize', 20)
	    zlabel('z','FontSize', 20)
	    legend('x gyro', 'y gyro', 'z gyro','Location', 'southoutside','FontSize', 20)
	    set(gca,'FontSize', 20)
	    title("gyro axes reoriented")
	    hold off

end