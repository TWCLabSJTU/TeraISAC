function [estimatedPar, imagingResult] = OFDMReceiver(Xtf, rxSignal, waveformPar, SNRdB, pathNumber, fun)
M = waveformPar.subcarrierNum;
N = waveformPar.symbolNum;
c0 = physconst('LightSpeed');
fc = waveformPar.carrierFrequency;
deltaf = waveformPar.subcarrierSpacing;
Ts = waveformPar.totalSymbolDuration;
rxFrame = fft(reshape(rxSignal, M, N)) / sqrt(M);
Ytf = rxFrame;

rangeList = 0:0.1:60;
delayList = range2time(rangeList, c0);
velocityList = -50:0.5:50;
DopplerList = speed2dop(2 * velocityList, c0 / fc);

Niter = 60;

if fun == 1
    [~, delay0, Doppler0] = OFDM_estimation(Xtf, Ytf, deltaf, Ts, pathNumber, Niter);
    estimatedRange = delay0 * c0 / 2;
    estimatedVelocity = Doppler0 * c0 / fc / 2;
    estimatedPar = [estimatedRange, estimatedVelocity];
    imagingResult = 0;
elseif fun == 2
    [delayGrid, DopplerGrid, normalizedProfile] = OFDM_imaging(Xtf, Ytf, deltaf, Ts, pathNumber, Niter, delayList, DopplerList);
    rangeGrid = delayGrid * c0 / 2;
    velocityGrid = DopplerGrid * c0 / (2 * fc);
    imagingResult{1} = rangeGrid;
    imagingResult{2} = velocityGrid;
    imagingResult{3} = normalizedProfile;
    estimatedPar = 0;
elseif fun == 3
    [~, delay0, Doppler0] = OFDM_estimation(Xtf, Ytf, deltaf, Ts, pathNumber, Niter);
    estimatedRange = delay0 * c0 / 2;
    estimatedVelocity = Doppler0 * c0 / fc / 2;
    estimatedPar = [estimatedRange, estimatedVelocity];

    DopplerList = speed2dop(2 * velocityList, c0 / fc);
    [delayGrid, DopplerGrid, normalizedProfile] = OFDM_imaging(Xtf, Ytf, deltaf, Ts, pathNumber, Niter, delayList, DopplerList);
    rangeGrid = delayGrid * c0 / 2;
    velocityGrid = DopplerGrid * c0 / (2 * fc);
    imagingResult{1} = rangeGrid;
    imagingResult{2} = velocityGrid;
    imagingResult{3} = normalizedProfile;
end
end