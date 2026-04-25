% 提取附件3数据
file_path = 'C:\Users\lenovo\Desktop\B题\附件\附件3.xlsx';
data_table = readtable(file_path, 'VariableNamingRule', 'preserve');
wave_number = data_table{:, 1};
reflectivity = data_table{:, 2};

n = numel(wave_number);
n1_data = zeros(n,1);
n2_data = zeros(n,1);
% 用于储存估计得到的硅晶圆片和衬底的折射率

for i = 1:n
    x0 = [3.5,3.3];
    options = optimset('TolFun', 1e-5, 'Display', 'off');
    fun = @(x) myEquations(x, wave_number(i), reflectivity(i));
    x = fsolve(fun, x0, options);
    n1_data(i) = x(1);
    n2_data(i) = x(2);
end
% 解n个二元方程组得到n组数值解
% 只考虑实部
n1_data = real(n1_data);
n2_data = real(n2_data);

%% 先处理硅晶圆片折射率，得到n1关于v的解析式
% 利用3σ准则找到异常值
window_size = 11;
mov_avg = movmean(n1_data, window_size);
deviation = abs(n1_data - mov_avg);
threshold = 3 * std(deviation);
outlier_idx = deviation > threshold;
valid_idx = ~outlier_idx;

% 利用线性插值替换异常值
n1_clean = n1_data;
if sum(valid_idx) >= 2
    n1_clean(outlier_idx) = interp1(wave_number(valid_idx), n1_data(valid_idx), ...
        wave_number(outlier_idx), 'linear');
end
n1_clean(isnan(n1_clean)) = mean(n1_clean(~isnan(n1_clean)));

% 拟合公式（Cauchy折射率公式）：n = a + b*v² + c*v⁴ ---
x = wave_number.^2;   % 自变量预先设为v²
[p, S, mu] = polyfit(x, n1_clean, 2);  

% 生成拟合曲线
n1_fit = polyval(p, x, S, mu);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 再处理衬底折射率，得到n2关于v的解析式
% 步骤同上
window_size = 11;
mov_avg = movmean(n2_data, window_size);
deviation = abs(n2_data - mov_avg);
threshold = 3 * std(deviation);
outlier_idx = deviation > threshold;
valid_idx = ~outlier_idx;

n2_clean = n2_data;
if sum(valid_idx) >= 2
    n2_clean(outlier_idx) = interp1(wave_number(valid_idx), n2_data(valid_idx), ...
        wave_number(outlier_idx), 'linear');
end
n2_clean(isnan(n2_clean)) = mean(n2_clean(~isnan(n2_clean)));

x = wave_number.^2;
[q, S, mu] = polyfit(x, n2_clean, 2);

n2_fit = polyval(q, x, S, mu);

% 对比原始数据、异常值处理后数据、拟合曲线
figure;
% 子图1：硅晶圆片折射率数据处理
subplot(2,1,1)
plot(wave_number, n1_data, 'b.', 'DisplayName', '原始数据'); 
hold on;
plot(wave_number, n1_clean, 'g-', 'DisplayName', '异常值处理后数据');
hold on;
plot(wave_number, n1_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'Cauchy公式拟合曲线');
xlabel('波数(cm⁻¹)','FontSize', 12);
ylabel('折射率','FontSize', 12);
ylim([-5,12]);
legend('Location', 'best','FontSize', 12);
title('附件3硅晶圆片折射率数据处理','FontSize', 14);
grid on;
% 子图2：衬底折射率数据处理
subplot(2,1,2)
plot(wave_number, n2_data, 'b.', 'DisplayName', '原始含异常值数据'); 
hold on;
plot(wave_number, n2_clean, 'g-', 'DisplayName', '异常值处理后数据');
hold on;
plot(wave_number, n2_fit, 'r-', 'LineWidth', 2, 'DisplayName', 'Cauchy公式拟合曲线');
xlabel('波数(cm⁻¹)', 'FontSize', 12);
ylabel('折射率', 'FontSize', 12);
ylim([-5,12]);
legend('Location', 'best','FontSize', 12);
title('附件3衬底折射率数据处理','FontSize', 14);
grid on;
hold off;