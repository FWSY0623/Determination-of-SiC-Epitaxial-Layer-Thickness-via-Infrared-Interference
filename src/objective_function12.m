function obj = objective_function12(params, x)
    % 提取数据
    file_path1 = 'C:\Users\lenovo\Desktop\B题\附件\附件1.xlsx';
    file_path2 = 'C:\Users\lenovo\Desktop\B题\附件\附件2.xlsx';
    data_table1 = readtable(file_path1, 'VariableNamingRule', 'preserve');
    data_table2 = readtable(file_path2, 'VariableNamingRule', 'preserve');
    wave_number1 = data_table1{:, 1};
    reflectivity1 = data_table1{:, 2};
    wave_number2 = data_table2{:, 1};
    reflectivity2 = data_table2{:, 2};
    
    % 检测极大值点
    is_max1 = islocalmax(reflectivity1, 'MinSeparation', 50, 'MinProminence', 0.3);
    wave_max1 = wave_number1(is_max1);
    is_max2 = islocalmax(reflectivity2, 'MinSeparation', 50, 'MinProminence', 0.3);
    wave_max2 = wave_number2(is_max2);
    
    % 检测极小值点
    is_min1 = islocalmin(reflectivity1, 'MinSeparation', 50, 'MinProminence', 0.3);
    wave_min1 = wave_number1(is_min1);
    is_min2 = islocalmin(reflectivity2, 'MinSeparation', 50, 'MinProminence', 0.3);
    wave_min2 = wave_number2(is_min2);
    
    % 筛选附件1、2波数-反射率图像平稳后的有效数据
    valid_data11 = wave_max1(wave_max1 > 2000);
    valid_data12 = wave_min1(wave_min1 > 2000);
    valid_data21 = wave_max2(wave_max2 > 2000);
    valid_data22 = wave_min2(wave_min2 > 2000);
    l11 = length(valid_data11);
    l12 = length(valid_data12);
    l21 = length(valid_data21);
    l22 = length(valid_data22);
    a = params(1);
    b = params(2);
    c = params(3);
    y_pred = a+b*x.^2+c*x.^4;
    %% 构建目标函数obj：厚度值方差
    sum11 = 0;
    square_sum11 = 0;
    sum12 = 0;
    square_sum12 = 0;
    sum21 = 0;
    square_sum21 = 0;
    sum22 = 0;
    square_sum22 = 0;
    % 附件1波数-反射率图极大值点
    for i = 1:l11-1
        sum11 = sum11+1/(2*(valid_data11(i+1)-valid_data11(i))*sqrt(y_pred(i)^2-sin(10*pi/180)^2));
        square_sum11 = square_sum11+1/(4*(valid_data11(i+1)-valid_data11(i))^2*(y_pred(i)^2-sin(10*pi/180)^2));
    end
    % 附件1波数-反射率图极小值点
    for i = 1:l12-1
        sum12 = sum12+1/(2*(valid_data12(i+1)-valid_data12(i))*sqrt(y_pred(l11-1+i)^2-sin(10*pi/180)^2));
        square_sum12 = square_sum12+1/(4*(valid_data12(i+1)-valid_data12(i))^2*(y_pred(l11-1+i)^2-sin(10*pi/180)^2));
    end
    % 附件2波数-反射率图极大值点
    for i = 1:l21-1
        sum21 = sum21+1/(2*(valid_data21(i+1)-valid_data21(i))*sqrt(y_pred(l11+l12-2+i)^2-sin(15*pi/180)^2));
        square_sum21 = square_sum21+1/(4*(valid_data21(i+1)-valid_data21(i))^2*(y_pred(l11+l12-2+i)^2-sin(15*pi/180)^2));
    end
    % 附件2波数-反射率图极小值点
    for i = 1:l22-1
        sum22 = sum22+1/(2*(valid_data22(i+1)-valid_data22(i))*sqrt(y_pred(l11+l12+l21-3+i)^2-sin(15*pi/180)^2));
        square_sum22 = square_sum22+1/(4*(valid_data22(i+1)-valid_data22(i))^2*(y_pred(l11+l12+l21-3+i)^2-sin(15*pi/180)^2));
    end
    % 平均厚度
    avg = (sum11+sum12+sum21+sum22)/(l11+l12+l21+l22-4);
    % 利用厚度方差构建目标函数
    obj = square_sum11+square_sum12+square_sum21+square_sum22-(l11+l12+l21+l22-4)*avg^2;
end