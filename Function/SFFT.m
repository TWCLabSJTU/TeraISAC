function ddSignal = SFFT(tfSignal, M, N)
ddSignal = ifft(fft(tfSignal.').') / sqrt(N) * sqrt(M);
end