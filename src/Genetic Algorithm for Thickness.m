% 提取数据
file_path = 'C:\Users\lenovo\Desktop\B题\附件\附件3.xlsx';
data_table = readtable(file_path, 'VariableNamingRule', 'preserve');
wave_number = data_table{:, 1};
reflectivity = data_table{:, 2};
reflectivity = 0.01*reflectivity;   % 化为小数，统一单位
wave_number = wave_number(2:end);
reflectivity = reflectivity(2:end);
theta0 = 10;

% 利用残差平方和构建损失函数
r_square_loss = @(d) sum(((Rs(d,wave_number,n1_fit,n2_fit)+Rp(d,wave_number,n1_fit,n2_fit))/2-reflectivity).^2);

%% 利用遗传算法全局搜索参数
nvars = 1;   % 优化变量数量1个（厚度d）
lb = 2e-4;   % 厚度下界2*10^(-4)cm
ub = 1e-3;   % 厚度上界10^(-3)cm

options_ga = optimoptions('ga', ...
    'TolFun', 1e-8, ...
    'PopulationSize', 100, ...
    'MaxGenerations', 500, ...
    'StallGenLimit', 50, ...
    'Display', 'iter');
[d_ga, fval_ga] = ga(r_square_loss, nvars, [], [], [], [], lb, ub, [], options_ga);
% d_ga即为全局搜索后的最优厚度

figure;
% 理论反射率
reflectivity_pred = (Rs(d_ga,wave_number,n1_fit,theta0)+Rp(d_ga,wave_number,n1_fit,n2_fit,theta0))/2;
plot(wave_number,reflectivity_pred,'r');
hold on;
plot(wave_number,reflectivity,'b');
xlabel('波数(cm⁻¹)', 'FontSize', 12);
ylabel('反射率', 'FontSize', 12);
legend({'理论反射率','实际反射率'}, 'FontSize', 12);
title('附件3理论反射率与实际反射率对比', 'FontSize', 12)


