%% 附件4数据可视化
file_path = 'C:\Users\lenovo\Desktop\B题\附件\附件3.xlsx';
data_table = readtable(file_path, 'VariableNamingRule', 'preserve');
% 提取数据
wave_number = data_table{:, 1};
reflectivity = data_table{:, 2};
data_matrix = [wave_number, reflectivity];

% 检测极大值点
is_max = islocalmax(reflectivity, 'MinSeparation', 50, 'MinProminence', 0.3);
wave_max = wave_number(is_max);
peaks_max = reflectivity(is_max);

% 检测极小值点
is_min = islocalmin(reflectivity, 'MinSeparation', 50, 'MinProminence', 0.3);
wave_min = wave_number(is_min);
peaks_min = reflectivity(is_min);

figure('Position', [100, 100, 1000, 600]);
plot(wave_number, reflectivity, 'b-', 'LineWidth', 1); 
xlabel('波数(cm⁻¹)', 'FontSize', 12);
ylabel('反射率(%)', 'FontSize', 12);
hold on;
plot(wave_max, peaks_max, 'r.', 'MarkerSize', 15, 'DisplayName', '极大值点');
plot(wave_min, peaks_min, 'g.', 'MarkerSize', 15, 'DisplayName', '极小值点');
title('附件4波数-反射率关系图', 'FontSize', 14, 'FontWeight', 'bold');
grid on; 
legend({'附件4测试数据', '极大值点', '极小值点'}, 'FontSize', 12, 'Location', 'best');

%% 硅晶圆片厚度估计方法
wave_number = wave_number(2:end);   % 删去第一个反射率为0的数据点
reflectivity = reflectivity(2:end)*0.01;   % 反射率转为小数

R_detrend = detrend(reflectivity);   % 去除线性趋势
win = hanning(length(R_detrend));
R_windowed = R_detrend.*win;   % 应用汉宁窗
delta_wave_number = mean(diff(wave_number));   % 计算平均波数间隔
wave_number_uniform = linspace(min(wave_number), max(wave_number), length(wave_number));   % 生成“均匀波数轴”
R_interp = interp1(wave_number, R_windowed, wave_number_uniform, 'linear', 'extrap');   % 插值得到均匀采样的反射率

N = length(R_interp);
Y = fft(R_interp);   % 快速傅里叶变换
f_axis = (0:N-1)*(1/(N*delta_wave_number));   % 计算频率轴  
Y_abs = abs(Y/N);   % 归一化FFT振幅
Y_abs(1) = 0;
[peak_amp, peak_idx] = max(Y_abs);   % 找振幅最大的峰
f_peak = f_axis(peak_idx);   % 主峰对应的频率

% 入射角和折射率估计
n_0 = 1;   % 空气折射率
n_1 = 3.45;   % 硅晶圆片的折射率
theta0 = 15;  % 入射角

% 斯涅尔定律
sin_theta0 = (n_0/n_1)*sin(theta0*pi/180);
cos_theta0 = sqrt(1-sin_theta0^2);

d = f_peak/(2*N*cos_theta0);   % 厚度估计值

%% 绘图可视化，验证多光束干涉与厚度合理性
figure;
% 子图1：原始反射谱
subplot(3,1,1);
plot(wave_number, reflectivity*100, 'b-', 'LineWidth',1);
xlabel('波数 (cm⁻¹)', 'FontSize', 12);
ylabel('反射率 (%)', 'FontSize', 12);
title('附件4实验数据得到的波数-反射率关系图', 'FontSize', 14);
grid on;

% 子图2：预处理后的反射率
subplot(3,1,2);
plot(wave_number_uniform, R_windowed*100, 'r-', 'LineWidth',1);
xlabel('波数(cm⁻¹)', 'FontSize', 12);
ylabel('反射率(%)', 'FontSize', 12);
title('附件4实验数据预处理后波数-反射率关系图', 'FontSize', 14);
grid on;

% 子图3：FFT频谱
subplot(3,1,3);
plot(f_axis, Y_abs, 'k-', 'LineWidth',1); 
hold on;
plot(f_peak, peak_amp, 'ro', 'MarkerSize',6, 'MarkerFaceColor','r');
xlabel('频率', 'FontSize', 12);
ylabel('FFT振幅', 'FontSize', 12);
title('附件4实验数据的傅里叶频谱', 'FontSize', 14);
text(f_peak, peak_amp, ...
     sprintf('主峰频率 f_peak = %.4f cm', f_peak), ...
     'VerticalAlignment','bottom');
grid on;
hold off;