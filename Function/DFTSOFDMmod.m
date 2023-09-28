function [Xtf, txSignal] = DFTSOFDMmod(data, M, N, pilotInterval, dftSize, fgiSize)
[~, Nd] = size(data);
if nargin == 6
    gi = repmat(generatePilotBlock(dftSize), 1, Nd);
    data = [data; gi(end - fgiSize + 1:end, :)];
end
PLoc = 1: pilotInterval:N;
DLoc = setxor(1:N, PLoc);
dataFrame = zeros(dftSize, N);
txPilot = repmat(generatePilotBlock(dftSize), 1, length(PLoc));
dataFrame(:, PLoc) = txPilot;
dataFrame(:, DLoc) = data;
tfFrame = fft(dataFrame, dftSize) / sqrt(dftSize);
txFrame = ifft([tfFrame; zeros(M - dftSize, N)]) * sqrt(M);
txSignal = reshape(txFrame, [], 1);
Xtf = tfFrame;
end