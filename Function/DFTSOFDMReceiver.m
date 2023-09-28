function estimatedPar = DFTSOFDMReceiver(Xtf, rxSignal, waveformPar, SNRdB, pathNumber)
M = waveformPar.subcarrierNum;
N = waveformPar.symbolNum;
c0 = physconst('LightSpeed');
fc = 300e9;
deltaf = waveformPar.subcarrierSpacing;
Ts = waveformPar.totalSymbolDuration;
dftSize = waveformPar.dftSize;
rxFrame = fft(reshape(rxSignal, M, N)) / sqrt(M);
rxFrame = rxFrame(1:dftSize, :);

Ytf = rxFrame;
[~, delay0, Doppler0] = OFDM_estimation(Xtf, Ytf, deltaf, Ts, pathNumber, 60);
estimatedRange = delay0 * c0 / 2;
estimatedVelocity = Doppler0 * c0 / fc / 2;
estimatedPar = [estimatedRange, estimatedVelocity];
end