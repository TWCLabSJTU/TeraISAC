function [Xtf, txSignal] = OFDMmod(data, M, N, pilotInterval)
PLoc = 1: pilotInterval: N;
DLoc = setxor(1:N, PLoc);
tfFrame = zeros(M, N);
txPilot = repmat(generatePilotBlock(M), 1, length(PLoc));
tfFrame(:, PLoc) = txPilot;
tfFrame(:, DLoc) = data;
txFrame = ifft(tfFrame) * sqrt(M);
txSignal = reshape(txFrame, [], 1);
Xtf = tfFrame;
end