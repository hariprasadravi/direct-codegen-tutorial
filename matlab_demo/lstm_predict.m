function [predictions, h_n, c_n] = lstm_predict(input, h_0, c_0)
%#codegen
% Run stateful LSTM inference using PyTorch ExportedProgram model.

persistent net;
if isempty(net)
    net = loadPyTorchExportedProgram("stateful_lstm.pt2");
end

[predictions, h_n, c_n] = net(input, h_0, c_0);

end
