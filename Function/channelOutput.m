function rxSignal = channelOutput(txSignal, channelPar, waveformType, waveformPar, SNRdB)
if strcmp(waveformType, 'OFDM') || strcmp(waveformType, 'CP-DFTSOFDM')
    rxSignal = channelOutputWithCP(txSignal, channelPar, waveformPar);
elseif strcmp(waveformType, 'OTFS') || strcmp(waveformType, 'DFTSOTFS')
    rxSignal = channelOutputWithoutCP(txSignal, channelPar, waveformPar);
elseif strcmp(waveformType, 'FGI-DFTSOFDM')
    rxSignal = channelOutputWithFGI(txSignal, channelPar, waveformPar);
end
rxSignal = awgn(rxSignal, SNRdB, 'measured');
end