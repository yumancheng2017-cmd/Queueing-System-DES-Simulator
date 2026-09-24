% =========================================================
% Discrete-Event Queueing System Simulator
% Simulation and Analytical Performance Comparison
% =========================================================
clc; clear; close all;

% The max rantime 6 month (hour)
max_runtime_hours = 24 * 30 * 24; 

fprintf('=========================================================\n');
fprintf('                          DES \n');
fprintf('=========================================================\n\n');

%% =========================================================
% PART 1: basic signl server
% =========================================================

fprintf('>>> Simulation...\n');

lambda_base = 10;   % 10 people come in per hour
mu_base = 60/5;     % serve 12 people per hour

% 1. M/M/1
[N_th_MM1, T_th_MM1] = analysis(lambda_base, mu_base, 'MM1');
[N_sm_MM1, T_sm_MM1] = simulation(lambda_base, mu_base, max_runtime_hours, 'MM1');

% 2. M/M/1/K 
K = 10;
mu_K_case1 = 60/5;
[N_th_MM1K1, T_th_MM1K1] = analysis(lambda_base, mu_K_case1, 'MM1K', K);
[N_sm_MM1K1, T_sm_MM1K1] = simulation(lambda_base, mu_K_case1, max_runtime_hours, 'MM1K', K);

mu_K_case2 = 60/6;
[N_th_MM1K2, T_th_MM1K2] = analysis(lambda_base, mu_K_case2, 'MM1K', K);
[N_sm_MM1K2, T_sm_MM1K2] = simulation(lambda_base, mu_K_case2, max_runtime_hours, 'MM1K', K);

% 3. M/G/1
[N_th_MG1, T_th_MG1] = analysis(lambda_base, mu_base, 'MG1_Uniform');
[N_sm_MG1, T_sm_MG1] = simulation(lambda_base, mu_base, max_runtime_hours, 'MG1_Uniform');

[N_th_MD1, T_th_MD1] = analysis(lambda_base, mu_base, 'MG1_Deterministic');
[N_sm_MD1, T_sm_MD1] = simulation(lambda_base, mu_base, max_runtime_hours, 'MG1_Deterministic');

%% =========================================================
% PART 2: mutiple servers: M/M/m
% =========================================================
fprintf('>>> M/M/m Simulation...\n\n');

% 5. Business Class: lambda=20, mu=24, m=2
lambda_bus = 20;
mu_bus = 24;
m_bus = 2;
[N_th_bus, T_th_bus, NQ_th_bus] = analysis(lambda_bus, mu_bus, 'MMm', inf, m_bus);
[N_sm_bus, T_sm_bus, NQ_sm_bus] = simulation(lambda_bus, mu_bus, max_runtime_hours, 'MMm', inf, m_bus);

% 6. Economy Class: lambda=100, mu=24, m=5
lambda_econ = 100;
mu_econ = 24; 
m_econ = 5;
[N_th_econ, T_th_econ, NQ_th_econ] = analysis(lambda_econ, mu_econ, 'MMm', inf, m_econ);
[N_sm_econ, T_sm_econ, NQ_sm_econ] = simulation(lambda_econ, mu_econ, max_runtime_hours, 'MMm', inf, m_econ);


