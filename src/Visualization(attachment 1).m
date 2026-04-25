file_path = 'C:\Users\lenovo\Desktop\B题\附件\附件1.xlsx';
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
plot(wave_number, reflectivity, 'b-', 'LineWidth', 1, 'DisplayName', '附件1测试数据'); 
xlabel('波数(cm⁻¹)', 'FontSize', 12);  % 横坐标：波数
ylabel('反射率(%)', 'FontSize', 12);  % 纵坐标：反射率
hold on;
plot(wave_max, peaks_max, 'r.', 'MarkerSize', 15, 'DisplayName', '极大值点');
plot(wave_min, peaks_min, 'g.', 'MarkerSize', 15, 'DisplayName', '极小值点');
title('附件1波数-反射率关系图', 'FontSize', 14, 'FontWeight', 'bold');
grid on; 
legend({'附件1测试数据', '极大值点', '极小值点'}, 'FontSize', 12, 'Location', 'best');


delta_max = diff(wave_max);
delta_min = diff(wave_min);
% 筛选图像平稳后的有效数据
valid_data1 = wave_max(wave_max > 2000);
valid_data2 = wave_min(wave_min > 2000);
l1 = length(valid_data1);
l2 = length(valid_data2);





