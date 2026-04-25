function data_with_fluct = gauss_fluctuation(original_data, percent)
% 给原始数据添加±percent%范围内的随机波动（默认±0.5%）
% 输入：
%   original_data - 原始数据向量（一维数值数组）
%   percent       - 波动百分比（可选，默认0.5，即±0.5%）
% 输出：
%   data_with_fluct - 添加波动后的数据
%   fluctuation     - 每个数据点的波动值（原始数据×随机比例）
    
    % 计算波动系数（将百分比转为小数，如0.5% → 0.005）
    % 计算高斯噪声的标准差：99.7%的噪声会落在±3σ内，因此σ = percent% / 3
    scale = percent / 100;  % 百分比转为小数（如0.5% → 0.005）
    sigma = scale / 3;      % 标准差 = 范围/3（确保99.7%噪声在±percent%内）
    
    % 生成零均值、标准差为sigma的高斯噪声（与原始数据同长度）
    n = length(original_data);
    noise_ratio = randn(n, 1) * sigma;  % 噪声比例（正态分布）
    noise = original_data .* noise_ratio;  % 实际噪声值（与原始数据成比例）
    
    % 添加噪声到原始数据
    data_with_fluct = original_data + noise;
end
