%% Project Startup — Direct Codegen Tutorial
% Runs automatically when the MATLAB project is opened.

fprintf('\n=== Direct Codegen Tutorial — Project Setup ===\n\n');

%% 1. Check Support Package
fprintf('[1/4] Checking MATLAB Coder Support Package for PyTorch and LiteRT Models...\n');
try
    info = SupportPackageRegistrationInfo('MC_PYTORCH_LITERT');
    fprintf('       Support package found: %s\n', info.Name);
catch
    warning('projectStartup:noSupportPkg', ...
        'Support package not found. Install "MATLAB Coder Support Package for PyTorch and LiteRT Models" from Add-On Explorer.');
end

%% 2. Configure Python Environment
fprintf('[2/4] Configuring Python environment...\n');
pyenvDir = fullfile(fileparts(mfilename('fullpath')), '..', 'pyenv');
pyExe = fullfile(pyenvDir, 'bin', 'python');
if isfile(pyExe)
    try
        pyenv(ExecutionMode="OutOfProcess", Version=pyExe);
        fprintf('       Python env: %s\n', pyExe);
    catch ME
        warning('projectStartup:pyenv', 'Could not set pyenv: %s', ME.message);
    end
else
    fprintf('       Python venv not found at %s\n', pyenvDir);
    fprintf('       To create: python3 -m venv pyenv && source pyenv/bin/activate && pip install torch==2.8.0 numpy\n');
end

%% 3. Check Model Files
fprintf('[3/4] Checking model files...\n');
demoDir = fileparts(mfilename('fullpath'));
models = {"repvit.pt2", "stateful_lstm.pt2", "yolo11s-seg_float32.tflite"};
for i = 1:numel(models)
    f = fullfile(demoDir, models{i});
    if isfile(f)
        fprintf('       [OK] %s\n', models{i});
    else
        fprintf('       [MISSING] %s — download from Colab notebook\n', models{i});
    end
end

%% 4. Generate Simulink Input Data
fprintf('[4/4] Generating Simulink input data...\n');
generate_lstm_simulink_input;

fprintf('\n=== Setup Complete ===\n\n');
