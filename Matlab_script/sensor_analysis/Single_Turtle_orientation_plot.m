dim_font = 30;
dim_fontb = 15;

calib = 0;

while calib ~= 1 && calib ~= 2
	fprintf('Use calibrated magnetic field? \n')
	fprintf('1 = yes \n')
	fprintf('2 = no \n')

	calib = input('');
end

if calib == 1
	mag_reor_plot = mag_postcalib;
	norm_mag_reor_plot = norm_mag_reor_calib;
	mag_norm_reor_plot = mag_norm_reor_calib;
	angle_c_plot = angle_c_calib;
	angle_c_norm_plot = angle_c_norm_calib;
	angle_s_plot = angle_s_calib;
	angle_s_norm_plot = angle_s_norm_calib;
	roll_plot = roll_calib;
	pitch_plot = pitch_calib;
	yaw_m_plot = yaw_m_calib;
	yaw_g_plot = yaw_g_calib;
	roll_norm_plot = roll_norm_calib;
	pitch_norm_plot = pitch_norm_calib;
	yaw_m_norm_plot = yaw_m_norm_calib;
	yaw_g_norm_plot = yaw_g_norm_calib;
else
	mag_reor_plot = mag_reor;
	norm_mag_reor_plot = norm_mag_reor;
	mag_norm_reor_plot = mag_norm_reor;
	angle_c_plot = angle_c;
	angle_c_norm_plot = angle_c_norm;
	angle_s_plot = angle_s;
	angle_s_norm_plot = angle_s_norm;
	roll_plot = roll;
	pitch_plot = pitch;
	yaw_m_plot = yaw_m;
	yaw_g_plot = yaw_g;
	roll_norm_plot = roll_norm;
	pitch_norm_plot = pitch_norm;
	yaw_m_norm_plot = yaw_m_norm;
	yaw_g_norm_plot = yaw_g_norm;
end

%% norm of acceleration plot, rotated measures
 
figure('Name', ['figure ', num2str(id_plot),', acceleration norm / g reoriented'], 'NumberTitle','off'); id_plot = id_plot + 1;

clf
plot(datetime_acc, norm_acc_reor);
	grid on
	box on
	axis tight
	xlabel('time','FontSize', dim_font)
	ylabel('acc_{norm}/g','FontSize', dim_font)
	set(gca,'FontSize', dim_font) 
	title('Acceleration norm / g reoriented')
	
figure('Name', ['figure ', num2str(id_plot),', magnetic field norm'], 'NumberTitle','off'); id_plot = id_plot + 1;

clf
plot(datetime_mag, norm_mag_reor_plot);
	grid on
	box on
	axis tight
	xlabel('time','FontSize', dim_font)
	ylabel('mag','FontSize', dim_font)
	set(gca,'FontSize', dim_font) 
	title('Magnetic field norm reoriented')
	
% filter

Fpass = 0.01;
Fs = 10;

g_x_B = lowpass(acc_reor(:, 1), Fpass, Fs);
g_y_B = lowpass(acc_reor(:, 2), Fpass, Fs);
g_z_B = lowpass(acc_reor(:, 3), Fpass, Fs);

acc_stat = [g_x_B g_y_B g_z_B];
[norm_acc_stat, ~, norm_mag_reor_stat, ~, ~, ~] = norm_acc_mg(acc_stat, mag_reor_plot);

