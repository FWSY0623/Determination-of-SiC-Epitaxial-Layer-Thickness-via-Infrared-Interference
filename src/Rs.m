function Rs = Rs(d,x,n1_fit,n2_fit,theta0)
% 计算空气和硅晶圆片间s分量反射率（基于厚度估计值d）
    % 采用厚度估计值d得到的n1、n2拟合数据作为折射率
    n1=n1_fit;
    n2=n2_fit;
    % 利用斯涅尔公式构建cos_theta1/2与n1/n2的联系
    cos_theta1 = sqrt(1-sin((theta0)*pi/180)^2./n1.^2);
    cos_theta2 = sqrt(1-sin((theta0)*pi/180)^2./n2.^2);
    % 菲涅尔公式，其中空气折射率n0 = 1
    r01_s = (cos((theta0)*pi/180)-n1.*cos_theta1)./(cos((theta0)*pi/180)+n1.*cos_theta1);
    r12_s = (n1.*cos_theta1-n2.*cos_theta2)./(n1.*cos_theta1+n2.*cos_theta2);

    phi = 4*pi*d.*n1.*x.*cos_theta1;   % 相位差

    Rs_nume = r01_s.^2+r12_s.^2+2*r01_s.*r12_s.*cos(phi);
    Rs_deno = 1+(r01_s.^2).*(r12_s.^2)+2*r01_s.*r12_s.*cos(phi);
    Rs = Rs_nume./Rs_deno;

