function [sensingSignal,txSignal] = generateTxSignal(data, M, N, waveformType, waveformPar)
if strcmp(waveformType, 'OFDM')
    pilotInterval = waveformPar.pilotInterval;
    [sensingSignal,txSignal] = OFDMmod(data, M, N, pilotInterval);
elseif strcmp(waveformType,'OTFS')
    sigma_p = waveformPar.sigma_p;
    [sensingSignal,txSignal] = OTFSmod(data, M, N, sigma_p);
elseif strcmp(waveformType, 'DFTSOTFS')
    sigma_p = waveformPar.sigma_p;
    [sensingSignal,txSignal] = DFTSOTFSmod(data, M, N, sigma_p);
elseif strcmp(waveformType, 'CP-DFTSOFDM')
    pilotInterval = waveformPar.pilotInterval;
    dftSize = waveformPar.dftSize;
    [sensingSignal,txSignal] = DFTSOFDMmod(data, M, N, pilotInterval, dftSize);
end
end
