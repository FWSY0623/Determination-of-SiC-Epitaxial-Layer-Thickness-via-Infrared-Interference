file_path = 'C:\Users\lenovo\Desktop\B题\附件\附件1.xlsx';
data_table = readtable(file_path, 'VariableNamingRule', 'preserve');
% 提取数据
wave_number = data_table{:, 1};
reflectivity = data_table{:, 2};

% 检测极大值点
is_max = islocalmax(reflectivity, 'MinSeparation', 50, 'MinProminence', 0.3);
wave_max = wave_number(is_max);

% 检测极小值点
is_min = islocalmin(reflectivity, 'MinSeparation', 50, 'MinProminence', 0.3);
wave_min = wave_number(is_min);

% 筛选图像平稳后的有效数据
valid_data1 = wave_max(wave_max > 2000);
valid_data2 = wave_min(wave_min > 2000);
l1 = length(valid_data1);
l2 = length(valid_data2);
lb = [2.5; 0; 0];
ub = [2.65; 0.001; 0.0001];
initial_guess = [2.55; 0.0001; 0.00001];  % 参数初始猜测值
options = optimoptions('fmincon', ...
    'Display', 'iter', ...  % 显示迭代过程
    'MaxIterations', 1000, ...  % 最大迭代次数
    'MaxFunctionEvaluations', 5000, ...
    'TolX', 1e-6, ...  
    'TolFun', 1e-30);
obj_fun = @(params) objective_function5(params, 1e-3*[valid_data1(1:l1-1);valid_data2(1:l2-1)]);
[optimal_params, min_obj] = fmincon(obj_fun,...
    initial_guess, [], [], [], [], lb, ub, [], options);

% 提取优化结果
a_opt = optimal_params(1);
b_opt = optimal_params(2);
c_opt = optimal_params(3);