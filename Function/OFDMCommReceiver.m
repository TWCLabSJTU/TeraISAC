function [recoveredData,equalizedData] = OFDMCommReceiver(rxSignal, waveformPar, SNRdB)
M = waveformPar.subcarrierNum;
N = waveformPar.symbolNum;
rxFrame = fft(reshape(rxSignal, M, N)) / sqrt(M);

pilotInterval = waveformPar.pilotInterval;
PLoc = 1: pilotInterval: N;
DLoc = setxor(1:N, PLoc);
rxPilot = rxFrame(:, PLoc);
rxData = rxFrame(:, DLoc);
txPilot = repmat(generatePilotBlock(M), 1, length(PLoc));
HData_LS = tfChannelEstimation(txPilot, rxPilot, M, N, PLoc, DLoc);
equalizedData = FDE(rxData, HData_LS, SNRdB);

modSize = waveformPar.modSize;
modType = waveformPar.modType;
recoveredData = demodulation(equalizedData, modSize, modType);
end