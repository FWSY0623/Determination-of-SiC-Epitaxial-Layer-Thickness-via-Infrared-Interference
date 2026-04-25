% 提取附件1、2数据
file_path = 'C:\Users\lenovo\Desktop\B题\附件\附件1.xlsx';
data_table = readtable(file_path, 'VariableNamingRule', 'preserve');
wave_number = data_table{:, 1};
reflectivity = data_table{:, 2};
reflectivity = reflectivity*0.01;

n = numel(wave_number);
n2_data = zeros(n,1);
% 用于储存衬底的折射率

for i = 1:n
    x0 = 3;
    options = optimset('TolFun', 1e-5, 'Display', 'off');
    fun = @(x) myEquations12(x, wave_number(i), reflectivity(i));
    x = fsolve(fun, x0, options);
    n2_data(i) = x;
end

% 只考虑实部
n2_data = real(n2_data);

wave_number = wave_number(wave_number>2000);
n2_data = n2_data((wave_number>2000));
mul = zeros(numel(wave_number),1);
% 判断是否发生多光束干涉的判断向量
d = 7.4465e-04;   % 外延层厚度d的计算值（问题2得出）
theta0 = 10;
for i = 1:numel(mul)
    w = wave_number(i);
    x = n2_data(i);
    n1 = 2.646+7.988*1e-10*w^2+8.3951*1e-17*w^4;
    cos_theta1 = sqrt(1-sin((theta0)*pi/180)^2./n1^2);
    cos_theta2 = sqrt(1-sin((theta0)*pi/180)^2./x^2);
    phi = 4*pi*d*n1*w*cos_theta1;
    % 计算s分量反射率
    r01_s = (cos((theta0)*pi/180)-n1*cos_theta1)/(cos((theta0)*pi/180)+n1*cos_theta1);
    r12_s = (n1*cos_theta1-x*cos_theta2)./(n1*cos_theta1+x*cos_theta2);
    
    % 计算p分量反射率
    r01_p = (-n1*cos((theta0)*pi/180)+cos_theta1)./(n1*cos((theta0)*pi/180)+cos_theta1);
    r12_p = (-x.*cos_theta1+n1.*cos_theta2)./(x.*cos_theta1+n1.*cos_theta2);
    
    eta_s = r01_s*r12_s;
    eta_p = r01_p*r12_p;
    if eta_s > 0.01 || eta_p > 0.01
        mul(i) = 1;
    end
end

    

