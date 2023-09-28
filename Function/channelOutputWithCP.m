function rxSignal = channelOutputWithCP(txSignal, channelPar, waveformPar)
M = waveformPar.subcarrierNum;
N = waveformPar.symbolNum;
T = waveformPar.symbolDuration;
deltaf = waveformPar.subcarrierSpacing;
Tcp = waveformPar.cpDuration;
T0 = waveformPar.totalSymbolDuration;

alpha = channelPar.pathCoefficient;
delay = channelPar.pathDelay;
doppler = channelPar.pathDoppler;

tfSignal = fft(reshape(txSignal, M, N)) / sqrt(M);
rxSignal = zeros(size(txSignal));

for p = 1:length(delay)
    txSignal_delay = reshape( ifft( diag(exp(-1j * 2 * pi * (0:1:(M-1)) *...
        deltaf * delay(p) ) ) * tfSignal ) * sqrt(M) , [], 1);
    dopplerEffect = exp(1j * 2 * pi * doppler(p) * Tcp) * repmat(exp(1j * 2 * pi * doppler(p) * (0:1:(M-1))' * T / M), 1, N) .*...
        repmat(exp(1j * 2 * pi * doppler(p) * (0:1:(N-1)) * T0), M, 1);
    rxSignal_p = alpha(p) * reshape(dopplerEffect, [], 1) .* txSignal_delay;
    rxSignal = rxSignal + rxSignal_p;
end

end