%% Create MATLAB Project for Direct Codegen Tutorial
% Run this once to set up the .prj file with startup/shutdown hooks.

projDir = fileparts(mfilename('fullpath'));

% Create project
proj = matlab.project.createProject(projDir);
proj.Name = "DirectCodegenTutorial";
proj.Description = "Direct code generation from PyTorch and LiteRT models — tutorial demos";

% Add all relevant files
addFile(proj, "projectStartup.m");
addFile(proj, "projectShutdown.m");
addFile(proj, "generate_lstm_simulink_input.m");
addFile(proj, "ActivityLabel.m");
addFile(proj, "classifyActivity.m");

% Add demo scripts
addFile(proj, "demo_repvit.m");
addFile(proj, "demo_lstm.m");
addFile(proj, "demo_yolo.m");
addFile(proj, "demo_verify_repvit.m");

% Add entry-point functions
addFile(proj, "repvit_predict.m");
addFile(proj, "repvit_preprocess.m");
addFile(proj, "lstm_predict.m");
addFile(proj, "yolo_segment.m");

% Add helper functions
addFile(proj, "createCOCOClasses.m");
addFile(proj, "getCOCOClassNames.m");
addFile(proj, "convertCenterBboxesToTopLeft.m");
addFile(proj, "topLeftBboxToXYXY.m");
addFile(proj, "processMasks.m");

% Add data files
addFile(proj, "imagenet_classes.txt");
addFile(proj, "downtownScene.jpg");

% Add Simulink model if present
if isfile(fullfile(projDir, "StatefulLSTMPyTorchExportedProgram.slx"))
    addFile(proj, "StatefulLSTMPyTorchExportedProgram.slx");
end

% Add live scripts if present
mlxFiles = dir(fullfile(projDir, "*.mlx"));
for i = 1:numel(mlxFiles)
    addFile(proj, mlxFiles(i).name);
end

% Set startup and shutdown scripts
addStartupFile(proj, fullfile(projDir, "projectStartup.m"));
addShutdownFile(proj, fullfile(projDir, "projectShutdown.m"));

fprintf('Project created: %s\n', proj.Name);
fprintf('Open with: openProject("%s")\n', projDir);
