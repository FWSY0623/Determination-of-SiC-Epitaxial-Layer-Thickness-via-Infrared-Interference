function n1 = n1_v(V)
    epsilon_inf = 11.7;
    sigma_TO = 610;
    Delta_epsilon = 1.5;
    gamma_phonon = 5;
    sigma_p_epi = 80;   % 等离子体波数
    Gamma_epi = 120;   % 散射率
    % 晶格贡献
    term_phonon = Delta_epsilon*sigma_TO^2./(sigma_TO^2-V.^2-1i*gamma_phonon.*V);
    % 自由载流子贡献
    term_drude = -(sigma_p_epi^2)./(V.*(V+1i*Gamma_epi));
    eps = epsilon_inf + term_phonon + term_drude;
    n1 = sqrt(eps);