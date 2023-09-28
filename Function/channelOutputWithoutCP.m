function rxSignal = channelOutputWithoutCP(txSignal, channelPar, waveformPar)
M = waveformPar.subcarrierNum;
N = waveformPar.symbolNum;
T = waveformPar.symbolDuration;
deltaf = waveformPar.subcarrierSpacing;

alpha = channelPar.pathCoefficient;
delay = channelPar.pathDelay;
doppler = channelPar.pathDoppler;

tfSignal = fft(reshape(txSignal, M, N)) / sqrt(M);
txSignal_delay = zeros(M * N, length(delay));
for p = 1:length(delay)
    l_tau = ceil(delay(p) / (T / M));
    txSignal_delay(:, p) = circshift(reshape(circshift(ifft(diag(exp(-1j * 2 * pi * (0:1:(M-1)) *  deltaf * delay(p))) * tfSignal ) * sqrt(M), - l_tau ), [], 1), l_tau);
end
dopplerEffect = exp(1j * 2 * pi * doppler .* (0:1:(M*N - 1))' * T / M);
rxSignal = repmat(alpha, M*N, 1) .* dopplerEffect .* txSignal_delay;
rxSignal = sum(rxSignal, 2);

end