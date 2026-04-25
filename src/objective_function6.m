function obj = objective_function3(d, x)
% 厚度值d作为待优化的变量
    % 提取数据
    file_path = 'C:\Users\lenovo\Desktop\B题\附件\附件3.xlsx';
    data_table = readtable(file_path, 'VariableNamingRule', 'preserve');
    reflectivity = data_table{:, 2};
    reflectivity = 0.01*reflectivity;   % 化为小数，统一单位

    n1 = a+b*(1e-3*x).^2;
    n2 = m+n*(1e-3*x).^2;

    cos_theta1 = sqrt(1-sin(10*pi/180)^2./n1.^2);
    cos_theta2 = sqrt(1-sin(10*pi/180)^2./n2.^2);
    
    r01_s = abs((cos(10*pi/180)-n1.*cos_theta1)./(cos(10*pi/180)+n1.*cos_theta1)).^2;
    r01_p = abs((n1*cos(10*pi/180)-cos_theta1)./(n1*cos(10*pi/180)+cos_theta1)).^2;
    r01 = (r01_s+r01_p)/2;
    r12_s = abs((n1.*cos_theta1-n2.*cos_theta2)./(n1.*cos_theta1+n2.*cos_theta2)).^2;
    r12_p = abs((n2.*cos_theta1-n1.*cos_theta2)./(n2.*cos_theta1+n1.*cos_theta2)).^2;
    r12 = (r12_s+r12_p)/2;
    
    obj = sum((abs((r01+r12.*exp(1i*4*pi*d.*n1.*x.*cos_theta1)) ...
        ./(1+r01.*r12.*exp(1i*4*pi*d.*n1.*x.*cos_theta1))).^2-reflectivity).^2);
