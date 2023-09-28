function [recoveredData,equalizedData] = DFTSOFDMCommReceiver(rxSignal, waveformPar, SNRdB)
M = waveformPar.subcarrierNum;
N = waveformPar.symbolNum;
dftSize = waveformPar.dftSize;
rxFrame = fft(reshape(rxSignal, M, N)) / sqrt(M);
rxFrame = rxFrame(1:dftSize, :);

pilotInterval = waveformPar.pilotInterval;
PLoc = 1: pilotInterval: N;
DLoc = setxor(1:N, PLoc);
rxPilot = rxFrame(:, PLoc);
rxData = rxFrame(:, DLoc);
txPilot = repmat(generatePilotBlock(dftSize), 1, length(PLoc));
txPilot = fft(txPilot) / sqrt(dftSize);
HData_LS = tfChannelEstimation(txPilot, rxPilot, dftSize, N, PLoc, DLoc);
equalizedData = FDE(rxData, HData_LS, SNRdB);
equalizedData = ifft(equalizedData) * sqrt(dftSize);

modSize = waveformPar.modSize;
modType = waveformPar.modType;
recoveredData = demodulation(equalizedData, modSize, modType);
end