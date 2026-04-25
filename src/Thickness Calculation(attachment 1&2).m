x = 1e-3*[valid_data1(1:l1-1);valid_data2(1:l2-1)];
y_pred = a_opt+b_opt*x.^2+c_opt*x.^4;
D1 = zeros(l1-1,1);
D2 = zeros(l2-1,1);
for i = 1:l1-1
    d1 = 1/(2*(valid_data1(i+1)-valid_data1(i))*sqrt(y_pred(i)^2-(sin(10*pi/180)^2)));
    D1(i) = d1;
end
for i = 1:l2-1
    d2 = 1/(2*(valid_data2(i+1)-valid_data2(i))*sqrt(y_pred(l1-1+i)^2-(sin(10*pi/180)^2)));
    D2(i) = d2;
end
avg_pred = (sum(D1)+sum(D2))/(l1+l2-2);
