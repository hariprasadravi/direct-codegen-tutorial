function out = yolo_segment(in)
%#codegen
% Run YOLOv11 segmentation on an input image using LiteRT model.

origSize = size(in, 1:2);
inputSize = [640 640];
img = im2single(imresize(in, inputSize));

persistent yoloSegModel
if isempty(yoloSegModel)
    yoloSegModel = loadLiteRTModel("yolo11s-seg_float32.tflite");
end

outs = cell(1, 2);
[outs{:}] = invoke(yoloSegModel, permute(img, [4 1 2 3]));
outputs = permute(outs{1}, [3 2 1]);
masks = squeeze(outs{2});

bboxIndices = 1:4;
scoresIndices = 5:84;

allBboxes = outputs(:, bboxIndices);
[allScores, allLabels] = max(outputs(:, scoresIndices), [], 2);
keep = allScores > 0.5;

bboxes = allBboxes(keep, :);
bboxes(:, [1 3]) = bboxes(:, [1 3]) * origSize(2);
bboxes(:, [2 4]) = bboxes(:, [2 4]) * origSize(1);

bboxes = convertCenterBboxesToTopLeft(bboxes);
scores = allScores(keep);
labels = allLabels(keep);

[bboxesNMS, ~, labelsNMS, nmsIndices] = selectStrongestBboxMulticlass(bboxes, scores, labels, ...
    'RatioType', 'Min', 'OverlapThreshold', 0.8);

classes = createCOCOClasses(labelsNMS);

maskCoeffs = outputs(keep, scoresIndices(end)+1:end);
maskCoeffs = maskCoeffs(nmsIndices, :);
binaryMasks = processMasks(masks, maskCoeffs, topLeftBboxToXYXY(bboxesNMS), origSize);
RGB = insertObjectMask(in, binaryMasks, LineColor=[1 1 1], LineWidth=1);
out = insertObjectAnnotation(RGB, 'rectangle', bboxesNMS, classes);

end
