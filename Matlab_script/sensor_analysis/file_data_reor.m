% struct_sensor_reoriented
function [acc_reor, mag_reor, gyro_reor]=file_data_reor(acc, mag, gyro, model, orientation)

%% acc and mag extrapulation: 'original' raw data
acc_x = acc(:, 1);
acc_y = acc(:, 2);
acc_z = acc(:, 3);

acc_sens_orig = [acc_x, acc_y, acc_z];

mag_x = mag(:, 1);
mag_y = mag(:, 2);
mag_z = mag(:, 3);

if sensor_model == 1 % agm
    gyro_x = gyro(:, 1);
    gyro_y = gyro(:, 2);
    gyro_z = gyro(:, 3);

    gyro_sens_orig = [gyro_x, gyro_y, gyro_z];
end

%% Possible configurations
% the configurations that has been taken into account are four:
%	1. connector to the front
%	2. connector to the back
%	3. connector to the right
%	4. connector to the left

% Note: for all these configurations, the logger is placed with the wide
%		base downstairs and with the smooth angle upstairs.

%% reorient
% For AGM: 
%	- accx is longitudinal and positive along the connector side. 
%	- accy is trasversal and positive to the side of the dot.
%	- accz is vertical and positive downstairs.
%	- magx is trasversal and negative to the side of the dot.
%	- magy is longitudinal and negative along the connector side.
%	- magz is vertical and positive downstairs.
%	- gyrox is longitudinal and negative along the connector side.
%	- gyroy is trasversal and negative to the side of the dot.
%	- gyroz is vertical and positive upstairs.
%
% For Axy: 
%	- accx is longitudinal and positive along the connector side. 
%	- accy is trasversal and positive to the connector side.
%	- accz is vertical and positive downstairs.
%	- magx is longitudinal and positive along the connector side.
%	- magy is trasversal and positive to the connector side.
%	- magz is vertical and positive upstairs.
%
% Lets start before by aligning all the sensors with the same reference
% frame as those of the acceletometer.
% For AGM:
% 	- gyrox_new = -gyrox
%	- gyroy_new = -gyroy
%	- gyroz_new = -gyroz
%	- magx_new = -magy
%	- magy_new = -magx
%	- magz_new = magz
% For Axy:
%	- magx_new = magx
%	- magy_new = magy
%	- magz_new = -magz

if sensor_model == 1
    mag_sens_orig = [-mag_y, -mag_x, mag_z];	%  microTesla AGM
	gyro_sens_orig = [-gyro_x, -gyro_y, -gyro_z];
elseif sensor_model == 2
    mag_sens_orig = [mag_x, mag_y, -mag_z];	%  microTesla Axy-5 CHECK
end
	
%% pseudo-NED (TODO)
% da qua in giu è sempre roba vecchia
%% new: vertical placement, wide base in back, tip down (high connector)*

% for how the sensor is mounted inside the structure (vertical with 
% 	connector at the top, wide base at the rear):

% for mag. data must be rotated of -pi/2 around y-axis and of -pi/2 around 
% z-axis (after first rotation):  
%							[0 0 -1]	[0  1 0]	[0  0 -1]
%	Ry(-pi/2)*Rx(-pi/2) =	[0 1  0] *  [-1 0 0] =  [-1 0  0]
%							[1 0  0]	[0 0  1]	[0  1  0]

% mag_sens = Ry(-pi/2) * Rx(-pi/2) * mag_sens_orig = [-mag_z, -mag_x, mag_y]

% For acc data must be rotated of pi around z-axis and of -pi/2 around
% y-axis (after first rotation): 
%						[-1 0  0]	[0 0 -1]	[0  0 1]
%	Rz(pi)*Ry(-pi/2) =	[0  -1 0] * [0 1  0] =  [0 -1 0]
%						[0  0  1]	[1 0  0]	[1 0  0]

% acc_sens = Rz(pi) * Ry(-pi/2) * acc_sens_orig = [acc_z, -acc_y, acc_x]

% It can be obtain also by rotating the measurements obtained for the 
% horizontal version of -pi/2 around the y-axis:
% acc_sens = [acc_x, -acc_y, -acc_z];
% mag_sens = [mag_y, -mag_x, mag_z];

% acc_sens' = Ry(-pi/2) * acc_sens = [acc_z, -acc_y, acc_x] 
% mag_sens' = Ry(-pi/2) * mag_sens = [-mag_z, -mag_x, mag_y];

% Attention, in the wander phase the sensor floats with the orange part at
% the top, so the sensor is placed horizontally with the wide base upwards.
% Then, the correction to be made is different. For the pre-deployment 
% phase, on the other hand, it makes little sense to talk about it because
% there is no fixed reference, it is me who rotate it in my hands, but for
% simplicity of interpretation of the data I reorient it as when it is on
% board the turtle.

acc_sens	= [acc_z, -acc_y, acc_x];
mag_sens	= [-mag_z, -mag_x, mag_y];

if sensor_model == 1
    gyro_sens	= [gyro_z, -gyro_y, gyro_x];
end

%% assign to the struct
data_raw.accx = acc_sens(:, 1);
data_raw.accy = acc_sens(:, 2);
data_raw.accz = acc_sens(:, 3);

data_raw.magx = mag_sens(:, 1);
data_raw.magy = mag_sens(:, 2);
data_raw.magz = mag_sens(:, 3);

if sensor_model == 1
    data_raw.gyrox = gyro_sens(:, 1);
    data_raw.gyroy = gyro_sens(:, 2);
    data_raw.gyroz = gyro_sens(:, 3);
end

%% save struct

fprintf(['all reoriented data have been correctly loaded \n'])
	
fprintf('Saving data_raw.mat... \n')
save('data_raw', 'data_raw');
fprintf('data_raw.mat saved! \n')