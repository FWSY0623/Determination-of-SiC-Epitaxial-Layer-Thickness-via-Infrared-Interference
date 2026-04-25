D = [D11;D12;D21;D22];
V = [valid_data11(1:l11-1);valid_data12(1:l12-1); ...
    valid_data21(1:l21-1);valid_data22(1:l22-1)];
figure;
plot(V, D, 'b.', 'MarkerSize', 15); 
xlim([2000,3800]);
ylim(1e-4*[5,9.5]);
xlabel('波数(cm⁻¹)', 'FontSize', 12);
ylabel('厚度(cm)', 'FontSize', 12);
title('明暗条纹处波数-碳化硅厚度关系图', 'FontSize', 14, 'FontWeight', 'bold');
grid on; 

SS_res = sum((D-mean(D)).^2);  % 残差平方和
RMSE = sqrt(SS_res/length(D));
std_D = std(D);
CV = std_D/mean(D)*100;

% 正态性检验
figure;
% 归一化直方图
histogram(D, 'Normalization', 'pdf', 'DisplayName', '数据直方图');
hold on;
% 概率密度曲线
mu = mean(D);
sigma = std(D);
x = linspace(mu-3*sigma, mu+3*sigma, 100);
y = normpdf(x, mu, sigma);
plot(x, y, 'r-', 'LineWidth', 1, 'DisplayName', '正态分布曲线');
xlabel('碳化硅厚度(cm)','FontSize', 12); ylabel('概率密度(cm⁻¹)','FontSize', 12);
legend('show','FontSize', 12); title('碳化硅厚度测量值的直方图和正态分布曲线','FontSize', 14);
hold off;
h = lillietest(D);
% h=0 表示不拒绝原假设；h=1 表示拒绝原假设

% Q-Q图检验正态性
figure;
qqplot(D);
title('Q-Q图正态性检验', 'FontSize', 14);
xlabel('理论分位数', 'FontSize', 12);
ylabel('样本分位数', 'FontSize', 12);