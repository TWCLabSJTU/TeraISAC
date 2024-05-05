function [estimatedPar, imagingResult] = OTFSReceiver(Xdd, rxSignal, waveformPar, SNRdB, pathNumber, fun)
M = waveformPar.subcarrierNum;
N = waveformPar.symbolNum;
T = waveformPar.symbolDuration;
% modSize = waveformPar.modSize;
% modType = waveformPar.modType;
% SNR = 10.^(SNRdB / 10);
% sigma_2 = 1 ./ SNR;
c0 = physconst('LightSpeed');
fc = waveformPar.carrierFrequency;

% sigma_p = waveformPar.sigma_p;
% sigma_d = 1 - sigma_p;
% pilotAmplitude = sqrt(M * N * sigma_p / sigma_d);
% pilot = zeros(M, N);
% pilot(M/2, N/2) = pilotAmplitude;

Ytf = WignerTransform(rxSignal, M, N);
Ydd = SFFT(Ytf, M, N);


rangeList = 0:0.1:60;
delayList = range2time(rangeList, c0);
velocityList = -50:0.5:50;
DopplerList = speed2dop(2 * velocityList, c0 / fc);

Niter = 60;

if fun == 1
    [~, delay0, Doppler0] = OTFS_estimation(Xdd, Ydd, T, pathNumber, Niter);
    estimatedRange = delay0 * c0 / 2;
    estimatedVelocity = Doppler0 * c0 / fc / 2;
    estimatedPar = [estimatedRange, estimatedVelocity];
    imagingResult = 0;
elseif fun == 2
    [delayGrid, DopplerGrid, normalizedProfile] = OTFS_imaging(Xdd, Ydd, T, pathNumber, Niter, delayList, DopplerList);
    rangeGrid = delayGrid * c0 / 2;
    velocityGrid = DopplerGrid * c0 / (2 * fc);
    imagingResult{1} = rangeGrid;
    imagingResult{2} = velocityGrid;
    imagingResult{3} = normalizedProfile;
    estimatedPar = 0;
elseif fun == 3
    [~, delay0, Doppler0] = OTFS_estimation(Xdd, Ydd, T, pathNumber, Niter);
    estimatedRange = delay0 * c0 / 2;
    estimatedVelocity = Doppler0 * c0 / fc / 2;
    estimatedPar = [estimatedRange, estimatedVelocity];

    DopplerList = speed2dop(2 * velocityList, c0 / fc);
    [delayGrid, DopplerGrid, normalizedProfile] = OTFS_imaging(Xdd, Ydd, T, pathNumber, Niter, delayList, DopplerList);
    rangeGrid = delayGrid * c0 / 2;
    velocityGrid = DopplerGrid * c0 / (2 * fc);
    imagingResult{1} = rangeGrid;
    imagingResult{2} = velocityGrid;
    imagingResult{3} = normalizedProfile;
end
end
