%% An example implementing communication in the THz ISAC Simulator
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
LoSDistance = 10;
NLoSDistance = [20 30];
ReflectionLoss_dB = 8;
MaximumVelocity_kmh = 50;
commChannelParam = getCommChannelParam(fc, bandwidth, txBeamformingGain, rxBeamformingGain,...
    LoSDistance, NLoSDistance, ReflectionLoss_dB, MaximumVelocity_kmh);
SNRdB = max(commChannelParam.pathSNRdB);

waveformType = waveformParam.waveformType;
M = waveformParam.subcarrierNum;
N = waveformParam.symbolNum;
nFrame = 8;
pathNumber = length(commChannelParam.pathDelay);
modSize = waveformParam.modSize;
modType = waveformParam.modType;
if strcmp(waveformType, 'OFDM')
    pilotInterval = waveformParam.pilotInterval;
    N = N * nFrame;
    waveformParam.symbolNum = N;
    PLoc = 1: pilotInterval:N;
    Nd = N - length(PLoc);
    data = generateData(M, Nd, modSize, modType);
    [~,txSignal] = generateTxSignal(data, M, N, 'OFDM', waveformParam);
    rxSignal = channelOutput(txSignal, commChannelParam, 'OFDM', waveformParam, SNRdB);
    [recoveredData, ~] = OFDMCommReceiver(rxSignal, waveformParam, SNRdB);
    demodulatedData = demodulation(data, modSize, modType);
    ber = calculateBer(demodulatedData, recoveredData, log2(modSize));
elseif strcmp(waveformType,'OTFS')
    ber = zeros(1, nFrame);
    for n = 1:nFrame
        data = generateData(M, N, modSize, modType);
        [~,txSignal] = generateTxSignal(data, M, N, 'OTFS', waveformParam);
        rxSignal = channelOutput(txSignal, commChannelParam, 'OTFS', waveformParam, SNRdB);
        [recoveredData, ~] = OTFSCommReceiver(rxSignal, waveformParam, SNRdB, pathNumber);
        demodulatedData = demodulation(data, modSize, modType);
        ber(n) = calculateBer(demodulatedData, recoveredData, log2(modSize));
    end
    ber = mean(ber);
elseif strcmp(waveformType, 'DFTSOTFS')
    ber = zeros(1, nFrame);
    for n = 1:nFrame
        data = generateData(M, N, modSize, modType);
        [~,txSignal] = generateTxSignal(data, M, N, 'DFTSOTFS', waveformParam);
        rxSignal = channelOutput(txSignal, commChannelParam, 'DFTSOTFS', waveformParam, SNRdB);
        [recoveredData, ~] = DFTSOTFSCommReceiver(rxSignal, waveformParam, SNRdB, pathNumber);
        demodulatedData = demodulation(data, modSize, modType);
        ber(n) = calculateBer(demodulatedData, recoveredData, log2(modSize));
    end
    ber = mean(ber);
elseif strcmp(waveformType, 'CP-DFTSOFDM')
    pilotInterval = waveformParam.pilotInterval;
    dftSize = waveformParam.dftSize;
    N = N * nFrame;
    waveformParam.symbolNum = N;
    PLoc = 1: pilotInterval:N;
    Nd = N - length(PLoc);
    data = generateData(dftSize, Nd, modSize, modType);
    [~,txSignal] = generateTxSignal(data, M, N, 'CP-DFTSOFDM', waveformParam);
    rxSignal = channelOutput(txSignal, commChannelParam, 'CP-DFTSOFDM', waveformParam, SNRdB);
    [recoveredData, ~] = DFTSOFDMCommReceiver(rxSignal, waveformParam, SNRdB);
    demodulatedData = demodulation(data, modSize, modType);
    ber = calculateBer(demodulatedData, recoveredData, log2(modSize));
end
disp(['Bit error rate: ', num2str(ber)]);

