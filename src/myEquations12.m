function F = myEquations12(x,w,r)
    d = 7.4465e-04;   % 外延层厚度d的计算值（问题2得出）
    theta0 = 10;
    n1 = 2.646+7.988*1e-10*w^2+8.3951*1e-17*w^4;
    cos_theta1 = sqrt(1-sin((theta0)*pi/180)^2./n1^2);
    cos_theta2 = sqrt(1-sin((theta0)*pi/180)^2./x^2);
    phi = 4*pi*d*n1*w*cos_theta1;
    % 计算s分量反射率
    r01_s = (cos((theta0)*pi/180)-n1*cos_theta1)/(cos((theta0)*pi/180)+n1*cos_theta1);
    r12_s = (n1*cos_theta1-x*cos_theta2)./(n1*cos_theta1+x*cos_theta2);
    Rs_nume = r01_s^2+r12_s^2+2*r01_s*r12_s*cos(phi);
    Rs_deno = 1+(r01_s^2)*(r12_s^2)+2*r01_s*r12_s*cos(phi);
    Rs = Rs_nume/Rs_deno;
    % 计算p分量反射率
    r01_p = (-n1*cos((theta0)*pi/180)+cos_theta1)./(n1*cos((theta0)*pi/180)+cos_theta1);
    r12_p = (-x.*cos_theta1+n1.*cos_theta2)./(x.*cos_theta1+n1.*cos_theta2);
    Rp_nume = r01_p.^2+r12_p.^2+2*r01_p.*r12_p.*cos(phi);
    Rp_deno = 1+(r01_p.^2).*(r12_p.^2)+2*r01_p.*r12_p.*cos(phi);
    Rp = Rp_nume./Rp_deno;
    F = (Rs+Rp)/2-r;
end
