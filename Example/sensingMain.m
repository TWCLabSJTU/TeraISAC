%% An example implementing sensing estimation in the THz ISAC simulator
clc, clear
addpath('../Function');

waveformType = 'OFDM';
M = 64;
N = 16;
deltaf = 15e3 * 2^5;
qamSize = 4;
bandwidth = M * deltaf;
waveformParam = getWaveformParam(waveformType, M, N, deltaf, qamSize);

fc = 300e9;
txBeamformingGain = 20;
rxBeamformingGain = 30;
targetDistance = [10, 20, 30];
targetVelocity = [-20, 20, 2];
targetRCS = [0, 0, 0];
sensingChannelParam = getSensingChannelParam(fc, bandwidth, txBeamformingGain,...
    rxBeamformingGain, targetDistance, targetVelocity, targetRCS);
SNRdB = max(sensingChannelParam.targetSNRdB);

waveformType = waveformParam.waveformType;
M = waveformParam.subcarrierNum;
N = waveformParam.symbolNum;
targetNumber = length(sensingChannelParam.pathDelay);
modSize = waveformParam.modSize;
modType = waveformParam.modType;
if strcmp(waveformType, 'OFDM')
    pilotInterval = waveformParam.pilotInterval;
    PLoc = 1: pilotInterval:N;
    Nd = N - length(PLoc);
    data = generateData(M, Nd, modSize, modType);
    [sensingSignal,txSignal] = generateTxSignal(data, M, N, 'OFDM', waveformParam);
    rxSignal = channelOutput(txSignal, sensingChannelParam, 'OFDM', waveformParam, SNRdB);
    [estimatedPar, ~] = OFDMReceiver(sensingSignal, rxSignal, waveformParam, SNRdB, targetNumber, 1);
elseif strcmp(waveformType,'OTFS')
    data = generateData(M, N, modSize, modType);
    [sensingSignal,txSignal] = generateTxSignal(data, M, N, 'OTFS', waveformParam);
    rxSignal = channelOutput(txSignal, sensingChannelParam, 'OTFS', waveformParam, SNRdB);
    [estimatedPar, ~] = OTFSReceiver(sensingSignal, rxSignal, waveformParam, SNRdB, targetNumber, 1);
elseif strcmp(waveformType, 'DFTSOTFS')
    data = generateData(M, N, modSize, modType);
    [sensingSignal,txSignal] = generateTxSignal(data, M, N, 'DFTSOTFS', waveformParam);
    rxSignal = channelOutput(txSignal, sensingChannelParam, 'DFTSOTFS', waveformParam, SNRdB);
    [estimatedPar, ~] = OTFSReceiver(sensingSignal, rxSignal, waveformParam, SNRdB, targetNumber, 1);
elseif strcmp(waveformType, 'CP-DFTSOFDM')
    pilotInterval = waveformParam.pilotInterval;
    PLoc = 1: pilotInterval:N;
    Nd = N - length(PLoc);
    data = generateData(M, Nd, modSize, modType);
    [sensingSignal,txSignal] = generateTxSignal(data, M, N, 'CP-DFTSOFDM', waveformParam);
    rxSignal = channelOutput(txSignal, sensingChannelParam, 'CP-DFTSOFDM', waveformParam, SNRdB);
    [estimatedPar, ~] = OFDMReceiver(sensingSignal, rxSignal, waveformParam, SNRdB, targetNumber, 1);
end
targetNumber = length(estimatedPar) / 2;
for p = 1:targetNumber
    disp(['Target ', num2str(p)]);
    disp(['Range: ', num2str(estimatedPar(p)), ' m']);
    disp(['Velocity: ', num2str(estimatedPar(p+targetNumber)), ' m/s']);
end