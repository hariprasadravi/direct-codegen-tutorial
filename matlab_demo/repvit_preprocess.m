function preprocessed_input = repvit_preprocess(img)
%#codegen
% Preprocess an image for RepViT: resize, center crop, normalize, and permute.

[h, w, ~] = size(img);
shortest_edge = min(h, w);
scale = 224 / shortest_edge;
new_h = round(h * scale);
new_w = round(w * scale);
img_resized = imresize(img, [new_h, new_w], "bilinear");

crop_size = 224;
start_h = floor((new_h - crop_size)/2) + 1;
start_w = floor((new_w - crop_size)/2) + 1;
img_cropped = img_resized(start_h + (0:crop_size-1), start_w + (0:crop_size-1), :);

img_rescaled = single(img_cropped) / 255;

meanVec = coder.const(single([0.485, 0.456, 0.406]));
stdVec  = coder.const(single([0.229, 0.224, 0.225]));
meanImg = reshape(meanVec, [1 1 3]);
stdImg  = reshape(stdVec,  [1 1 3]);
img_normalized = (img_rescaled - meanImg) ./ stdImg;

preprocessed_input = permute(img_normalized, [4 3 1 2]);

end
