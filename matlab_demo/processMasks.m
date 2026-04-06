function [mask,downsampled_bboxes] = processMasks(masks, maskCoeffs, bboxes, origShape)

coder.gpu.kernelfun;

[mh, mw, c] = size(masks);
[ih, iw] = deal(origShape(1),origShape(2));

protPermute = permute(masks,[3,2,1]);
protoVal = reshape(protPermute,c,[]);

maskTmp = maskCoeffs*protoVal;

% Match Python code
maskTmpTrans = permute(maskTmp,[2,1]);
masks = reshape(maskTmpTrans,mw,mh,[]);
masks = permute(masks,[2,1,3]);

% Vectorized bbox calculations
scale = [mw./iw, mh./ih, mw./iw, mh./ih];
% scale = [shape(2)./iw, shape(1)./ih, shape(2)./iw, shape(1)./ih];
downsampled_bboxes = bboxes .* scale;

masks = iCropMasks(masks, downsampled_bboxes);

% Resize masks efficiently
mask = false([origShape(1:2), size(masks, 3)]);  % Preallocate as logical
for i = 1:size(masks, 3)
    mask(:,:,i) = imresize(masks(:,:,i), [origShape(1), origShape(2)], 'bilinear') > 0;
end
end

function resultMasks = iCropMasks(masks, boxes)
[rows, cols, numBoxes] = size(masks);
[r, c] = ndgrid(1:rows, 1:cols);
resultMasks = zeros(size(masks), 'like', masks);  % Use same data type as input

% Vectorized box coordinates
boxes = boxes + 1;  % Add 1 to all coordinates at once
for i = 1:numBoxes
    logicalMask = (r >= boxes(i,2)) & (r < boxes(i,4)) & ...
        (c >= boxes(i,1)) & (c < boxes(i,3));
    resultMasks(:,:,i) = masks(:,:,i) .* logicalMask;
end
end