function n2 = n2_v(V)
    N = length(V);   % 数据点数量
    % ================= 2. 高掺杂硅衬底的模型参数（文献来源）=================
    epsilon_inf = 11.7;          % 高频介电常数
    sigma_p = 2800;              % 等离子体波数（cm⁻¹）
    Gamma = 450;                 % 载流子散射率（cm⁻¹）
    sigma_TO = 610;              % 横光学声子共振波数（cm⁻¹）
    Delta_epsilon = 1.5;         % 声子振子强度
    gamma = 5;                   % 声子阻尼系数（cm⁻¹）
    
    % ================= 3. 逐波数计算复数折射率=================
    n2 = zeros(N,1);
    for i = 1:N
        sigma_i = V(i);  % 当前波数
        % 3.1 计算介电常数：Drude项 + Lorentz项
        % Drude项（自由载流子贡献）
        drude = - (sigma_p^2) / (sigma_i * (sigma_i + 1i * Gamma));
        % Lorentz项（晶格声子贡献）
        lorentz = (Delta_epsilon * sigma_TO^2) / (sigma_TO^2 - sigma_i^2 - 1i * gamma * sigma_i);
        % 总介电常数
        eps = epsilon_inf + drude + lorentz;
        n2(i) = sqrt(eps);
    end
end