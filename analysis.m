function [N_theo, T_theo_mins, N_Q_theo] = analysis(lambda, mu, queue_type, K, m)
    % =========================================================
    %               Analysis value
    % =========================================================
    
    % Defence programming
    if nargin < 5; m = 1; end
    if nargin < 4; K = inf; end
    if nargin < 3; queue_type = 'MM1'; end

    % Calculate the ρ
    rho_single = lambda / mu; 
    
    % set a NQ value
    N_Q_theo = 0; 

    switch queue_type
        case 'MM1'
            if rho_single >= 1
                N_theo = inf; T_theo_hours = inf; N_Q_theo = inf;
                disp('ERROR')
            else
                N_theo = rho_single / (1 - rho_single);
                T_theo_hours = 1 / (mu - lambda);
                N_Q_theo = N_theo - rho_single; % Number in queue of single server
            end
            
        case 'MM1K'
            if rho_single == 1
                N_theo = K / 2;
                T_theo_hours = (K + 1) / (2 * lambda);
                N_Q_theo = N_theo - (1 - 1/(K+1)); 
            else
                numerator_N = 1 - (K+1)*rho_single^K + K*rho_single^(K+1);
                denominator_N = (1 - rho_single^(K+1)) * (1 - rho_single);
                N_theo = rho_single * (numerator_N / denominator_N);
                
                lambda_bar = lambda * (1 - rho_single^K) / (1 - rho_single^(K+1));
                T_theo_hours = N_theo / lambda_bar;
                N_Q_theo = N_theo - (lambda_bar / mu);
            end
            
        case 'MG1_Uniform'
            a = 2.5 / 60; b = 7.5 / 60;
            X2_bar = (a^2 + a*b + b^2) / 3;
            
            N_theo = rho_single + (lambda^2 * X2_bar) / (2 * (1 - rho_single));
            T_theo_hours = (1 / mu) + (lambda * X2_bar) / (2 * (1 - rho_single));
            N_Q_theo = N_theo - rho_single;
            
        case 'MG1_Deterministic'
            X2_bar = (1 / mu)^2;
            
            N_theo = rho_single + (lambda^2 * X2_bar) / (2 * (1 - rho_single));
            T_theo_hours = (1 / mu) + (lambda * X2_bar) / (2 * (1 - rho_single));
            N_Q_theo = N_theo - rho_single;
            
        case 'MMm'
            % ρ of mutiple servers
            rho_m = lambda / (m * mu); 
            
            if rho_m >= 1
                disp('ERROR');
                N_theo = inf; T_theo_hours = inf; N_Q_theo = inf;
            else
                % probability of that there are no customers in the system
                sum_part = 0;
                for i = 0:(m-1)
                    sum_part = sum_part + ((m * rho_m)^i) / factorial(i);
                end
                last_term = ((m * rho_m)^m) / (factorial(m) * (1 - rho_m));
                p0 = 1 / (sum_part + last_term);
                
                % average number of people in queue
                numerator_NQ = p0 * rho_m * (m * rho_m)^m;
                denominator_NQ = factorial(m) * (1 - rho_m)^2;
                N_Q_theo = numerator_NQ / denominator_NQ;
              
                T_Q_hours = N_Q_theo / lambda;
                T_theo_hours = T_Q_hours + (1 / mu);
                
                % Total number of people in system
                N_theo = N_Q_theo + (lambda / mu);
            end
            
        otherwise
            error('未知的队列类型！');
    end

    % use munite as unit
    T_theo_mins = T_theo_hours * 60;
end