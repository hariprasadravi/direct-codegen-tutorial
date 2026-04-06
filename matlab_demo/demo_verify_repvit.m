%% Demo: Numeric Verification — MATLAB vs Python Reference
% Use MATLAB's Python interface to call torch.export.load directly
% and compare against loadPyTorchExportedProgram output.

%% Setup: Point MATLAB to a Python with torch 2.8.0
% Create once in a terminal:
%   python3 -m venv /local-ssd/hravisha/directCodegenLectureSeminar/pyenv
%   source /local-ssd/hravisha/directCodegenLectureSeminar/pyenv/bin/activate
%   pip install torch==2.8.0 numpy
pyenv(ExecutionMode="OutOfProcess", ...
    Version="/local-ssd/hravisha/directCodegenLectureSeminar/pyenv/bin/python");

%% Load Model in MATLAB
net = loadPyTorchExportedProgram("repvit.pt2");

%% Create a Random Test Input
rng(42);
input = single(randn(1, 3, 224, 224));

%% Run Inference in MATLAB
mlOut = net(input);

%% Run Inference in Python (reference)
% Load the same .pt2 model using torch.export.load
torch = py.importlib.import_module("torch");
np = py.importlib.import_module("numpy");

ep = torch.export.load("repvit.pt2");
model = ep.module();

% Convert MATLAB input to a torch tensor via numpy
npInput = np.array(input, dtype="float32");
tInput = torch.from_numpy(npInput);

% Run inference
pyResult = model(tInput);

% Convert back to MATLAB
pyOut = single(pyResult.detach().numpy());

%% Compare
maxErr = max(abs(double(mlOut) - double(pyOut)), [], 'all');
[~, mlPred] = max(mlOut);
[~, pyPred] = max(pyOut);

fprintf('Max absolute error: %g\n', maxErr);
fprintf('Top-1 class — MATLAB: %d, Python: %d, Match: %s\n', ...
    mlPred, pyPred, string(mlPred == pyPred));
