%% Project Shutdown — Direct Codegen Tutorial
% Runs automatically when the MATLAB project is closed.

fprintf('Direct Codegen Tutorial project closed.\n');

% Terminate Python environment to release resources
if pyenv().Status == "Loaded"
    terminate(pyenv);
    fprintf('Python environment terminated.\n');
end
