function n1 = n1_v_interp(v)
    n_intrinsic_sigmas = [500, 1000, 1500, 2000, 2500, 3000, 3500, 4000];
    n_intrinsic_values = [3.418, 3.417, 3.415, 3.413, 3.410, 3.407, 3.403, 3.399];
    if v <= min(n_intrinsic_sigmas)
        n1 = n_intrinsic_values(1);
    elseif v >= max(n_intrinsic_sigmas)
        n1 = n_intrinsic_values(end);
    else
        % 线性插值
        n1 = interp1(n_intrinsic_sigmas, n_intrinsic_values, v, 'linear');
    end
end