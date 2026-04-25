function obj = objective_function4(params, x)
    file_path = 'C:\Users\lenovo\Desktop\B题\附件\附件1.xlsx';
    data_table = readtable(file_path, 'VariableNamingRule', 'preserve');
    % 提取数据
    wave_number = data_table{:, 1};
    reflectivity = data_table{:, 2};
    
    % 检测极大值点
    is_max = islocalmax(reflectivity, 'MinSeparation', 50, 'MinProminence', 0.3);
    wave_max = wave_number(is_max);
    
    % 检测极小值点
    is_min = islocalmin(reflectivity, 'MinSeparation', 50, 'MinProminence', 0.3);
    wave_min = wave_number(is_min);
    
    % 筛选图像平稳后的有效数据
    valid_data1 = wave_max(wave_max > 2000);
    valid_data2 = wave_min(wave_min > 2000);
    l1 = length(valid_data1);
    l2 = length(valid_data2);
    a = params(1);
    b = params(2);
    c = params(3);
    y_pred = a+b*x.^2+c*x.^4;
    % 目标函数obj：厚度值方差
    sum1 = 0;
    square_sum1 = 0;
    sum2 = 0;
    square_sum2 = 0;
    for i = 1:l1-1
        sum1 = sum1+1/(2*(valid_data1(i+1)-valid_data1(i))*sqrt(y_pred(i)^2-sin(10*pi/180)^2));
        square_sum1 = square_sum1+1/(4*(valid_data1(i+1)-valid_data1(i))^2*(y_pred(i)^2-sin(10*pi/180)^2));
    end
    for i = 1:l2-1
        sum2 = sum2+1/(2*(valid_data2(i+1)-valid_data2(i))*sqrt(y_pred(l1-1+i)^2-sin(10*pi/180)^2));
        square_sum2 = square_sum2+1/(4*(valid_data2(i+1)-valid_data2(i))^2*(y_pred(l1-1+i)^2-sin(10*pi/180)^2));
    end
    avg = (sum1+sum2)/(l1+l2-2);
    obj = square_sum1+square_sum2-(l1+l2-2)*avg^2;
end