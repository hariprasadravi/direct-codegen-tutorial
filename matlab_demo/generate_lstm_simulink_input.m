%% Generate Synthetic Sensor Data for Stateful LSTM Simulink Model
% Creates accelerometer-like input data in [1, 75, 3] windows
% with varying activity patterns for streaming demo.

Fs = 50;            % Sampling frequency (Hz)
windowLen = 75;     % Sequence length (matches exported model)
sampleTime = windowLen / Fs; % 1.5 s per window

% Define activity patterns (each generates [75 x 3] accelerometer data)
rng(0);
t = (0:windowLen-1)' / Fs;

patterns = {
    % Sitting — very low amplitude, near-static
    @() single(0.05 * randn(windowLen, 3))
    % Walking — moderate, regular stride (~2 Hz)
    @() single([0.5*sin(2*pi*2*t), 0.3*cos(2*pi*2*t), 0.8*sin(2*pi*2*t+0.5)] + 0.1*randn(windowLen,3))
    % Running — high amplitude, fast (~3.5 Hz)
    @() single([1.5*sin(2*pi*3.5*t), 1.2*cos(2*pi*3.5*t), 2.0*sin(2*pi*3.5*t+1)] + 0.2*randn(windowLen,3))
    % Standing — very low, slight sway
    @() single([0.02*sin(2*pi*0.3*t), 0.03*cos(2*pi*0.2*t), 0.01*ones(windowLen,1)] + 0.03*randn(windowLen,3))
    % Dancing — irregular, mixed frequencies
    @() single([sin(2*pi*1.5*t).*cos(2*pi*0.7*t), 0.8*sin(2*pi*2.5*t+2), cos(2*pi*1.8*t)+0.5*sin(2*pi*3*t)] + 0.15*randn(windowLen,3))
};

% Sequence: Sitting → Walking → Running → Standing → Dancing → Running → Sitting → Walking
activitySequence = [3, 2, 5, 1, 4, 3, 5, 2, 1, 4, 3, 2];
nWindows = numel(activitySequence);

inputWindows = zeros(1, windowLen, 3, nWindows, 'single');
for i = 1:nWindows
    accel = patterns{activitySequence(i)}();
    inputWindows(1, :, :, i) = reshape(accel, 1, windowLen, 3);
end

% Create struct for From Workspace block
% signals.values: [nWindows x 1 x 75 x 3], signals.dimensions: [1 75 3]
tWindows = (0:nWindows-1)' * sampleTime;
sensorInput.time = tWindows;
% For N-D signals, values must be [dim1 x dim2 x ... x nWindows]
% i.e. time is the LAST dimension
vals = permute(inputWindows, [1 2 3 4]); % [1 x 75 x 3 x nWindows]
sensorInput.signals.values = vals;
sensorInput.signals.dimensions = [1 75 3];

% Initial hidden and cell states
h_0 = single(zeros(1, 1, 50));
c_0 = single(zeros(1, 1, 50));

fprintf('Generated %d windows of [1, %d, 3] at %.1fs sample time\n', ...
    nWindows, windowLen, sampleTime);
fprintf('Simulation stop time: %.1f s\n', tWindows(end));
