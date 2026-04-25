x = 1e-3*[valid_data11(1:l11-1);valid_data12(1:l12-1); ...
    valid_data21(1:l21-1);valid_data22(1:l22-1)];
y_pred = a_opt+b_opt*x.^2+c_opt*x.^4;
D11 = zeros(l11-1,1);
D12 = zeros(l12-1,1);
D21 = zeros(l21-1,1);
D22 = zeros(l22-1,1);
for i = 1:l11-1
    d11 = 1/(2*(valid_data11(i+1)-valid_data11(i))*sqrt(y_pred(i)^2-(sin(10*pi/180)^2)));
    D11(i) = d11;
end
for i = 1:l12-1
    d12 = 1/(2*(valid_data12(i+1)-valid_data12(i))*sqrt(y_pred(l11-1+i)^2-(sin(10*pi/180)^2)));
    D12(i) = d12;
end
for i = 1:l21-1
    d21 = 1/(2*(valid_data21(i+1)-valid_data21(i))*sqrt(y_pred(l11+l12-2+i)^2-(sin(15*pi/180)^2)));
    D21(i) = d21;
end
for i = 1:l22-1
    d22 = 1/(2*(valid_data22(i+1)-valid_data22(i))*sqrt(y_pred(l11+l12+l21-3+i)^2-(sin(15*pi/180)^2)));
    D22(i) = d22;
end
avg_pred = (sum(D11)+sum(D12)+sum(D21)+sum(D22))/(l11+l12+l21+l22-4);
