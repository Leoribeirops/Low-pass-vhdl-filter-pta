%% 0) Clear everything
% -----------------------
clc; clear;

%% 1) Paths
% Get computer name
hostname = getenv('COMPUTERNAME');   % Windows
hostname = strtrim(hostname);

project_location = pwd;

cd('data');
load('ECG_MIT_01.mat');
x = ECG_MIT_01';        % ECG INPUT
cd('../');

fs = 360;               % Sampling frequency
n  = (0:length(x)-1);   % Sample axis

figure('Name', 'ECG MIT 01');
plotN = 120;
plot( ...
    n(1:plotN), x(1:plotN), ...
    'Color', 'r', ...
    'LineWidth', 2.5, ...
    'LineStyle', '-' , ...
    'DisplayName', 'ECG (MIT-BIH)' ...
    );
grid on; grid minor;
title('ECG'); xlabel('Samples'); ylabel('Amplitude');
legend('Location','northeast');

% Cosimulation setup
load  = ones(1, length(x));
N     = 650e3;
reset = zeros(1, N);
reset(1) = 1;

load = ones(1, N);
load(1) = 0;

disp('Project Ready');

%% Stimulus Generator: IMPULSE (check coefficients)
fs = 360;               % Sampling frequency
n  = (0:length(x)-1);   % Sample axis

% Configuration
N_total  = 120;     % 100 samples are enough to flush the pipeline
amplitude = 1;      % High value, but within 13 bits (Max 4095)

% Create zero vector
ecg_impulse = zeros(1, N_total);

% Inject impulse at sample 10 (enough time for reset)
ecg_impulse(10) = amplitude;

x = ecg_impulse;

% Force signal to be a ROW vector (1xN)
x = x(:)';

disp('>>> Stimulus Generator: IMPULSE coefficient check DONE <<<');

figure('Name', 'Impulse');
plotN = 20;
plot( ...
    n(1:plotN), x(1:plotN), ...
    'Color', 'r', ...
    'LineWidth', 2.5, ...
    'LineStyle', '-' , ...
    'DisplayName', 'Impulse' ...
    );
grid on; grid minor;
title('Impulse'); xlabel('Samples'); ylabel('Amplitude');
legend('Location','northeast');

%% Stimulus Generator: STEP (check output)
fs = 360;               % Sampling frequency
n  = (0:length(x)-1);   % Sample axis

% Configuration
N_total  = 120;
amplitude = 1;

% Create zero vector
ecg_stim = zeros(N_total, 1);

% Create step signal
% From start to t=9 is zero; from t=10 onward is 1
ecg_stim(10:end) = amplitude;

x = ecg_stim;

% Force signal to be a ROW vector (1xN)
x = x(:)';

disp('>>> Stimulus Generator: STEP output check DONE <<<');

figure('Name', 'STEP');
plotN = 20;
plot( ...
    n(1:plotN), x(1:plotN), ...
    'Color', 'r', ...
    'LineWidth', 2.5, ...
    'LineStyle', '-' , ...
    'DisplayName', 'STEP' ...
    );
grid on; grid minor;
title('STEP'); xlabel('Samples'); ylabel('Amplitude');
legend('Location','northeast');

%% Check if signal is normalized
max_val = max(abs(x));

if max_val <= 1
    disp('Signal is normalized.');
else
    disp('Signal is NOT normalized.');
    x = x / max(abs(x));
    disp('Signal has been normalized.');
end

%% LOW-PASS FILTER
% y[n] = 2y[n−1] − y[n−2] + x[n] − 2x[n−6] + x[n−12]

b = [1 0 0 0 0 0 -2 0 0 0 0 0 1];
a = [1 -2 1];

y = filter(b, a, x);

sample_plot = 100;
disp('>>> Run Co-Simulation <<<');

figure('Name', 'MATLAB OUTPUT');
plotN = 120;
plot( ...
    n(1:plotN), y(1:plotN), ...
    'Color', 'r', ...
    'LineWidth', 2.5, ...
    'LineStyle', '-' , ...
    'DisplayName', 'MATLAB OUTPUT' ...
    );
grid on; grid minor;
title('MATLAB OUTPUT'); xlabel('Samples'); ylabel('Amplitude');
legend('Location','northeast');

%% First-time Cosimulation Setup
cd('cosim_link');
cosimWizard;

% Use HDL simulator executables located at:
% C:\modeltech64_2020.4\win64
% Next
% Add VHDL
% Compile
% Select TOP LEVEL architecture for cosimulation
% Input list: all signals as Input for better control
% Output data type: usually Fixed-Point, signed
% Fractional bits must be considered (example: 9 bits)

%% Run tests
cd('cosim_link');
open('LPF_IMP_STEP_test.slx');

%% VHDL Output
vhdl_out_LPF = out.S_LPF';

figure('Name', 'VHDL OUTPUT');
plotN = 120;
plot( ...
    n(1:plotN), vhdl_out_LPF(1:plotN), ...
    'Color', 'b', ...
    'LineWidth', 2.5, ...
    'LineStyle', '-' , ...
    'DisplayName', 'VHDL OUTPUT' ...
    );
grid on; grid minor;
title('VHDL OUTPUT'); xlabel('Samples'); ylabel('Amplitude');
legend('Location','northeast');

%% Signal Comparison
figure('Name', 'Signal Comparison');

plotN = 1000;

subplot(2,1,1);
plot( ...
    n(1:plotN), y(1:plotN), ...
    'Color', 'r', ...
    'LineWidth', 2.5, ...
    'LineStyle', '-', ...
    'DisplayName', 'MATLAB OUTPUT' ...
    );
grid on; grid minor;
title('MATLAB OUTPUT');
xlabel('Samples');
ylabel('Amplitude');
legend('Location','northeast');

subplot(2,1,2);
plot( ...
    n(1:plotN), vhdl_out_LPF(1:plotN), ...
    'Color', 'b', ...
    'LineWidth', 2.5, ...
    'LineStyle', '-', ...
    'DisplayName', 'VHDL OUTPUT' ...
    );
grid on; grid minor;
title('VHDL OUTPUT');
xlabel('Samples');
ylabel('Amplitude');
legend('Location','northeast');