figure('Name', ['figure ', num2str(id_plot),', static acceleration norm / g reoriented'], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
plot(datetime_acc(5:end-5), norm_acc_stat(5:end-5));
	grid on
	box on
	axis tight
	xlabel('time','FontSize', dim_font)
	ylabel('acc_{norm}/g','FontSize', dim_font)
	set(gca,'FontSize', dim_font) 
	title('Static acceleration norm / g reoriented')
%% norm of magnetic field plot, rotated measures
figure('Name', ['figure ', num2str(id_plot),', magnetic field norm reoriented'], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
F_micro_plot = ones(size(norm_mag_reor_plot, 1), size(norm_mag_reor_plot, 2))*F_micro;
plot(datetime_mag, [norm_mag_reor_plot, F_micro_plot]);
	grid on
	box on
	axis tight
	xlabel('time','FontSize', dim_font)
	ylabel('mf_{norm} (\mu T)','FontSize', dim_font)
	set(gca,'FontSize', dim_font) 
	title('Magnetic field norm reoriented (Rotx(pi))')

%% 3D plot of normalized magnetic field, rotated measures
figure('Name', ['figure ', num2str(id_plot),', 3D plot of normalized magnetic field reoriented '], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
plot3(mag_norm_reor_plot(:, 1), mag_norm_reor_plot(:, 2), mag_norm_reor_plot(:, 3), 'o');
	grid on
	box on
	axis equal
	xlabel('normalized mag_x','FontSize', dim_font)
	ylabel('normalized mag_y','FontSize', dim_font)
	zlabel('normalized mag_z','FontSize', dim_font)
	set(gca,'FontSize', dim_font) 
	title('Normalized magnetic field reoriented (Rotx(pi))')	

%% 3D plot of magnetic field, rotated measures
figure('Name', ['figure ', num2str(id_plot),', 3D plot of magnetic field reoriented'], 'NumberTitle','off'); id_plot = id_plot + 1;

clf
plot3(mag_reor_plot(:, 1), mag_reor_plot(:, 2), mag_reor_plot(:, 3), 'o');
	grid on
	box on
	axis equal
	xlabel('mag_x (\mu T)','FontSize', dim_font)
	ylabel('mag_y (\mu T)','FontSize', dim_font)
	zlabel('mag_z (\mu T)','FontSize', dim_font)
	set(gca,'FontSize', dim_font) 
	title('Magnetic field reoriented (Rotx(pi))')	

%% acceleration reoriented
figure('Name', ['figure ', num2str(id_plot),', acceleration reoriented'], 'NumberTitle','off'); id_plot = id_plot + 1;

clf	
	subplot(3,1,1)
		plot(datetime_acc, acc_reor(:, 1), 'DisplayName', 'acc_x');
		grid on
		box on
		axis tight
		xlabel('time','FontSize', dim_fontb)
		ylabel('acc','FontSize', dim_fontb)
		legend('Location', 'best','FontSize', dim_fontb, 'Location', 'best')
		set(gca,'FontSize', dim_fontb) 
		title('acc_x reoriented')

	subplot(3,1,2)
		plot(datetime_acc, acc_reor(:, 2), 'DisplayName', 'acc_y');
		grid on
		box on
		axis tight
		xlabel('time','FontSize', dim_fontb)
		ylabel('acc','FontSize', dim_fontb)
		legend('Location', 'best','FontSize', dim_fontb, 'Location', 'best')
		set(gca,'FontSize', dim_fontb) 
		title('acc_y reoriented')

	subplot(3,1,3)
		plot(datetime_acc, acc_reor(:, 3), 'DisplayName', 'acc_z');
		grid on
		box on
		axis tight
		xlabel('time','FontSize', dim_fontb)
		ylabel('acc','FontSize', dim_fontb)
		legend('Location', 'best','FontSize', dim_fontb, 'Location', 'best')
		set(gca,'FontSize', dim_fontb) 
		title('Acc_z reoriented')
	 	
	sgtitle('Acceleration reoriented','FontSize', dim_font)
		
%% magnetic field reoriented
figure('Name', ['figure ', num2str(id_plot),', magnetic field reoriented'], 'NumberTitle','off'); id_plot = id_plot + 1;

clf
	subplot(3,1,1)
		plot(datetime_mag, mag_reor_plot(:, 1), 'DisplayName', 'mag_x');
		grid on
		axis tight
		xlabel('time','FontSize', dim_fontb)
		ylabel('mag (\mu T)','FontSize', dim_fontb)
		legend('Location', 'best','FontSize', dim_fontb, 'Location', 'best')
		set(gca,'FontSize', dim_fontb) 
		title('Mag_x of magnetic field reoriented')

	subplot(3,1,2)
		plot(datetime_mag, mag_reor_plot(:, 2), 'DisplayName', 'mag_y');
		grid on
		axis tight
		xlabel('time','FontSize', dim_fontb)
		ylabel('mag','FontSize', dim_fontb)
		legend('Location', 'best','FontSize', dim_fontb, 'Location', 'best')
		set(gca,'FontSize', dim_fontb) 
		title('Mag_y of magnetic field reoriented')

	subplot(3,1,3)
		plot(datetime_mag, mag_reor_plot(:, 3), 'DisplayName', 'mag_z');
		grid on
		axis tight
		xlabel('time','FontSize', dim_fontb)
		ylabel('mag','FontSize', dim_fontb)
		legend('Location', 'best','FontSize', dim_fontb, 'Location', 'best')
		set(gca,'FontSize', dim_fontb) 
		title('Mag_z of magnetic field reoriented')
	 	
	sgtitle('Magnetic field reoriented (Rotx(pi))', 'FontSize', dim_font)

%% angle between g and magnetic field reoriented 
% the not normed and normed version must give the same value, you can 
% comment one of the two versions once verified that it happens

angle_c_NED_plt = angle_c_NED * ones(size(angle_c_plot, 1), size(angle_c_plot, 2));
angle_s_NED_plt = angle_s_NED * ones(size(angle_s_plot, 1), size(angle_s_plot, 2));
	%% acos
	
figure('Name', ['figure ', num2str(id_plot),', angle between g and magnetic field reoriented (acos)'], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
plot(datetime_mag, [angle_c_plot, angle_c_NED_plt])
	grid on
	box on
	axis tight
	ylim([20, 60])
	xlabel('time','FontSize', dim_font)
	ylabel('angle (deg)','FontSize', dim_font)
	legend('computed angle', 'expected angle','FontSize', dim_font, 'Location', 'best')
	set(gca,'FontSize', dim_font) 
	title('Angle between g and magnetic field reoriented (acos)')
	%% asin
	
figure('Name', ['figure ', num2str(id_plot),', angle between g and magnetic field reoriented (asin)'], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
plot(datetime_mag, [angle_s_plot, angle_s_NED_plt])
	grid on
	box on
	axis tight
	ylim([20, 60])
	xlabel('time','FontSize', dim_font)
	ylabel('angle (deg)','FontSize', dim_font)
	legend('computed angle', 'expected angle','FontSize', dim_font, 'Location', 'best')
	set(gca,'FontSize', dim_font) 
	title('Angle between g and magnetic field reoriented (asin)')
	%% acos norm
	
figure('Name', ['figure ', num2str(id_plot),', angle between normalized g and magnetic field reoriented (acos)'], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
plot(datetime_mag, [angle_c_norm_plot, angle_c_NED_plt])
	grid on
	box on
	axis tight
	ylim([20, 60])
	xlabel('time','FontSize', dim_font)
	ylabel('angle (deg)','FontSize', dim_font)
	legend('computed angle', 'expected angle','FontSize', dim_font, 'Location', 'best')
	set(gca,'FontSize', dim_font) 
	title('Angle between normalized g and magnetic field reoriented (acos)')
	%% asin norm
	
figure('Name', ['figure ', num2str(id_plot),', angle between normalized g and magnetic field reoriented (asin)'], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
plot(datetime_mag, [angle_s_norm_plot, angle_s_NED_plt])
	grid on
	box on
	axis tight
	ylim([20, 60])
	xlabel('time','FontSize', dim_font)
	ylabel('angle (deg)','FontSize', dim_font)
	legend('computed angle', 'expected angle','FontSize', dim_font, 'Location', 'best')
	set(gca,'FontSize', dim_font) 
	title('Angle between normalized g and magnetic field reoriented (asin)')
	
%% YPR 
% standard and non-standard versions must be equal, here we use rotated 
% measurement vectors
	%% YPR reoriented	w.r.t. magnetic	North
	
figure('Name', ['figure ', num2str(id_plot),', YPR reoriented w.r.t. magnetic North'], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
plot(datetime_mag, [roll_plot, pitch_plot, yaw_m_plot])
	grid on
	box on
	axis tight
	xlabel('time','FontSize', dim_font)
	ylabel('angle (deg)','FontSize', dim_font)
	legend('Roll', 'Pitch', 'Yaw','FontSize', dim_font, 'Location', 'best')
	set(gca,'FontSize', dim_font) 
	title('YPR reoriented w.r.t. magnetic North')
	%% YPR norm reoriented	w.r.t. magnetic		North

figure('Name', ['figure ', num2str(id_plot),', YPR norm reoriented w.r.t. magnetic North'], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
plot(datetime_mag, [roll_norm_plot, pitch_norm_plot, yaw_m_norm_plot])
	grid on
	box on
	axis tight
	xlabel('time','FontSize', dim_font)
	ylabel('angle (deg)','FontSize', dim_font)
	legend('Roll', 'Pitch', 'Yaw','FontSize', dim_font, 'Location', 'best')
	set(gca,'FontSize', dim_font) 
	title('YPR norm reoriented w.r.t. magnetic North')

	%% YPR reoriented		w.r.t. geographic	North

figure('Name', ['figure ', num2str(id_plot),', Yaw angle w.r.t. geographic North'], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
plot(datetime_mag, yaw_g_plot)
	grid on
	box on
	axis tight
	xlabel('time','FontSize', dim_font)
	ylabel('angle (deg)','FontSize', dim_font)
	legend('Yaw','FontSize', dim_font, 'Location', 'best')
	set(gca,'FontSize', dim_font) 
	title('Yaw angle w.r.t. geographic North')
	
figure('Name', ['figure ', num2str(id_plot),', YPR reoriented w.r.t. geographic North'], 'NumberTitle','off'); id_plot = id_plot + 1;
clf
plot(datetime_mag, [roll_plot, pitch_plot, yaw_g_plot])
	grid on
	box on
	axis tight
	xlabel('time','FontSize', dim_font)
	ylabel('angle (deg)','FontSize', dim_font)
	legend('Roll', 'Pitch', 'Yaw','FontSize', dim_font, 'Location', 'best')
	set(gca,'FontSize', dim_font) 
	title('YPR reoriented w.r.t. geographic North')
	%% YPR norm reoriented	w.r.t. geographic	North after calibration
	
figure('Name', ['figure ', num2str(id_plot),', YPR norm reoriented w.r.t. geographic North '], 'NumberTitle','off'); id_plot = id_plot + 1;
	clf
plot(datetime_mag, [roll_norm_plot, pitch_norm_plot, yaw_g_norm_plot])
	grid on
	box on
	axis tight
	xlabel('time','FontSize', dim_font)
	ylabel('angle (deg)','FontSize', dim_font)
	legend('Roll', 'Pitch', 'Yaw','FontSize', dim_font, 'Location', 'best')
	set(gca,'FontSize', dim_font) 
	title('YPR norm reoriented w.r.t. geographic North')

	
fprintf('single_turtle_orientation_plot completed \n')