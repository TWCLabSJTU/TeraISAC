function [recoveredData, X_eq] = OTFSCommReceiver(rxSignal, waveformPar, SNRdB, pathNumber)
M = waveformPar.subcarrierNum;
N = waveformPar.symbolNum;
T = waveformPar.symbolDuration;
modSize = waveformPar.modSize;
modType = waveformPar.modType;
SNR = 10.^(SNRdB / 10);
sigma_2 = 1 ./ SNR;

sigma_p = waveformPar.sigma_p;
sigma_d = 1 - sigma_p;
pilotAmplitude = sqrt(M * N * sigma_p / sigma_d);
pilot = zeros(M, N);
pilot(M/2, N/2) = pilotAmplitude;

Ytf = WignerTransform(rxSignal, M, N);
Ydd = SFFT(Ytf, M, N);
[alpha0, delay0, Doppler0] = OTFS_estimation(pilot, Ydd, T, pathNumber, 10);
Rt = reshape(rxSignal, M, N);
s_eq = OTFS_LMMSE(Rt, alpha0, delay0, Doppler0, T, sigma_2);
S_eq = reshape(s_eq, M, N);
X_eq = fft(S_eq.').' / sqrt(N);
X_eq = X_eq - pilot;
X_de = demodulation(X_eq, modSize, modType);
nEq = 5;
for n = 1:nEq
    data_star_dd = modulation(X_de, modSize, modType);
    Xdd_star = data_star_dd + pilot;
    [alpha, delay, Doppler] = OTFS_estimation(Xdd_star, Ydd, T, pathNumber, 10);
    s_eq = OTFS_LMMSE(Rt, alpha, delay, Doppler, T, sigma_2);
    S_eq = reshape(s_eq, M, N);
    X_eq = fft(S_eq.').' / sqrt(N);
    X_eq = X_eq - pilot;
    X_de = demodulation(X_eq, modSize, modType);
end
recoveredData = X_de;
end