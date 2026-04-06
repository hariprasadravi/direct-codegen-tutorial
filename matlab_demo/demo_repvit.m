%% Demo 1: RepViT Image Classification
% Load a RepViT PyTorch ExportedProgram and classify an image.

%% Load and Display a Test Image
img = imread("peppers.png");
imshow(img);
title("Input Image");

%% Run Inference
scores = repvit_predict(img);

%% Display Top-5 Predictions
classNames = readlines("imagenet_classes.txt");
[sorted_scores, idx] = sort(scores, 'descend');
fprintf('\nTop-5 Predictions:\n');
for i = 1:5
    fprintf('  %s: %.4f\n', classNames(idx(i)), sorted_scores(i));
end

%% Generate MEX (Code Generation)
cfg = coder.config("mex");
codegen repvit_predict -config cfg -args {img};
fprintf('MEX function generated successfully.\n');

%% Run Generated MEX
scores_mex = repvit_predict_mex(img);
[~, pred_mex] = max(scores_mex);
[~, pred_ml] = max(scores);
fprintf('MATLAB prediction: class %d\n', pred_ml);
fprintf('MEX prediction:    class %d\n', pred_mex);
fprintf('Match: %s\n', string(pred_ml == pred_mex));