%% =========================================================
% PART 3: ERROR report
% =========================================================
fprintf('=========================================================\n');
fprintf('             Single server simulation vs analysis error               \n');
fprintf('=========================================================\n');
fprintf('Model typre         index     analysis   simulation   error  %%\n');
fprintf('---------------------------------------------------------\n');
fprintf('M/M/1              N          %10.4f  %10.4f  %10.4f%%\n', N_th_MM1, N_sm_MM1, abs(N_sm_MM1-N_th_MM1)/N_th_MM1*100);
fprintf('                   T(minute)  %10.4f  %10.4f  %10.4f%%\n', T_th_MM1, T_sm_MM1, abs(T_sm_MM1-T_th_MM1)/T_th_MM1*100);
fprintf('---------------------------------------------------------\n');
fprintf('M/M/1/K (5min)     N          %10.4f  %10.4f  %10.4f%%\n', N_th_MM1K1, N_sm_MM1K1, abs(N_sm_MM1K1-N_th_MM1K1)/N_th_MM1K1*100);
fprintf('                   T(minute)  %10.4f  %10.4f  %10.4f%%\n', T_th_MM1K1, T_sm_MM1K1, abs(T_sm_MM1K1-T_th_MM1K1)/T_th_MM1K1*100);
fprintf('M/M/1/K (6min)     N          %10.4f  %10.4f  %10.4f%%\n', N_th_MM1K2, N_sm_MM1K2, abs(N_sm_MM1K2-N_th_MM1K2)/N_th_MM1K2*100);
fprintf('                   T(minute)  %10.4f  %10.4f  %10.4f%%\n', T_th_MM1K2, T_sm_MM1K2, abs(T_sm_MM1K2-T_th_MM1K2)/T_th_MM1K2*100);
fprintf('---------------------------------------------------------\n');
fprintf('M/G/1 (Uniform)    N          %10.4f  %10.4f  %10.4f%%\n', N_th_MG1, N_sm_MG1, abs(N_sm_MG1-N_th_MG1)/N_th_MG1*100);
fprintf('                   T(minutes) %10.4f  %10.4f  %10.4f%%\n', T_th_MG1, T_sm_MG1, abs(T_sm_MG1-T_th_MG1)/T_th_MG1*100);
fprintf('---------------------------------------------------------\n');
fprintf('M/D/1              N          %10.4f  %10.4f  %10.4f%%\n', N_th_MD1, N_sm_MD1, abs(N_sm_MD1-N_th_MD1)/N_th_MD1*100);
fprintf('                   T(minutes) %10.4f  %10.4f  %10.4f%%\n', T_th_MD1, T_sm_MD1, abs(T_sm_MD1-T_th_MD1)/T_th_MD1*100);
fprintf('=========================================================\n');
fprintf('  M/M/m Simulation vs Analysis Error  \n');
fprintf('bussiness (m=2) -> Number in queue NQ: Analysis %.4f | Simulation %.4f | error %.4f%%\n', NQ_th_bus, NQ_sm_bus, abs(NQ_sm_bus-NQ_th_bus)/NQ_th_bus*100);
fprintf('bussiness (m=2) -> max stay time T :   Analysis %.4f | Simulation %.4f | error %.4f%%\n', T_th_bus, T_sm_bus, abs(T_sm_bus-T_th_bus)/T_th_bus*100);
fprintf('economy (m=5) ->  NQ: Analysis %.4f | Simulation %.4f | error %.4f%%\n', NQ_th_econ, NQ_sm_econ, abs(NQ_sm_econ-NQ_th_econ)/NQ_th_econ*100);
fprintf('economy (m=5) ->  T : Analysis %.4f | Simulation %.4f | error %.4f%%\n', T_th_econ, T_sm_econ, abs(T_sm_econ-T_th_econ)/T_th_econ*100);
fprintf('=========================================================\n\n');


%% =========================================================
% PART 4: Bar graph 
% =========================================================
labels_single = {'M/M/1', 'M/M/1/K(5min)', 'M/M/1/K(6min)', 'M/G/1(U)', 'M/D/1'};
labels_airport = {'Business Class (m=2)', 'Economy Class (m=5)'};

% --- Figure 1: Number of people in single server N  ---
figure(1); set(gcf, 'Name', 'Single Server - System Size (N)');
bar([N_th_MM1, N_sm_MM1; 
     N_th_MM1K1, N_sm_MM1K1; 
     N_th_MM1K2, N_sm_MM1K2; 
     N_th_MG1, N_sm_MG1; 
     N_th_MD1, N_sm_MD1], 'grouped');
set(gca, 'XTickLabel', labels_single); title('Average System Size (N) - Single Server');
ylabel('Number of Customers'); legend('Theoretical', 'Simulated', 'Location', 'northwest'); grid on;

% --- Figure 2: max runtime of single server T  ---
figure(2); set(gcf, 'Name', 'Single Server - Total Time (T)');
bar([T_th_MM1, T_sm_MM1; 
     T_th_MM1K1, T_sm_MM1K1; 
     T_th_MM1K2, T_sm_MM1K2; 
     T_th_MG1, T_sm_MG1; 
     T_th_MD1, T_sm_MD1], 'grouped');
set(gca, 'XTickLabel', labels_single); title('Average Time in System (T) - Single Server');
ylabel('Time (Minutes)'); legend('Theoretical', 'Simulated', 'Location', 'northwest'); grid on;

% --- Figure 3:  Bussiness vs Economy NQ  ---
figure(3); set(gcf, 'Name', 'Airport M/M/m - Queue Length (NQ)');
bar([NQ_th_bus, NQ_sm_bus; NQ_th_econ, NQ_sm_econ], 'grouped');
set(gca, 'XTickLabel', labels_airport); title('Average Queue Length (N_Q) - Airport Terminal');
ylabel('Number of Customers Waiting'); legend('Theoretical', 'Simulated', 'Location', 'northwest'); grid on;

% --- Figure 4: Bussiness vs Econom T  ---
figure(4); set(gcf, 'Name', 'Airport M/M/m - Total Time (T)');
bar([T_th_bus, T_sm_bus; T_th_econ, T_sm_econ], 'grouped');
set(gca, 'XTickLabel', labels_airport); title('Average Total Time (T) - Airport Terminal');
ylabel('Time (Minutes)'); legend('Theoretical', 'Simulated', 'Location', 'northwest'); 

grid on;