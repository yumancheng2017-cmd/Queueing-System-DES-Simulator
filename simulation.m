function [N_sim, T_sim_mins, N_Q_sim] = simulation(lambda, mu, max_runtime_hours, queue_type, K, m)
    % =========================================================
    %  DES for all kinds of queue 
    % =========================================================
    
    % defence programming
    if nargin < 6; m = 1; end      % The default number of servers is 1
    if nargin < 5; K = inf; end    % The default capacity number is inf
    if nargin < 4; queue_type = 'MM1'; end

    % 1. set up parameters
    expected_customers = lambda * max_runtime_hours;
    max_array_size = round(expected_customers * 1.2);
    
    arrival_times = zeros(1, max_array_size);
    departure_times = zeros(1, max_array_size);
    arr_count = 0; dep_count = 0;
    
    % 2. initialize the simuletion and calculation
    t = 0;
    N = 0;
    time_density_N = 0;  % "area" of Number
    time_density_NQ = 0; % "area" of Number in queue
    
    t_arrival = exprnd(1/lambda);
    % make all m servers inf at beginning
    t_depart = inf(1, m); 
    
    % 3. Main loop of DES
    while t < max_runtime_hours
        % find the sonnest derpart event
        [min_t_depart, server_idx] = min(t_depart);
        % decide next event
        t_next_event = min(min_t_depart, t_arrival);
        
        delta_t = t_next_event - t;
        % sum of "area"
        time_density_N = time_density_N + (N * delta_t);
        time_density_NQ = time_density_NQ + (max(0, N - m) * delta_t);
        
        t = t_next_event; 
        
        % ==================================
        % Arrival event
        % ==================================
        if t == t_arrival
            if N < K % the queue is not full
                N = N + 1;% People come
                arr_count = arr_count + 1;
                arrival_times(arr_count) = t;
                
                t_arrival = t + exprnd(1/lambda);% decide next arrival event
                
                % Condition of these are empty sersers
                if N <= m
                    idle_idx = find(t_depart == inf, 1);
                    % give the server a depart time
                    t_depart(idle_idx) = t + get_service_time(mu, queue_type); 
                end
            else
                t_arrival = t + exprnd(1/lambda); % The queue is full, decide the next arrival time
            end
            
        % ==================================
        % Depart event
        % ==================================
        else
            N = N - 1;% people leave
            dep_count = dep_count + 1;
            departure_times(dep_count) = t;
            
            % If there are people in the queue, start a new service time
            if N >= m
                t_depart(server_idx) = t + get_service_time(mu, queue_type);
            else
                t_depart(server_idx) = inf; % If queue is empty, set inf(shut down the server temprarily)
            end
        end
    end
    
    % 4. Calculation
    N_sim = time_density_N / max_runtime_hours;
    N_Q_sim = time_density_NQ / max_runtime_hours;
    
    valid_arrivals = arrival_times(1:dep_count);
    valid_departures = departure_times(1:dep_count);
    T_sim_mins = mean(valid_departures - valid_arrivals) * 60;
end

% --- generate a serve time according to the type ---
function st = get_service_time(mu, queue_type)
    switch queue_type
        case {'MM1', 'MM1K', 'MMm'}
            st = exprnd(1/mu);
        case 'MG1_Uniform'
            a = 2.5/60; b = 7.5/60;
            st = a + (b-a)*rand();
        case 'MG1_Deterministic'
            st = 1/mu;
    end
end