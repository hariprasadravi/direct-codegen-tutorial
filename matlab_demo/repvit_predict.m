function scores = repvit_predict(img)
%#codegen
% Classify an image using the RepViT PyTorch ExportedProgram model.

persistent net;
if isempty(net)
    net = loadPyTorchExportedProgram("repvit.pt2");
end

img_input = repvit_preprocess(img);
scores = net(img_input);

end
