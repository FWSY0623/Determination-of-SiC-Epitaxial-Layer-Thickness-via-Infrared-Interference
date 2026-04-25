file_path1 = 'C:\Users\lenovo\Desktop\B题\附件\附件1.xlsx';
file_path2 = 'C:\Users\lenovo\Desktop\B题\附件\附件2.xlsx';
data_table1 = readtable(file_path1, 'VariableNamingRule', 'preserve');
data_table2 = readtable(file_path2, 'VariableNamingRule', 'preserve');
% 提取数据
wave_number1 = data_table1{:, 1};
reflectivity1 = data_table1{:, 2};
wave_number2 = data_table2{:, 1};
reflectivity2 = data_table2{:, 2};

% 检测极大值点
is_max1 = islocalmax(reflectivity1, 'MinSeparation', 50, 'MinProminence', 0.3);
wave_max1 = wave_number1(is_max1);
is_max2 = islocalmax(reflectivity2, 'MinSeparation', 50, 'MinProminence', 0.3);
wave_max2 = wave_number2(is_max2);

% 检测极小值点
is_min1 = islocalmin(reflectivity1, 'MinSeparation', 50, 'MinProminence', 0.3);
wave_min1 = wave_number1(is_min1);
is_min2 = islocalmin(reflectivity2, 'MinSeparation', 50, 'MinProminence', 0.3);
wave_min2 = wave_number2(is_min2);

% 筛选图像平稳后的有效数据
valid_data11 = wave_max1(wave_max1 > 2000);
valid_data12 = wave_min1(wave_min1 > 2000);
valid_data21 = wave_max2(wave_max2 > 2000);
valid_data22 = wave_min2(wave_min2 > 2000);
l11 = length(valid_data11);
l12 = length(valid_data12);
l21 = length(valid_data21);
l22 = length(valid_data22);
lb = [2.5; 0; 0];
ub = [2.65; 0.001; 0.0001];
initial_guess = [2.55; 0.0001; 0.00001];  % 参数初始猜测值
options = optimoptions('fmincon', ...
    'Display', 'iter', ...  % 显示迭代过程
    'MaxIterations', 1000, ...  % 最大迭代次数
    'MaxFunctionEvaluations', 5000, ...
    'TolX', 1e-6, ...  
    'TolFun', 1e-30);
obj_fun = @(params) objective_function5(params, 1e-3*[valid_data11(1:l11-1);valid_data12(1:l12-1); ...
    valid_data21(1:l21-1);valid_data22(1:l22-1)]);
[optimal_params, min_obj] = fmincon(obj_fun,...
    initial_guess, [], [], [], [], lb, ub, [], options);

% 提取优化结果
a_opt = optimal_params(1);
b_opt = optimal_params(2);
c_opt = optimal_params(3);