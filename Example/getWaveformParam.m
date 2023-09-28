function waveformParam = getWaveformParam(waveformType, M, N, deltaf, qamSize)
waveformParam.waveformType = waveformType;
waveformParam.subcarrierNum = M;
waveformParam.symbolNum = N;
waveformParam.subcarrierSpacing = deltaf;
waveformParam.symbolDuration = 1 / waveformParam.subcarrierSpacing;
waveformParam.cpDuration = 1/4 * waveformParam.symbolDuration;
waveformParam.totalSymbolDuration = waveformParam.symbolDuration + waveformParam.cpDuration;
waveformParam.dftSize = 1 * waveformParam.subcarrierNum;
waveformParam.fgiSize = 1/4 * waveformParam.dftSize;
waveformParam.modSize = qamSize;
waveformParam.modType = 'qam';
waveformParam.pilotInterval = 8;
waveformParam.sigma_p = 0.06;
end