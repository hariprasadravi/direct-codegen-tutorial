%% Demo 3: Stateful LSTM Activity Recognition
% Load a stateful LSTM PyTorch ExportedProgram and classify sensor data.

%% Load the Model and Inspect It
net = loadPyTorchExportedProgram("stateful_lstm.pt2");
summary(net);

%% Create Sample Sensor Data
% Simulate 75 timesteps of 3-axis accelerometer data
% Input shape for the model: (batch=1, seq_len=75, features=3)
rng(42);
sample_input = single(randn(1, 75, 3));

%% Initialize Hidden States
% The stateful LSTM requires explicit hidden state (h) and cell state (c)
% Shape: (num_layers=1, batch=1, hidden_size=50)
h_0 = single(zeros(1, 1, 50));
c_0 = single(zeros(1, 1, 50));

%% Run Inference
% Pass the entire sequence with initial hidden and cell states.
% The model returns predictions for each timestep, plus the final
% hidden and cell states that could be fed into the next call.
[predictions, h_n, c_n] = net(sample_input, h_0, c_0);

activities = ["Dancing", "Running", "Sitting", "Standing", "Walking"];
[~, last_pred] = max(predictions(1, end, :));
fprintf('Predicted activity: %s\n', activities(last_pred));
fprintf('Output shape: %s (batch x timesteps x classes)\n', mat2str(size(predictions)));
fprintf('Hidden state shape: %s\n', mat2str(size(h_n)));

%% Generate MEX (Code Generation)
cfg = coder.config("mex");
codegen lstm_predict -config cfg -args {sample_input, h_0, c_0};
fprintf('MEX function generated successfully.\n');

%% Run Generated MEX
[pred_mex, h_mex, c_mex] = lstm_predict_mex(sample_input, h_0, c_0);
[~, mex_pred] = max(pred_mex(1, end, :));
fprintf('MEX prediction: %s\n', activities(mex_pred));
fprintf('MATLAB and MEX agree: %s\n', string(last_pred == mex_pred));
