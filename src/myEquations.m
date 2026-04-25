function F = myEquations(x,w,r)
    d = 3.6273e-04;   % 外延层厚度d的估计值
    theta0 = 10;
    cos_theta1 = sqrt(1-sin((theta0)*pi/180)^2./x(1)^2);
    cos_theta2 = sqrt(1-sin((theta0)*pi/180)^2./x(2)^2);
    phi = 4*pi*d*x(1)*w*cos_theta1;

    % 计算空气和硅晶圆片间s分量反射率
    r01_s = (cos((theta0)*pi/180)-x(1)*cos_theta1)/(cos((theta0)*pi/180)+x(1)*cos_theta1);
    r12_s = (x(1)*cos_theta1-x(2)*cos_theta2)./(x(1)*cos_theta1+x(2)*cos_theta2);
    Rs_nume = r01_s^2+r12_s^2+2*r01_s*r12_s*cos(phi);
    Rs_deno = 1+(r01_s^2)*(r12_s^2)+2*r01_s*r12_s*cos(phi);
    Rs = Rs_nume/Rs_deno;
    % 计算空气和硅晶圆片间p分量反射率
    r01_p = (-x(1)*cos((theta0)*pi/180)+cos_theta1)./(x(1)*cos((theta0)*pi/180)+cos_theta1);
    r12_p = (-x(2).*cos_theta1+x(1).*cos_theta2)./(x(2).*cos_theta1+x(1).*cos_theta2);
    Rp_nume = r01_p.^2+r12_p.^2+2*r01_p.*r12_p.*cos(phi);
    Rp_deno = 1+(r01_p.^2).*(r12_p.^2)+2*r01_p.*r12_p.*cos(phi);
    Rp = Rp_nume./Rp_deno;

    F(1) = (Rs+Rp)/2-r;   % 由估计值d得到的反射率等于实验值
    F(2) = x(1)-1.1*x(2);    % 添加硅晶圆片折射率为衬底折射率的1.1倍的条件

end
