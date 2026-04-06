%% Setup Environment
% Register the support package to enable PyTorch and LiteRT model loading.
% This is required when running from a sandbox (CI/CD) environment.

s = SupportPackageRegistrationInfo('MC_PYTORCH_LITERT');
s.register;

fprintf('Support package registered successfully.\n');
