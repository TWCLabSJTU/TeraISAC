function estimatedPar = DFTSOTFSReceiver(Xdd, rxSignal, waveformPar, SNRdB, pathNumber)
M = waveformPar.subcarrierNum;
N = waveformPar.symbolNum;
T = waveformPar.symbolDuration;
% modSize = waveformPar.modSize;
% modType = waveformPar.modType;
% SNR = 10.^(SNRdB / 10);
% sigma_2 = 1 ./ SNR;
c0 = physconst('LightSpeed');
fc = 300e9;

% sigma_p = waveformPar.sigma_p;
% sigma_d = 1 - sigma_p;
% pilotAmplitude = sqrt(M * N * sigma_p / sigma_d);
% pilot = zeros(M, N);
% pilot(M/2, N/2) = pilotAmplitude;

Ytf = WignerTransform(rxSignal, M, N);
Ydd = SFFT(Ytf, M, N);
[~, delay0, Doppler0] = OTFS_estimation(Xdd, Ydd, T, pathNumber, 60);
estimatedRange = delay0 * c0 / 2;
estimatedVelocity = Doppler0 * c0 / fc / 2;
estimatedPar = [estimatedRange, estimatedVelocity];
end